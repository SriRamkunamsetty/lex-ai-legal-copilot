import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:lex_copilot/core/errors/failure.dart';
import 'package:lex_copilot/core/result.dart';
import 'package:lex_copilot/core/storage/app_database.dart';

/// Metadata describing an offline downloadable / bundled Knowledge Pack.
@immutable
class KnowledgePackSummary {
  /// Creates a [KnowledgePackSummary].
  const new({
    required this.packId,
    required this.packName,
    required this.assetPath,
    required this.jurisdiction,
    required this.version,
    required this.sourceAuthority,
    required this.publicationDate,
    required this.effectiveDate,
    required this.sha256,
    required this.provisionCount,
    required this.sizeBytes,
    this.footnoteCount = 0,
    this.referenceCount = 0,
    this.relationCount = 0,
    this.installed = false,
  });

  /// Pack identifier (`constitution_in_2026_v1`, `central_priority_acts_v1`).
  final String packId;

  /// Human-readable display title.
  final String packName;

  /// Asset path or download source.
  final String assetPath;

  /// Legal jurisdiction (`India`).
  final String jurisdiction;

  /// Version string.
  final String version;

  /// Official publishing authority.
  final String sourceAuthority;

  /// Official publication date (`YYYY-MM-DD`).
  final String publicationDate;

  /// Consolidated effective date (`YYYY-MM-DD`).
  final String effectiveDate;

  /// Expected SHA-256 verification digest.
  final String sha256;

  /// Number of statutory/constitutional provisions in this pack.
  final int provisionCount;

  /// Uncompressed pack JSON byte length.
  final int sizeBytes;

  /// Number of separated amendment/judicial footnotes.
  final int footnoteCount;

  /// Number of cataloged external references.
  final int referenceCount;

  /// Number of knowledge graph relations.
  final int relationCount;

  /// Whether verified & hydrated into the encrypted local database.
  final bool installed;
}

/// Manages SHA-256 verification and encrypted offline hydration of versioned
/// Indian Legal Knowledge Packs (`Module H` + Constitution Book Engine).
class KnowledgePackService {
  /// Creates a [KnowledgePackService].
  const new(this._db, [this._bundle]);

  /// Catalog manifest asset path.
  static const String catalogAssetPath =
      'assets/corpus/packs/pack_catalog.json';

  /// Staleness notice shown alongside every offline pack.
  static const String stalenessNotice =
      'Offline packs are fixed snapshots by publication date and may not reflect subsequent Gazette amendments or court rulings.';

  final AppDatabase _db;
  final AssetBundle? _bundle;

  AssetBundle get _effectiveBundle => _bundle ?? rootBundle;

  /// Loads pack catalog entries merged with local DB installation status.
  Future<Result<List<KnowledgePackSummary>>> loadCatalog() => Result.guard(
    () async {
      final rawCatalog = await _effectiveBundle.loadString(catalogAssetPath);
      final decoded = jsonDecode(rawCatalog) as Map<String, dynamic>;
      final rawPacks = decoded['packs'] as List<dynamic>? ?? const [];

      final installedRows = await _db.select(_db.legalKnowledgePacks).get();
      final installedIds = {for (final r in installedRows) r.packId: r};

      final summaries = <KnowledgePackSummary>[];
      for (final item in rawPacks.whereType<Map<String, dynamic>>()) {
        final packId = item['pack_id']?.toString() ?? '';
        final existing = installedIds[packId];
        summaries.add(
          KnowledgePackSummary(
            packId: packId,
            packName: item['pack_name']?.toString() ?? packId,
            assetPath: item['asset_path']?.toString() ?? '',
            jurisdiction: item['jurisdiction']?.toString() ?? 'India',
            version: item['version']?.toString() ?? '1.0.0',
            sourceAuthority: item['source_authority']?.toString() ?? '',
            publicationDate: item['publication_date']?.toString() ?? '',
            effectiveDate: item['effective_date']?.toString() ?? '',
            sha256: item['sha256']?.toString() ?? '',
            provisionCount: (item['provision_count'] as num?)?.toInt() ?? 0,
            sizeBytes: (item['size_bytes'] as num?)?.toInt() ?? 0,
            footnoteCount: (item['footnote_count'] as num?)?.toInt() ?? 0,
            referenceCount: (item['reference_count'] as num?)?.toInt() ?? 0,
            relationCount: (item['relation_count'] as num?)?.toInt() ?? 0,
            installed:
                existing != null &&
                existing.sha256 == item['sha256']?.toString(),
          ),
        );
      }
      return summaries;
    },
    onError: (error, _) =>
        StorageFailure('Failed to read Knowledge Pack catalog.', cause: error),
  );

