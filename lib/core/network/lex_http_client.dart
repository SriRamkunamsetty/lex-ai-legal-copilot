import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:lex_copilot/ai/redaction/pii_redactor.dart';
import 'package:lex_copilot/app/flavors.dart';

/// Callback providing or refreshing a short-lived device bearer token.
typedef DeviceTokenProvider = Future<String?> Function();

/// Callback invalidating a rejected cached bearer token before retrying once.
typedef DeviceTokenInvalidator = void Function();

/// Safe diagnostic logger callback (always receives PII-redacted text).
typedef DiagnosticLogCallback = void Function(String message);

/// Configured [Dio] HTTP client with device-token auth, 401 refresh + transient
/// retry, PII-redacted logging, and real SPKI/DER SHA-256 certificate pinning.
class LexHttpClient {
  /// Creates a [LexHttpClient] configured for [flavorConfig].
  new({
    required FlavorConfig flavorConfig,
    DeviceTokenProvider? tokenProvider,
    DeviceTokenInvalidator? onTokenRejected,
    DiagnosticLogCallback? logger,
    String? pinnedCertSha256,
    List<String> pinnedCertSha256List = const [],
    Dio? dioOverride,
  }) : _dio =
           dioOverride ??
           Dio(
             BaseOptions(
               baseUrl: flavorConfig.apiBaseUrl,
               connectTimeout: const Duration(seconds: 12),
               receiveTimeout: const Duration(seconds: 45),
               headers: const {'Accept': 'application/json'},
             ),
           ) {
    final normalizedPins = <String>[
      if (pinnedCertSha256 != null && pinnedCertSha256.trim().isNotEmpty)
        pinnedCertSha256.trim(),
      ...pinnedCertSha256List.map((e) => e.trim()).where((e) => e.isNotEmpty),
    ];

    final adapter = _dio.httpClientAdapter;
    if (flavorConfig.enableCertificatePinning &&
        normalizedPins.isNotEmpty &&
        adapter is IOHttpClientAdapter) {
      // Enforced on every TLS handshake even when the OS CA chain succeeds.
      adapter.validateCertificate = (cert, host, port) {
        if (cert == null) return false;
        return verifyCertificatePin(cert, normalizedPins);
      };
    }

    _dio.interceptors.addAll([
      _DeviceAuthInterceptor(_dio, tokenProvider, onTokenRejected),
      _RetryInterceptor(_dio),
      if (flavorConfig.enableVerboseLogging) _PiiRedactedLogInterceptor(logger),
    ]);
  }

  final Dio _dio;

  /// Exposes the configured [Dio] instance.
  Dio get dio => _dio;

  /// Verifies [cert] against [allowedPins] (supports `sha256/<base64>`,
  /// base64 SPKI/DER digests, and 64-char hex SPKI/DER digests for key rotation).
  static bool verifyCertificatePin(
    X509Certificate cert,
    List<String> allowedPins,
  ) {
    return verifyDerBytesPin(cert.der, allowedPins);
  }

  /// Verifies raw X.509 [certDer] bytes against [allowedPins] using both
  /// SubjectPublicKeyInfo (SPKI) SHA-256 and full-certificate DER SHA-256.
  static bool verifyDerBytesPin(Uint8List certDer, List<String> allowedPins) {
    if (certDer.isEmpty || allowedPins.isEmpty) return false;
    final candidates = <String>{..._formatSha256Digests(certDer)};
    final spki = extractSpkiDer(certDer);
    if (spki != null) {
      candidates.addAll(_formatSha256Digests(spki));
    }

    for (final rawPin in allowedPins) {
      final pin = _normalizePin(rawPin);
      if (pin.isEmpty) continue;
      if (candidates.contains(pin)) {
        return true;
      }
    }
    return false;
  }

  /// Parses an X.509 DER certificate and returns the exact DER bytes of its
  /// `tbsCertificate.subjectPublicKeyInfo` ASN.1 SEQUENCE, or `null` if invalid.
  static Uint8List? extractSpkiDer(Uint8List certDer) {
    try {
      final outer = _readTlv(certDer, 0);
      if (outer == null || outer.tag != 0x30) return null;
      final tbs = _readTlv(certDer, outer.contentStart);
      if (tbs == null || tbs.tag != 0x30) return null;

      var cursor = tbs.contentStart;
      final tbsEnd = tbs.tlvEnd;

      // 1. Optional [0] EXPLICIT version (tag 0xA0)
      var item = _readTlv(certDer, cursor);
      if (item == null || item.tlvEnd > tbsEnd) return null;
      if (item.tag == 0xA0) {
        cursor = item.tlvEnd;
        item = _readTlv(certDer, cursor);
        if (item == null || item.tlvEnd > tbsEnd) return null;
      }

      // 2. serialNumber, 3. signature, 4. issuer, 5. validity, 6. subject
      for (var step = 0; step < 5; step++) {
        cursor = item!.tlvEnd;
        item = _readTlv(certDer, cursor);
        if (item == null || item.tlvEnd > tbsEnd) return null;
      }

      // 7. subjectPublicKeyInfo (SEQUENCE 0x30)
      if (item!.tag != 0x30) return null;
      return Uint8List.sublistView(certDer, item.tlvStart, item.tlvEnd);
    } on Object {
      return null;
    }
  }

