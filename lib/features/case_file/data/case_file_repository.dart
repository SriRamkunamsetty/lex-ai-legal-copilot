import 'package:drift/drift.dart';
import 'package:lex_copilot/core/errors/failure.dart';
import 'package:lex_copilot/core/result.dart';
import 'package:lex_copilot/core/storage/app_database.dart';
import 'package:lex_copilot/features/case_file/domain/case_file_models.dart';

/// Repository managing dispute/case files, deadlines, timelines, checklists,
/// and shareable matter summaries in the encrypted [AppDatabase].
class CaseFileRepository {
  /// Creates a [CaseFileRepository].
  const new(this._db);

  final AppDatabase _db;

  /// Streams all case matters ordered most recently updated first.
  Stream<List<CaseFileRecord>> watchCases() =>
      (_db.select(
        _db.caseFiles,
      )..orderBy([(t) => OrderingTerm.desc(t.updatedAt)])).watch().map(
        (rows) => rows
            .map(
              (r) => CaseFileRecord(
                id: r.id,
                title: r.title,
                category: r.category,
                status: r.status,
                summary: r.summary,
                createdAt: r.createdAt,
                updatedAt: r.updatedAt,
              ),
            )
            .toList(),
      );

  /// Streams deadlines across all cases ordered earliest due date first.
  Stream<List<CaseDeadlineRecord>> watchUpcomingDeadlines({
    bool includeCompleted = false,
  }) {
    final stmt = _db.select(_db.caseDeadlines)
      ..orderBy([(t) => OrderingTerm.asc(t.dueAt)]);
    if (!includeCompleted) {
      stmt.where((t) => t.completed.equals(false));
    }
    return stmt.watch().map(
      (rows) => rows
          .map(
            (r) => CaseDeadlineRecord(
              id: r.id,
              caseId: r.caseId,
              title: r.title,
              dueAt: r.dueAt,
              reminderScheduled: r.reminderScheduled,
              completed: r.completed,
            ),
          )
          .toList(),
    );
  }

  /// Streams deadlines for [caseId] ordered earliest due date first.
  Stream<List<CaseDeadlineRecord>> watchDeadlines(String caseId) =>
      (_db.select(_db.caseDeadlines)
            ..where((t) => t.caseId.equals(caseId))
            ..orderBy([(t) => OrderingTerm.asc(t.dueAt)]))
          .watch()
          .map(
            (rows) => rows
                .map(
                  (r) => CaseDeadlineRecord(
                    id: r.id,
                    caseId: r.caseId,
                    title: r.title,
                    dueAt: r.dueAt,
                    reminderScheduled: r.reminderScheduled,
                    completed: r.completed,
                  ),
                )
                .toList(),
          );

