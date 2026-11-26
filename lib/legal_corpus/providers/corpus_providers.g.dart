// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'corpus_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the initialized encrypted [AppDatabase].
///
/// Overridden during app startup in `bootstrap` and in tests.

@ProviderFor(appDatabase)
final appDatabaseProvider = AppDatabaseProvider._();

/// Provides the initialized encrypted [AppDatabase].
///
/// Overridden during app startup in `bootstrap` and in tests.

final class AppDatabaseProvider
    extends $FunctionalProvider<AppDatabase, AppDatabase, AppDatabase>
    with $Provider<AppDatabase> {
  /// Provides the initialized encrypted [AppDatabase].
  ///
  /// Overridden during app startup in `bootstrap` and in tests.
  AppDatabaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appDatabaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appDatabaseHash();

  @$internal
  @override
  $ProviderElement<AppDatabase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AppDatabase create(Ref ref) {
    return appDatabase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppDatabase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppDatabase>(value),
    );
  }
}

String _$appDatabaseHash() => r'c327c0532d3d69a14b5088f4a74378e49df9ef03';

/// Provides the offline [LegalCorpusRepository].

@ProviderFor(legalCorpusRepository)
final legalCorpusRepositoryProvider = LegalCorpusRepositoryProvider._();

/// Provides the offline [LegalCorpusRepository].

final class LegalCorpusRepositoryProvider
    extends
        $FunctionalProvider<
          LegalCorpusRepository,
          LegalCorpusRepository,
          LegalCorpusRepository
        >
    with $Provider<LegalCorpusRepository> {
  /// Provides the offline [LegalCorpusRepository].
  LegalCorpusRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'legalCorpusRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$legalCorpusRepositoryHash();

  @$internal
  @override
  $ProviderElement<LegalCorpusRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  LegalCorpusRepository create(Ref ref) {
    return legalCorpusRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LegalCorpusRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LegalCorpusRepository>(value),
    );
  }
}

String _$legalCorpusRepositoryHash() =>
    r'b46acca180691ff7ff3cc1f6e12be71ab0520824';

/// Provides the offline [KnowledgePackService] verifying & hydrating
/// signed Constitution and Central Act Knowledge Packs.

@ProviderFor(knowledgePackService)
final knowledgePackServiceProvider = KnowledgePackServiceProvider._();

/// Provides the offline [KnowledgePackService] verifying & hydrating
/// signed Constitution and Central Act Knowledge Packs.

final class KnowledgePackServiceProvider
    extends
        $FunctionalProvider<
          KnowledgePackService,
          KnowledgePackService,
          KnowledgePackService
        >
    with $Provider<KnowledgePackService> {
  /// Provides the offline [KnowledgePackService] verifying & hydrating
  /// signed Constitution and Central Act Knowledge Packs.
  KnowledgePackServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'knowledgePackServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$knowledgePackServiceHash();

  @$internal
  @override
  $ProviderElement<KnowledgePackService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  KnowledgePackService create(Ref ref) {
    return knowledgePackService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(KnowledgePackService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<KnowledgePackService>(value),
    );
  }
}

String _$knowledgePackServiceHash() =>
    r'ec12a797ad3f05f356c7b155e01ff2f15a79cb2c';

/// Seeds the offline legal corpus & verified Knowledge Packs on first access.

@ProviderFor(corpusSeed)
final corpusSeedProvider = CorpusSeedProvider._();

/// Seeds the offline legal corpus & verified Knowledge Packs on first access.

final class CorpusSeedProvider
    extends
        $FunctionalProvider<
          AsyncValue<Result<int>>,
          Result<int>,
          FutureOr<Result<int>>
        >
    with $FutureModifier<Result<int>>, $FutureProvider<Result<int>> {
  /// Seeds the offline legal corpus & verified Knowledge Packs on first access.
  CorpusSeedProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'corpusSeedProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$corpusSeedHash();

  @$internal
  @override
  $FutureProviderElement<Result<int>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Result<int>> create(Ref ref) {
    return corpusSeed(ref);
  }
}

