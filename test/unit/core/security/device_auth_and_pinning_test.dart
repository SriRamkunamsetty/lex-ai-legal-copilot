import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lex_copilot/app/flavors.dart';
import 'package:lex_copilot/core/network/lex_http_client.dart';
import 'package:lex_copilot/core/security/device_auth_service.dart';
import 'package:lex_copilot/core/security/secure_key_store.dart';

class _InMemSecretStore implements KeyValueSecretStore {
  final Map<String, String> _values = {};

  @override
  Future<String?> read(String key) async => _values[key];

  @override
  Future<void> write(String key, String value) async => _values[key] = value;

  @override
  Future<void> delete(String key) async => _values.remove(key);
}

Uint8List _derTlv(int tag, List<int> content) {
  final len = content.length;
  final lenBytes = len < 128 ? [len] : [0x82, (len >> 8) & 0xFF, len & 0xFF];
  return Uint8List.fromList([tag, ...lenBytes, ...content]);
}

void main() {
  group('DeviceAuthService & Certificate Pinning', () {
    test('acquires, persists device_id, caches token, and refreshes when near expiry', () async {
      final secrets = _InMemSecretStore();
      var calls = 0;
      var now = DateTime.fromMillisecondsSinceEpoch(1700000000 * 1000);

      final fakeDio = Dio()
        ..interceptors.add(
          InterceptorsWrapper(
            onRequest: (options, handler) {
              calls += 1;
              expect(options.path, '/v1/auth/device-token');
              handler.resolve(
                Response<Map<String, dynamic>>(
                  requestOptions: options,
                  statusCode: 200,
                  data: {
                    'token': 'tok_$calls',
                    'expires_at': (now.millisecondsSinceEpoch ~/ 1000) + 120,
                  },
                ),
              );
            },
          ),
        );

      final auth = DeviceAuthService(
        flavorConfig: FlavorConfig.forFlavor(LexFlavor.dev),
        secretStore: secrets,
        authDio: fakeDio,
        clock: () => now,
      );

      final t1 = await auth.getToken();
      final t2 = await auth.getToken();
      expect(t1, 'tok_1');
      expect(t2, 'tok_1');
      expect(calls, 1);

      // Advance into 60s refresh window -> refreshes cleanly.
      now = now.add(const Duration(seconds: 70));
      final t3 = await auth.getToken();
      expect(t3, 'tok_2');
      expect(calls, 2);
    });

    test('verifies X.509 DER & extracted SPKI SHA-256 pins with rotation support', () {
      // Minimal valid ASN.1 DER X.509 wrapper containing SubjectPublicKeyInfo.
      final spki = _derTlv(0x30, [0x03, 0x03, 0x00, 0xAB, 0xCD]);
      final tbs = _derTlv(0x30, [
        ..._derTlv(0xA0, [0x02, 0x01, 0x02]), // [0] version v3
        ..._derTlv(0x02, [0x01]), // serialNumber
        ..._derTlv(0x30, []), // signature
        ..._derTlv(0x30, []), // issuer
        ..._derTlv(0x30, []), // validity
        ..._derTlv(0x30, []), // subject
        ...spki, // subjectPublicKeyInfo
      ]);
      final certDer = _derTlv(0x30, tbs);

      final extracted = LexHttpClient.extractSpkiDer(certDer);
      expect(extracted, equals(spki));

      final spkiB64 = base64Encode(sha256.convert(spki).bytes);
      final wrongPin = 'sha256/${base64Encode(List<int>.filled(32, 0))}';

      expect(
        LexHttpClient.verifyDerBytesPin(certDer, [wrongPin, 'sha256/$spkiB64']),
        isTrue,
      );
      expect(LexHttpClient.verifyDerBytesPin(certDer, [wrongPin]), isFalse);
    });
  });
}
