import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:lex_copilot/core/security/encrypted_file_store.dart';
import 'package:lex_copilot/core/security/secure_key_store.dart';

class _MemorySecretStore implements KeyValueSecretStore {
  final Map<String, String> _map = {};

  @override
  Future<String?> read(String key) async => _map[key];

  @override
  Future<void> write(String key, String value) async => _map[key] = value;

  @override
  Future<void> delete(String key) async => _map.remove(key);
}

void main() {
  test('EncryptedFileStore encrypts bytes at rest, rejects tampering, and wipes cleanly', () async {
    final tempDir = await Directory.systemTemp.createTemp('lex_vault_test_');
    addTearDown(() async {
      if (tempDir.existsSync()) await tempDir.delete(recursive: true);
    });

    final keyManager = SecureKeyManager(_MemorySecretStore());
    final store = EncryptedFileStore(
      keyManager: keyManager,
      baseDirProvider: () async => tempDir,
    );

    final plain = Uint8List.fromList(
      utf8.encode('Confidential Legal Notice: Aadhaar 1234-5678-9012'),
    );
    final writeRes = await store.writeBytes(
      fileName: 'Notice.jpg',
      plainBytes: plain,
      encrypt: true,
    );
    expect(writeRes.isSuccess, isTrue);

    final encryptedPath = writeRes.valueOrNull!;
    final rawDisk = await File(encryptedPath).readAsBytes();
    expect(
      utf8.decode(rawDisk, allowMalformed: true),
      isNot(contains('Aadhaar')),
    );

    final readRes = await store.readBytes(encryptedPath);
    expect(readRes.isSuccess, isTrue);
    expect(readRes.valueOrNull, equals(plain));

    // Tamper 1 byte -> HMAC check must fail cleanly.
    final tampered = Uint8List.fromList(rawDisk);
    tampered[25] ^= 0xFF;
    await File(encryptedPath).writeAsBytes(tampered);
    final tamperedRes = await store.readBytes(encryptedPath);
    expect(tamperedRes.isErr, isTrue);

    final wipeRes = await store.wipeAll();
    expect(wipeRes.isSuccess, isTrue);
    expect(File(encryptedPath).existsSync(), isFalse);
  });
}
