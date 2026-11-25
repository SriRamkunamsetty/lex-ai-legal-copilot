import 'package:flutter_test/flutter_test.dart';
import 'package:lex_copilot/core/errors/failure.dart';
import 'package:lex_copilot/core/security/secure_key_store.dart';

class _InMemorySecretStore implements KeyValueSecretStore {
  final Map<String, String> _data = {};
  bool shouldThrow = false;

  @override
  Future<void> delete(String key) async {
    if (shouldThrow) throw StateError('keystore locked');
    _data.remove(key);
  }

  @override
  Future<String?> read(String key) async {
    if (shouldThrow) throw StateError('keystore locked');
    return _data[key];
  }

  @override
  Future<void> write(String key, String value) async {
    if (shouldThrow) throw StateError('keystore locked');
    _data[key] = value;
  }
}

void main() {
  group('SecureKeyManager', () {
    test('generates, persists, and reuses 256-bit hex database key', () async {
      final store = _InMemorySecretStore();
      final manager = SecureKeyManager(store);

      final first = await manager.getOrCreateDatabaseKey();
      expect(first.isSuccess, isTrue);
      final key1 = first.valueOrNull!;
      expect(key1.length, 64);
      expect(RegExp(r'^[0-9a-f]{64}$').hasMatch(key1), isTrue);

      final second = await manager.getOrCreateDatabaseKey();
      expect(second.valueOrNull, key1);

      final deleted = await manager.deleteDatabaseKey();
      expect(deleted.isSuccess, isTrue);

      final regenerated = await manager.getOrCreateDatabaseKey();
      expect(regenerated.valueOrNull, isNot(key1));
    });

    test('maps keystore errors to StorageFailure', () async {
      final store = _InMemorySecretStore()..shouldThrow = true;
      final manager = SecureKeyManager(store);

      final result = await manager.getOrCreateDatabaseKey();
      expect(result.isErr, isTrue);
      expect(result.failureOrNull, isA<StorageFailure>());
    });
  });
}
