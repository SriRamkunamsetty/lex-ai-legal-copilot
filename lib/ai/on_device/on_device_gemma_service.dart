import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_edge_ai/flutter_edge_ai.dart';
import 'package:flutter_edge_ai_litertlm/flutter_edge_ai_litertlm.dart';
import 'package:lex_copilot/ai/llm_service.dart';
import 'package:lex_copilot/ai/on_device/device_capability_service.dart';
import 'package:lex_copilot/ai/schemas/schema_validator.dart';
import 'package:lex_copilot/core/errors/failure.dart';
import 'package:lex_copilot/core/result.dart';

/// Preferred on-device Gemma 4 model tier.
enum Gemma4Tier {
  /// Gemma 4 Effective 2B (~2.59 GB, fits lower-RAM devices).
  e2b('gemma-4-e2b-it', 'Gemma 4 E2B', 2650),

  /// Gemma 4 Effective 4B (higher reasoning capacity, falls back to E2B on OOM).
  e4b('gemma-4-e4b-it', 'Gemma 4 E4B', 4900);

  new(this.catalogId, this.displayName, this.approxDownloadMb);

  /// Catalog model identifier in `flutter_edge_ai_litertlm`.
  final String catalogId;

  /// Human-readable name shown in UI badges.
  final String displayName;

  /// Approximate download size in MiB.
  final int approxDownloadMb;
}

/// Lifecycle state for the on-device Gemma 4 runtime.
enum OnDeviceModelStatus {
  /// No local `.litertlm` model has been downloaded yet.
  notInstalled,

  /// Model download + SHA-256 verification is in progress.
  downloading,

  /// Model download paused by user; resumable.
  paused,

  /// Downloaded and ready for offline inference.
  ready,

  /// Active with low-memory fallback (downgraded to E2B / CPU backend).
  lowMemoryFallback,

  /// Initialization or download error.
  error,
}

/// Result returned by [OnDeviceGemmaService.runLatencyBenchmark].
@immutable
class OnDeviceBenchmarkResult {
  /// Creates an [OnDeviceBenchmarkResult].
  const new({
    required this.tier,
    required this.latencyMs,
    required this.backendLabel,
    required this.outputChars,
  });

  /// Active tier tested.
  final Gemma4Tier tier;

  /// End-to-end warm inference latency in milliseconds.
  final int latencyMs;

  /// Reported execution backend (`gpu`, `cpu`, etc.).
  final String backendLabel;

  /// Output character count generated during self-test.
  final int outputChars;
}

