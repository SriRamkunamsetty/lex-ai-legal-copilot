// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'security_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the OS keystore-backed database & vault key manager.

@ProviderFor(secureKeyManager)
final secureKeyManagerProvider = SecureKeyManagerProvider._();

/// Provides the OS keystore-backed database & vault key manager.

final class SecureKeyManagerProvider
    extends
        $FunctionalProvider<
          SecureKeyManager,
          SecureKeyManager,
          SecureKeyManager
        >
    with $Provider<SecureKeyManager> {
  /// Provides the OS keystore-backed database & vault key manager.
  SecureKeyManagerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'secureKeyManagerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$secureKeyManagerHash();

  @$internal
  @override
  $ProviderElement<SecureKeyManager> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SecureKeyManager create(Ref ref) {
    return secureKeyManager(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SecureKeyManager value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SecureKeyManager>(value),
    );
  }
}

String _$secureKeyManagerHash() => r'9116bb46db6270c0623437ca1f6a327607b5be44';

/// Provides the local scan-file encryption store.

@ProviderFor(encryptedFileStore)
final encryptedFileStoreProvider = EncryptedFileStoreProvider._();

/// Provides the local scan-file encryption store.

final class EncryptedFileStoreProvider
    extends
        $FunctionalProvider<
          EncryptedFileStore,
          EncryptedFileStore,
          EncryptedFileStore
        >
    with $Provider<EncryptedFileStore> {
  /// Provides the local scan-file encryption store.
  EncryptedFileStoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'encryptedFileStoreProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$encryptedFileStoreHash();

  @$internal
  @override
  $ProviderElement<EncryptedFileStore> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  EncryptedFileStore create(Ref ref) {
    return encryptedFileStore(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EncryptedFileStore value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EncryptedFileStore>(value),
    );
  }
}

String _$encryptedFileStoreHash() =>
    r'080770afd444185dbad522b6211541784044f091';

/// Provides the biometric unlock & Android screenshot protection service.

@ProviderFor(appSecurityService)
final appSecurityServiceProvider = AppSecurityServiceProvider._();

/// Provides the biometric unlock & Android screenshot protection service.

final class AppSecurityServiceProvider
    extends
        $FunctionalProvider<
          AppSecurityService,
          AppSecurityService,
          AppSecurityService
        >
    with $Provider<AppSecurityService> {
  /// Provides the biometric unlock & Android screenshot protection service.
  AppSecurityServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appSecurityServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appSecurityServiceHash();

  @$internal
  @override
  $ProviderElement<AppSecurityService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AppSecurityService create(Ref ref) {
    return appSecurityService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppSecurityService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppSecurityService>(value),
    );
  }
}

String _$appSecurityServiceHash() =>
    r'9bec552f6dd98a132b698157ba104274f56701e6';
