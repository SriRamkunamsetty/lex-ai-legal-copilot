// Private field keeps keystore dependency encapsulated.
// ignore_for_file: prefer_initializing_formals
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:lex_copilot/core/errors/failure.dart';
import 'package:lex_copilot/core/result.dart';
import 'package:lex_copilot/core/security/secure_key_store.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Encrypts and decrypts local scanned document files inside the app-private
/// vault directory using an OS keystore-backed 256-bit key (`LEX1` envelope
/// with per-file random nonce + SHA-256 CTR keystream + HMAC-SHA256 integrity tag).
class EncryptedFileStore {
  /// Creates an [EncryptedFileStore].
  new({
    required SecureKeyManager keyManager,
    Future<Directory> Function()? baseDirProvider,
  }) : _keyManager = keyManager,
       _baseDirProvider = baseDirProvider ?? getApplicationSupportDirectory;

  final SecureKeyManager _keyManager;
  final Future<Directory> Function() _baseDirProvider;

  static const List<int> _magicHeader = [0x4C, 0x45, 0x58, 0x31]; // LEX1

  /// Encrypts [plainBytes] (when [encrypt] is `true`) and persists it in the
  /// private vault folder returning the stored file path.
  Future<Result<String>> writeBytes({
    required String fileName,
    required Uint8List plainBytes,
    required bool encrypt,
  }) => Result.guard(
    () async {
      final vaultDir = await _ensureVaultDir();
      final sanitized = fileName.replaceAll(RegExp('[^A-Za-z0-9._-]'), '_');
      final targetPath = p.join(
        vaultDir.path,
        '${DateTime.now().microsecondsSinceEpoch}_$sanitized${encrypt ? '.enc' : ''}',
      );
      final file = File(targetPath);

      if (!encrypt) {
        file.writeAsBytesSync(plainBytes, flush: true);
        return targetPath;
      }

      final keyRes = await _keyManager.getOrCreateDatabaseKey();
      final hexKey = switch (keyRes) {
        Success(:final value) => value,
        Err(:final failure) => throw StateError(failure.message),
      };
      final keyBytes = _hexToBytes(hexKey);
      final random = Random.secure();
      final nonce = Uint8List.fromList(
        List<int>.generate(16, (_) => random.nextInt(256)),
      );
      final cipher = _xorKeystream(
        data: plainBytes,
        key: keyBytes,
        nonce: nonce,
      );
      final macInput = <int>[..._magicHeader, ...nonce, ...cipher];
      final tag = Hmac(sha256, keyBytes).convert(macInput).bytes;

      final payload = Uint8List.fromList([...macInput, ...tag]);
      file.writeAsBytesSync(payload, flush: true);
      return targetPath;
    },
    onError: (error, _) =>
        StorageFailure('Failed to write secure local file.', cause: error),
  );

  /// Reads and verifies [filePath], transparently decrypting `LEX1` envelopes.
  Future<Result<Uint8List>> readBytes(String filePath) => Result.guard(
    () async {
      final file = File(filePath);
      if (!file.existsSync()) {
        throw StateError('Local file not found.');
      }
      final raw = file.readAsBytesSync();
      if (raw.length < 4 + 16 + 32 ||
          raw[0] != _magicHeader[0] ||
          raw[1] != _magicHeader[1] ||
          raw[2] != _magicHeader[2] ||
          raw[3] != _magicHeader[3]) {
        return raw;
      }

      final keyRes = await _keyManager.getOrCreateDatabaseKey();
      final hexKey = switch (keyRes) {
        Success(:final value) => value,
        Err(:final failure) => throw StateError(failure.message),
      };
      final keyBytes = _hexToBytes(hexKey);
      final macOffset = raw.length - 32;
      final authenticated = raw.sublist(0, macOffset);
      final storedTag = raw.sublist(macOffset);
      final expectedTag = Hmac(sha256, keyBytes).convert(authenticated).bytes;
      if (!_constantTimeEquals(storedTag, expectedTag)) {
        throw StateError('Encrypted file integrity check failed.');
      }

      final nonce = raw.sublist(4, 20);
      final cipher = raw.sublist(20, macOffset);
      return _xorKeystream(data: cipher, key: keyBytes, nonce: nonce);
    },
    onError: (error, _) =>
        StorageFailure('Failed to decrypt local file.', cause: error),
  );

  /// Deletes all files stored in the encrypted scan vault directory.
  Future<Result<void>> wipeAll() => Result.guard(
    () async {
      final dir = await _ensureVaultDir();
      if (dir.existsSync()) {
        await dir.delete(recursive: true);
      }
    },
    onError: (error, _) =>
        StorageFailure('Failed to wipe secure file vault.', cause: error),
  );

  Future<Directory> _ensureVaultDir() async {
    final base = await _baseDirProvider();
    final dir = Directory(p.join(base.path, 'lex_secure_scans'));
    if (!dir.existsSync()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  static Uint8List _xorKeystream({
    required Uint8List data,
    required List<int> key,
    required Uint8List nonce,
  }) {
    final output = Uint8List(data.length);
    var offset = 0;
    var counter = 0;
    while (offset < data.length) {
      final counterBytes = utf8.encode(':$counter');
      final block = Hmac(
        sha256,
        key,
      ).convert(<int>[...nonce, ...counterBytes]).bytes;
      for (var i = 0; i < block.length && offset < data.length; i++) {
        output[offset] = data[offset] ^ block[i];
        offset++;
      }
      counter++;
    }
    return output;
  }

  static List<int> _hexToBytes(String hex) {
    final clean = hex.length.isOdd ? '0$hex' : hex;
    final bytes = <int>[];
    for (var i = 0; i < clean.length; i += 2) {
      bytes.add(int.parse(clean.substring(i, i + 2), radix: 16));
    }
    return bytes;
  }

  static bool _constantTimeEquals(List<int> a, List<int> b) {
    if (a.length != b.length) return false;
    var diff = 0;
    for (var i = 0; i < a.length; i++) {
      diff |= a[i] ^ b[i];
    }
    return diff == 0;
  }
}
