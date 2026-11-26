import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

/// Offline Indian statutory sections table hydrated from the versioned corpus
/// asset.
class LegalSections extends Table {
  /// Short act code (`BNS`, `BNSS`, `BSA`, etc.).
  TextColumn get actCode => text()();

  /// Full act title (`Bharatiya Nyaya Sanhita, 2023`).
  TextColumn get actName => text()();

  /// Section identifier (`303`, `304`, `173`, etc.).
  TextColumn get sectionNumber => text()();

  /// Official marginal section title.
  TextColumn get title => text()();

  /// Chapter heading.
  TextColumn get chapter => text()();

  /// Verbatim statutory text.
  TextColumn get bodyText => text()();

  /// Official India Code / Gazette source URL.
  TextColumn get sourceUrl => text()();

  /// Optional legacy IPC / CrPC / IEA mapping.
  TextColumn get legacyMapping => text().nullable()();

  /// Optional curated plain-language explanation.
  TextColumn get plainLanguage => text().nullable()();

  /// Optional extracted or curated punishment summary.
  TextColumn get punishment => text().nullable()();

  /// JSON-encoded list of related section keys (e.g. `["BNS:303","BNS:309"]`).
  TextColumn get relatedSectionsJson =>
      text().withDefault(const Constant('[]'))();

  @override
  Set<Column<Object>> get primaryKey => {actCode, sectionNumber};
}

/// Bookmarked statutory sections saved by the user.
class Bookmarks extends Table {
  /// Auto-incrementing row ID.
  IntColumn get id => integer().autoIncrement()();

  /// Act code of the bookmarked section.
  TextColumn get actCode => text()();

  /// Section number of the bookmarked section.
  TextColumn get sectionNumber => text()();

  /// Optional user note.
  TextColumn get note => text().nullable()();

  /// Timestamp when bookmarked.
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

/// Scanned legal documents and extracted OCR/AI summaries.
class SavedScans extends Table {
  /// Stable UUID or timestamp ID.
  TextColumn get id => text()();

  /// Display file/document title.
  TextColumn get title => text()();

  /// Encrypted or app-private local file path.
  TextColumn get filePath => text()();

  /// Extracted OCR text.
  TextColumn get ocrText => text().withDefault(const Constant(''))();

  /// JSON-encoded structured summary fields.
  TextColumn get summaryJson => text().withDefault(const Constant('{}'))();

  /// Number of scanned pages.
  IntColumn get pageCount => integer().withDefault(const Constant(1))();

  /// Creation timestamp.
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  /// Optional auto-delete expiration timestamp.
  DateTimeColumn get expiresAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Saved legal document drafts generated from templates.
class SavedDrafts extends Table {
  /// Stable draft ID.
  TextColumn get id => text()();

  /// Template identifier (`rent_agreement`, `nda`, `legal_notice`, etc.).
  TextColumn get templateType => text()();

  /// User-facing draft title.
  TextColumn get title => text()();

  /// Draft body text with `[placeholder]` markers if incomplete.
  TextColumn get content => text()();

  /// JSON-encoded field values.
  TextColumn get fieldsJson => text().withDefault(const Constant('{}'))();

  /// Creation timestamp.
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  /// Last update timestamp.
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Local user activity log for Library History (no PII logged remotely).
class ActivityHistory extends Table {
  /// Auto-incrementing row ID.
  IntColumn get id => integer().autoIncrement()();

  /// Activity category (`section_view`, `chat`, `scan`, `incident`, `contract`, `draft`).
  TextColumn get kind => text()();

  /// Primary history title.
  TextColumn get title => text()();

  /// Secondary descriptor.
  TextColumn get subtitle => text()();

  /// In-app GoRouter location to reopen the item.
  TextColumn get route => text()();

  /// Event timestamp.
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

/// Active legal dispute / case matter grouping scans, drafts, timelines,
/// checklists, and reminders.
class CaseFiles extends Table {
  /// Stable case ID.
  TextColumn get id => text()();

  /// Short matter title (e.g. `Security Deposit Dispute`).
  TextColumn get title => text()();

  /// Category (`Civil`, `Criminal`, `Consumer`, `Tenancy`, `Employment`).
  TextColumn get category => text().withDefault(const Constant('General'))();

  /// Current case status (`Open`, `Notice sent`, `In progress`, `Closed`).
  TextColumn get status => text().withDefault(const Constant('Open'))();

