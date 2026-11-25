// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'incident_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the speech-to-text service for Incident voice input.

@ProviderFor(voiceInputService)
final voiceInputServiceProvider = VoiceInputServiceProvider._();

/// Provides the speech-to-text service for Incident voice input.

final class VoiceInputServiceProvider
    extends
        $FunctionalProvider<
          VoiceInputService,
          VoiceInputService,
          VoiceInputService
        >
    with $Provider<VoiceInputService> {
  /// Provides the speech-to-text service for Incident voice input.
  VoiceInputServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'voiceInputServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$voiceInputServiceHash();

  @$internal
  @override
  $ProviderElement<VoiceInputService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  VoiceInputService create(Ref ref) {
    return voiceInputService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(VoiceInputService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<VoiceInputService>(value),
    );
  }
}

String _$voiceInputServiceHash() => r'062814970c4ad7f2a01fa5ee8d48273a1c94e3c6';

/// Manages incident classification, voice dictation, evidence photo capture,
/// and [IncidentPipeline] execution.

@ProviderFor(IncidentController)
final incidentControllerProvider = IncidentControllerProvider._();

/// Manages incident classification, voice dictation, evidence photo capture,
/// and [IncidentPipeline] execution.
final class IncidentControllerProvider
    extends $NotifierProvider<IncidentController, IncidentState> {
  /// Manages incident classification, voice dictation, evidence photo capture,
  /// and [IncidentPipeline] execution.
  IncidentControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'incidentControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$incidentControllerHash();

  @$internal
  @override
  IncidentController create() => IncidentController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(IncidentState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<IncidentState>(value),
    );
  }
}

String _$incidentControllerHash() =>
    r'8917229a5b665cc981a744fca5d380137e6bf348';

/// Manages incident classification, voice dictation, evidence photo capture,
/// and [IncidentPipeline] execution.

abstract class _$IncidentController extends $Notifier<IncidentState> {
  IncidentState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<IncidentState, IncidentState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<IncidentState, IncidentState>,
              IncidentState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
