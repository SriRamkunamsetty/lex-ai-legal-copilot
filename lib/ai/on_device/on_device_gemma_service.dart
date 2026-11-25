import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_edge_ai/flutter_edge_ai.dart';
import 'package:flutter_edge_ai_litertlm/flutter_edge_ai_litertlm.dart';
import 'package:lex_copilot/ai/llm_service.dart';
import 'package:lex_copilot/ai/schemas/schema_validator.dart';
import 'package:lex_copilot/core/errors/failure.dart';
import 'package:lex_copilot/core/result.dart';

/// Preferred on-device Gemma 4 model tier.
enum Gemma4Tier {
  /// Gemma 4 Effective 2B (~2.59 GB, fits lower-RAM devices).
  e2b('gemma-4-e2b-it', 'Gemma 4 E2B'),

  /// Gemma 4 Effective 4B (higher reasoning capacity, falls back to E2B on OOM).
  e4b('gemma-4-e4b-it', 'Gemma 4 E4B');

  new(this.catalogId, this.displayName);

  /// Catalog model identifier in `flutter_edge_ai_litertlm`.
  final String catalogId;

  /// Human-readable name shown in UI badges.
  final String displayName;
}

/// Lifecycle state for the on-device Gemma 4 runtime.
enum OnDeviceModelStatus {
  /// No local `.litertlm` model has been downloaded yet.
  notInstalled,

  /// Model download + SHA-256 verification is in progress.
  downloading,

  /// Downloaded and ready for offline inference.
  ready,

  /// Active with low-memory fallback (downgraded to E2B / CPU backend).
  lowMemoryFallback,

  /// Initialization or download error.
  error,
}

/// Snapshot of on-device Gemma 4 availability and download progress.
@immutable
class OnDeviceModelState {
  /// Creates an [OnDeviceModelState].
  const new({
    required this.status,
    required this.tier,
    this.progress = 0,
    this.activeBackendLabel,
    this.errorMessage,
  });

  /// Current lifecycle state.
  final OnDeviceModelStatus status;

  /// Configured or fallback Gemma 4 tier.
  final Gemma4Tier tier;

  /// Download percentage `[0..100]`.
  final int progress;

  /// Actual hardware backend (`gpu`, `cpu`, `npu`) once loaded.
  final String? activeBackendLabel;

  /// Non-PII error message when [status] is [OnDeviceModelStatus.error].
  final String? errorMessage;

  /// Returns a modified copy.
  OnDeviceModelState copyWith({
    OnDeviceModelStatus? status,
    Gemma4Tier? tier,
    int? progress,
    String? activeBackendLabel,
    String? errorMessage,
  }) => OnDeviceModelState(
    status: status ?? this.status,
    tier: tier ?? this.tier,
    progress: progress ?? this.progress,
    activeBackendLabel: activeBackendLabel ?? this.activeBackendLabel,
    errorMessage: errorMessage ?? this.errorMessage,
  );
}

/// Abstraction over the `flutter_edge_ai` + LiteRT-LM runtime so unit tests can
/// exercise download, checksum failure, OOM fallback, and streaming without
/// needing a 2.5 GB `.litertlm` file on disk.
abstract interface class EdgeAiRuntimeAdapter {
  /// Initializes the LiteRT-LM engine once.
  Future<void> initialize();

  /// Returns `true` if a model matching [catalogId] is already installed.
  Future<bool> isInstalled(String catalogId);

  /// Downloads, verifies SHA-256 checksum, and activates [tier].
  Future<void> installTier(
    Gemma4Tier tier, {
    required void Function(int progress) onProgress,
    String? huggingFaceToken,
  });

  /// Deletes installed on-device model weights to reclaim storage.
  Future<void> uninstall(Gemma4Tier tier);

  /// Streams response tokens from the active on-device model.
  Stream<String> generateStream({
    required List<LlmMessage> messages,
    required LlmGenerationOptions options,
    required PreferredBackend? preferredBackend,
  });
}

/// Production [EdgeAiRuntimeAdapter] backed by `flutter_edge_ai` and
/// `flutter_edge_ai_litertlm` (`LiteRtLmEngine` + `LiteRtLmModels.gemma4E2bIt` /
/// `gemma4E4bIt`).
class FlutterEdgeAiRuntimeAdapter implements EdgeAiRuntimeAdapter {
  bool _initialized = false;

  @override
  Future<void> initialize() async {
    if (_initialized) return;
    await FlutterEdgeAi.initialize(inferenceEngines: const [LiteRtLmEngine()]);
    _initialized = true;
  }