  /// Plain-language matter summary / facts.
  TextColumn get summary => text().withDefault(const Constant(''))();

  /// Creation timestamp.
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  /// Last updated timestamp.
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Scheduled deadlines & hearings attached to a [CaseFiles] matter.
class CaseDeadlines extends Table {
  /// Auto-incrementing row ID.
  IntColumn get id => integer().autoIncrement()();

  /// Owning case ID.
  TextColumn get caseId => text()();

  /// Deadline description (e.g. `Reply to 30-day landlord notice`).
  TextColumn get title => text()();

  /// Due date/time.
  DateTimeColumn get dueAt => dateTime()();

  /// Whether a local notification has been scheduled.
  BoolColumn get reminderScheduled =>
      boolean().withDefault(const Constant(false))();

  /// Whether the deadline has been completed.
  BoolColumn get completed => boolean().withDefault(const Constant(false))();
}

/// Actionable compliance checklist & timeline events for a [CaseFiles] matter.
class CaseChecklistItems extends Table {
  /// Auto-incrementing row ID.
  IntColumn get id => integer().autoIncrement()();

  /// Owning case ID.
  TextColumn get caseId => text()();

  /// Step or attached artifact title.
  TextColumn get title => text()();

  /// Item category (`checklist`, `timeline`, `scan`, `draft`, `chat`).
  TextColumn get kind => text().withDefault(const Constant('checklist'))();

  /// Optional linked resource route or ID.
  TextColumn get referenceId => text().nullable()();

  /// Completion state.
  BoolColumn get done => boolean().withDefault(const Constant(false))();

  /// Creation timestamp.
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

/// Persistent Ask Lex conversation threads.
class Conversations extends Table {
  /// Stable conversation identifier.
  TextColumn get id => text()();

  /// Display title of the conversation.
  TextColumn get title =>
      text().withDefault(const Constant('Legal research'))();

  /// Optional linked scan ID.
  TextColumn get attachedScanId => text().nullable()();

  /// JSON-encoded attachment metadata if a scan is attached.
  TextColumn get attachedScanJson => text().nullable()();

  /// Creation timestamp.
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  /// Last message timestamp.
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Individual messages stored within a [Conversations] thread.
class Messages extends Table {
  /// Unique message ID.
  TextColumn get id => text()();

  /// Owning conversation ID.
  TextColumn get conversationId => text()();

  /// Whether sent by the user (`true`) or Lex (`false`).
  BoolColumn get isUser => boolean()();

  /// Message body text.
  TextColumn get content => text()();

  /// Engine provenance label (`Gemma 4 E2B · On-Device` or `Cloud · Gemma 4`).
  TextColumn get engineLabel => text().nullable()();

  /// Confidence level (`high`, `medium`, `low`).
  TextColumn get confidence => text().nullable()();

  /// JSON-encoded list of verified citations.
  TextColumn get citationsJson => text().withDefault(const Constant('[]'))();

  /// Optional retrieval and verification summary.
  TextColumn get reasoningTrail => text().nullable()();

  /// Optional counter-arguments summary.
  TextColumn get counterArguments => text().nullable()();

  /// Count of unverified citations removed by verifier.
  IntColumn get droppedUnverifiedCount =>
      integer().withDefault(const Constant(0))();

  /// Optional JSON-encoded scan attachment snapshot for the turn.
  TextColumn get attachmentJson => text().nullable()();

  /// Optional recoverable failure message.
  TextColumn get errorMessage => text().nullable()();

  /// Creation timestamp.
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Chunked text & local embedding vectors for documents & Knowledge Packs.
class DocumentChunks extends Table {
  /// Unique chunk ID.
  TextColumn get id => text()();

  /// Source scan, contract, or provision ID.
  TextColumn get sourceId => text()();

  /// Source classification (`scan`, `contract`, `statute`).
  TextColumn get sourceKind => text()();

  /// 1-based page number when available.
  IntColumn get pageNumber => integer().withDefault(const Constant(1))();

  /// 0-based sequential chunk index.
  IntColumn get chunkIndex => integer()();

  /// Normalized chunk content.
  TextColumn get chunkText => text()();

  /// Optional JSON or float32 bytes of local semantic embedding.
  BlobColumn get embeddingBlob => blob().nullable()();

  /// Creation timestamp.
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Persisted contract risk assessments powering live Risk Radar & exports.
class ContractAnalyses extends Table {
  /// Unique analysis ID.
  TextColumn get id => text()();

