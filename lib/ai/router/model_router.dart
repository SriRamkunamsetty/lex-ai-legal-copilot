import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:lex_copilot/ai/cloud/cloud_gemma_service.dart';
import 'package:lex_copilot/ai/llm_service.dart';
import 'package:lex_copilot/ai/on_device/on_device_gemma_service.dart';
import 'package:lex_copilot/ai/redaction/pii_redactor.dart';
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

/// Request metadata surfaced to the user before sending redacted text to cloud.
@immutable
class CloudConsentRequest {
  /// Creates a [CloudConsentRequest].
  const new({
    required this.taskKind,
    required this.reason,
    required this.redactedPreview,
  });

  /// Task classification triggering cloud escalation.
  final RoutingTaskKind taskKind;

  /// Human-readable reason cloud assistance is requested.
  final String reason;

  /// PII-redacted preview snippet shown on the explicit consent sheet.
  final String redactedPreview;
}

/// Asynchronous prompt callback asking the user to approve cloud escalation.
typedef CloudConsentRequester = Future<bool> Function(
  CloudConsentRequest request,
);

/// Thrown when `Auto`/`Hybrid` mode requires explicit user consent before
/// uploading redacted content to the cloud proxy.
class CloudConsentRequiredException implements Exception {
  /// Creates a [CloudConsentRequiredException].
  const new(this.request);

  /// Redacted payload details awaiting explicit user approval.
  final CloudConsentRequest request;

  @override
  String toString() => 'CloudConsentRequiredException(${request.reason})';
}

/// Resolved inference engine route with provenance metadata.
@immutable
class ResolvedModelRoute {
  /// Creates a [ResolvedModelRoute].
  const new({
    required this.primary,
    required this.engineLabel,
    this.fallback,
    this.usedCloudConsent = false,
  });

  /// Primary inference service selected for this call.
  final LlmService primary;

  /// Optional non-cloud fallback service (only when degrading Cloud -> Local).
  final LlmService? fallback;

  /// Human-readable engine provenance label for UI badges & audit logs.
  final String engineLabel;

  /// Whether this cloud route was explicitly authorized via consent prompt.
  final bool usedCloudConsent;
}

/// Routes AI inference across [OnDeviceGemmaService] and [CloudGemmaService]
/// according to [LexSettings.modelRouting], task depth, connectivity, and
/// strict no-silent-cloud-upload consent rules.
class ModelRouter implements LlmService {
  /// Creates a [ModelRouter].
  new({
    required this.onDevice,
    required this.cloud,
    required this.readSettings,
    ConnectivityChecker? isOnline,
    this.requestCloudConsent,
  }) : _isOnline = isOnline ?? _defaultOfflineSafe;

  /// On-device Gemma 4 inference service.
  final OnDeviceGemmaService onDevice;

  /// Cloud Gemma 4 API-proxy service.
  final CloudGemmaService cloud;

  /// Callback reading the latest user [LexSettings].
  final LexSettings Function() readSettings;
  final ConnectivityChecker _isOnline;

  /// Optional prompt callback requesting explicit user approval for cloud use.
  final CloudConsentRequester? requestCloudConsent;

  String _lastResolvedEngineLabel = 'Gemma 4 · On-Device';

  /// Engine label of the most recently executed route (for UI provenance chips).
  String get lastResolvedEngineLabel => _lastResolvedEngineLabel;

  // Fail closed when connectivity checker is not wired.
  static Future<bool> _defaultOfflineSafe() async => false;

  bool get _isOnDeviceReady =>
      onDevice.currentState.status == OnDeviceModelStatus.ready ||
      onDevice.currentState.status == OnDeviceModelStatus.lowMemoryFallback;

  static String _labelFor(LlmService service) {
    if (service.isOnDevice) {
      final tierLabel = service.modelId.toLowerCase().contains('e4b')
          ? 'Gemma 4 E4B · On-Device'
          : 'Gemma 4 E2B · On-Device';
      return tierLabel;
    }
    return 'Cloud · Gemma 4';
  }

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
      readSettings().modelRouting == LexModelRouting.onDevice ||
      (readSettings().modelRouting == LexModelRouting.auto && _isOnDeviceReady);

