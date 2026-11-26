// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contract_review_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Streams the most recently persisted contract analysis for live Home widgets.

@ProviderFor(latestContractAnalysisStream)
final latestContractAnalysisStreamProvider =
    LatestContractAnalysisStreamProvider._();

/// Streams the most recently persisted contract analysis for live Home widgets.

final class LatestContractAnalysisStreamProvider
    extends
        $FunctionalProvider<
          AsyncValue<ContractSummarySnapshot?>,
          ContractSummarySnapshot?,
          Stream<ContractSummarySnapshot?>
        >
    with
        $FutureModifier<ContractSummarySnapshot?>,
        $StreamProvider<ContractSummarySnapshot?> {
  /// Streams the most recently persisted contract analysis for live Home widgets.
  LatestContractAnalysisStreamProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'latestContractAnalysisStreamProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$latestContractAnalysisStreamHash();

  @$internal
  @override
  $StreamProviderElement<ContractSummarySnapshot?> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<ContractSummarySnapshot?> create(Ref ref) {
    return latestContractAnalysisStream(ref);
  }
}

String _$latestContractAnalysisStreamHash() =>
    r'63f4cbebb6d5d2215c13c70e4543fa708a671087';

/// Manages contract input/scan import, risk scoring, redlines, and rewrites.

@ProviderFor(ContractReviewController)
final contractReviewControllerProvider = ContractReviewControllerProvider._();

/// Manages contract input/scan import, risk scoring, redlines, and rewrites.
final class ContractReviewControllerProvider
    extends $NotifierProvider<ContractReviewController, ContractReviewState> {
  /// Manages contract input/scan import, risk scoring, redlines, and rewrites.
  ContractReviewControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'contractReviewControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$contractReviewControllerHash();

  @$internal
  @override
  ContractReviewController create() => ContractReviewController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ContractReviewState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ContractReviewState>(value),
    );
  }
}

String _$contractReviewControllerHash() =>
    r'c5e61a2b693186750465a5d92654f331023278f1';

/// Manages contract input/scan import, risk scoring, redlines, and rewrites.

abstract class _$ContractReviewController
    extends $Notifier<ContractReviewState> {
  ContractReviewState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<ContractReviewState, ContractReviewState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ContractReviewState, ContractReviewState>,
              ContractReviewState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
