import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lex_copilot/app/flavors.dart';
import 'package:lex_copilot/core/network/lex_http_client.dart';
import 'package:lex_copilot/core/security/e2ee_sync_service.dart';
import 'package:lex_copilot/core/security/secure_key_store.dart';
import 'package:lex_copilot/features/draft/presentation/draft_controller.dart';

class _InMemorySecretStore implements KeyValueSecretStore {
  final Map<String, String> _data = {};

  @override
  Future<void> delete(String key) async => _data.remove(key);

  @override
  Future<String?> read(String key) async => _data[key];

  @override
  Future<void> write(String key, String value) async => _data[key] = value;
}

class _FakeSyncAdapter implements HttpClientAdapter {
  final List<Map<String, dynamic>> storedBlobs = [];
  bool sawPushAuth = false;

  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    if (options.path.endsWith('/v1/accounts/login')) {
      return ResponseBody.fromString(
        jsonEncode({
          'user_id': 'usr_1',
          'token': 'ws_tok_1',
          'expires_at': 9999999999,
        }),
        200,
        headers: {
          Headers.contentTypeHeader: ['application/json'],
        },
      );
    }
    if (options.path.endsWith('/v1/sync/push')) {
      sawPushAuth = options.headers['Authorization'] == 'Bearer ws_tok_1';
      final body = options.data as Map<String, dynamic>;
      storedBlobs
        ..clear()
        ..addAll((body['blobs'] as List<dynamic>).cast<Map<String, dynamic>>());
      return ResponseBody.fromString(
        jsonEncode({'accepted_count': storedBlobs.length}),
        200,
        headers: {
          Headers.contentTypeHeader: ['application/json'],
        },
      );
    }
    if (options.path.endsWith('/v1/sync/pull')) {
      return ResponseBody.fromString(
        jsonEncode({'count': storedBlobs.length, 'blobs': storedBlobs}),
        200,
        headers: {
          Headers.contentTypeHeader: ['application/json'],
        },
      );
    }
    return ResponseBody.fromString('{}', 404);
  }
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

  test('E2eeSyncTransport authenticates, pushes encrypted blobs, pulls, and decrypts cleanly', () async {
    final crypto = E2eeSyncService(_InMemorySecretStore());
    await crypto.generateRecoveryKey();
    final httpClient = LexHttpClient(
      flavorConfig: FlavorConfig.forFlavor(LexFlavor.dev),
    );
    final adapter = _FakeSyncAdapter();
    httpClient.dio.httpClientAdapter = adapter;

    final transport = E2eeSyncTransport(crypto: crypto, httpClient: httpClient);
    final login = await transport.loginAccount(
      email: 'advocate@lex.in',
      password: 'StrongPassword#26',
      deviceId: 'phone-1',
    );
    expect(login.isSuccess, isTrue);

    final sync = await transport.pushAndPullRecords(
      records: const [
        (
          recordType: 'case_file',
          recordId: 'case-42',
          payload: {'title': 'Article 226 Writ', 'status': 'active'},
        ),
      ],
    );
    expect(sync.isSuccess, isTrue);
    expect(adapter.sawPushAuth, isTrue);
    expect(sync.valueOrNull!.pushedCount, 1);
    final firstPayload =
        sync.valueOrNull!.decryptedRecords.first['payload']
            as Map<String, dynamic>;
    expect(firstPayload['title'], 'Article 226 Writ');
  });

  test(
    'DraftController.computeLineDiff detects additions and removals accurately',
    () {
      final diff = DraftController.computeLineDiff(
        'Line 1\nOld clause\nLine 3',
        'Line 1\nSafer clause\nLine 3',
      );
      expect(
        diff.any(
          (d) => d.kind == DraftDiffKind.removed && d.text == 'Old clause',
        ),
        isTrue,
      );
      expect(
        diff.any(
          (d) => d.kind == DraftDiffKind.added && d.text == 'Safer clause',
        ),
        isTrue,
      );
    },
  );
}
