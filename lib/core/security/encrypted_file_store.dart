// Private field keeps keystore dependency encapsulated.
// ignore_for_file: prefer_initializing_formals
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:crypto/crypto.dart' as crypto;
import 'package:cryptography/cryptography.dart';
import 'package:flutter/foundation.dart';
import 'package:lex_copilot/core/errors/failure.dart';
import 'package:lex_copilot/core/result.dart';
import 'package:lex_copilot/core/security/secure_key_store.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Encrypts and decrypts local legal documents inside the app-private vault
/// using OS keystore-backed **AES-256-GCM** AEAD (`LEX2` envelope), while
/// preserving backwards-compatible verification & decryption for legacy `LEX1`
/// envelopes. Enforces max file size and allowed magic-byte validation.
class EncryptedFileStore {
  /// Creates an [EncryptedFileStore].
  new({
    required SecureKeyManager keyManager,
    Future<Directory> Function()? baseDirProvider,
  }) : _keyManager = keyManager,
       _baseDirProvider = baseDirProvider ?? getApplicationSupportDirectory;

  final SecureKeyManager _keyManager;
  final Future<Directory> Function() _baseDirProvider;

  /// Maximum permitted document upload size (25 MiB).
  static const int maxFileSizeBytes = 25 * 1024 * 1024;

  static const List<int> _magicV1 = [0x4C, 0x45, 0x58, 0x31]; // LEX1
  static const List<int> _magicV2 = [0x4C, 0x45, 0x58, 0x32]; // LEX2 (AES-GCM)
  static final AesGcm _aesGcm = AesGcm.with256bits();

  /// Validates [bytes] against [maxFileSizeBytes] and expected legal document
  /// headers (JPEG, PNG, PDF, ZIP/DOCX, or valid UTF-8 plain text).
  static Result<void> validateDocumentBytes(
    Uint8List bytes, {
    int maxBytes = maxFileSizeBytes,
  }) {
    if (bytes.isEmpty) {
      return const Err(ValidationFailure('Document file is empty.'));
    }
    if (bytes.length > maxBytes) {
      return Err(
        ValidationFailure(
          'File exceeds maximum allowed size (${maxBytes ~/ (1024 * 1024)} MB).',
        ),
      );
    }

    if (_hasAllowedMagic(bytes)) {
      return const Success(null);
    }

    // Fallback check: printable UTF-8 text without embedded NUL bytes.
    if (!bytes.contains(0)) {
      try {
        utf8.decode(bytes);
        return const Success(null);
      } on FormatException {
        // Invalid UTF-8 & unknown binary header -> reject below.
      }
    }

    return const Err(
      ValidationFailure(
        'Unsupported or corrupted file format. Only JPEG, PNG, PDF, DOCX, or UTF-8 text files are permitted.',
      ),
    );
  }

  /// Encrypts [plainBytes] using AES-256-GCM (`LEX2` envelope) when
  /// [encrypt] is `true`, and persists it in the private vault directory.
  Future<Result<String>> writeBytes({
    required String fileName,
    required Uint8List plainBytes,
    required bool encrypt,
    bool validateFormat = false,
  }) => Result.guard(
    () async {
      if (plainBytes.length > maxFileSizeBytes) {
        throw const FormatException('Document exceeds 25 MB vault limit.');
      }
      if (validateFormat) {
        final validation = validateDocumentBytes(plainBytes);
        if (validation case Err(:final failure)) {
          throw FormatException(failure.message);
        }
      }

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
      final keyBytes = _normalizeAes256Key(_hexToBytes(hexKey));
      final secretKey = SecretKey(keyBytes);
      final random = Random.secure();
      final nonce = List<int>.generate(12, (_) => random.nextInt(256));

      final secretBox = await _aesGcm.encrypt(
        plainBytes,
        secretKey: secretKey,
        nonce: nonce,
        aad: _magicV2,
      );

      final payload = Uint8List.fromList([
        ..._magicV2,
        ...secretBox.nonce,
        ...secretBox.cipherText,
        ...secretBox.mac.bytes,
      ]);
      file.writeAsBytesSync(payload, flush: true);
      return targetPath;
    },
    onError: (error, _) =>
        StorageFailure('Failed to write secure local file.', cause: error),
  );

