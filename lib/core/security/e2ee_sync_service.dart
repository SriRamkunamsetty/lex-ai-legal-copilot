// Encapsulated transport & store fields keep E2EE internals private.
// ignore_for_file: prefer_initializing_formals
import 'dart:convert';
import 'dart:io' show Platform;
import 'dart:math';

import 'package:cryptography/cryptography.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:lex_copilot/core/errors/failure.dart';
import 'package:lex_copilot/core/network/lex_http_client.dart';
import 'package:lex_copilot/core/result.dart';
import 'package:lex_copilot/core/security/secure_key_store.dart';

/// Zero-knowledge encrypted payload ready for optional backend sync.
@immutable
class E2eeSyncEnvelope {
  /// Creates an [E2eeSyncEnvelope].
  const new({
    required this.recordType,
    required this.recordId,
    required this.version,
    required this.nonceB64,
    required this.ciphertextB64,
    required this.tagB64,
    required this.keyEpoch,
    this.orgId,
    this.deleted = false,
  });

  /// Reconstructs an [E2eeSyncEnvelope] from JSON returned by `/v1/sync/pull`.
  factory fromJson(Map<String, dynamic> json) {
    return E2eeSyncEnvelope(
      orgId: json['org_id'] as String?,
      recordType: json['record_type'] as String? ?? 'case_file',
      recordId: json['record_id'] as String? ?? '',
      version: (json['version'] as num?)?.toInt() ?? 1,
      nonceB64: json['nonce_b64'] as String? ?? '',
      ciphertextB64: json['ciphertext_b64'] as String? ?? '',
      tagB64: json['tag_b64'] as String? ?? '',
      keyEpoch: (json['key_epoch'] as num?)?.toInt() ?? 1,
      deleted: json['deleted'] as bool? ?? false,
    );
  }

  /// Optional team workspace ID (`null` means personal vault).
  final String? orgId;

  /// One of `case_file`, `draft`, `bookmark`, or `scan_meta`.
  final String recordType;

  /// Client record identifier.
  final String recordId;

  /// Monotonic version counter.
  final int version;

  /// Base64 96-bit AES-GCM nonce.
  final String nonceB64;

  /// Base64 AES-GCM ciphertext bytes.
  final String ciphertextB64;

  /// Base64 128-bit GCM authentication tag.
  final String tagB64;

  /// HKDF derivation epoch.
  final int keyEpoch;

  /// Tombstone flag for deleted records.
  final bool deleted;

  /// Serializes into `/v1/sync/push` payload format.
  Map<String, dynamic> toJson() => {
    if (orgId != null) 'org_id': orgId,
    'record_type': recordType,
    'record_id': recordId,
    'version': version,
    'nonce_b64': nonceB64,
    'ciphertext_b64': ciphertextB64,
    'tag_b64': tagB64,
    'key_epoch': keyEpoch,
    'deleted': deleted,
  };
}

/// Selective sync categories opted into by the user.
@immutable
class SyncSelectionConfig {
  /// Creates a [SyncSelectionConfig].
  const new({
    this.syncEnabled = false,
    this.syncCases = true,
    this.syncDrafts = true,
    this.syncBookmarks = true,
    this.syncScanMetadata = false,
    this.orgId,
  });

  /// Master opt-in switch (disabled by default; offline mode needs zero login).
  final bool syncEnabled;

  /// Sync encrypted case files and deadlines.
  final bool syncCases;

  /// Sync encrypted draft revisions.
  final bool syncDrafts;

  /// Sync encrypted statutory bookmarks.
  final bool syncBookmarks;

  /// Sync encrypted scan titles/tags (raw images stay local by default).
  final bool syncScanMetadata;

  /// Optional team organization workspace ID.
  final String? orgId;
}

/// Client-side zero-knowledge E2EE sync key manager and AEAD envelope codec.
///
/// The 256-bit recovery key never leaves device keystore / user backup.
class E2eeSyncService {
  /// Creates an [E2eeSyncService].
  new(this._store);

  final KeyValueSecretStore _store;

  static const String _recoveryKeyStorageKey = 'lex_e2ee_recovery_key_v1';
  static const String _workspaceTokenStorageKey = 'lex_workspace_session_v1';

  static final AesGcm _aesGcm = AesGcm.with256bits();
  static final Hkdf _hkdf = Hkdf(hmac: Hmac.sha256(), outputLength: 32);

  /// Returns `true` if a master recovery key is configured on this device.
  Future<bool> hasRecoveryKey() async {
    final existing = await _store.read(_recoveryKeyStorageKey);
    return existing != null && _normalizeHex(existing).length == 64;
  }

