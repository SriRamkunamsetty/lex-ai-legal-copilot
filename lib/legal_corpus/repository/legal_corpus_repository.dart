import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter/services.dart';
import 'package:lex_copilot/core/errors/failure.dart';
import 'package:lex_copilot/core/result.dart';
import 'package:lex_copilot/core/storage/app_database.dart';
import 'package:lex_copilot/legal_corpus/models/legal_section.dart';

/// Offline repository for India's statutory corpus backed by encrypted Drift
/// and SQLite FTS5 full-text search.
class LegalCorpusRepository {
  /// Creates a [LegalCorpusRepository].
  const new(this._db, [this._bundle]);

  /// Path to the bundled versioned corpus asset.
  static const String defaultAssetPath =
      'assets/corpus/indian_law_corpus_v1.json';

  final AppDatabase _db;
  final AssetBundle? _bundle;

  AssetBundle get _effectiveBundle => _bundle ?? rootBundle;

  /// Ensures the offline statutory corpus is loaded into the encrypted DB.
  ///
  /// Returns the number of sections available after seeding.
  Future<Result<int>> ensureSeeded({
    String assetPath = defaultAssetPath,
  }) => Result.guard(
    () async {
      final countExp = _db.legalSections.sectionNumber.count();
      final query = _db.selectOnly(_db.legalSections)..addColumns([countExp]);
      final existing = (await query.getSingle()).read(countExp) ?? 0;
      if (existing > 0) {
        return existing;
      }

      final rawJson = await _effectiveBundle.loadString(assetPath);
      final decoded = jsonDecode(rawJson);
      if (decoded is! Map<String, dynamic>) {
        throw const FormatException('Corpus JSON root must be a JSON object.');
      }
      final rawSections = decoded['sections'];
      if (rawSections is! List<dynamic>) {
        throw const FormatException('Corpus JSON must contain sections list.');
      }

      final companions = <LegalSectionsCompanion>[];
      for (final item in rawSections) {
        if (item is! Map<String, dynamic>) continue;
        final actCode = (item['act_code'] as String? ?? '').trim();
        final sectionNumber = (item['section_number'] as String? ?? '').trim();
        final text = (item['text'] as String? ?? '').trim();
        if (actCode.isEmpty || sectionNumber.isEmpty || text.isEmpty) continue;

        final punishment = _extractPunishment(text);
        final related = _extractRelatedSections(actCode, sectionNumber, text);
        final plain = _curatedPlainLanguage(actCode, sectionNumber);

        companions.add(
          LegalSectionsCompanion.insert(
            actCode: actCode,
            actName: (item['act_name'] as String? ?? actCode).trim(),
            sectionNumber: sectionNumber,
            title: (item['title'] as String? ?? 'Section $sectionNumber')
                .trim(),
            chapter: (item['chapter'] as String? ?? '').trim(),
            bodyText: text,
            sourceUrl: (item['source_url'] as String? ?? '').trim(),
            legacyMapping: Value(item['legacy_mapping'] as String?),
            plainLanguage: Value(plain),
            punishment: Value(punishment),
            relatedSectionsJson: Value(jsonEncode(related)),
          ),
        );
      }

      await _db.batch((batch) {
        batch.insertAllOnConflictUpdate(_db.legalSections, companions);
      });
      await _db.rebuildCorpusFtsIndex();
      return companions.length;
    },
    onError: (error, _) =>
        StorageFailure('Failed to load offline legal corpus.', cause: error),
  );

  /// Fetches a single section by [actCode] (case-insensitive) and
  /// [sectionNumber].
  Future<Result<LegalSectionModel>> getSection(
    String actCode,
    String sectionNumber,
  ) => Result.guard(
    () async {
      final normalizedAct = actCode.trim().toUpperCase();
      final normalizedNum = sectionNumber.trim();
      final row =
          await (_db.select(_db.legalSections)..where(
                (t) =>
                    t.actCode.equals(normalizedAct) &
                    t.sectionNumber.equals(normalizedNum),
              ))
              .getSingleOrNull();
      if (row == null) {
        throw _MissingSectionException(normalizedAct, normalizedNum);
      }
      return _mapRow(row);
    },
    onError: (error, _) => error is _MissingSectionException
        ? NotFoundFailure(
            '${error.actCode} Section ${error.sectionNumber} was not found in the local corpus.',
          )
        : StorageFailure('Failed to read section.', cause: error),
  );