  /// Streams checklist tasks and timeline/artifact entries for [caseId].
  Stream<List<CaseChecklistRecord>> watchChecklistItems(String caseId) =>
      (_db.select(_db.caseChecklistItems)
            ..where((t) => t.caseId.equals(caseId))
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
          .watch()
          .map(
            (rows) => rows
                .map(
                  (r) => CaseChecklistRecord(
                    id: r.id,
                    caseId: r.caseId,
                    title: r.title,
                    kind: r.kind,
                    referenceId: r.referenceId,
                    done: r.done,
                    createdAt: r.createdAt,
                  ),
                )
                .toList(),
          );

  /// Fetches a complete snapshot [CaseBundle] for [caseId].
  Future<Result<CaseBundle>> getCaseBundle(String caseId) => Result.guard(
    () async {
      final row = await (_db.select(
        _db.caseFiles,
      )..where((t) => t.id.equals(caseId))).getSingle();
      final deadlines = await watchDeadlines(caseId).first;
      final items = await watchChecklistItems(caseId).first;
      return CaseBundle(
        matter: CaseFileRecord(
          id: row.id,
          title: row.title,
          category: row.category,
          status: row.status,
          summary: row.summary,
          createdAt: row.createdAt,
          updatedAt: row.updatedAt,
        ),
        deadlines: deadlines,
        items: items,
      );
    },
    onError: (error, _) => StorageFailure('Case file not found.', cause: error),
  );

  /// Creates a new case matter with default compliance checklist starters.
  Future<Result<String>> createCase({
    required String title,
    required String category,
    String summary = '',
    List<String> starterTasks = const [
      'Collect identity & transaction proof',
      'Preserve relevant messages, receipts, and timestamps',
      'Review applicable statutory sections offline',
    ],
  }) => Result.guard(
    () async {
      final cleanTitle = title.trim();
      if (cleanTitle.isEmpty) {
        throw const FormatException('Case title is required.');
      }
      final id = 'case_${DateTime.now().microsecondsSinceEpoch}';
      await _db.transaction(() async {
        await _db
            .into(_db.caseFiles)
            .insert(
              CaseFilesCompanion.insert(
                id: id,
                title: cleanTitle,
                category: Value(category.trim()),
                summary: Value(summary.trim()),
              ),
            );
        await _db
            .into(_db.caseChecklistItems)
            .insert(
              CaseChecklistItemsCompanion.insert(
                caseId: id,
                title: 'Matter created ($category)',
                kind: const Value('timeline'),
              ),
            );
        for (final task in starterTasks) {
          await _db
              .into(_db.caseChecklistItems)
              .insert(
                CaseChecklistItemsCompanion.insert(
                  caseId: id,
                  title: task,
                  kind: const Value('checklist'),
                ),
              );
        }
      });
      return id;
    },
    onError: (error, _) =>
        StorageFailure('Failed to create case file.', cause: error),
  );

  /// Updates the status badge (`Open`, `Notice sent`, `In progress`, `Closed`).
  Future<Result<void>> updateStatus({
    required String caseId,
    required String status,
  }) => Result.guard(
    () async {
      await (_db.update(
        _db.caseFiles,
      )..where((t) => t.id.equals(caseId))).write(
        CaseFilesCompanion(
          status: Value(status),
          updatedAt: Value(DateTime.now()),
        ),
      );
    },
    onError: (error, _) =>
        StorageFailure('Failed to update case status.', cause: error),
  );

  /// Inserts a deadline/hearing row and returns its integer row ID.
  Future<Result<int>> addDeadline({
    required String caseId,
    required String title,
    required DateTime dueAt,
    bool reminderScheduled = false,
  }) => Result.guard(
    () async {
      final rowId = await _db
          .into(_db.caseDeadlines)
          .insert(
            CaseDeadlinesCompanion.insert(
              caseId: caseId,
              title: title.trim(),
              dueAt: dueAt,
              reminderScheduled: Value(reminderScheduled),
            ),
          );
      await _touchCase(caseId);
      return rowId;
    },
    onError: (error, _) =>
        StorageFailure('Failed to save deadline.', cause: error),
  );

  /// Marks whether a deadline reminder is active.
  Future<Result<void>> markReminderScheduled({
    required int deadlineId,
    required bool scheduled,
  }) => Result.guard(
    () async {
      await (_db.update(_db.caseDeadlines)
            ..where((t) => t.id.equals(deadlineId)))
          .write(CaseDeadlinesCompanion(reminderScheduled: Value(scheduled)));
    },
    onError: (error, _) =>
        StorageFailure('Failed to update reminder flag.', cause: error),
  );

  /// Toggles completion status on a deadline.
  Future<Result<void>> toggleDeadlineCompleted({
    required int deadlineId,
    required bool completed,
  }) => Result.guard(
    () async {
      await (_db.update(_db.caseDeadlines)
            ..where((t) => t.id.equals(deadlineId)))
          .write(CaseDeadlinesCompanion(completed: Value(completed)));
    },
    onError: (error, _) =>
        StorageFailure('Failed to update deadline.', cause: error),
  );

  /// Adds a checklist task or attached artifact timeline item.
  Future<Result<int>> addChecklistOrTimelineItem({
    required String caseId,
    required String title,
    String kind = 'checklist',
    String? referenceId,
  }) => Result.guard(
    () async {
      final rowId = await _db
          .into(_db.caseChecklistItems)
          .insert(
            CaseChecklistItemsCompanion.insert(
              caseId: caseId,
              title: title.trim(),
              kind: Value(kind),
              referenceId: Value(referenceId),
            ),
          );
      await _touchCase(caseId);
      return rowId;
    },
    onError: (error, _) =>
        StorageFailure('Failed to add case item.', cause: error),
  );

  /// Toggles a checklist task completion checkbox.
  Future<Result<void>> toggleItemDone({
    required int itemId,
    required bool done,
  }) => Result.guard(
    () async {
      await (_db.update(_db.caseChecklistItems)
            ..where((t) => t.id.equals(itemId)))
          .write(CaseChecklistItemsCompanion(done: Value(done)));
    },
    onError: (error, _) =>
        StorageFailure('Failed to update checklist item.', cause: error),
  );

  /// Builds a concise shareable text summary for legal aid or advocate intake.
  String buildShareableSummary(CaseBundle bundle) {
    final m = bundle.matter;
    final buf = StringBuffer()
      ..writeln('CASE SUMMARY — ${m.title}')
      ..writeln('Category: ${m.category} · Status: ${m.status}');
    if (m.summary.isNotEmpty) {
      buf.writeln('\nFacts / Summary:\n${m.summary}');
    }
    if (bundle.deadlines.isNotEmpty) {
      buf.writeln('\nUpcoming Deadlines:');
      for (final d in bundle.deadlines) {
        final dateStr =
            '${d.dueAt.year}-${d.dueAt.month.toString().padLeft(2, '0')}-${d.dueAt.day.toString().padLeft(2, '0')}';
        buf.writeln(
          '- [${d.completed ? 'DONE' : 'OPEN'}] $dateStr: ${d.title}',
        );
      }
    }
    if (bundle.timelineEvents.isNotEmpty) {
      buf.writeln('\nAttached Records & Timeline:');
      for (final e in bundle.timelineEvents.take(8)) {
        buf.writeln('- (${e.kind}) ${e.title}');
      }
    }
    buf.writeln(
      '\nGenerated via Lex. Verify facts and statutory provisions with an advocate — not legal advice.',
    );
    return buf.toString();
  }

  /// Wipes all case files, deadlines, and checklists (called by Delete All Data).
  Future<Result<void>> deleteAllCases() => Result.guard(
    () async {
      await _db.transaction(() async {
        await _db.delete(_db.caseDeadlines).go();
        await _db.delete(_db.caseChecklistItems).go();
        await _db.delete(_db.caseFiles).go();
      });
    },
    onError: (error, _) =>
        StorageFailure('Failed to delete case files.', cause: error),
  );

  Future<void> _touchCase(String caseId) async {
    await (_db.update(_db.caseFiles)..where((t) => t.id.equals(caseId))).write(
      CaseFilesCompanion(updatedAt: Value(DateTime.now())),
    );
  }
}
