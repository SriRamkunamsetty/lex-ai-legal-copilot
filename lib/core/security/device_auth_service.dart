// Encapsulated keystore field avoids leaking secret storage handle publicly.
// ignore_for_file: prefer_initializing_formals
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:lex_copilot/app/flavors.dart';
import 'package:lex_copilot/core/security/secure_key_store.dart';

/// Acquires, caches, and refreshes short-lived HMAC device bearer tokens
/// from `/v1/auth/device-token` using a random per-install device ID persisted
/// in the OS Keystore/Keychain via [KeyValueSecretStore].
class DeviceAuthService {
  /// Creates a [DeviceAuthService].
  new({
    required FlavorConfig flavorConfig,
    required KeyValueSecretStore secretStore,
    Dio? authDio,
    DateTime Function()? clock,
  }) : _secretStore = secretStore,
       _clock = clock ?? DateTime.now,
       _authDio =
           authDio ??
           Dio(
             BaseOptions(
               baseUrl: flavorConfig.apiBaseUrl,
               connectTimeout: const Duration(seconds: 10),
               receiveTimeout: const Duration(seconds: 15),
               headers: const {'Accept': 'application/json'},
             ),
           );

  /// Keystore key holding the random per-install device identifier.
  static const String deviceIdKeyName = 'lex_device_install_id_v1';

  final KeyValueSecretStore _secretStore;
  final Dio _authDio;
  final DateTime Function() _clock;

  String? _cachedToken;
  int _expiresAtEpochSec = 0;
  Future<String?>? _inFlightFetch;

  /// Returns a valid cached bearer token, or requests a fresh one if expired
  /// (within a 60-second safety margin). Returns `null` if acquisition fails
  /// (e.g. offline) without crashing callers.
  Future<String?> getToken() {
    final nowSec = _clock().millisecondsSinceEpoch ~/ 1000;
    if (_cachedToken != null && nowSec + 60 < _expiresAtEpochSec) {
      return Future.value(_cachedToken);
    }
    return _inFlightFetch ??= _fetchAndCacheToken().whenComplete(() {
      _inFlightFetch = null;
    });
  }

  /// Clears any cached token so the next request forces a refresh (e.g. on 401).
  void invalidateCachedToken() {
    _cachedToken = null;
    _expiresAtEpochSec = 0;
  }

  /// Reads or creates the per-install random device UUID inside [KeyValueSecretStore].
  Future<String> getOrCreateDeviceId() async {
    try {
      final existing = await _secretStore.read(deviceIdKeyName);
      if (existing != null && existing.trim().length >= 16) {
        return existing.trim();
      }
      final generated = _generateUuidV4();
      await _secretStore.write(deviceIdKeyName, generated);
      return generated;
    } on Object {
      // Ephemeral fallback only when platform keystore is unavailable in tests.
      return _generateUuidV4();
    }
  }

  Future<String?> _fetchAndCacheToken() async {
    try {
      final deviceId = await getOrCreateDeviceId();
      final response = await _authDio.post<Map<String, dynamic>>(
        '/v1/auth/device-token',
        data: {'device_id': deviceId},
      );
      final data = response.data;
      if (data == null) return null;
      final token = data['token']?.toString().trim();
      final expiresAt = switch (data['expires_at']) {
        final int v => v,
        final num v => v.toInt(),
        final String s => int.tryParse(s) ?? 0,
        _ => 0,
      };
      if (token == null || token.isEmpty) {
        return null;
      }
      _cachedToken = token;
      _expiresAtEpochSec = expiresAt > 0
          ? expiresAt
          : (_clock().millisecondsSinceEpoch ~/ 1000) + 300;
      return _cachedToken;
    } on Object {
      return null;
    }
  }

  static String _generateUuidV4() {
    final rng = Random.secure();
    final bytes = List<int>.generate(16, (_) => rng.nextInt(256));
    bytes[6] = (bytes[6] & 0x0f) | 0x40;
    bytes[8] = (bytes[8] & 0x3f) | 0x80;
    final hex = bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
    return '${hex.substring(0, 8)}-${hex.substring(8, 12)}-'
        '${hex.substring(12, 16)}-${hex.substring(16, 20)}-${hex.substring(20)}';
  }
}