  /// Generates a fresh 256-bit recovery key formatted into 8 readable groups.
  Future<Result<String>> generateRecoveryKey() => Result.guard(() async {
    final rng = Random.secure();
    final bytes = List<int>.generate(32, (_) => rng.nextInt(256));
    final hex = bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
    await _store.write(_recoveryKeyStorageKey, hex);
    return formatRecoveryPhrase(hex);
  }, onError: (e, _) => StorageFailure('Failed to generate recovery key: $e'));

  /// Validates and imports a user's backed-up recovery phrase.
  Future<Result<void>> importRecoveryKey(String phrase) =>
      Result.guard(() async {
        final normalized = _normalizeHex(phrase);
        if (normalized.length != 64 ||
            !RegExp(r'^[0-9a-fA-F]{64}$').hasMatch(normalized)) {
          throw const FormatException(
            'Invalid recovery key format. Expected 64 hexadecimal characters.',
          );
        }
        await _store.write(_recoveryKeyStorageKey, normalized.toLowerCase());
      }, onError: (e, _) => ValidationFailure(e.toString()));

  /// Reads the local formatted recovery phrase if configured.
  Future<String?> readFormattedRecoveryKey() async {
    final raw = await _store.read(_recoveryKeyStorageKey);
    if (raw == null || _normalizeHex(raw).length != 64) return null;
    return formatRecoveryPhrase(_normalizeHex(raw));
  }

  /// Clears stored sync keys and optional workspace session tokens from device.
  Future<void> clearSyncCredentials() async {
    await _store.delete(_recoveryKeyStorageKey);
    await _store.delete(_workspaceTokenStorageKey);
  }

  /// Persists the optional workspace session token in secure storage.
  Future<void> saveWorkspaceToken(String token) async {
    await _store.write(_workspaceTokenStorageKey, token);
  }

  /// Reads the optional workspace session token from secure storage.
  Future<String?> readWorkspaceToken() =>
      _store.read(_workspaceTokenStorageKey);

  /// Formats 64-char hex into hyphenated 8-char groups prefixed with `LEX-`.
  static String formatRecoveryPhrase(String hex64) {
    final clean = _normalizeHex(hex64).toUpperCase();
    final groups = <String>[];
    for (var i = 0; i < clean.length; i += 8) {
      groups.add(clean.substring(i, min(i + 8, clean.length)));
    }
    return 'LEX-${groups.join('-')}';
  }

  /// Encrypts [payload] client-side using HKDF + AES-256-GCM bound to AAD.
  Future<Result<E2eeSyncEnvelope>> encryptRecord({
    required String recordType,
    required String recordId,
    required Map<String, dynamic> payload,
    int version = 1,
    int keyEpoch = 1,
    String? orgId,
    bool deleted = false,
  }) => Result.guard(() async {
    final derivedKey = await _deriveEpochKey(keyEpoch: keyEpoch);
    final rng = Random.secure();
    final nonce = List<int>.generate(12, (_) => rng.nextInt(256));
    final aad = _buildAad(
      orgId: orgId,
      recordType: recordType,
      recordId: recordId,
      keyEpoch: keyEpoch,
    );
    final plaintext = utf8.encode(jsonEncode(payload));
    final box = await _aesGcm.encrypt(
      plaintext,
      secretKey: derivedKey,
      nonce: nonce,
      aad: aad,
    );
    return E2eeSyncEnvelope(
      orgId: orgId,
      recordType: recordType,
      recordId: recordId,
      version: version,
      nonceB64: base64Encode(box.nonce),
      ciphertextB64: base64Encode(box.cipherText),
      tagB64: base64Encode(box.mac.bytes),
      keyEpoch: keyEpoch,
      deleted: deleted,
    );
  }, onError: (e, _) => StorageFailure('E2EE encryption failed: $e'));