  /// Analyzed document filename/title.
  TextColumn get title => text()();

  /// Optional local document path.
  TextColumn get documentPath => text().nullable()();

  /// Aggregate 0-100 risk score.
  IntColumn get overallScore => integer()();

  /// JSON summary / risk factor breakdown.
  TextColumn get summaryJson => text().withDefault(const Constant('{}'))();

  /// Engine provenance (`Gemma 4 · On-Device` / `Cloud · Gemma 4` / `Heuristic`).
  TextColumn get engineLabel =>
      text().withDefault(const Constant('Gemma 4 · On-Device'))();

  /// Analysis timestamp.
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Clause-level contract risk findings linked to [ContractAnalyses].
class RiskFindings extends Table {
  /// Unique finding ID.
  TextColumn get id => text()();

  /// Owning [ContractAnalyses.id].
  TextColumn get analysisId => text()();

  /// Clause heading.
  TextColumn get clauseTitle => text()();

  /// Clause numbering or section reference.
  TextColumn get clauseReference => text().nullable()();

  /// 1-based page number if extracted from PDF/DOCX.
  IntColumn get pageNumber => integer().withDefault(const Constant(1))();

  /// Risk severity (`high`, `medium`, `low`).
  TextColumn get riskLevel => text()();

  /// Legal risk category (e.g. `indemnity`, `termination`, `arbitration`).
  TextColumn get riskCategory =>
      text().withDefault(const Constant('general'))();

  /// Verbatim clause excerpt.
  TextColumn get originalText => text()();

  /// Plain-language legal risk explanation.
  TextColumn get explanation => text()();

  /// Grounded statutory or evidence note.
  TextColumn get evidence => text().nullable()();

  /// Suggested safer rewrite.
  TextColumn get suggestedRewrite => text()();

  /// Whether the user applied the safer rewrite.
  BoolColumn get applied => boolean().withDefault(const Constant(false))();

  /// Verification state (`verified`, `review_required`).
  TextColumn get verificationStatus =>
      text().withDefault(const Constant('review_required'))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Installed offline legal knowledge pack metadata and integrity hashes.
class LegalKnowledgePacks extends Table {
  /// Unique pack ID (`constitution_in_2026_v1`, `bns_bnss_bsa_v1`, etc.).
  TextColumn get packId => text()();

  /// Human-readable pack name.
  TextColumn get packName => text()();

  /// Jurisdiction (`India`, `Central`, state code).
  TextColumn get jurisdiction => text().withDefault(const Constant('India'))();

  /// Semantic or date-based version string.
  TextColumn get version => text()();

  /// Publishing authority (`Ministry of Law and Justice`, `India Code`).
  TextColumn get sourceAuthority => text()();

  /// Official publication date (`YYYY-MM-DD`).
  TextColumn get publicationDate => text()();

  /// Consolidated effective date (`YYYY-MM-DD`).
  TextColumn get effectiveDate => text()();

  /// SHA-256 verification digest of the pack bundle.
  TextColumn get sha256 => text()();

  /// Number of indexed provisions inside this pack.
  IntColumn get provisionCount => integer().withDefault(const Constant(0))();

  /// Size on disk in bytes.
  IntColumn get sizeBytes => integer().withDefault(const Constant(0))();

  /// Installation timestamp.
  DateTimeColumn get installedAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column<Object>> get primaryKey => {packId};
}

/// Statutory compliance checklists & progress records.
class ComplianceRecords extends Table {
  /// Unique record ID.
  TextColumn get id => text()();

  /// Compliance framework (`DPDP_2023`, `STARTUP_LABOUR`, etc.).
  TextColumn get framework => text()();

  /// Requirement title.
  TextColumn get title => text()();

  /// Statutory citation reference (`DPDP:8`, etc.).
  TextColumn get citationRef => text()();

  /// Official authority.
  TextColumn get sourceAuthority => text()();

  /// Effective / commencement status date.
  TextColumn get effectiveDate => text()();

  /// Verification status (`verified`, `partial`, `pending_review`).
  TextColumn get verificationStatus => text()();

  /// User progress (`pending`, `in_progress`, `completed`, `not_applicable`).
  TextColumn get status => text().withDefault(const Constant('pending'))();

  /// Optional user compliance note.
  TextColumn get notes => text().withDefault(const Constant(''))();

