import 'package:flutter/foundation.dart';
import 'package:lex_copilot/core/result.dart';

/// Chat message role for [LlmService].
enum LlmRole {
  /// System-level grounding and legal-trust instructions.
  system,

  /// End-user prompt or follow-up.
  user,

  /// Assistant reply.
  assistant,
}

/// Immutable message passed to [LlmService.chat].
@immutable
class LlmMessage {
  /// Creates an [LlmMessage].
  const new({
    required this.role,
    required this.content,
    this.images = const [],
  });

  /// Speaker role.
  final LlmRole role;

  /// Text message content.
  final String content;

  /// Optional attached page/document images (PNG/JPEG bytes).
  final List<Uint8List> images;
}

/// Generation hyperparameters (defaults to low temperature for legal accuracy).
@immutable
class LlmGenerationOptions {
  /// Creates [LlmGenerationOptions].
  const new({
    this.temperature = 0.15,
    this.maxOutputTokens = 1024,
    this.systemInstruction,
  });

  /// Sampling temperature (`0.1`–`0.2` recommended for legal tasks).
  final double temperature;

  /// Maximum output tokens to generate.
  final int maxOutputTokens;

  /// Optional system prompt override.
  final String? systemInstruction;
}

/// Typed schema descriptor + parser for [LlmService.structured].
@immutable
class LlmSchema<T> {
  /// Creates an [LlmSchema].
  const new({
    required this.name,
    required this.jsonSchema,
    required this.fromJson,
  });

  /// Schema identifier.
  final String name;

  /// JSON Schema object sent to model/validator.
  final Map<String, dynamic> jsonSchema;

  /// Typed parser invoked once JSON structure is validated.
  final T Function(Map<String, dynamic> json) fromJson;
}

/// Unified abstraction over on-device Gemma 4 and cloud Gemma 4 backends.
abstract interface class LlmService {
  /// Unique model identifier (e.g. `gemma-4-e4b-it`, `gemma-4-31b-it`).
  String get modelId;

  /// Whether this backend supports multimodal image input.
  bool get supportsImages;

  /// Whether this backend supports audio input.
  bool get supportsAudio;

  /// Whether inference executes locally without network access.
  bool get isOnDevice;

  /// Streams incremental text tokens for a conversation [messages].
  Stream<String> chat(
    List<LlmMessage> messages, {
    LlmGenerationOptions options = const LlmGenerationOptions(),
  });

  /// Generates structured JSON conforming to [schema] and parses it to [T].
  ///
  /// Implementations must validate JSON against [schema] and retry once on
  /// malformed JSON before returning an [Err].
  Future<Result<T>> structured<T>(
    LlmSchema<T> schema,
    String prompt, {
    List<Uint8List> images = const [],
    LlmGenerationOptions options = const LlmGenerationOptions(),
  });

  /// Extracts text/summary from an image using multimodal vision capabilities.
  Future<Result<String>> describeImage(
    Uint8List imageBytes, {
    required String prompt,
  });
}