  /// Decrypts and verifies an [E2eeSyncEnvelope] using AAD + GCM tag.
  Future<Result<Map<String, dynamic>>> decryptRecord(
    E2eeSyncEnvelope envelope,
  ) => Result.guard(() async {
    final derivedKey = await _deriveEpochKey(keyEpoch: envelope.keyEpoch);
    final nonce = base64Decode(envelope.nonceB64);
    final cipherText = base64Decode(envelope.ciphertextB64);
    final macBytes = base64Decode(envelope.tagB64);
    final aad = _buildAad(
      orgId: envelope.orgId,
      recordType: envelope.recordType,
      recordId: envelope.recordId,
      keyEpoch: envelope.keyEpoch,
    );
    final box = SecretBox(cipherText, nonce: nonce, mac: Mac(macBytes));
    final clear = await _aesGcm.decrypt(box, secretKey: derivedKey, aad: aad);
    final decoded = jsonDecode(utf8.decode(clear));
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException(
        'Decrypted E2EE payload is not a JSON object.',
      );
    }
    return decoded;
  }, onError: (e, _) => StorageFailure('E2EE decryption failed: $e'));

  Future<SecretKey> _deriveEpochKey({required int keyEpoch}) async {
    final hexKey = await _store.read(_recoveryKeyStorageKey);
    if (hexKey == null || _normalizeHex(hexKey).length != 64) {
      throw StateError(
        'No E2EE recovery key present. Generate or import a recovery key first.',
      );
    }
    final clean = _normalizeHex(hexKey);
    final masterBytes = <int>[
      for (var i = 0; i < clean.length; i += 2)
        int.parse(clean.substring(i, i + 2), radix: 16),
    ];
    return await _hkdf.deriveKey(
      secretKey: SecretKey(masterBytes),
      nonce: utf8.encode('lex-e2ee-salt-v1'),
      info: utf8.encode('lex-e2ee-sync-epoch-$keyEpoch'),
    );
  }

  static List<int> _buildAad({
    required String? orgId,
    required String recordType,
    required String recordId,
    required int keyEpoch,
  }) => utf8.encode('${orgId ?? 'personal'}|$recordType|$recordId|$keyEpoch');

  static String _normalizeHex(String input) => input
      .replaceAll(RegExp('^LEX-', caseSensitive: false), '')
      .replaceAll('-', '')
      .trim();
}

/// Summary of an optional E2EE cloud sync pass.
@immutable
class E2eeSyncSummary {
  /// Creates an [E2eeSyncSummary].
  const new({
    required this.pushedCount,
    required this.pulledCount,
    required this.decryptedRecords,
  });

  /// Number of encrypted envelopes uploaded to `/v1/sync/push`.
  final int pushedCount;

  /// Number of encrypted envelopes downloaded from `/v1/sync/pull`.
  final int pulledCount;

  /// Client-side decrypted records verified via AEAD tag & AAD.
  final List<Map<String, dynamic>> decryptedRecords;
}

/// HTTP transport connecting [E2eeSyncService] to the optional P5 backend routes
/// (`/v1/accounts/*`, `/v1/orgs/*`, `/v1/sync/push`, `/v1/sync/pull`).
class E2eeSyncTransport {
  /// Creates an [E2eeSyncTransport].
  const new({
    required E2eeSyncService crypto,
    required LexHttpClient httpClient,
  }) : _crypto = crypto,
       _httpClient = httpClient;

  final E2eeSyncService _crypto;
  final LexHttpClient _httpClient;

  String _platformName() {
    if (kIsWeb) return 'other';
    if (Platform.isAndroid) return 'android';
    if (Platform.isIOS) return 'ios';
    return 'desktop';
  }

  /// Registers a new optional sync account and persists its workspace token.
  Future<Result<String>> registerAccount({
    required String email,
    required String password,
    required String deviceId,
    String displayLabel = 'Lex User',
  }) => Result.guard(
    () async {
      final resp = await _httpClient.dio.post<Map<String, dynamic>>(
        '/v1/accounts/register',
        data: {
          'email': email.trim(),
          'password': password,
          'display_label': displayLabel.trim(),
          'device_id': deviceId,
          'device_name': 'Lex ${_platformName()}',
          'platform': _platformName(),
        },
      );
      final token = resp.data?['token'] as String? ?? '';
      final userId = resp.data?['user_id'] as String? ?? '';
      if (token.isEmpty) {
        throw StateError(
          'Workspace registration did not return a session token.',
        );
      }
      await _crypto.saveWorkspaceToken(token);
      return userId;
    },
    onError: (e, _) =>
        NetworkFailure('Account registration failed: $e', cause: e),
  );

  /// Authenticates an existing optional sync account and saves its session token.
  Future<Result<String>> loginAccount({
    required String email,
    required String password,
    required String deviceId,
  }) => Result.guard(
    () async {
      final resp = await _httpClient.dio.post<Map<String, dynamic>>(
        '/v1/accounts/login',
        data: {
          'email': email.trim(),
          'password': password,
          'device_id': deviceId,
          'device_name': 'Lex ${_platformName()}',
          'platform': _platformName(),
        },
      );
      final token = resp.data?['token'] as String? ?? '';
      final userId = resp.data?['user_id'] as String? ?? '';
      if (token.isEmpty) {
        throw StateError('Workspace sign-in did not return a session token.');
      }
      await _crypto.saveWorkspaceToken(token);
      return userId;
    },
    onError: (e, _) => NetworkFailure('Workspace sign-in failed: $e', cause: e),
  );

