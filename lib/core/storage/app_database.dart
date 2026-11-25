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
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      await customStatement(
        'CREATE UNIQUE INDEX IF NOT EXISTS idx_bookmarks_act_section '
        'ON bookmarks(act_code, section_number)',
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
