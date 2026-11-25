import 'dart:math';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lex_copilot/core/errors/failure.dart';
import 'package:lex_copilot/core/result.dart';

/// Abstraction over platform keystore/keychain storage for sensitive keys.
abstract interface class KeyValueSecretStore {
  /// Reads the secret stored under [key], or `null` if absent.
  Future<String?> read(String key);

  /// Stores [value] under [key].
  Future<void> write(String key, String value);

  /// Deletes the entry at [key].
  Future<void> delete(String key);
}

/// [KeyValueSecretStore] backed by [FlutterSecureStorage] (Android Keystore /
/// iOS Keychain).
class SecureStorageSecretStore implements KeyValueSecretStore {
  /// Creates a [SecureStorageSecretStore].
  new({FlutterSecureStorage? storage})
    : _storage =
          storage ??
          const FlutterSecureStorage(
            iOptions: IOSOptions(
              accessibility: KeychainAccessibility.first_unlock_this_device,
            ),
          );

  final FlutterSecureStorage _storage;

  @override
  Future<String?> read(String key) => _storage.read(key: key);

  @override
  Future<void> write(String key, String value) =>
      _storage.write(key: key, value: value);

  @override
  Future<void> delete(String key) => _storage.delete(key: key);
}

/// Manages the 256-bit database encryption passphrase stored in the OS
/// keystore/keychain.
class SecureKeyManager {
  /// Creates a [SecureKeyManager].
  const new(this._store);

  /// Keystore identifier for the SQLite/SQLCipher database passphrase.
  static const String dbKeyName = 'lex_sqlcipher_key_v1';

  final KeyValueSecretStore _store;

  /// Retrieves the existing database encryption key, or generates and persists a
  /// cryptographically random 256-bit hex key if none exists yet.
  Future<Result<String>> getOrCreateDatabaseKey() => Result.guard(
    () async {
      final existing = await _store.read(dbKeyName);
      if (existing != null && existing.length >= 32) {
        return existing;
      }
      final key = _generateHexKey(32);
      await _store.write(dbKeyName, key);
      return key;
    },
    onError: (error, _) => StorageFailure(
      'Failed to access OS keystore for database key.',
      cause: error,
    ),
  );

  /// Deletes the database encryption key (used by the "Delete all data" flow).
  Future<Result<void>> deleteDatabaseKey() => Result.guard(
    () => _store.delete(dbKeyName),
    onError: (error, _) => StorageFailure(
      'Failed to remove database key from OS keystore.',
      cause: error,
    ),
  );

  static String _generateHexKey(int byteLength) {
    final rng = Random.secure();
    final buffer = StringBuffer();
    for (var i = 0; i < byteLength; i++) {
      buffer.write(rng.nextInt(256).toRadixString(16).padLeft(2, '0'));
    }
    return buffer.toString();
  }
}