  InferenceVariant _pickVariant(Gemma4Tier tier) {
    final model = FlutterEdgeAi.catalog.byId(tier.catalogId);
    if (model == null) {
      throw StateError('Catalog model ${tier.catalogId} is not registered.');
    }
    final variant =
        model.variantFor(backend: PreferredBackend.gpu) ??
        model.variantFor(backend: PreferredBackend.cpu);
    if (variant is! InferenceVariant) {
      throw StateError('No runnable variant for ${tier.catalogId}.');
    }
    return variant;
  }

  @override
  Future<bool> isInstalled(String catalogId) async {
    await initialize();
    if (!FlutterEdgeAi.hasActiveModel()) return false;
    final installed = await FlutterEdgeAi.listInstalledModels();
    return installed.any((id) => id.toLowerCase().contains('gemma-4'));
  }

  @override
  Future<void> installTier(
    Gemma4Tier tier, {
    required void Function(int progress) onProgress,
    String? huggingFaceToken,
  }) async {
    await initialize();
    final variant = _pickVariant(tier);
    await FlutterEdgeAi.installModelFromCatalog(
      variant,
      token: huggingFaceToken,
      foreground: true,
    ).withProgress(onProgress).install();
  }

  @override
  Future<void> uninstall(Gemma4Tier tier) async {
    await initialize();
    final variant = _pickVariant(tier);
    if (variant.files.isNotEmpty) {
      await FlutterEdgeAi.uninstallModel(variant.files.first.installFilename);
    }
  }

  @override
  Stream<String> generateStream({
    required List<LlmMessage> messages,
    required LlmGenerationOptions options,
    required PreferredBackend? preferredBackend,
  }) async* {
    await initialize();
    final hasImages = messages.any((m) => m.images.isNotEmpty);
    final model = await FlutterEdgeAi.getActiveModel(
      maxTokens: 2048,
      preferredBackend: preferredBackend,
      supportImage: hasImages,
    );
    final session = await model.openSession(
      temperature: options.temperature,
      maxOutputTokens: options.maxOutputTokens,
      systemInstruction: options.systemInstruction,
      enableVisionModality: hasImages ? true : null,
    );
    try {
      final promptText = messages
          .map((m) => '${m.role.name.toUpperCase()}: ${m.content}')
          .join('\n\n');
      final allImages = messages.expand((m) => m.images).toList();
      final queryMsg = allImages.isEmpty
          ? Message.text(text: promptText, isUser: true)
          : Message.withImages(
              text: promptText,
              imageBytes: allImages,
              isUser: true,
            );
      await session.addQueryChunk(queryMsg);
      yield* session.getResponseAsync();
    } finally {
      await session.close();
    }
  }
}

/// On-device multimodal Gemma 4 implementation of [LlmService] powered by
/// LiteRT-LM (`flutter_edge_ai_litertlm`).
class OnDeviceGemmaService implements LlmService {
  /// Creates an [OnDeviceGemmaService].
  new({
    EdgeAiRuntimeAdapter? runtime,
    Gemma4Tier preferredTier = Gemma4Tier.e2b,
  }) : _runtime = runtime ?? FlutterEdgeAiRuntimeAdapter(),
       _state = ValueNotifier(
         OnDeviceModelState(
           status: OnDeviceModelStatus.notInstalled,
           tier: preferredTier,
         ),
       );

  final EdgeAiRuntimeAdapter _runtime;
  final ValueNotifier<OnDeviceModelState> _state;

  /// Observable lifecycle & download progress state for UI surfaces.
  ValueListenable<OnDeviceModelState> get stateListenable => _state;

  /// Current lifecycle snapshot.
  OnDeviceModelState get currentState => _state.value;

  @override
  String get modelId => _state.value.tier.catalogId;

  @override
  bool get supportsImages => true;

  @override
  bool get supportsAudio => true;

  @override
  bool get isOnDevice => true;

  /// Checks whether a Gemma 4 `.litertlm` model is already installed locally.
  Future<Result<bool>> refreshAvailability() => Result.guard(
    () async {
      final ready = await _runtime.isInstalled(_state.value.tier.catalogId);
      _state.value = _state.value.copyWith(
        status: ready
            ? OnDeviceModelStatus.ready
            : OnDeviceModelStatus.notInstalled,
      );
      return ready;
    },
    onError: (error, _) =>
        AiFailure('Unable to check on-device Gemma 4 status.', cause: error),
  );