  /// Picks the primary and optional fallback service for [taskKind],
  /// [payloadLength], and redacted [previewSource] under strict consent rules.
  Future<ResolvedModelRoute> resolveRouteWithConsent({
    RoutingTaskKind taskKind = RoutingTaskKind.shortPrivate,
    int payloadLength = 0,
    String previewSource = '',
    CloudConsentRequester? consentOverride,
  }) async {
    final settings = readSettings();
    final online = await _isOnline();

    switch (settings.modelRouting) {
      case LexModelRouting.onDevice:
        return ResolvedModelRoute(
          primary: onDevice,
          engineLabel: _labelFor(onDevice),
        );
      case LexModelRouting.cloud:
        if (!online && _isOnDeviceReady) {
          return ResolvedModelRoute(
            primary: onDevice,
            engineLabel: _labelFor(onDevice),
          );
        }
        return ResolvedModelRoute(
          primary: cloud,
          fallback: _isOnDeviceReady ? onDevice : null,
          engineLabel: _labelFor(cloud),
          usedCloudConsent: true,
        );
      case LexModelRouting.auto:
        final needsDeepCloud =
            settings.deepResearchUsesCloud &&
            (taskKind == RoutingTaskKind.deepResearch || payloadLength > 4000);

        if (needsDeepCloud && online) {
          final request = _buildConsentRequest(
            taskKind: taskKind,
            reason: 'Long or multi-document research benefits from Cloud Gemma 4. Only PII-redacted text will be transmitted.',
            previewSource: previewSource,
          );
          final requester = consentOverride ?? requestCloudConsent;
          final approved = requester != null && await requester(request);
          if (approved) {
            return ResolvedModelRoute(
              primary: cloud,
              fallback: _isOnDeviceReady ? onDevice : null,
              engineLabel: _labelFor(cloud),
              usedCloudConsent: true,
            );
          }
          if (_isOnDeviceReady) {
            // Stay local if user declines cloud escalation.
            return ResolvedModelRoute(
              primary: onDevice,
              engineLabel: _labelFor(onDevice),
            );
          }
          throw CloudConsentRequiredException(request);
        }

        // Strict invariant: never fall back silently from Local -> Cloud.
        if (_isOnDeviceReady || !online) {
          return ResolvedModelRoute(
            primary: onDevice,
            engineLabel: _labelFor(onDevice),
          );
        }

        final request = _buildConsentRequest(
          taskKind: taskKind,
          reason: 'On-device Gemma 4 model is not installed yet. Allow sending PII-redacted text to Cloud Gemma 4?',
          previewSource: previewSource,
        );
        final requester = consentOverride ?? requestCloudConsent;
        final approved = requester != null && await requester(request);
        if (!approved) {
          throw CloudConsentRequiredException(request);
        }
        return ResolvedModelRoute(
          primary: cloud,
          engineLabel: _labelFor(cloud),
          usedCloudConsent: true,
        );
    }
  }

  /// Convenience wrapper returning `(primary, fallback)` for existing callers.
  Future<({LlmService primary, LlmService? fallback})> resolveRoute({
    RoutingTaskKind taskKind = RoutingTaskKind.shortPrivate,
    int payloadLength = 0,
    String previewSource = '',
    CloudConsentRequester? consentOverride,
  }) async {
    final resolved = await resolveRouteWithConsent(
      taskKind: taskKind,
      payloadLength: payloadLength,
      previewSource: previewSource,
      consentOverride: consentOverride,
    );
    return (primary: resolved.primary, fallback: resolved.fallback);
  }

  @override
  Stream<String> chat(
    List<LlmMessage> messages, {
    LlmGenerationOptions options = const LlmGenerationOptions(),
    RoutingTaskKind taskKind = RoutingTaskKind.shortPrivate,
    CloudConsentRequester? consentOverride,
  }) async* {
    final combined = messages.map((m) => m.content).join('\n');
    final route = await resolveRouteWithConsent(
      taskKind: taskKind,
      payloadLength: combined.length,
      previewSource: combined,
      consentOverride: consentOverride,
    );
    _lastResolvedEngineLabel = route.engineLabel;

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

    _lastResolvedEngineLabel = _labelFor(route.fallback!);
    yield* route.fallback!.chat(messages, options: options);
  }

  @override
  Future<Result<T>> structured<T>(
    LlmSchema<T> schema,
    String prompt, {
    List<Uint8List> images = const [],
    LlmGenerationOptions options = const LlmGenerationOptions(),
    RoutingTaskKind taskKind = RoutingTaskKind.shortPrivate,
    CloudConsentRequester? consentOverride,
  }) async {
    late final ResolvedModelRoute route;
    try {
      route = await resolveRouteWithConsent(
        taskKind: taskKind,
        payloadLength: prompt.length,
        previewSource: prompt,
        consentOverride: consentOverride,
      );
    } on CloudConsentRequiredException catch (e) {
      return Err(
        AuthFailure(e.request.reason, code: 'cloud_consent_required', cause: e),
      );
    }
    _lastResolvedEngineLabel = route.engineLabel;

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

    _lastResolvedEngineLabel = _labelFor(route.fallback!);
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
    late final ResolvedModelRoute route;
    try {
      route = await resolveRouteWithConsent(previewSource: prompt);
    } on CloudConsentRequiredException catch (e) {
      return Err(
        AuthFailure(e.request.reason, code: 'cloud_consent_required', cause: e),
      );
    }
    _lastResolvedEngineLabel = route.engineLabel;
    final primary = await route.primary.describeImage(
      imageBytes,
      prompt: prompt,
    );
    if (primary.isSuccess || route.fallback == null) {
      return primary;
    }
    _lastResolvedEngineLabel = _labelFor(route.fallback!);
    return await route.fallback!.describeImage(imageBytes, prompt: prompt);
  }

  static CloudConsentRequest _buildConsentRequest({
    required RoutingTaskKind taskKind,
    required String reason,
    required String previewSource,
  }) {
    final redacted = PiiRedactor.redact(previewSource).redactedText.trim();
    final clipped = redacted.length > 400
        ? '${redacted.substring(0, 400)}…'
        : redacted;
    return CloudConsentRequest(
      taskKind: taskKind,
      reason: reason,
      redactedPreview: clipped,
    );
  }
}
