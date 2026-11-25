import 'dart:async';
import 'dart:typed_data';

import 'package:lex_copilot/ai/cloud/cloud_gemma_service.dart';
import 'package:lex_copilot/ai/llm_service.dart';
import 'package:lex_copilot/ai/on_device/on_device_gemma_service.dart';
import 'package:lex_copilot/core/errors/failure.dart';
import 'package:lex_copilot/core/result.dart';
import 'package:lex_copilot/features/settings/domain/lex_settings.dart';

/// Hints about the current AI task used by [ModelRouter] in Auto mode.
enum RoutingTaskKind {
  /// Short Q&A, scan follow-up, or privacy-sensitive local extraction.
  shortPrivate,

  /// Multi-document research, long contract review, or complex drafting.
  deepResearch,
}

/// Callback checking whether the device currently has network connectivity.
typedef ConnectivityChecker = Future<bool> Function();

/// Routes AI inference across [OnDeviceGemmaService] and [CloudGemmaService]
/// according to [LexSettings.modelRouting], task depth, connectivity, and
/// graceful fallback rules.
class ModelRouter implements LlmService {
  /// Creates a [ModelRouter].
  new({
    required this.onDevice,
    required this.cloud,
    required this.readSettings,
    ConnectivityChecker? isOnline,
  }) : _isOnline = isOnline ?? _defaultOnline;

  /// On-device Gemma 4 inference service.
  final OnDeviceGemmaService onDevice;

  /// Cloud Gemma 4 API-proxy service.
  final CloudGemmaService cloud;

  /// Callback reading the latest user [LexSettings].
  final LexSettings Function() readSettings;
  final ConnectivityChecker _isOnline;

  static Future<bool> _defaultOnline() async => true;

  bool get _isOnDeviceReady =>
      onDevice.currentState.status == OnDeviceModelStatus.ready ||
      onDevice.currentState.status == OnDeviceModelStatus.lowMemoryFallback;

  @override
  String get modelId => switch (readSettings().modelRouting) {
    LexModelRouting.onDevice => onDevice.modelId,
    LexModelRouting.cloud => cloud.modelId,
    LexModelRouting.auto => _isOnDeviceReady ? onDevice.modelId : cloud.modelId,
  };

  @override
  bool get supportsImages => true;

  @override
  bool get supportsAudio => onDevice.supportsAudio;

  @override
  bool get isOnDevice =>
      readSettings().modelRouting == LexModelRouting.onDevice;

  /// Picks the primary and optional fallback service for [taskKind] &
  /// [payloadLength].
  Future<({LlmService primary, LlmService? fallback})> resolveRoute({
    RoutingTaskKind taskKind = RoutingTaskKind.shortPrivate,
    int payloadLength = 0,
  }) async {
    final settings = readSettings();
    final online = await _isOnline();

    switch (settings.modelRouting) {
      case LexModelRouting.onDevice:
        return (primary: onDevice, fallback: null);
      case LexModelRouting.cloud:
        if (!online && _isOnDeviceReady) {
          return (primary: onDevice, fallback: null);
        }
        return (primary: cloud, fallback: _isOnDeviceReady ? onDevice : null);
      case LexModelRouting.auto:
        final needsDeepCloud =
            settings.deepResearchUsesCloud &&
            (taskKind == RoutingTaskKind.deepResearch || payloadLength > 4000);
        if (needsDeepCloud && online) {
          return (primary: cloud, fallback: _isOnDeviceReady ? onDevice : null);
        }
        if (_isOnDeviceReady || !online) {
          return (primary: onDevice, fallback: online ? cloud : null);
        }
        return (primary: cloud, fallback: null);
    }
  }

  @override
  Stream<String> chat(
    List<LlmMessage> messages, {
    LlmGenerationOptions options = const LlmGenerationOptions(),
    RoutingTaskKind taskKind = RoutingTaskKind.shortPrivate,
  }) async* {
    final payloadLength = messages.fold<int>(
      0,
      (sum, m) => sum + m.content.length,
    );
    final route = await resolveRoute(
      taskKind: taskKind,
      payloadLength: payloadLength,
    );

    var emittedAny = false;
    try {
      await for (final chunk in route.primary.chat(
        messages,
        options: options,
      )) {
        emittedAny = true;
        yield chunk;
      }
      return;
    } on Object {
      if (emittedAny || route.fallback == null) {
        rethrow;
      }
    }

    yield* route.fallback!.chat(messages, options: options);
  }

  @override
  Future<Result<T>> structured<T>(
    LlmSchema<T> schema,
    String prompt, {
    List<Uint8List> images = const [],
    LlmGenerationOptions options = const LlmGenerationOptions(),
    RoutingTaskKind taskKind = RoutingTaskKind.shortPrivate,
  }) async {
    final route = await resolveRoute(
      taskKind: taskKind,
      payloadLength: prompt.length,
    );

    final primaryResult = await route.primary.structured(
      schema,
      prompt,
      images: images,
      options: options,
    );
    if (primaryResult.isSuccess || route.fallback == null) {
      if (primaryResult.isErr && route.fallback == null) {
        return Err(
          AiFailure(
            'Unable to run AI right now (${primaryResult.failureOrNull?.message}). Your input has been preserved.',
            cause: primaryResult.failureOrNull,
          ),
        );
      }
      return primaryResult;
    }

    final fallbackResult = await route.fallback!.structured(
      schema,
      prompt,
      images: images,
      options: options,
    );
    return await fallbackResult.fold(
      onSuccess: Success.new,
      onFailure: (failure) => Err(
        AiFailure(
          'Both cloud and on-device models failed (${failure.message}). Your input has been preserved.',
          cause: failure,
        ),
      ),
    );
  }

  @override
  Future<Result<String>> describeImage(
    Uint8List imageBytes, {
    required String prompt,
  }) async {
    final route = await resolveRoute();
    final primary = await route.primary.describeImage(
      imageBytes,
      prompt: prompt,
    );
    if (primary.isSuccess || route.fallback == null) {
      return primary;
    }
    return await route.fallback!.describeImage(imageBytes, prompt: prompt);
  }
}
