// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'library_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the [LibraryRepository] backed by the encrypted AppDatabase.

@ProviderFor(libraryRepository)
final libraryRepositoryProvider = LibraryRepositoryProvider._();

/// Provides the [LibraryRepository] backed by the encrypted AppDatabase.

final class LibraryRepositoryProvider
    extends
        $FunctionalProvider<
          LibraryRepository,
          LibraryRepository,
          LibraryRepository
        >
    with $Provider<LibraryRepository> {
  /// Provides the [LibraryRepository] backed by the encrypted AppDatabase.
  LibraryRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'libraryRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$libraryRepositoryHash();

  @$internal
  @override
  $ProviderElement<LibraryRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  LibraryRepository create(Ref ref) {
    return libraryRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LibraryRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LibraryRepository>(value),
    );
  }
}

String _$libraryRepositoryHash() => r'dc1b2685eb6380fdb375fe85759f1e1fd6fe831a';

/// Streams all saved section bookmarks.

@ProviderFor(bookmarksStream)
final bookmarksStreamProvider = BookmarksStreamProvider._();

/// Streams all saved section bookmarks.

final class BookmarksStreamProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<BookmarkRecord>>,
          List<BookmarkRecord>,
          Stream<List<BookmarkRecord>>
        >
    with
        $FutureModifier<List<BookmarkRecord>>,
        $StreamProvider<List<BookmarkRecord>> {
  /// Streams all saved section bookmarks.
  BookmarksStreamProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bookmarksStreamProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bookmarksStreamHash();

  @$internal
  @override
  $StreamProviderElement<List<BookmarkRecord>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<BookmarkRecord>> create(Ref ref) {
    return bookmarksStream(ref);
  }
}

String _$bookmarksStreamHash() => r'4863dfc9e6c0906ba7d8c21794554104dfe7d10e';

/// Streams whether a specific section is bookmarked.

@ProviderFor(isSectionBookmarked)
final isSectionBookmarkedProvider = IsSectionBookmarkedFamily._();

/// Streams whether a specific section is bookmarked.

final class IsSectionBookmarkedProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, Stream<bool>>
    with $FutureModifier<bool>, $StreamProvider<bool> {
  /// Streams whether a specific section is bookmarked.
  IsSectionBookmarkedProvider._({
    required IsSectionBookmarkedFamily super.from,
    required (String, String) super.argument,
  }) : super(
         retry: null,
         name: r'isSectionBookmarkedProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$isSectionBookmarkedHash();

  @override
  String toString() {
    return r'isSectionBookmarkedProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $StreamProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<bool> create(Ref ref) {
    final argument = this.argument as (String, String);
    return isSectionBookmarked(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is IsSectionBookmarkedProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$isSectionBookmarkedHash() =>
    r'abd1e5a03a659c1c8255eb9422f73ea4cfcf95eb';

/// Streams whether a specific section is bookmarked.

final class IsSectionBookmarkedFamily extends $Family
    with $FunctionalFamilyOverride<Stream<bool>, (String, String)> {
  IsSectionBookmarkedFamily._()
    : super(
        retry: null,
        name: r'isSectionBookmarkedProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Streams whether a specific section is bookmarked.

  IsSectionBookmarkedProvider call(String actCode, String sectionNumber) =>
      IsSectionBookmarkedProvider._(
        argument: (actCode, sectionNumber),
        from: this,
      );

  @override
  String toString() => r'isSectionBookmarkedProvider';
}

/// Streams saved scans filtered by [query].

@ProviderFor(scansStream)
final scansStreamProvider = ScansStreamFamily._();

/// Streams saved scans filtered by [query].

final class ScansStreamProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<SavedScanRecord>>,
          List<SavedScanRecord>,
          Stream<List<SavedScanRecord>>
        >
    with
        $FutureModifier<List<SavedScanRecord>>,
        $StreamProvider<List<SavedScanRecord>> {
  /// Streams saved scans filtered by [query].
  ScansStreamProvider._({
    required ScansStreamFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'scansStreamProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$scansStreamHash();

  @override
  String toString() {
    return r'scansStreamProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<SavedScanRecord>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<SavedScanRecord>> create(Ref ref) {
    final argument = this.argument as String;
    return scansStream(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ScansStreamProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$scansStreamHash() => r'7a1c69334710f7d9f85c30085947c7780c118bd6';

/// Streams saved scans filtered by [query].

final class ScansStreamFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<SavedScanRecord>>, String> {
  ScansStreamFamily._()
    : super(
        retry: null,
        name: r'scansStreamProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Streams saved scans filtered by [query].

  ScansStreamProvider call(String query) =>
      ScansStreamProvider._(argument: query, from: this);

  @override
  String toString() => r'scansStreamProvider';
}

/// Streams saved drafts filtered by [query].

@ProviderFor(draftsStream)
final draftsStreamProvider = DraftsStreamFamily._();

/// Streams saved drafts filtered by [query].

final class DraftsStreamProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<SavedDraftRecord>>,
          List<SavedDraftRecord>,
          Stream<List<SavedDraftRecord>>
        >
    with
        $FutureModifier<List<SavedDraftRecord>>,
        $StreamProvider<List<SavedDraftRecord>> {
  /// Streams saved drafts filtered by [query].
  DraftsStreamProvider._({
    required DraftsStreamFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'draftsStreamProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$draftsStreamHash();

  @override
  String toString() {
    return r'draftsStreamProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<SavedDraftRecord>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<SavedDraftRecord>> create(Ref ref) {
    final argument = this.argument as String;
    return draftsStream(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is DraftsStreamProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$draftsStreamHash() => r'63b5c2ad373550dd82719d97a4145d9bba58f7af';

/// Streams saved drafts filtered by [query].

final class DraftsStreamFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<SavedDraftRecord>>, String> {
  DraftsStreamFamily._()
    : super(
        retry: null,
        name: r'draftsStreamProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Streams saved drafts filtered by [query].

  DraftsStreamProvider call(String query) =>
      DraftsStreamProvider._(argument: query, from: this);

  @override
  String toString() => r'draftsStreamProvider';
}

/// Streams local activity history filtered by [query].

@ProviderFor(historyStream)
final historyStreamProvider = HistoryStreamFamily._();

/// Streams local activity history filtered by [query].

final class HistoryStreamProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ActivityRecord>>,
          List<ActivityRecord>,
          Stream<List<ActivityRecord>>
        >
    with
        $FutureModifier<List<ActivityRecord>>,
        $StreamProvider<List<ActivityRecord>> {
  /// Streams local activity history filtered by [query].
  HistoryStreamProvider._({
    required HistoryStreamFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'historyStreamProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$historyStreamHash();

  @override
  String toString() {
    return r'historyStreamProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<ActivityRecord>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<ActivityRecord>> create(Ref ref) {
    final argument = this.argument as String;
    return historyStream(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is HistoryStreamProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$historyStreamHash() => r'3f62a68270e2b6d05bfe836665a2d996ea0ded9c';

/// Streams local activity history filtered by [query].

final class HistoryStreamFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<ActivityRecord>>, String> {
  HistoryStreamFamily._()
    : super(
        retry: null,
        name: r'historyStreamProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Streams local activity history filtered by [query].

  HistoryStreamProvider call(String query) =>
      HistoryStreamProvider._(argument: query, from: this);

  @override
  String toString() => r'historyStreamProvider';
}
