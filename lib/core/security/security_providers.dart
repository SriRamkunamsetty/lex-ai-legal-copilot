import 'package:lex_copilot/core/security/biometric_lock_service.dart';
import 'package:lex_copilot/core/security/encrypted_file_store.dart';
import 'package:lex_copilot/core/security/secure_key_store.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'security_providers.g.dart';

/// Provides the OS keystore-backed database & vault key manager.
@Riverpod(keepAlive: true)
SecureKeyManager secureKeyManager(Ref ref) {
  return SecureKeyManager(SecureStorageSecretStore());
}

/// Provides the local scan-file encryption store.
@Riverpod(keepAlive: true)
EncryptedFileStore encryptedFileStore(Ref ref) {
  return EncryptedFileStore(keyManager: ref.watch(secureKeyManagerProvider));
}

/// Provides the biometric unlock & Android screenshot protection service.
@Riverpod(keepAlive: true)
AppSecurityService appSecurityService(Ref ref) {
  return AppSecurityService();
}
