import 'package:lex_copilot/features/library/data/library_repository.dart';
import 'package:lex_copilot/features/library/domain/library_models.dart';
import 'package:lex_copilot/legal_corpus/providers/corpus_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'library_providers.g.dart';

/// Provides the [LibraryRepository] backed by the encrypted AppDatabase.
@Riverpod(keepAlive: true)
LibraryRepository libraryRepository(Ref ref) {
  return LibraryRepository(ref.watch(appDatabaseProvider));
}

/// Streams all saved section bookmarks.
@riverpod
Stream<List<BookmarkRecord>> bookmarksStream(Ref ref) {
  return ref.watch(libraryRepositoryProvider).watchBookmarks();
}

/// Streams whether a specific section is bookmarked.
@riverpod
Stream<bool> isSectionBookmarked(
  Ref ref,
  String actCode,
  String sectionNumber,
) {
  return ref
      .watch(libraryRepositoryProvider)
      .watchIsBookmarked(actCode, sectionNumber);
}

/// Streams saved scans filtered by [query].
@riverpod
Stream<List<SavedScanRecord>> scansStream(Ref ref, String query) {
  return ref.watch(libraryRepositoryProvider).watchScans(query: query);
}

/// Streams saved drafts filtered by [query].
@riverpod
Stream<List<SavedDraftRecord>> draftsStream(Ref ref, String query) {
  return ref.watch(libraryRepositoryProvider).watchDrafts(query: query);
}

/// Streams local activity history filtered by [query].
@riverpod
Stream<List<ActivityRecord>> historyStream(Ref ref, String query) {
  return ref.watch(libraryRepositoryProvider).watchHistory(query: query);
}