  /// Last update timestamp.
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Zero-PII telemetry table recording engine latency and success metrics.
class AiExecutionLogs extends Table {
  /// Unique event ID.
  TextColumn get id => text()();

  /// Task category (`chat`, `scan`, `contract`, `draft`, `incident`).
  TextColumn get taskKind => text()();

  /// Active engine (`Gemma 4 E2B · On-Device`, `Cloud · Gemma 4`, etc.).
  TextColumn get engineLabel => text()();

  /// Duration in milliseconds.
  IntColumn get latencyMs => integer()();

  /// Estimated token count (no raw text).
  IntColumn get tokenEstimate => integer().withDefault(const Constant(0))();

  /// Whether execution completed cleanly.
  BoolColumn get success => boolean()();

  /// Execution timestamp.
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Security & consent audit log stored locally (strictly non-PII summaries).
class AuditEvents extends Table {
  /// Unique event ID.
  TextColumn get id => text()();

  /// Event code (`cloud_consent_granted`, `cloud_consent_denied`, `vault_wiped`).
  TextColumn get eventType => text()();

  /// Safe audit description without personal identifiers.
  TextColumn get summary => text()();

  /// Event timestamp.
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Registry of Constitutional, Central, and State legal instruments & verification state.
class LegalInstruments extends Table {
  /// Canonical instrument ID (`CONST_IN_2026`, `DPDP_2023`, `IT_2000`, `ICA_1872`).
  TextColumn get instrumentId => text()();

  /// Category (`constitution`, `central_act`, `state_act`, `amendment_act`, `constitutional_order`).
  TextColumn get instrumentType => text()();

  /// Official title.
  TextColumn get title => text()();

  /// Normalized short code (`CONST`, `DPDP_2023`, `IT_2000`).
  TextColumn get shortCode => text()();

  /// Consolidation / publication date (`YYYY-MM-DD`).
  TextColumn get editionDate => text().nullable()();

  /// Authoritative government source authority.
  TextColumn get sourceAuthority => text()();

  /// Official India Code / MeitY / Gazette source URL.
  TextColumn get sourceUrl => text().nullable()();

  /// Whether verified verbatim section text is present locally.
  BoolColumn get fullTextAvailable =>
      boolean().withDefault(const Constant(false))();

  /// Verification state (`verified_in_book`, `verified`, `pending_review`, `outdated`).
  TextColumn get verificationStatus =>
      text().withDefault(const Constant('pending_review'))();

  /// Indexed provision count.
  IntColumn get provisionCount => integer().withDefault(const Constant(0))();

  @override
  Set<Column<Object>> get primaryKey => {instrumentId};
}

/// Consolidated statutory & constitutional provisions with amendment lifecycle states.
class LegalProvisions extends Table {
  /// Canonical key (`CONST:ART:21`, `CONST:PREAMBLE`, `CENTRAL:DPDP_2023:8`).
  TextColumn get canonicalRef => text()();

  /// Parent [LegalInstruments.instrumentId].
  TextColumn get instrumentId => text()();

  /// Parent entity key (`INST:CONSTITUTION_INDIA_2026`).
  TextColumn get parentRef => text().withDefault(const Constant(''))();

  /// Provision type (`preamble`, `constitutional_article`, `schedule`, `appendix`, `section`).
  TextColumn get provisionType => text()();

  /// Article / Schedule / Section number string.
  TextColumn get number => text()();

  /// Official heading.
  TextColumn get title => text()();

  /// Part, Chapter, or Schedule label.
  TextColumn get partOrChapter => text().withDefault(const Constant(''))();

  /// Verbatim extracted legal text.
  TextColumn get officialText => text()();

  /// Status (`active`, `omitted_repealed`, `unnotified_prospective`, `struck_down_judicial`).
  TextColumn get consolidatedStatus =>
      text().withDefault(const Constant('active'))();

  /// Commencement / effective date (`w.e.f.`) if known.
  TextColumn get effectiveDate => text().nullable()();

  /// Start page number in source book/PDF.
  IntColumn get bookPage => integer().withDefault(const Constant(0))();

  /// End page number in source book/PDF.
  IntColumn get endPage => integer().withDefault(const Constant(0))();

  /// SHA-256 content hash.
  TextColumn get sourceHash => text().withDefault(const Constant(''))();

  /// Whether full text is verified present.
  BoolColumn get fullTextAvailable =>
      boolean().withDefault(const Constant(true))();