  /// Lists sections for [actCode] (or all acts if `null`) ordered by insertion.
  Future<Result<List<LegalSectionModel>>> listSections({
    String? actCode,
    int limit = 50,
    int offset = 0,
  }) => Result.guard(
    () async {
      final stmt = _db.select(_db.legalSections);
      if (actCode != null && actCode.trim().isNotEmpty) {
        stmt.where((t) => t.actCode.equals(actCode.trim().toUpperCase()));
      }
      stmt.limit(limit, offset: offset);
      final rows = await stmt.get();
      return rows.map(_mapRow).toList();
    },
    onError: (error, _) =>
        StorageFailure('Failed to list sections.', cause: error),
  );

  /// Performs offline full-text + citation search across the corpus.
  Future<Result<List<LegalSectionModel>>> search(
    String query, {
    String? actCode,
    int limit = 25,
  }) => Result.guard(
    () async {
      final trimmed = query.trim();
      if (trimmed.isEmpty) {
        final listed = await listSections(actCode: actCode, limit: limit);
        return listed.valueOrNull ?? const [];
      }

      final results = <LegalSectionModel>[];
      final seen = <String>{};

      void addIfNew(LegalSectionModel section) {
        final key = '${section.actCode}:${section.sectionNumber}';
        if (seen.add(key)) {
          results.add(section);
        }
      }

      // 1. Direct citation match (e.g., "BNS 304", "304", "BNSS 173")
      final citationMatch = RegExp(
        r'^(?:(BNS|BNSS|BSA)\s+)?(\d+[A-Z]?)$',
        caseSensitive: false,
      ).firstMatch(trimmed);
      if (citationMatch != null) {
        final matchedAct =
            citationMatch.group(1)?.toUpperCase() ?? actCode?.toUpperCase();
        final matchedNum = citationMatch.group(2)!;
        final directQuery = _db.select(_db.legalSections)
          ..where((t) {
            final numCond = t.sectionNumber.equals(matchedNum);
            return matchedAct != null
                ? numCond & t.actCode.equals(matchedAct)
                : numCond;
          });
        for (final row in await directQuery.get()) {
          addIfNew(_mapRow(row));
        }
      }

      // 2. FTS5 full-text search
      final ftsTerms = trimmed
          .split(RegExp(r'\s+'))
          .map((t) => t.replaceAll(RegExp('[^a-zA-Z0-9]'), ''))
          .where((t) => t.isNotEmpty)
          .map((t) => '$t*')
          .toList();

      if (ftsTerms.isNotEmpty) {
        final ftsExpr = ftsTerms.join(' ');
        final actFilter = actCode != null && actCode.trim().isNotEmpty
            ? ' AND s.act_code = ?'
            : '';
        final variables = <Variable<Object>>[
          Variable.withString(ftsExpr),
          if (actFilter.isNotEmpty)
            Variable.withString(actCode!.trim().toUpperCase()),
          Variable.withInt(limit),
        ];

        final ftsRows = await _db
            .customSelect(
              'SELECT s.* FROM legal_sections_fts f '
              'JOIN legal_sections s '
              '  ON s.act_code = f.act_code AND s.section_number = f.section_number '
              'WHERE legal_sections_fts MATCH ?$actFilter '
              'ORDER BY bm25(legal_sections_fts) '
              'LIMIT ?',
              variables: variables,
              readsFrom: {_db.legalSections},
            )
            .get();

        for (final row in ftsRows) {
          addIfNew(_mapCustomRow(row));
        }
      }

      // 3. Substring LIKE fallback if FTS returned fewer than limit
      if (results.length < limit) {
        final pattern = '%$trimmed%';
        final stmt = _db.select(_db.legalSections)
          ..where((t) {
            final match =
                t.title.like(pattern) |
                t.bodyText.like(pattern) |
                t.sectionNumber.like(pattern) |
                t.legacyMapping.like(pattern);
            return actCode != null && actCode.trim().isNotEmpty
                ? match & t.actCode.equals(actCode.trim().toUpperCase())
                : match;
          })
          ..limit(limit);
        for (final row in await stmt.get()) {
          addIfNew(_mapRow(row));
          if (results.length >= limit) break;
        }
      }

      return results.take(limit).toList();
    },
    onError: (error, _) =>
        StorageFailure('Corpus search failed.', cause: error),
  );

