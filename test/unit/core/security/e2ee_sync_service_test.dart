import 'package:flutter_test/flutter_test.dart';
import 'package:lex_copilot/core/security/e2ee_sync_service.dart';
import 'package:lex_copilot/core/security/secure_key_store.dart';

class _InMemorySecretStore implements KeyValueSecretStore {
  final Map<String, String> _data = {};

  @override
  Future<void> delete(String key) async => _data.remove(key);

  @override
  Future<String?> read(String key) async => _data[key];

  @override
  Future<void> write(String key, String value) async => _data[key] = value;
}

void main() {
  test('E2eeSyncService generates recovery key, encrypts/decrypts round-trip, and rejects tampering', () async {
    final store = _InMemorySecretStore();
    final service = E2eeSyncService(store);

    expect(await service.hasRecoveryKey(), isFalse);
    final genRes = await service.generateRecoveryKey();
    expect(genRes.isSuccess, isTrue);
    final phrase = genRes.valueOrNull!;
    expect(phrase.startsWith('LEX-'), isTrue);
    expect(await service.hasRecoveryKey(), isTrue);

    final envRes = await service.encryptRecord(
      recordType: 'case_file',
      recordId: 'case-101',
      orgId: 'org_abc',
      payload: {'title': 'Writ Petition WP(C) 2026', 'client': 'Confidential'},
    );
    expect(envRes.isSuccess, isTrue);
    final envelope = envRes.valueOrNull!;

    // Server sees only base64 ciphertext & nonce; plaintext never leaves client.
    expect(envelope.ciphertextB64, isNot(contains('Writ Petition')));

    // Restore on a second device using only the backed-up recovery phrase.
    final secondDevice = E2eeSyncService(_InMemorySecretStore());
    final importRes = await secondDevice.importRecoveryKey(phrase);
    expect(importRes.isSuccess, isTrue);

    final decRes = await secondDevice.decryptRecord(envelope);
    expect(decRes.isSuccess, isTrue);
    expect(decRes.valueOrNull!['title'], 'Writ Petition WP(C) 2026');

    // Cross-tenant / AAD swap fails closed.
    final wrongOrg = E2eeSyncEnvelope(
      orgId: 'org_attacker',
      recordType: envelope.recordType,
      recordId: envelope.recordId,
      version: envelope.version,
      nonceB64: envelope.nonceB64,
      ciphertextB64: envelope.ciphertextB64,
      tagB64: envelope.tagB64,
      keyEpoch: envelope.keyEpoch,
    );
    final tamperRes = await secondDevice.decryptRecord(wrongOrg);
    expect(tamperRes.isErr, isTrue);

    // Invalid recovery key format rejected cleanly.
    final badImport = await secondDevice.importRecoveryKey('not-valid');
    expect(badImport.isErr, isTrue);

    await service.clearSyncCredentials();
    expect(await service.hasRecoveryKey(), isFalse);
  });
}