  /// Verification gate status.
  TextColumn get verificationStatus =>
      text().withDefault(const Constant('verified_in_book'))();

  @override
  Set<Column<Object>> get primaryKey => {canonicalRef};
}

/// Separated amendment, commencement, and judicial invalidation footnotes.
class LegalFootnotes extends Table {
  /// Unique footnote ID.
  TextColumn get footnoteId => text()();

  /// Target provision canonical ref.
  TextColumn get provisionRef => text()();

  /// Printed footnote number or asterisk marker.
  TextColumn get footnoteNumber => text()();

  /// Source book page number.
  IntColumn get bookPage => integer()();

  /// Category (`amendment`, `judicial_invalidation`, `commencement_unnotified`, `constitutional_order`, `editorial`).
  TextColumn get footnoteType => text()();

  /// Verbatim footnote text.
  TextColumn get noteText => text()();

  /// JSON array of referenced instrument IDs mentioned inside the footnote.
  TextColumn get referencedInstrumentsJson =>
      text().withDefault(const Constant('[]'))();

  @override
  Set<Column<Object>> get primaryKey => {footnoteId};
}

/// Extracted cross-references catalogued from source books (with strict `fullTextAvailable` flag).
class LegalReferences extends Table {
  /// Unique extraction trace ID.
  TextColumn get referenceId => text()();

  /// Reference class (`legislative_act`, `amendment_act`, `constitutional_order`, `judicial_decision`).
  TextColumn get referenceType => text()();

  /// Extracted Act, Amendment, or Judgment title/citation.
  TextColumn get title => text()();

  /// Reference number / Ninth Schedule Entry / Citation.
  TextColumn get referenceNumber => text()();

  /// Source book title (`Constitution of India`).
  TextColumn get parentDocument => text()();

  /// Exact book page number.
  IntColumn get bookPage => integer()();

  /// Verbatim excerpt from the source book.
  TextColumn get sourceText => text()();

  /// Extraction method (`pdf_text`, `ocr`).
  TextColumn get extractionMethod =>
      text().withDefault(const Constant('pdf_text'))();

  /// Extraction confidence (`high`, `review_required`).
  TextColumn get confidence =>
      text().withDefault(const Constant('review_required'))();

  /// Whether full statutory/judgment text is locally available (`false` for external acts in Constitution footnotes).
  BoolColumn get fullTextAvailable =>
      boolean().withDefault(const Constant(false))();

  /// Review status (`verified_in_book`, `pending_review`, `rejected`).
  TextColumn get verificationStatus =>
      text().withDefault(const Constant('pending_review'))();

  /// Source provision citing this reference.
  TextColumn get sourceProvisionRef => text()();

  @override
  Set<Column<Object>> get primaryKey => {referenceId};
}

/// Relational Legal Knowledge Graph nodes (Module D).
class LegalEntities extends Table {
  /// Unique entity ID.
  TextColumn get entityId => text()();

  /// Node type (`constitution`, `constitutional_article`, `legislative_act`, `judicial_decision`, etc.).
  TextColumn get entityType => text()();

  /// Canonical ID string.
  TextColumn get canonicalRef => text()();

  /// Human-readable node label.
  TextColumn get label => text()();

  /// Whether verified full text exists for this node.
  BoolColumn get fullTextAvailable =>
      boolean().withDefault(const Constant(false))();

  /// JSON metadata payload.
  TextColumn get metadataJson => text().withDefault(const Constant('{}'))();

  @override
  Set<Column<Object>> get primaryKey => {entityId};
}

/// Relational Legal Knowledge Graph directed edges (Module D).
class LegalRelations extends Table {
  /// Unique edge ID.
  TextColumn get relationId => text()();

  /// Source entity ID.
  TextColumn get fromEntity => text()();

  /// Directed relation (`amends`, `omits`, `struck_down_by`, `interprets`, `protected_under_schedule_9`, `cross_references`).
  TextColumn get relationType => text()();

  /// Target entity ID.
  TextColumn get toEntity => text()();

  /// Provenance note (`Constitution fn p.89`).
  TextColumn get sourceRef => text()();

  /// Source page number.
  IntColumn get bookPage => integer().withDefault(const Constant(0))();

  /// Edge confidence (`high`, `review_required`).
  TextColumn get confidence => text().withDefault(const Constant('high'))();

