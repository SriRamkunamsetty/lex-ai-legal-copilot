// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contract_review_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
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
    r'd5f273799456c8dd24f85e05b041640b8c474d2a';

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
