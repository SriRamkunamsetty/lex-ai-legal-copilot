import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:lex_copilot/ai/redaction/pii_redactor.dart';
import 'package:lex_copilot/app/flavors.dart';

/// Callback providing or refreshing a short-lived device bearer token.
typedef DeviceTokenProvider = Future<String?> Function();

/// Safe diagnostic logger callback (always receives PII-redacted text).
typedef DiagnosticLogCallback = void Function(String message);

/// Configured [Dio] HTTP client with device-token auth, retry, PII-redacted
/// logging, and optional TLS certificate pinning.
class LexHttpClient {
  /// Creates a [LexHttpClient] configured for [flavorConfig].
  new({
    required FlavorConfig flavorConfig,
    DeviceTokenProvider? tokenProvider,
    DiagnosticLogCallback? logger,
    String? pinnedCertSha256,
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
    if (flavorConfig.enableCertificatePinning &&
        pinnedCertSha256 != null &&
        _dio.httpClientAdapter is IOHttpClientAdapter) {
      (_dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
        final client = HttpClient()
          ..badCertificateCallback = (cert, host, port) {
            // TODO(verify): Replace with actual production SPKI SHA-256 pin check.
            return false;
          };
        return client;
      };
    }

    _dio.interceptors.addAll([
      _DeviceAuthInterceptor(tokenProvider),
      _RetryInterceptor(_dio),
      if (flavorConfig.enableVerboseLogging) _PiiRedactedLogInterceptor(logger),
    ]);
  }

  final Dio _dio;

  /// Exposes the configured [Dio] instance.
  Dio get dio => _dio;
}

class _DeviceAuthInterceptor extends Interceptor {
  new(this._tokenProvider);

  final DeviceTokenProvider? _tokenProvider;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (!options.headers.containsKey('Authorization') &&
        _tokenProvider != null) {
      final token = await _tokenProvider();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
    handler.next(options);
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
