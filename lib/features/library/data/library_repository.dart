import 'package:drift/drift.dart';
import 'package:lex_copilot/core/errors/failure.dart';
import 'package:lex_copilot/core/result.dart';
import 'package:lex_copilot/core/storage/app_database.dart';
import 'package:lex_copilot/features/library/domain/library_models.dart';

/// Repository managing user bookmarks, encrypted scans, saved drafts, and local
/// activity history inside the encrypted [AppDatabase].
class LibraryRepository {
  /// Creates a [LibraryRepository].
  const new(this._db);

  final AppDatabase _db;

  /// Streams all bookmarked sections ordered newest first.
  Stream<List<BookmarkRecord>> watchBookmarks() =>
      (_db.select(
        _db.bookmarks,
      )..orderBy([(t) => OrderingTerm.desc(t.createdAt)])).watch().map(
        (rows) => rows
            .map(
              (r) => BookmarkRecord(
                id: r.id,
                actCode: r.actCode,
                sectionNumber: r.sectionNumber,
                note: r.note,
                createdAt: r.createdAt,
              ),
            )
            .toList(),
      );

  /// Streams whether `(actCode, sectionNumber)` is currently bookmarked.
  Stream<bool> watchIsBookmarked(String actCode, String sectionNumber) {
    final normAct = actCode.trim().toUpperCase();
    final normNum = sectionNumber.trim();
    return (_db.select(_db.bookmarks)..where(
          (t) => t.actCode.equals(normAct) & t.sectionNumber.equals(normNum),
        ))
        .watch()
        .map((rows) => rows.isNotEmpty);
  }

  /// Toggles bookmark status for `(actCode, sectionNumber)` and returns the
  /// resulting state (`true` if now bookmarked).
  Future<Result<bool>> toggleBookmark({
    required String actCode,
    required String sectionNumber,
    String? note,
  }) => Result.guard(
    () async {
      final normAct = actCode.trim().toUpperCase();
      final normNum = sectionNumber.trim();
      final existing =
          await (_db.select(_db.bookmarks)..where(
                (t) =>
                    t.actCode.equals(normAct) & t.sectionNumber.equals(normNum),
              ))
              .getSingleOrNull();
      if (existing != null) {
        await (_db.delete(
          _db.bookmarks,
        )..where((t) => t.id.equals(existing.id))).go();
        return false;
      }
      await _db
          .into(_db.bookmarks)
          .insert(
            BookmarksCompanion.insert(
              actCode: normAct,
              sectionNumber: normNum,
              note: Value(note),
            ),
          );
      return true;
    },
    onError: (error, _) =>
        StorageFailure('Failed to update bookmark.', cause: error),
  );

  /// Streams saved scans ordered newest first.
  Stream<List<SavedScanRecord>> watchScans({String query = ''}) {
    final stmt = _db.select(_db.savedScans)
      ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]);
    final trimmed = query.trim();
    if (trimmed.isNotEmpty) {
      final pattern = '%$trimmed%';
      stmt.where((t) => t.title.like(pattern) | t.ocrText.like(pattern));
    }
    return stmt.watch().map(
      (rows) => rows
          .map(
            (r) => SavedScanRecord(
              id: r.id,
              title: r.title,
              filePath: r.filePath,
              ocrText: r.ocrText,
              summaryJson: r.summaryJson,
              pageCount: r.pageCount,
              createdAt: r.createdAt,
              expiresAt: r.expiresAt,
            ),
          )
          .toList(),
    );
  }

  /// Inserts or updates a scanned document entry.
  Future<Result<void>> saveScan(SavedScansCompanion scan) => Result.guard(
    () => _db.into(_db.savedScans).insertOnConflictUpdate(scan),
    onError: (error, _) =>
        StorageFailure('Failed to save scan record.', cause: error),
  );

  /// Deletes expired scans whose `expiresAt` is before [now].
  Future<Result<int>> purgeExpiredScans([DateTime? now]) => Result.guard(
    () {
      final cutoff = now ?? DateTime.now();
      return (_db.delete(_db.savedScans)..where(
            (t) =>
                t.expiresAt.isNotNull() &
                t.expiresAt.isSmallerThanValue(cutoff),
          ))
          .go();
    },
    onError: (error, _) =>
        StorageFailure('Failed to purge expired scans.', cause: error),
  );

  /// Streams saved drafts ordered by most recently updated.
  Stream<List<SavedDraftRecord>> watchDrafts({String query = ''}) {
    final stmt = _db.select(_db.savedDrafts)
      ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)]);
    final trimmed = query.trim();
    if (trimmed.isNotEmpty) {
      final pattern = '%$trimmed%';
      stmt.where((t) => t.title.like(pattern) | t.content.like(pattern));
    }
    return stmt.watch().map(
      (rows) => rows
          .map(
            (r) => SavedDraftRecord(
              id: r.id,
              templateType: r.templateType,
              title: r.title,
              content: r.content,
              fieldsJson: r.fieldsJson,
              createdAt: r.createdAt,
              updatedAt: r.updatedAt,
            ),
          )
          .toList(),
    );
  }

  /// Inserts or updates a saved draft.
  Future<Result<void>> saveDraft(SavedDraftsCompanion draft) => Result.guard(
    () => _db.into(_db.savedDrafts).insertOnConflictUpdate(draft),
    onError: (error, _) =>
        StorageFailure('Failed to save draft.', cause: error),
  );

  /// Streams local activity history ordered newest first.
  Stream<List<ActivityRecord>> watchHistory({String query = ''}) {
    final stmt = _db.select(_db.activityHistory)
      ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
      ..limit(100);
    final trimmed = query.trim();
    if (trimmed.isNotEmpty) {
      final pattern = '%$trimmed%';
      stmt.where((t) => t.title.like(pattern) | t.subtitle.like(pattern));
    }
    return stmt.watch().map(
      (rows) => rows
          .map(
            (r) => ActivityRecord(
              id: r.id,
              kind: r.kind,
              title: r.title,
              subtitle: r.subtitle,
              route: r.route,
              createdAt: r.createdAt,
            ),
          )
          .toList(),
    );
  }

  /// Records a local navigation/research event in [ActivityHistory].
  Future<Result<void>> recordActivity({
    required String kind,
    required String title,
    required String subtitle,
    required String route,
  }) => Result.guard(
    () => _db
        .into(_db.activityHistory)
        .insert(
          ActivityHistoryCompanion.insert(
            kind: kind,
            title: title,
            subtitle: subtitle,
            route: route,
          ),
        ),
    onError: (error, _) =>
        StorageFailure('Failed to record activity.', cause: error),
  );

  /// Deletes all user-generated data from the encrypted database.
  Future<Result<void>> deleteAllUserData() => Result.guard(
    () async {
      await _db.transaction(() async {
        await _db.delete(_db.bookmarks).go();
        await _db.delete(_db.savedScans).go();
        await _db.delete(_db.savedDrafts).go();
        await _db.delete(_db.activityHistory).go();
      });
    },
    onError: (error, _) =>
        StorageFailure('Failed to wipe local user data.', cause: error),
  );
}