  /// Verifies [pack]'s SHA-256 digest and hydrates provisions, footnotes,
  /// external references, and knowledge graph edges into [AppDatabase] and
  /// `LegalSections` FTS5 cleanly.
  Future<Result<int>> installAndVerifyPack(
    KnowledgePackSummary pack,
  ) => Result.guard(
    () async {
      final byteData = await _effectiveBundle.load(pack.assetPath);
      final bytes = byteData.buffer.asUint8List(
        byteData.offsetInBytes,
        byteData.lengthInBytes,
      );
      final actualSha = sha256.convert(bytes).toString().toLowerCase();
      if (pack.sha256.isNotEmpty && actualSha != pack.sha256.toLowerCase()) {
        throw StateError(
          'SHA-256 mismatch for ${pack.packId}: expected ${pack.sha256}, got $actualSha',
        );
      }

      final payload = jsonDecode(utf8.decode(bytes)) as Map<String, dynamic>;
      final provisions = payload['provisions'] as List<dynamic>? ?? const [];
      final footnotes = payload['footnotes'] as List<dynamic>? ?? const [];
      final references = payload['references'] as List<dynamic>? ?? const [];
      final entities = payload['entities'] as List<dynamic>? ?? const [];
      final relations = payload['relations'] as List<dynamic>? ?? const [];
      final instrumentsList = <Map<String, dynamic>>[
        if (payload['instrument'] is Map<String, dynamic>)
          payload['instrument'] as Map<String, dynamic>,
        if (payload['instruments'] is List<dynamic>)
          ...(payload['instruments'] as List<dynamic>)
              .whereType<Map<String, dynamic>>(),
      ];

      var hydratedProvisionsCount = 0;

      await _db.transaction(() async {
        if (instrumentsList.isNotEmpty) {
          await _db.batch((batch) {
            batch.insertAllOnConflictUpdate(
              _db.legalInstruments,
              instrumentsList.map((inst) {
                return LegalInstrumentsCompanion.insert(
                  instrumentId: inst['instrument_id']?.toString() ?? '',
                  instrumentType:
                      inst['instrument_type']?.toString() ?? 'central_act',
                  title: inst['title']?.toString() ?? '',
                  shortCode: inst['short_code']?.toString() ?? '',
                  editionDate: Value(inst['edition_date']?.toString()),
                  sourceAuthority: inst['source_authority']?.toString() ?? '',
                  sourceUrl: Value(inst['source_url']?.toString()),
                  fullTextAvailable: Value(inst['full_text_available'] == true),
                  verificationStatus: Value(
                    inst['verification_status']?.toString() ?? 'pending_review',
                  ),
                  provisionCount: Value(
                    (inst['provision_count'] as num?)?.toInt() ?? 0,
                  ),
                );
              }).toList(),
            );
          });
        }

        final provCompanions = <LegalProvisionsCompanion>[];
        final sectionCompanions = <LegalSectionsCompanion>[];
        final actTitles = {
          for (final i in instrumentsList)
            (i['instrument_id']?.toString() ?? ''):
                (i['title']?.toString() ?? ''),
        };

        for (final raw in provisions.whereType<Map<String, dynamic>>()) {
          final cref = raw['canonical_ref']?.toString() ?? '';
          final instId = raw['instrument_id']?.toString() ?? '';
          final number = raw['number']?.toString() ?? '';
          final title = raw['title']?.toString() ?? '';
          final chapter = raw['part_or_chapter']?.toString() ?? '';
          final body = raw['official_text']?.toString() ?? '';
          final status = raw['consolidated_status']?.toString() ?? 'active';
          if (cref.isEmpty || body.isEmpty) continue;

          provCompanions.add(
            LegalProvisionsCompanion.insert(
              canonicalRef: cref,
              instrumentId: instId,
              parentRef: Value(raw['parent_ref']?.toString() ?? ''),
              provisionType: raw['provision_type']?.toString() ?? 'provision',
              number: number,
              title: title,
              partOrChapter: Value(chapter),
              officialText: body,
              consolidatedStatus: Value(status),
              effectiveDate: Value(raw['effective_date']?.toString()),
              bookPage: Value((raw['book_page'] as num?)?.toInt() ?? 0),
              endPage: Value((raw['end_page'] as num?)?.toInt() ?? 0),
              sourceHash: Value(raw['source_hash']?.toString() ?? ''),
              fullTextAvailable: Value(raw['full_text_available'] != false),
              verificationStatus: Value(
                raw['verification_status']?.toString() ?? 'verified_in_book',
              ),
            ),
          );

          // Bridge into LegalSections so SectionReader & FTS search work seamlessly.
          final bridgedActCode = instId == 'CONST_IN_2026' ? 'CONST' : instId;
          final bridgedNumber = cref == 'CONST:PREAMBLE'
              ? 'PREAMBLE'
              : cref.startsWith('CONST:SCH:')
              ? cref.replaceFirst('CONST:', '')
              : cref.startsWith('CONST:APP:')
              ? cref.replaceFirst('CONST:', '')
              : number;
          final statusBanner = status == 'active'
              ? null
              : '[Status: $status${raw['effective_date'] != null ? ' · w.e.f. ${raw['effective_date']}' : ''}]';
          sectionCompanions.add(
            LegalSectionsCompanion.insert(
              actCode: bridgedActCode,
              actName: actTitles[instId] ?? bridgedActCode,
              sectionNumber: bridgedNumber,
              title: title,
              chapter: chapter,
              bodyText: body,
              sourceUrl:
                  'offline://pack/${pack.packId}#p${raw['book_page'] ?? 1}',
              legacyMapping: Value(statusBanner),
            ),
          );
        }

        if (provCompanions.isNotEmpty) {
          hydratedProvisionsCount = provCompanions.length;
          await _db.batch((b) {
            b
              ..insertAllOnConflictUpdate(_db.legalProvisions, provCompanions)
              ..insertAllOnConflictUpdate(_db.legalSections, sectionCompanions);
          });
        }

        if (footnotes.isNotEmpty) {
          await _db.batch((b) {
            b.insertAllOnConflictUpdate(
              _db.legalFootnotes,
              footnotes.whereType<Map<String, dynamic>>().map((f) {
                return LegalFootnotesCompanion.insert(
                  footnoteId: f['footnote_id']?.toString() ?? '',
                  provisionRef: f['provision_ref']?.toString() ?? '',
                  footnoteNumber: f['footnote_number']?.toString() ?? '',
                  bookPage: (f['book_page'] as num?)?.toInt() ?? 0,
                  footnoteType: f['footnote_type']?.toString() ?? 'editorial',
                  noteText: f['note_text']?.toString() ?? '',
                  referencedInstrumentsJson: Value(
                    jsonEncode(f['referenced_instruments'] ?? const []),
                  ),
                );
              }).toList(),
            );
          });
        }

        if (references.isNotEmpty) {
          await _db.batch((b) {
            b.insertAllOnConflictUpdate(
              _db.legalReferences,
              references.whereType<Map<String, dynamic>>().map((r) {
                return LegalReferencesCompanion.insert(
                  referenceId: r['reference_id']?.toString() ?? '',
                  referenceType: r['reference_type']?.toString() ?? '',
                  title: r['title']?.toString() ?? '',
                  referenceNumber: r['reference_number']?.toString() ?? '',
                  parentDocument: r['parent_document']?.toString() ?? '',
                  bookPage: (r['book_page'] as num?)?.toInt() ?? 0,
                  sourceText: r['source_text']?.toString() ?? '',
                  extractionMethod: Value(
                    r['extraction_method']?.toString() ?? 'pdf_text',
                  ),
                  confidence: Value(
                    r['confidence']?.toString() ?? 'review_required',
                  ),
                  fullTextAvailable: Value(r['full_text_available'] == true),
                  verificationStatus: Value(
                    r['verification_status']?.toString() ?? 'pending_review',
                  ),
                  sourceProvisionRef:
                      r['source_provision_ref']?.toString() ?? '',
                );
              }).toList(),
            );
          });
        }

        if (entities.isNotEmpty) {
          await _db.batch((b) {
            b.insertAllOnConflictUpdate(
              _db.legalEntities,
              entities.whereType<Map<String, dynamic>>().map((e) {
                return LegalEntitiesCompanion.insert(
                  entityId: e['entity_id']?.toString() ?? '',
                  entityType: e['entity_type']?.toString() ?? '',
                  canonicalRef: e['canonical_ref']?.toString() ?? '',
                  label: e['label']?.toString() ?? '',
                  fullTextAvailable: Value(e['full_text_available'] == true),
                  metadataJson: Value(jsonEncode(e['metadata'] ?? const {})),
                );
              }).toList(),
            );
          });
        }

        if (relations.isNotEmpty) {
          await _db.batch((b) {
            b.insertAllOnConflictUpdate(
              _db.legalRelations,
              relations.whereType<Map<String, dynamic>>().map((rel) {
                return LegalRelationsCompanion.insert(
                  relationId: rel['relation_id']?.toString() ?? '',
                  fromEntity: rel['from_entity']?.toString() ?? '',
                  relationType: rel['relation_type']?.toString() ?? '',
                  toEntity: rel['to_entity']?.toString() ?? '',
                  sourceRef: rel['source_ref']?.toString() ?? '',
                  bookPage: Value((rel['book_page'] as num?)?.toInt() ?? 0),
                  confidence: Value(rel['confidence']?.toString() ?? 'high'),
                  verificationStatus: Value(
                    rel['verification_status']?.toString() ??
                        'verified_in_book',
                  ),
                );
              }).toList(),
            );
          });
        }

        await _db
            .into(_db.legalKnowledgePacks)
            .insertOnConflictUpdate(
              LegalKnowledgePacksCompanion.insert(
                packId: pack.packId,
                packName: pack.packName,
                jurisdiction: Value(pack.jurisdiction),
                version: pack.version,
                sourceAuthority: pack.sourceAuthority,
                publicationDate: pack.publicationDate,
                effectiveDate: pack.effectiveDate,
                sha256: actualSha,
                provisionCount: Value(provCompanions.length),
                sizeBytes: Value(bytes.length),
              ),
            );
      });

      await _db.rebuildCorpusFtsIndex();
      return hydratedProvisionsCount;
    },
    onError: (error, _) => StorageFailure(
      'Failed to verify and install Knowledge Pack.',
      cause: error,
    ),
  );

  /// Installs all bundled verified packs from [catalogAssetPath].
  Future<Result<int>> ensureBundledPacksInstalled() => Result.guard(
    () async {
      final catalogRes = await loadCatalog();
      final packs = catalogRes.valueOrNull ?? const <KnowledgePackSummary>[];
      var total = 0;
      for (final p in packs) {
        if (!p.installed) {
          final res = await installAndVerifyPack(p);
          total += res.valueOrNull ?? 0;
        }
      }
      return total;
    },
    onError: (error, _) => StorageFailure(
      'Failed to hydrate offline Knowledge Packs.',
      cause: error,
    ),
  );
}