  /// Revokes all active sessions across devices and clears local token.
  Future<Result<void>> logoutAllSessions() => Result.guard(
    () async {
      final token = await _requireToken();
      await _httpClient.dio.post<Map<String, dynamic>>(
        '/v1/accounts/logout-all',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      await _crypto.clearSyncCredentials();
    },
    onError: (e, _) =>
        NetworkFailure('Failed to log out all sessions: $e', cause: e),
  );

  /// Lists devices registered to the authenticated sync account.
  Future<Result<List<Map<String, dynamic>>>> listDevices() => Result.guard(
    () async {
      final token = await _requireToken();
      final resp = await _httpClient.dio.get<Map<String, dynamic>>(
        '/v1/accounts/devices',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      final raw = resp.data?['devices'] as List<dynamic>? ?? const [];
      return raw.whereType<Map<String, dynamic>>().toList();
    },
    onError: (e, _) => NetworkFailure('Failed to load devices: $e', cause: e),
  );

  /// Revokes [deviceId] on the server.
  Future<Result<void>> revokeDevice(String deviceId) => Result.guard(
    () async {
      final token = await _requireToken();
      await _httpClient.dio.post<Map<String, dynamic>>(
        '/v1/accounts/devices/$deviceId/revoke',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
    },
    onError: (e, _) => NetworkFailure('Failed to revoke device: $e', cause: e),
  );

  /// Creates an optional multi-tenant Organization workspace with the caller as owner.
  Future<Result<Map<String, dynamic>>> createOrganization(String name) =>
      Result.guard(
        () async {
          final token = await _requireToken();
          final resp = await _httpClient.dio.post<Map<String, dynamic>>(
            '/v1/orgs',
            data: {'name': name.trim()},
            options: Options(headers: {'Authorization': 'Bearer $token'}),
          );
          return resp.data ?? const <String, dynamic>{};
        },
        onError: (e, _) =>
            NetworkFailure('Organization creation failed: $e', cause: e),
      );

  /// Encrypts [records] client-side and pushes/pulls via `/v1/sync/push` & `/v1/sync/pull`.
  Future<Result<E2eeSyncSummary>> pushAndPullRecords({
    required List<
      ({String recordType, String recordId, Map<String, dynamic> payload})
    >
    records,
    String? orgId,
  }) => Result.guard(() async {
    final token = await _requireToken();
    final envelopes = <Map<String, dynamic>>[];
    for (final rec in records.take(50)) {
      final encrypted = await _crypto.encryptRecord(
        recordType: rec.recordType,
        recordId: rec.recordId,
        orgId: orgId,
        payload: rec.payload,
      );
      switch (encrypted) {
        case Success(:final value):
          envelopes.add(value.toJson());
        case Err(:final failure):
          throw StateError(failure.message);
      }
    }

    var accepted = 0;
    if (envelopes.isNotEmpty) {
      final pushResp = await _httpClient.dio.post<Map<String, dynamic>>(
        '/v1/sync/push',
        data: {'blobs': envelopes},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      accepted =
          (pushResp.data?['accepted_count'] as num?)?.toInt() ??
          envelopes.length;
    }

    final pullResp = await _httpClient.dio.get<Map<String, dynamic>>(
      '/v1/sync/pull',
      queryParameters: {
        if (orgId != null && orgId.trim().isNotEmpty) 'org_id': orgId.trim(),
      },
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    final rawBlobs = pullResp.data?['blobs'] as List<dynamic>? ?? const [];
    final decrypted = <Map<String, dynamic>>[];
    for (final item in rawBlobs.whereType<Map<String, dynamic>>()) {
      final env = E2eeSyncEnvelope.fromJson(item);
      final dec = await _crypto.decryptRecord(env);
      if (dec case Success(:final value)) {
        decrypted.add({
          'record_type': env.recordType,
          'record_id': env.recordId,
          'version': env.version,
          'payload': value,
        });
      }
    }
    return E2eeSyncSummary(
      pushedCount: accepted,
      pulledCount: rawBlobs.length,
      decryptedRecords: decrypted,
    );
  }, onError: (e, _) => NetworkFailure('E2EE sync failed: $e', cause: e));

  Future<String> _requireToken() async {
    final token = await _crypto.readWorkspaceToken();
    if (token == null || token.trim().isEmpty) {
      throw StateError('Sign in to an optional sync account first.');
    }
    return token.trim();
  }
}
