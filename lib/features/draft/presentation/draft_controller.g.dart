// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'draft_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Manages legal drafting templates, scan prefill, `[placeholder]` self-check,
/// encrypted Library save, and PDF export.

@ProviderFor(DraftController)
final draftControllerProvider = DraftControllerProvider._();

/// Manages legal drafting templates, scan prefill, `[placeholder]` self-check,
/// encrypted Library save, and PDF export.
final class DraftControllerProvider
    extends $NotifierProvider<DraftController, DraftState> {
  /// Manages legal drafting templates, scan prefill, `[placeholder]` self-check,
  /// encrypted Library save, and PDF export.
  DraftControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'draftControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$draftControllerHash();

  @$internal
  @override
  DraftController create() => DraftController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DraftState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DraftState>(value),
    );
  }
}

String _$draftControllerHash() => r'b73a000754aa16deecd8c171ee77d840e2e6f7c9';

/// Manages legal drafting templates, scan prefill, `[placeholder]` self-check,
/// encrypted Library save, and PDF export.

abstract class _$DraftController extends $Notifier<DraftState> {
  DraftState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<DraftState, DraftState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DraftState, DraftState>,
              DraftState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
