// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the initialized [SharedPreferences] instance.
///
/// Overridden in `bootstrap` during app startup and in widget/unit tests.

@ProviderFor(sharedPreferences)
final sharedPreferencesProvider = SharedPreferencesProvider._();

/// Provides the initialized [SharedPreferences] instance.
///
/// Overridden in `bootstrap` during app startup and in widget/unit tests.

final class SharedPreferencesProvider
    extends
        $FunctionalProvider<
          SharedPreferences,
          SharedPreferences,
          SharedPreferences
        >
    with $Provider<SharedPreferences> {
  /// Provides the initialized [SharedPreferences] instance.
  ///
  /// Overridden in `bootstrap` during app startup and in widget/unit tests.
  SharedPreferencesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sharedPreferencesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sharedPreferencesHash();

  @$internal
  @override
  $ProviderElement<SharedPreferences> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SharedPreferences create(Ref ref) {
    return sharedPreferences(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SharedPreferences value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SharedPreferences>(value),
    );
  }
}

String _$sharedPreferencesHash() => r'bc60c9b54b4a188aeb80ec2d8dca08256006d654';

/// Provides the [SettingsRepository].

@ProviderFor(settingsRepository)
final settingsRepositoryProvider = SettingsRepositoryProvider._();

/// Provides the [SettingsRepository].

final class SettingsRepositoryProvider
    extends
        $FunctionalProvider<
          SettingsRepository,
          SettingsRepository,
          SettingsRepository
        >
    with $Provider<SettingsRepository> {
  /// Provides the [SettingsRepository].
  SettingsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'settingsRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$settingsRepositoryHash();

  @$internal
  @override
  $ProviderElement<SettingsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SettingsRepository create(Ref ref) {
    return settingsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SettingsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SettingsRepository>(value),
    );
  }
}

String _$settingsRepositoryHash() =>
    r'76c502ed93dc8c944013aad7605c1744dfbd4870';

/// Live reactive controller for all [LexSettings] customization options.

@ProviderFor(SettingsController)
final settingsControllerProvider = SettingsControllerProvider._();

/// Live reactive controller for all [LexSettings] customization options.
final class SettingsControllerProvider
    extends $NotifierProvider<SettingsController, LexSettings> {
  /// Live reactive controller for all [LexSettings] customization options.
  SettingsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'settingsControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$settingsControllerHash();

  @$internal
  @override
  SettingsController create() => SettingsController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LexSettings value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LexSettings>(value),
    );
  }
}

String _$settingsControllerHash() =>
    r'6d5ec1c2a340f84d7af0700d0cb2c291c855ef1c';

/// Live reactive controller for all [LexSettings] customization options.

abstract class _$SettingsController extends $Notifier<LexSettings> {
  LexSettings build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<LexSettings, LexSettings>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<LexSettings, LexSettings>,
              LexSettings,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