  /// Downloads and checksum-verifies Gemma 4 (`E4B` with low-memory fallback to
  /// `E2B`) while updating [stateListenable].
  Future<Result<void>> downloadModel({String? huggingFaceToken}) async {
    var tier = _state.value.tier;
    _state.value = _state.value.copyWith(
      status: OnDeviceModelStatus.downloading,
      progress: 0,
    );

    try {
      await _runtime.installTier(
        tier,
        huggingFaceToken: huggingFaceToken,
        onProgress: (p) {
          _state.value = _state.value.copyWith(
            status: OnDeviceModelStatus.downloading,
            progress: p.clamp(0, 100),
          );
        },
      );
      _state.value = _state.value.copyWith(
        status: OnDeviceModelStatus.ready,
        tier: tier,
        progress: 100,
      );
      return const Success(null);
    } on Object catch (error) {
      // Low-memory / device constraint fallback: retry with smaller E2B tier.
      if (tier == Gemma4Tier.e4b) {
        tier = Gemma4Tier.e2b;
        try {
          await _runtime.installTier(
            tier,
            huggingFaceToken: huggingFaceToken,
            onProgress: (p) {
              _state.value = _state.value.copyWith(
                status: OnDeviceModelStatus.downloading,
                tier: tier,
                progress: p.clamp(0, 100),
              );
            },
          );
          _state.value = _state.value.copyWith(
            status: OnDeviceModelStatus.lowMemoryFallback,
            tier: tier,
            progress: 100,
            activeBackendLabel: 'cpu-fallback',
          );
          return const Success(null);
        } on Object catch (fallbackError) {
          _state.value = _state.value.copyWith(
            status: OnDeviceModelStatus.error,
            errorMessage: fallbackError.toString(),
          );
          return Err(
            AiFailure(
              'On-device Gemma 4 download failed on both E4B and E2B.',
              cause: fallbackError,
            ),
          );
        }
      }
      _state.value = _state.value.copyWith(
        status: OnDeviceModelStatus.error,
        errorMessage: error.toString(),
      );
      return Err(AiFailure('On-device Gemma 4 download failed.', cause: error));
    }
  }

  /// Removes installed model weights from device storage.
  Future<Result<void>> deleteModel() => Result.guard(
    () async {
      await _runtime.uninstall(_state.value.tier);
      _state.value = _state.value.copyWith(
        status: OnDeviceModelStatus.notInstalled,
        progress: 0,
      );
    },
    onError: (error, _) =>
        StorageFailure('Failed to remove on-device model.', cause: error),
  );

  @override
  Stream<String> chat(
    List<LlmMessage> messages, {
    LlmGenerationOptions options = const LlmGenerationOptions(),
  }) async* {
    var emittedAny = false;
    try {
      await for (final chunk in _runtime.generateStream(
        messages: messages,
        options: options,
        preferredBackend: PreferredBackend.gpu,
      )) {
        emittedAny = true;
        yield chunk;
      }
      return;
    } on Object {
      if (emittedAny) rethrow;
      // Low-memory / GPU init fallback -> retry on CPU backend.
      _state.value = _state.value.copyWith(
        status: OnDeviceModelStatus.lowMemoryFallback,
        activeBackendLabel: 'cpu',
      );
      yield* _runtime.generateStream(
        messages: messages,
        options: options,
        preferredBackend: PreferredBackend.cpu,
      );
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
      final raw1 = await chat([
        LlmMessage(role: LlmRole.user, content: prompt, images: images),
      ], options: options).join();

      final parsed1 = SchemaValidator.parseAndValidate(raw1, schema.jsonSchema);
      if (parsed1 case Success(:final value)) {
        return schema.fromJson(value);
      }

      // Retry once on invalid JSON with explicit repair hint.
      final repairPrompt =
          'Your previous response was invalid JSON (${parsed1.failureOrNull?.message}). '
          'Return ONLY a valid JSON object matching schema ${schema.name}: '
          '${jsonEncode(schema.jsonSchema)}.\n\nOriginal request:\n$prompt';
      final raw2 = await chat([
        LlmMessage(role: LlmRole.user, content: repairPrompt, images: images),
      ], options: options).join();

      final parsed2 = SchemaValidator.parseAndValidate(raw2, schema.jsonSchema);
      return await parsed2.fold(
        onSuccess: schema.fromJson,
        onFailure: (failure) => throw StateError(failure.message),
      );
    },
    onError: (error, _) => AiFailure(
      'On-device structured generation failed: $error',
      cause: error,
    ),
  );

  @override
  Future<Result<String>> describeImage(
    Uint8List imageBytes, {
    required String prompt,
  }) => Result.guard(
    () => chat([
      LlmMessage(role: LlmRole.user, content: prompt, images: [imageBytes]),
    ]).join(),
    onError: (error, _) =>
        AiFailure('On-device image analysis failed.', cause: error),
  );
}