  LegalSectionModel _mapRow(LegalSection row) {
    final relatedRaw = jsonDecode(row.relatedSectionsJson);
    final related = relatedRaw is List
        ? relatedRaw.whereType<String>().toList()
        : const <String>[];
    return LegalSectionModel(
      actCode: row.actCode,
      actName: row.actName,
      sectionNumber: row.sectionNumber,
      title: row.title,
      chapter: row.chapter,
      text: row.bodyText,
      sourceUrl: row.sourceUrl,
      legacyMapping: row.legacyMapping,
      plainLanguage: row.plainLanguage,
      punishment: row.punishment,
      relatedSections: related,
    );
  }

  LegalSectionModel _mapCustomRow(QueryRow row) {
    final relatedRaw = jsonDecode(row.read<String>('related_sections_json'));
    final related = relatedRaw is List
        ? relatedRaw.whereType<String>().toList()
        : const <String>[];
    return LegalSectionModel(
      actCode: row.read<String>('act_code'),
      actName: row.read<String>('act_name'),
      sectionNumber: row.read<String>('section_number'),
      title: row.read<String>('title'),
      chapter: row.read<String>('chapter'),
      text: row.read<String>('body_text'),
      sourceUrl: row.read<String>('source_url'),
      legacyMapping: row.readNullable<String>('legacy_mapping'),
      plainLanguage: row.readNullable<String>('plain_language'),
      punishment: row.readNullable<String>('punishment'),
      relatedSections: related,
    );
  }

  /// Extracts a verbatim punishment sentence directly from official section text
  /// without fabricating penalties.
  static String? _extractPunishment(String text) {
    final normalized = text.replaceAll(RegExp(r'\s+'), ' ');
    final match = RegExp(
      r'((?:shall be )?punished with [^.]+\.)',
      caseSensitive: false,
    ).firstMatch(normalized);
    return match?.group(1)?.trim();
  }

  /// Extracts explicit intra-act section references from the official text.
  static List<String> _extractRelatedSections(
    String actCode,
    String selfNumber,
    String text,
  ) {
    final matches = RegExp(
      r'\bsection\s+(\d+[A-Z]?)\b',
      caseSensitive: false,
    ).allMatches(text);
    final refs = <String>{};
    for (final m in matches) {
      final num = m.group(1)!;
      if (num != selfNumber) {
        refs.add('$actCode:$num');
      }
      if (refs.length >= 4) break;
    }
    if (actCode == 'BNS' && (selfNumber == '303' || selfNumber == '304')) {
      refs.addAll(['BNS:303', 'BNS:304', 'BNS:309']..remove('BNS:$selfNumber'));
    }
    return refs.take(4).toList();
  }

  /// Verified plain-language summaries for core seeded sections; all other
  /// sections fall back cleanly to official text in the UI.
  static String? _curatedPlainLanguage(String actCode, String sectionNumber) =>
      switch ((actCode, sectionNumber)) {
        ('BNS', '303') => 'Taking someone’s movable property dishonestly without their consent is theft. First-time petty theft below ₹5,000 may carry community service if returned; general theft is punishable up to 3 years, fine, or both.',
        ('BNS', '304') => 'If someone suddenly, quickly, or forcibly grabs or takes away your phone, bag, or other movable property, BNS classifies it as snatching — punishable with up to 3 years imprisonment and a fine.',
        ('BNS', '309') => 'Theft or extortion becomes robbery when the offender causes or threatens instant death, hurt, or wrongful restraint while committing the offence or carrying away property.',
        ('BNSS', '173') => 'You can report a cognizable offence orally or electronically at any police station regardless of jurisdiction (Zero FIR). Electronic reports must be signed within 3 days, and you are entitled to a free copy of the FIR.',
        _ => null,
      };
}

class _MissingSectionException implements Exception {
  const new(this.actCode, this.sectionNumber);

  final String actCode;
  final String sectionNumber;
}