/// Snapshot of on-device Gemma 4 availability, hardware compatibility, and
/// download progress.
@immutable
class OnDeviceModelState {
  /// Creates an [OnDeviceModelState].
  const new({
    required this.status,
    required this.tier,
    this.progress = 0,
    this.activeBackendLabel,
    this.errorMessage,
    this.installedVersion,
    this.updateAvailable = false,
    this.capabilityReport,
    this.lastBenchmark,
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

  /// Version identifier of the verified installed weights.
  final String? installedVersion;

  /// Whether a newer catalog manifest version is available.
  final bool updateAvailable;

  /// Latest evaluated device RAM, storage, and thermal compatibility report.
  final DeviceCapabilityReport? capabilityReport;

  /// Result of most recent offline latency self-test.
  final OnDeviceBenchmarkResult? lastBenchmark;

  /// Returns a modified copy.
  OnDeviceModelState copyWith({
    OnDeviceModelStatus? status,
    Gemma4Tier? tier,
    int? progress,
    String? activeBackendLabel,
    String? errorMessage,
    bool clearError = false,
    String? installedVersion,
    bool? updateAvailable,
    DeviceCapabilityReport? capabilityReport,
    OnDeviceBenchmarkResult? lastBenchmark,
  }) => OnDeviceModelState(
    status: status ?? this.status,
    tier: tier ?? this.tier,
    progress: progress ?? this.progress,
    activeBackendLabel: activeBackendLabel ?? this.activeBackendLabel,
    errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    installedVersion: installedVersion ?? this.installedVersion,
    updateAvailable: updateAvailable ?? this.updateAvailable,
    capabilityReport: capabilityReport ?? this.capabilityReport,
    lastBenchmark: lastBenchmark ?? this.lastBenchmark,
  );
}

/// Abstraction over the `flutter_edge_ai` + LiteRT-LM runtime so unit tests can
/// exercise download, checksum failure, OOM fallback, and streaming without
/// needing a 2.5 GB `.litertlm` file on disk.
abstract interface class EdgeAiRuntimeAdapter {
  /// Initializes the LiteRT-LM engine once.
  Future<void> initialize();

  /// Returns `true` if the exact model matching [catalogId] is installed.
  Future<bool> isInstalled(String catalogId);

  /// Downloads, verifies checksum, and activates [tier].
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

/// Optional extension implemented by runtimes supporting active download
/// cancellation/pause without breaking lightweight test fakes.
abstract interface class CancellableEdgeAiRuntimeAdapter
    implements EdgeAiRuntimeAdapter {
  /// Requests cancellation of the active model download.
  void cancelActiveInstall();
}

/// Production [EdgeAiRuntimeAdapter] backed by `flutter_edge_ai` and
/// `flutter_edge_ai_litertlm` (`LiteRtLmEngine` + `LiteRtLmModels.gemma4E2bIt` /
/// `gemma4E4bIt`).
class FlutterEdgeAiRuntimeAdapter implements CancellableEdgeAiRuntimeAdapter {
  bool _initialized = false;
  CancelToken? _activeCancelToken;

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
    final targetTier = Gemma4Tier.values
        .where((t) => t.catalogId.toLowerCase() == catalogId.toLowerCase())
        .firstOrNull;
    if (targetTier == null) {
      return installed.any((id) => id.toLowerCase() == catalogId.toLowerCase());
    }
    final variant = _pickVariant(targetTier);
    final filenames = variant.files
        .map((f) => f.installFilename.toLowerCase())
        .toSet();
    final tierMarker = targetTier == Gemma4Tier.e4b ? 'e4b' : 'e2b';
    return installed.any((entry) {
      final lower = entry.toLowerCase();
      return lower == catalogId.toLowerCase() ||
          filenames.any(lower.contains) ||
          (lower.contains('gemma') && lower.contains(tierMarker));
    });
  }

  @override
  Future<void> installTier(
    Gemma4Tier tier, {
    required void Function(int progress) onProgress,
    String? huggingFaceToken,
  }) async {
    await initialize();
    final variant = _pickVariant(tier);
    final cancelToken = CancelToken();
    _activeCancelToken = cancelToken;
    try {
      await FlutterEdgeAi.installModelFromCatalog(
        variant,
        token: huggingFaceToken,
        foreground: true,
      ).withCancelToken(cancelToken).withProgress(onProgress).install();
    } finally {
      if (identical(_activeCancelToken, cancelToken)) {
        _activeCancelToken = null;
      }
    }
  }

  @override
  void cancelActiveInstall() {
    _activeCancelToken?.cancel('Paused by user');
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
/// LiteRT-LM (`flutter_edge_ai_litertlm`) and [DeviceCapabilityService].
class OnDeviceGemmaService implements LlmService {
  /// Creates an [OnDeviceGemmaService].
  new({
    EdgeAiRuntimeAdapter? runtime,
    DeviceCapabilityService? capabilityService,
    Gemma4Tier preferredTier = Gemma4Tier.e2b,
    String currentManifestVersion = '2026.05.01',
  }) : _runtime = runtime ?? FlutterEdgeAiRuntimeAdapter(),
       _capabilityService =
           capabilityService ?? const DeviceCapabilityService(),
       _manifestVersion = currentManifestVersion,
       _state = ValueNotifier(
         OnDeviceModelState(
           status: OnDeviceModelStatus.notInstalled,
           tier: preferredTier,
         ),
       );

  final EdgeAiRuntimeAdapter _runtime;
  final DeviceCapabilityService _capabilityService;
  final String _manifestVersion;
  final ValueNotifier<OnDeviceModelState> _state;

  bool _pauseRequested = false;

  /// Observable lifecycle, hardware report, and download progress state.
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

  /// Evaluates RAM, free storage, and thermal status cleanly.
  Future<DeviceCapabilityReport> evaluateCapability() async {
    final report = await _capabilityService.evaluate();
    _state.value = _state.value.copyWith(capabilityReport: report);
    return report;
  }

  /// Selects desired [tier] and refreshes availability without wiping other files.
  Future<Result<bool>> selectTier(Gemma4Tier tier) {
    _state.value = _state.value.copyWith(tier: tier, clearError: true);
    return refreshAvailability();
  }

  /// Checks whether the currently selected Gemma 4 tier is installed locally.
  Future<Result<bool>> refreshAvailability() => Result.guard(
    () async {
      final report = await _capabilityService.evaluate();
      final ready = await _runtime.isInstalled(_state.value.tier.catalogId);
      _state.value = _state.value.copyWith(
        status: ready
            ? OnDeviceModelStatus.ready
            : OnDeviceModelStatus.notInstalled,
        capabilityReport: report,
        installedVersion: ready ? _manifestVersion : null,
      );
      return ready;
    },
    onError: (error, _) =>
        AiFailure('Unable to check on-device Gemma 4 status.', cause: error),
  );

  /// Compares installed weights version against [latestCatalogVersion].
  bool checkForUpdate(String latestCatalogVersion) {
    final installed = _state.value.installedVersion;
    final hasUpdate =
        installed != null && installed.trim() != latestCatalogVersion.trim();
    _state.value = _state.value.copyWith(updateAvailable: hasUpdate);
    return hasUpdate;
  }

  /// Pauses an active download cleanly so the user can resume later.
  void pauseDownload() {
    if (_state.value.status != OnDeviceModelStatus.downloading) return;
    _pauseRequested = true;
    final rt = _runtime;
    if (rt is CancellableEdgeAiRuntimeAdapter) {
      rt.cancelActiveInstall();
    }
    _state.value = _state.value.copyWith(status: OnDeviceModelStatus.paused);
  }

  /// Resumes a paused download from the active tier.
  Future<Result<void>> resumeDownload({String? huggingFaceToken}) {
    return downloadModel(huggingFaceToken: huggingFaceToken);
  }

  /// Downloads and verifies Gemma 4 (`E4B` with hardware-safe fallback to `E2B`)
  /// while enforcing RAM & free-storage guards.
  Future<Result<void>> downloadModel({String? huggingFaceToken}) async {
    _pauseRequested = false;
    final report = await evaluateCapability();
    if (!report.canInstallE2b) {
      _state.value = _state.value.copyWith(
        status: OnDeviceModelStatus.error,
        errorMessage: report.advisoryReason,
      );
      return Err(StorageFailure(report.advisoryReason));
    }

    var tier = _state.value.tier;
    var downgradedPreFlight = false;
    if (tier == Gemma4Tier.e4b &&
        report.totalRamMb > 0 &&
        !report.canInstallE4b) {
      tier = Gemma4Tier.e2b;
      downgradedPreFlight = true;
    }

    _state.value = _state.value.copyWith(
      status: OnDeviceModelStatus.downloading,
      tier: tier,
      progress: _state.value.status == OnDeviceModelStatus.paused
          ? _state.value.progress
          : 0,
      clearError: true,
    );

    try {
      await _runtime.installTier(
        tier,
        huggingFaceToken: huggingFaceToken,
        onProgress: (p) {
          if (_pauseRequested) return;
          _state.value = _state.value.copyWith(
            status: OnDeviceModelStatus.downloading,
            progress: p.clamp(0, 100),
          );
        },
      );
      if (_pauseRequested) {
        _state.value = _state.value.copyWith(
          status: OnDeviceModelStatus.paused,
        );
        return const Success(null);
      }
      _state.value = _state.value.copyWith(
        status: downgradedPreFlight
            ? OnDeviceModelStatus.lowMemoryFallback
            : OnDeviceModelStatus.ready,
        tier: tier,
        progress: 100,
        installedVersion: _manifestVersion,
        updateAvailable: false,
      );
      return const Success(null);
    } on Object catch (error) {
      if (_pauseRequested) {
        _state.value = _state.value.copyWith(
          status: OnDeviceModelStatus.paused,
        );
        return const Success(null);
      }
      // Low-memory / device constraint fallback: retry with smaller E2B tier.
      if (tier == Gemma4Tier.e4b) {
        tier = Gemma4Tier.e2b;
        try {
          await _runtime.installTier(
            tier,
            huggingFaceToken: huggingFaceToken,
            onProgress: (p) {
              if (_pauseRequested) return;
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
            installedVersion: _manifestVersion,
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
        updateAvailable: false,
        clearError: true,
      );
    },
    onError: (error, _) =>
        StorageFailure('Failed to remove on-device model.', cause: error),
  );

  /// Runs a minimal local inference probe to verify active runtime responsiveness
  /// and measure latency in milliseconds.
  Future<Result<OnDeviceBenchmarkResult>> runLatencyBenchmark() => Result.guard(
    () async {
      final sw = Stopwatch()..start();
      final out = await chat(
        const [
          LlmMessage(
            role: LlmRole.user,
            content:
                'Reply in one short sentence: what does Article 21 protect?',
          ),
        ],
        options: const LlmGenerationOptions(
          temperature: 0,
          maxOutputTokens: 48,
        ),
      ).join();
      sw.stop();
      final result = OnDeviceBenchmarkResult(
        tier: _state.value.tier,
        latencyMs: sw.elapsedMilliseconds,
        backendLabel: _state.value.activeBackendLabel ?? 'gpu',
        outputChars: out.length,
      );
      _state.value = _state.value.copyWith(lastBenchmark: result);
      return result;
    },
    onError: (error, _) =>
        AiFailure('On-device latency benchmark failed.', cause: error),
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