  /// Reads and authenticates [filePath], transparently decrypting `LEX2`
  /// (AES-256-GCM) and legacy `LEX1` envelopes.
  Future<Result<Uint8List>> readBytes(String filePath) => Result.guard(
    () async {
      final file = File(filePath);
      if (!file.existsSync()) {
        throw StateError('Local file not found.');
      }
      final raw = file.readAsBytesSync();
      if (_matchesPrefix(raw, _magicV2)) {
        return await _decryptV2(raw);
      }
      if (_matchesPrefix(raw, _magicV1)) {
        return await _decryptV1(raw);
      }
      return raw;
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

  Future<Uint8List> _decryptV2(Uint8List raw) async {
    // Format: 4B LEX2 + 12B nonce + N bytes ciphertext + 16B GCM tag
    if (raw.length < 4 + 12 + 16) {
      throw StateError('Corrupt LEX2 encrypted file.');
    }
    final keyRes = await _keyManager.getOrCreateDatabaseKey();
    final hexKey = switch (keyRes) {
      Success(:final value) => value,
      Err(:final failure) => throw StateError(failure.message),
    };
    final keyBytes = _normalizeAes256Key(_hexToBytes(hexKey));
    final secretKey = SecretKey(keyBytes);

    final nonce = raw.sublist(4, 16);
    final macStart = raw.length - 16;
    final cipherText = raw.sublist(16, macStart);
    final mac = Mac(raw.sublist(macStart));

    final plain = await _aesGcm.decrypt(
      SecretBox(cipherText, nonce: nonce, mac: mac),
      secretKey: secretKey,
      aad: _magicV2,
    );
    return Uint8List.fromList(plain);
  }

  Future<Uint8List> _decryptV1(Uint8List raw) async {
    if (raw.length < 4 + 16 + 32) {
      throw StateError('Corrupt LEX1 encrypted file.');
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
    final expectedTag = crypto.Hmac(
      crypto.sha256,
      keyBytes,
    ).convert(authenticated).bytes;
    if (!_constantTimeEquals(storedTag, expectedTag)) {
      throw StateError('Encrypted file integrity check failed.');
    }

    final nonce = raw.sublist(4, 20);
    final cipher = raw.sublist(20, macOffset);
    return _xorKeystream(data: cipher, key: keyBytes, nonce: nonce);
  }

  Future<Directory> _ensureVaultDir() async {
    final base = await _baseDirProvider();
    final dir = Directory(p.join(base.path, 'lex_secure_scans'));
    if (!dir.existsSync()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  static bool _matchesPrefix(Uint8List data, List<int> prefix) {
    if (data.length < prefix.length) return false;
    for (var i = 0; i < prefix.length; i++) {
      if (data[i] != prefix[i]) return false;
    }
    return true;
  }

  static bool _hasAllowedMagic(Uint8List bytes) {
    // JPEG: FF D8 FF
    if (bytes.length >= 3 &&
        bytes[0] == 0xFF &&
        bytes[1] == 0xD8 &&
        bytes[2] == 0xFF) {
      return true;
    }
    // PNG: 89 50 4E 47
    if (_matchesPrefix(bytes, const [0x89, 0x50, 0x4E, 0x47])) {
      return true;
    }
    // PDF: %PDF-
    if (_matchesPrefix(bytes, const [0x25, 0x50, 0x44, 0x46, 0x2D])) {
      return true;
    }
    // ZIP / DOCX / ODT: PK 03 04
    if (_matchesPrefix(bytes, const [0x50, 0x4B, 0x03, 0x04])) {
      return true;
    }
    return false;
  }

  static List<int> _normalizeAes256Key(List<int> keyBytes) {
    if (keyBytes.length == 32) return keyBytes;
    return crypto.sha256.convert(keyBytes).bytes;
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
      final block = crypto.Hmac(
        crypto.sha256,
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