String _$corpusSeedHash() => r'35555a64b24bda6229e4c5183a45676829ac77e3';

/// Fetches a single statutory section by [actCode] and [sectionNumber] after
/// ensuring the corpus is seeded.

@ProviderFor(legalSection)
final legalSectionProvider = LegalSectionFamily._();

/// Fetches a single statutory section by [actCode] and [sectionNumber] after
/// ensuring the corpus is seeded.

final class LegalSectionProvider
    extends
        $FunctionalProvider<
          AsyncValue<Result<LegalSectionModel>>,
          Result<LegalSectionModel>,
          FutureOr<Result<LegalSectionModel>>
        >
    with
        $FutureModifier<Result<LegalSectionModel>>,
        $FutureProvider<Result<LegalSectionModel>> {
  /// Fetches a single statutory section by [actCode] and [sectionNumber] after
  /// ensuring the corpus is seeded.
  LegalSectionProvider._({
    required LegalSectionFamily super.from,
    required (String, String) super.argument,
  }) : super(
         retry: null,
         name: r'legalSectionProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$legalSectionHash();

  @override
  String toString() {
    return r'legalSectionProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<Result<LegalSectionModel>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Result<LegalSectionModel>> create(Ref ref) {
    final argument = this.argument as (String, String);
    return legalSection(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is LegalSectionProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$legalSectionHash() => r'bb2aa5ad467fe1ae3ac872cab26ba112ebb20be5';

/// Fetches a single statutory section by [actCode] and [sectionNumber] after
/// ensuring the corpus is seeded.

final class LegalSectionFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<Result<LegalSectionModel>>,
          (String, String)
        > {
  LegalSectionFamily._()
    : super(
        retry: null,
        name: r'legalSectionProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Fetches a single statutory section by [actCode] and [sectionNumber] after
  /// ensuring the corpus is seeded.

  LegalSectionProvider call(String actCode, String sectionNumber) =>
      LegalSectionProvider._(argument: (actCode, sectionNumber), from: this);

  @override
  String toString() => r'legalSectionProvider';
}

/// Searches the offline statutory corpus for [query] and optional [actCode].

@ProviderFor(corpusSearch)
final corpusSearchProvider = CorpusSearchFamily._();

/// Searches the offline statutory corpus for [query] and optional [actCode].

final class CorpusSearchProvider
    extends
        $FunctionalProvider<
          AsyncValue<Result<List<LegalSectionModel>>>,
          Result<List<LegalSectionModel>>,
          FutureOr<Result<List<LegalSectionModel>>>
        >
    with
        $FutureModifier<Result<List<LegalSectionModel>>>,
        $FutureProvider<Result<List<LegalSectionModel>>> {
  /// Searches the offline statutory corpus for [query] and optional [actCode].
  CorpusSearchProvider._({
    required CorpusSearchFamily super.from,
    required (String, {String? actCode}) super.argument,
  }) : super(
         retry: null,
         name: r'corpusSearchProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$corpusSearchHash();

  @override
  String toString() {
    return r'corpusSearchProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<Result<List<LegalSectionModel>>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Result<List<LegalSectionModel>>> create(Ref ref) {
    final argument = this.argument as (String, {String? actCode});
    return corpusSearch(ref, argument.$1, actCode: argument.actCode);
  }

  @override
  bool operator ==(Object other) {
    return other is CorpusSearchProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$corpusSearchHash() => r'c5e92e4c1f12ec4eb0a415b6b0d7f839422d42af';

/// Searches the offline statutory corpus for [query] and optional [actCode].

final class CorpusSearchFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<Result<List<LegalSectionModel>>>,
          (String, {String? actCode})
        > {
  CorpusSearchFamily._()
    : super(
        retry: null,
        name: r'corpusSearchProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Searches the offline statutory corpus for [query] and optional [actCode].

  CorpusSearchProvider call(String query, {String? actCode}) =>
      CorpusSearchProvider._(argument: (query, actCode: actCode), from: this);

  @override
  String toString() => r'corpusSearchProvider';
}