  /// Verification state (`verified_in_book`, `pending_review`).
  TextColumn get verificationStatus =>
      text().withDefault(const Constant('verified_in_book'))();

  @override
  Set<Column<Object>> get primaryKey => {relationId};
}

/// Encrypted Drift database using SQLite3MultipleCiphers (`PRAGMA key`).
@DriftDatabase(
  tables: [
    LegalSections,
    Bookmarks,
    SavedScans,
    SavedDrafts,
    ActivityHistory,
    CaseFiles,
    CaseDeadlines,
    CaseChecklistItems,
    Conversations,
    Messages,
    DocumentChunks,
    ContractAnalyses,
    RiskFindings,
    LegalKnowledgePacks,
    ComplianceRecords,
    AiExecutionLogs,
    AuditEvents,
    LegalInstruments,
    LegalProvisions,
    LegalFootnotes,
    LegalReferences,
    LegalEntities,
    LegalRelations,
  ],
)
class AppDatabase extends _$AppDatabase {
  /// Opens an encrypted [AppDatabase] at the platform app-support directory
  /// using [encryptionKey].
  factory openEncrypted({required String encryptionKey}) {
    final executor = LazyDatabase(() async {
      final dir = await getApplicationSupportDirectory();
      final dbFile = File(p.join(dir.path, 'lex_vault_v1.sqlite'));
      final escapedKey = encryptionKey.replaceAll("'", "''");
      return NativeDatabase.createInBackground(
        dbFile,
        setup: (rawDb) {
          rawDb
            ..execute("PRAGMA key = '$escapedKey';")
            ..execute("PRAGMA cipher = 'sqlcipher';")
            ..execute('PRAGMA foreign_keys = ON;');
        },
      );
    });
    return AppDatabase._(executor);
  }

  /// Creates an [AppDatabase] backed by a custom [QueryExecutor] (e.g.
  /// `NativeDatabase.memory()` in tests).
  new forTesting(super.e);

  new _(super.e);

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      await customStatement(
        'CREATE UNIQUE INDEX IF NOT EXISTS idx_bookmarks_act_section '
        'ON bookmarks(act_code, section_number)',
      );
      await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_messages_conversation '
        'ON messages(conversation_id, created_at)',
      );
      await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_legal_footnotes_prov '
        'ON legal_footnotes(provision_ref)',
      );
      await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_legal_relations_endpoints '
        'ON legal_relations(from_entity, to_entity)',
      );
      await customStatement(
        'CREATE VIRTUAL TABLE IF NOT EXISTS legal_sections_fts USING fts5('
        ' act_code, section_number, title, chapter, body_text, legacy_mapping'
        ' )',
      );
    },
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.createTable(caseFiles);
        await m.createTable(caseDeadlines);
        await m.createTable(caseChecklistItems);
      }
      if (from < 3) {
        await m.createTable(conversations);
        await m.createTable(messages);
        await m.createTable(documentChunks);
        await m.createTable(contractAnalyses);
        await m.createTable(riskFindings);
        await m.createTable(legalKnowledgePacks);
        await m.createTable(complianceRecords);
        await m.createTable(aiExecutionLogs);
        await m.createTable(auditEvents);
        await customStatement(
          'CREATE INDEX IF NOT EXISTS idx_messages_conversation '
          'ON messages(conversation_id, created_at)',
        );
      }
      if (from < 4) {
        await m.createTable(legalInstruments);
        await m.createTable(legalProvisions);
        await m.createTable(legalFootnotes);
        await m.createTable(legalReferences);
        await m.createTable(legalEntities);
        await m.createTable(legalRelations);
        await customStatement(
          'CREATE INDEX IF NOT EXISTS idx_legal_footnotes_prov '
          'ON legal_footnotes(provision_ref)',
        );
        await customStatement(
          'CREATE INDEX IF NOT EXISTS idx_legal_relations_endpoints '
          'ON legal_relations(from_entity, to_entity)',
        );
      }
    },
  );

  /// Rebuilds the FTS5 index from [legalSections].
  Future<void> rebuildCorpusFtsIndex() async {
    await customStatement('DELETE FROM legal_sections_fts');
    await customStatement(
      'INSERT INTO legal_sections_fts '
      '(act_code, section_number, title, chapter, body_text, legacy_mapping) '
      'SELECT act_code, section_number, title, chapter, body_text, '
      "COALESCE(legacy_mapping, '') FROM legal_sections",
    );
  }
}
