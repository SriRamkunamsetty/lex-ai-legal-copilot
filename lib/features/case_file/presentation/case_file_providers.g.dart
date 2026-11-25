// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'case_file_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the local notification reminder scheduler.

@ProviderFor(reminderScheduler)
final reminderSchedulerProvider = ReminderSchedulerProvider._();

/// Provides the local notification reminder scheduler.

final class ReminderSchedulerProvider
    extends
        $FunctionalProvider<
          ReminderScheduler,
          ReminderScheduler,
          ReminderScheduler
        >
    with $Provider<ReminderScheduler> {
  /// Provides the local notification reminder scheduler.
  ReminderSchedulerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'reminderSchedulerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$reminderSchedulerHash();

  @$internal
  @override
  $ProviderElement<ReminderScheduler> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ReminderScheduler create(Ref ref) {
    return reminderScheduler(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ReminderScheduler value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ReminderScheduler>(value),
    );
  }
}

String _$reminderSchedulerHash() => r'46968fb388f154cc0b8bd8a571084e54cf51b167';

/// Provides the encrypted [CaseFileRepository].

@ProviderFor(caseFileRepository)
final caseFileRepositoryProvider = CaseFileRepositoryProvider._();

/// Provides the encrypted [CaseFileRepository].

final class CaseFileRepositoryProvider
    extends
        $FunctionalProvider<
          CaseFileRepository,
          CaseFileRepository,
          CaseFileRepository
        >
    with $Provider<CaseFileRepository> {
  /// Provides the encrypted [CaseFileRepository].
  CaseFileRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'caseFileRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$caseFileRepositoryHash();

  @$internal
  @override
  $ProviderElement<CaseFileRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CaseFileRepository create(Ref ref) {
    return caseFileRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CaseFileRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CaseFileRepository>(value),
    );
  }
}

String _$caseFileRepositoryHash() =>
    r'445ad5c143f2ea348ce7972835f64a0d4a5d133c';

/// Streams all stored case matters.

@ProviderFor(casesStream)
final casesStreamProvider = CasesStreamProvider._();

/// Streams all stored case matters.

final class CasesStreamProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<CaseFileRecord>>,
          List<CaseFileRecord>,
          Stream<List<CaseFileRecord>>
        >
    with
        $FutureModifier<List<CaseFileRecord>>,
        $StreamProvider<List<CaseFileRecord>> {
  /// Streams all stored case matters.
  CasesStreamProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'casesStreamProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$casesStreamHash();

  @$internal
  @override
  $StreamProviderElement<List<CaseFileRecord>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<CaseFileRecord>> create(Ref ref) {
    return casesStream(ref);
  }
}

String _$casesStreamHash() => r'a9ec446a4a3fe3450ff12d35d58b908e3ebcfd2b';

/// Streams deadlines for [caseId].

@ProviderFor(caseDeadlinesStream)
final caseDeadlinesStreamProvider = CaseDeadlinesStreamFamily._();

/// Streams deadlines for [caseId].

final class CaseDeadlinesStreamProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<CaseDeadlineRecord>>,
          List<CaseDeadlineRecord>,
          Stream<List<CaseDeadlineRecord>>
        >
    with
        $FutureModifier<List<CaseDeadlineRecord>>,
        $StreamProvider<List<CaseDeadlineRecord>> {
  /// Streams deadlines for [caseId].
  CaseDeadlinesStreamProvider._({
    required CaseDeadlinesStreamFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'caseDeadlinesStreamProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$caseDeadlinesStreamHash();

  @override
  String toString() {
    return r'caseDeadlinesStreamProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<CaseDeadlineRecord>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<CaseDeadlineRecord>> create(Ref ref) {
    final argument = this.argument as String;
    return caseDeadlinesStream(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is CaseDeadlinesStreamProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$caseDeadlinesStreamHash() =>
    r'3cd02ec134e00155b2c8b7c86be8f2b48975dfbf';

/// Streams deadlines for [caseId].

final class CaseDeadlinesStreamFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<CaseDeadlineRecord>>, String> {
  CaseDeadlinesStreamFamily._()
    : super(
        retry: null,
        name: r'caseDeadlinesStreamProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Streams deadlines for [caseId].

  CaseDeadlinesStreamProvider call(String caseId) =>
      CaseDeadlinesStreamProvider._(argument: caseId, from: this);

  @override
  String toString() => r'caseDeadlinesStreamProvider';
}

/// Streams checklist and timeline items for [caseId].

@ProviderFor(caseItemsStream)
final caseItemsStreamProvider = CaseItemsStreamFamily._();

/// Streams checklist and timeline items for [caseId].

final class CaseItemsStreamProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<CaseChecklistRecord>>,
          List<CaseChecklistRecord>,
          Stream<List<CaseChecklistRecord>>
        >
    with
        $FutureModifier<List<CaseChecklistRecord>>,
        $StreamProvider<List<CaseChecklistRecord>> {
  /// Streams checklist and timeline items for [caseId].
  CaseItemsStreamProvider._({
    required CaseItemsStreamFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'caseItemsStreamProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$caseItemsStreamHash();

  @override
  String toString() {
    return r'caseItemsStreamProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<CaseChecklistRecord>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<CaseChecklistRecord>> create(Ref ref) {
    final argument = this.argument as String;
    return caseItemsStream(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is CaseItemsStreamProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$caseItemsStreamHash() => r'12d5c52b976f1484a713fa47acfad649d7d09167';

/// Streams checklist and timeline items for [caseId].

final class CaseItemsStreamFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<CaseChecklistRecord>>, String> {
  CaseItemsStreamFamily._()
    : super(
        retry: null,
        name: r'caseItemsStreamProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Streams checklist and timeline items for [caseId].

  CaseItemsStreamProvider call(String caseId) =>
      CaseItemsStreamProvider._(argument: caseId, from: this);

  @override
  String toString() => r'caseItemsStreamProvider';
}
