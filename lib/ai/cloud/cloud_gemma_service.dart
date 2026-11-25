import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:lex_copilot/ai/llm_service.dart';
import 'package:lex_copilot/ai/redaction/pii_redactor.dart';
import 'package:lex_copilot/ai/schemas/schema_validator.dart';
import 'package:lex_copilot/core/errors/failure.dart';
import 'package:lex_copilot/core/network/lex_http_client.dart';
import 'package:lex_copilot/core/result.dart';

/// Cloud Gemma 4 31B [LlmService] calling the FastAPI proxy backend with SSE
/// streaming and automatic pre-flight PII redaction + post-response restoration.
class CloudGemmaService implements LlmService {
  /// Creates a [CloudGemmaService].
  new(this._httpClient, {this.modelId = 'gemma-4-31b-it'});

  final LexHttpClient _httpClient;

  @override
  final String modelId;

  @override
  bool get supportsImages => true;

  @override
  bool get supportsAudio => false;

  @override
  bool get isOnDevice => false;

  @override
  Stream<String> chat(
    List<LlmMessage> messages, {
    LlmGenerationOptions options = const LlmGenerationOptions(),
  }) async* {
    // Redact PII across all messages before transmitting to cloud proxy.
    final combinedTokenMap = <String, String>{};
    final redactedMessages = <Map<String, dynamic>>[];

    for (final msg in messages) {
      final redaction = PiiRedactor.redact(msg.content);
      combinedTokenMap.addAll(redaction.tokenMap);
      redactedMessages.add({
        'role': msg.role.name,
        'content': redaction.redactedText,
        if (msg.images.isNotEmpty)
          'images_base64': msg.images.map(base64Encode).toList(),
      });
    }

    final response = await _httpClient.dio.post<ResponseBody>(
      '/v1/chat',
      data: {
        'messages': redactedMessages,
        'temperature': options.temperature,
        'max_output_tokens': options.maxOutputTokens,
        if (options.systemInstruction != null)
          'system_instruction': PiiRedactor.redact(options.systemInstruction!)
              .redactedText,
      },
      options: Options(responseType: ResponseType.stream),
    );

    final stream = response.data?.stream;
    if (stream == null) return;

    final lineBuffer = StringBuffer();
    var buffered = '';
    await for (final bytes in stream) {
      buffered = '$lineBuffer${utf8.decode(bytes, allowMalformed: true)}';
      lineBuffer.clear();
      while (true) {
        final nlIndex = buffered.indexOf('\n');
        if (nlIndex < 0) {
          lineBuffer.write(buffered);
          break;
        }
        final line = buffered.substring(0, nlIndex).trim();
        buffered = buffered.substring(nlIndex + 1);

        if (!line.startsWith('data:')) continue;
        final payload = line.substring(5).trim();
        if (payload == '[DONE]' || payload.isEmpty) continue;

        final token = _parseSseToken(payload);
        if (token.isNotEmpty) {
          yield PiiRedactor.restore(token, combinedTokenMap);
        }
      }
    }
  }

  @override
  Future<Result<T>> structured<T>(
    LlmSchema<T> schema,
    String prompt, {
    List<Uint8List> images = const [],
    LlmGenerationOptions options = const LlmGenerationOptions(),
  }) => Result.guard(
    () async {
      final redaction = PiiRedactor.redact(prompt);
      final structuredPrompt =
          'Respond ONLY with a valid JSON object matching schema '
          '${schema.name}: ${jsonEncode(schema.jsonSchema)}.\n\n'
          '${redaction.redactedText}';

      final raw1 = await _singleCompletion(
        structuredPrompt,
        images: images,
        options: options,
        tokenMap: redaction.tokenMap,
      );
      final parsed1 = SchemaValidator.parseAndValidate(raw1, schema.jsonSchema);
      if (parsed1 case Success(:final value)) {
        return schema.fromJson(value);
      }

      // Retry once on invalid JSON
      final retryPrompt =
          'Invalid JSON (${parsed1.failureOrNull?.message}). Return ONLY valid '
          'JSON matching ${schema.name}.\n\n${redaction.redactedText}';
      final raw2 = await _singleCompletion(
        retryPrompt,
        images: images,
        options: options,
        tokenMap: redaction.tokenMap,
      );
      final parsed2 = SchemaValidator.parseAndValidate(raw2, schema.jsonSchema);
      return await parsed2.fold(
        onSuccess: schema.fromJson,
        onFailure: (failure) => throw StateError(failure.message),
      );
    },
    onError: (error, _) =>
        NetworkFailure('Cloud structured request failed: $error', cause: error),
  );

  @override
  Future<Result<String>> describeImage(
    Uint8List imageBytes, {
    required String prompt,
  }) => Result.guard(
    () async {
      final redaction = PiiRedactor.redact(prompt);
      final response = await _httpClient.dio.post<Map<String, dynamic>>(
        '/v1/document/analyze',
        data: {
          'prompt': redaction.redactedText,
          'images_base64': [base64Encode(imageBytes)],
        },
      );
      final text = response.data?['summary'] as String? ?? '';
      return redaction.restore(text);
    },
    onError: (error, _) =>
        NetworkFailure('Cloud document image analysis failed.', cause: error),
  );

  Future<String> _singleCompletion(
    String redactedPrompt, {
    required List<Uint8List> images,
    required LlmGenerationOptions options,
    required Map<String, String> tokenMap,
  }) async {
    final response = await _httpClient.dio.post<ResponseBody>(
      '/v1/chat',
      data: {
        'messages': [
          {
            'role': 'user',
            'content': redactedPrompt,
            if (images.isNotEmpty)
              'images_base64': images.map(base64Encode).toList(),
          },
        ],
        'temperature': options.temperature,
        'max_output_tokens': options.maxOutputTokens,
        if (options.systemInstruction != null)
          'system_instruction': PiiRedactor.redact(options.systemInstruction!)
              .redactedText,
      },
      options: Options(responseType: ResponseType.stream),
    );

    final buffer = StringBuffer();
    final stream = response.data?.stream;
    if (stream == null) return '';
    final pendingBuf = StringBuffer();
    await for (final chunk in stream) {
      pendingBuf.write(utf8.decode(chunk, allowMalformed: true));
      var pending = pendingBuf.toString();
      pendingBuf.clear();
      while (true) {
        final idx = pending.indexOf('\n');
        if (idx < 0) {
          pendingBuf.write(pending);
          break;
        }
        final line = pending.substring(0, idx).trim();
        pending = pending.substring(idx + 1);
        if (!line.startsWith('data:')) continue;
        final payload = line.substring(5).trim();
        if (payload == '[DONE]' || payload.isEmpty) continue;
        buffer.write(_parseSseToken(payload));
      }
    }
    return PiiRedactor.restore(buffer.toString(), tokenMap);
  }

  static String _parseSseToken(String payload) {
    try {
      final decoded = jsonDecode(payload);
      if (decoded is Map<String, dynamic>) {
        return (decoded['delta'] as String?) ??
            (decoded['text'] as String?) ??
            '';
      }
    } on FormatException {
      return payload;
    }
    return '';
  }
}
