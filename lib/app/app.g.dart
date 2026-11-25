// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the active [FlavorConfig] for the running build.

@ProviderFor(flavorConfig)
final flavorConfigProvider = FlavorConfigProvider._();

/// Provides the active [FlavorConfig] for the running build.

final class FlavorConfigProvider
    extends $FunctionalProvider<FlavorConfig, FlavorConfig, FlavorConfig>
    with $Provider<FlavorConfig> {
  /// Provides the active [FlavorConfig] for the running build.
  FlavorConfigProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'flavorConfigProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$flavorConfigHash();

  @$internal
  @override
  $ProviderElement<FlavorConfig> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  FlavorConfig create(Ref ref) {
    return flavorConfig(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FlavorConfig value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FlavorConfig>(value),
    );
  }
}

String _$flavorConfigHash() => r'35d4e9e0d67649ea86a93043a8c742f4af822288';