  static Set<String> _formatSha256Digests(Uint8List bytes) {
    final digest = sha256.convert(bytes).bytes;
    final hex = digest
        .map((b) => b.toRadixString(16).padLeft(2, '0'))
        .join()
        .toLowerCase();
    final b64 = base64Encode(digest);
    return {hex, b64, 'sha256/$b64'};
  }

  static String _normalizePin(String pin) {
    final trimmed = pin.trim();
    if (trimmed.isEmpty) return '';
    if (trimmed.toLowerCase().startsWith('sha256/')) {
      return 'sha256/${trimmed.substring(7).trim()}';
    }
    if (RegExp(r'^[0-9a-fA-F:]{64,}$').hasMatch(trimmed)) {
      return trimmed.replaceAll(':', '').toLowerCase();
    }
    return trimmed;
  }

  static ({int tag, int tlvStart, int contentStart, int tlvEnd})? _readTlv(
    Uint8List data,
    int offset,
  ) {
    if (offset >= data.length) return null;
    final tag = data[offset];
    if (offset + 1 >= data.length) return null;
    final firstLen = data[offset + 1];
    var lenBytesCount = 1;
    int contentLen;
    if ((firstLen & 0x80) == 0) {
      contentLen = firstLen;
    } else {
      final numOctets = firstLen & 0x7F;
      if (numOctets == 0 ||
          numOctets > 4 ||
          offset + 2 + numOctets > data.length) {
        return null;
      }
      lenBytesCount = 1 + numOctets;
      contentLen = 0;
      for (var i = 0; i < numOctets; i++) {
        contentLen = (contentLen << 8) | data[offset + 2 + i];
      }
    }
    final contentStart = offset + 1 + lenBytesCount;
    final tlvEnd = contentStart + contentLen;
    if (contentLen < 0 || tlvEnd > data.length) return null;
    return (
      tag: tag,
      tlvStart: offset,
      contentStart: contentStart,
      tlvEnd: tlvEnd,
    );
  }
}

class _DeviceAuthInterceptor extends Interceptor {
  new(this._dio, this._tokenProvider, this._onTokenRejected);

  final Dio _dio;
  final DeviceTokenProvider? _tokenProvider;
  final DeviceTokenInvalidator? _onTokenRejected;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (options.path.contains('/v1/auth/device-token')) {
      handler.next(options);
      return;
    }
    if (!options.headers.containsKey('Authorization') &&
        _tokenProvider != null) {
      final token = await _tokenProvider();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final status = err.response?.statusCode;
    final retriedAuth = err.requestOptions.extra['auth_retried'] == true;
    if (status == 401 &&
        !retriedAuth &&
        _tokenProvider != null &&
        !err.requestOptions.path.contains('/v1/auth/device-token') &&
        err.requestOptions.responseType != ResponseType.stream) {
      _onTokenRejected?.call();
      final refreshed = await _tokenProvider();
      if (refreshed != null && refreshed.isNotEmpty) {
        err.requestOptions.extra['auth_retried'] = true;
        err.requestOptions.headers['Authorization'] = 'Bearer $refreshed';
        try {
          final response = await _dio.fetch<dynamic>(err.requestOptions);
          handler.resolve(response);
          return;
        } on DioException catch (retryErr) {
          handler.next(retryErr);
          return;
        }
      }
    }
    handler.next(err);
  }
}

class _RetryInterceptor extends Interceptor {
  new(this._dio);

  final Dio _dio;
  static const int _maxRetries = 2;

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final attempt = (err.requestOptions.extra['retry_attempt'] as int?) ?? 0;
    final isRetryable =
        err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        (err.response?.statusCode != null && err.response!.statusCode! >= 500);

    if (isRetryable &&
        attempt < _maxRetries &&
        err.requestOptions.responseType != ResponseType.stream) {
      err.requestOptions.extra['retry_attempt'] = attempt + 1;
      await Future<void>.delayed(Duration(milliseconds: 250 * (attempt + 1)));
      try {
        final response = await _dio.fetch<dynamic>(err.requestOptions);
        handler.resolve(response);
        return;
      } on DioException catch (retryErr) {
        handler.next(retryErr);
        return;
      }
    }
    handler.next(err);
  }
}

class _PiiRedactedLogInterceptor extends Interceptor {
  new(this._logger);

  final DiagnosticLogCallback? _logger;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final safePath = PiiRedactor.redactForLogging(options.path);
    _logger?.call('[HTTP] -> ${options.method} $safePath');
    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    final safePath = PiiRedactor.redactForLogging(response.requestOptions.path);
    _logger?.call('[HTTP] <- ${response.statusCode} $safePath');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final safeMsg = PiiRedactor.redactForLogging(err.message ?? 'error');
    _logger?.call(
      '[HTTP] !! ${err.requestOptions.method} ${err.response?.statusCode}: $safeMsg',
    );
    handler.next(err);
  }
}
