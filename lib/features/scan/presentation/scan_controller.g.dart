// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scan_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Manages document capture, multi-page OCR + LLM field extraction, and
/// encrypted persistence in [SavedScans].

@ProviderFor(ScanController)
final scanControllerProvider = ScanControllerProvider._();

/// Manages document capture, multi-page OCR + LLM field extraction, and
/// encrypted persistence in [SavedScans].
final class ScanControllerProvider
    extends $NotifierProvider<ScanController, ScanState> {
  /// Manages document capture, multi-page OCR + LLM field extraction, and
  /// encrypted persistence in [SavedScans].
  ScanControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'scanControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$scanControllerHash();

  @$internal
  @override
  ScanController create() => ScanController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ScanState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ScanState>(value),
    );
  }
}

String _$scanControllerHash() => r'089cebf15618ffb2515c136393003f2a246ef2db';

/// Manages document capture, multi-page OCR + LLM field extraction, and
/// encrypted persistence in [SavedScans].

abstract class _$ScanController extends $Notifier<ScanState> {
  ScanState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<ScanState, ScanState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ScanState, ScanState>,
              ScanState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
