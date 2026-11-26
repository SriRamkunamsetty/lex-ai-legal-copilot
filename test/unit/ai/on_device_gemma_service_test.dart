import 'package:flutter_edge_ai/flutter_edge_ai.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lex_copilot/ai/llm_service.dart';
import 'package:lex_copilot/ai/on_device/device_capability_service.dart';
import 'package:lex_copilot/ai/on_device/on_device_gemma_service.dart';

class _TestMetricsReader implements DeviceMetricsReader {
  const new({this.freeMb = 12000});

  final int freeMb;

  @override
  Future<RawDeviceMetrics> readMetrics() async => RawDeviceMetrics(
    totalRamMb: 8192,
    freeStorageMb: freeMb,
    osLabel: 'test-os',
  );
}

class _FakeEdgeAiAdapter implements EdgeAiRuntimeAdapter {
  bool installed = false;
  bool failE4bInstall = false;
  bool failGpuInference = false;
  int structuredCalls = 0;
  final List<PreferredBackend?> backendsAttempted = [];

  @override
  Future<void> initialize() async {}

  @override
  Future<bool> isInstalled(String catalogId) async => installed;

  @override
  Future<void> installTier(
    Gemma4Tier tier, {
    required void Function(int progress) onProgress,
    String? huggingFaceToken,
  }) async {
    if (failE4bInstall && tier == Gemma4Tier.e4b) {
      throw StateError('Insufficient memory for E4B');
    }
    onProgress(50);
    onProgress(100);
    installed = true;
  }

  @override
  Future<void> uninstall(Gemma4Tier tier) async {
    installed = false;
  }

  @override
  Stream<String> generateStream({
    required List<LlmMessage> messages,
    required LlmGenerationOptions options,
    required PreferredBackend? preferredBackend,
  }) async* {
    backendsAttempted.add(preferredBackend);
    if (failGpuInference && preferredBackend == PreferredBackend.gpu) {
      throw StateError('GPU delegate failed');
    }
    structuredCalls += 1;
    if (structuredCalls == 1 &&
        messages.first.content.contains('TRIGGER_RETRY')) {
      yield 'not valid json';
      return;
    }
    yield '{"ok": true, "answer": "verified"}';
  }
}

void main() {
  group('OnDeviceGemmaService', () {
    test('falls back from E4B to E2B when E4B install fails', () async {
      final adapter = _FakeEdgeAiAdapter()..failE4bInstall = true;
      final service = OnDeviceGemmaService(
        runtime: adapter,
        capabilityService: const DeviceCapabilityService(
          metricsReader: _TestMetricsReader(),
        ),
        preferredTier: Gemma4Tier.e4b,
      );

      final result = await service.downloadModel();
      expect(result.isSuccess, isTrue);
      expect(
        service.currentState.status,
        OnDeviceModelStatus.lowMemoryFallback,
      );
      expect(service.currentState.tier, Gemma4Tier.e2b);
      expect(service.checkForUpdate('2026.06.01'), isTrue);
    });

    test(
      'blocks download on insufficient free storage and runs offline benchmark',
      () async {
        final adapter = _FakeEdgeAiAdapter();
        final lowDisk = OnDeviceGemmaService(
          runtime: adapter,
          capabilityService: const DeviceCapabilityService(
            metricsReader: _TestMetricsReader(freeMb: 500),
          ),
        );
        final denied = await lowDisk.downloadModel();
        expect(denied.isErr, isTrue);

        final healthy = OnDeviceGemmaService(
          runtime: adapter,
          capabilityService: const DeviceCapabilityService(
            metricsReader: _TestMetricsReader(),
          ),
        );
        final bench = await healthy.runLatencyBenchmark();
        expect(bench.isSuccess, isTrue);
        expect(bench.valueOrNull!.outputChars, greaterThan(0));
      },
    );

    test('falls back to CPU when GPU inference fails and retries invalid JSON once', () async {
      final adapter = _FakeEdgeAiAdapter()..failGpuInference = true;
      final service = OnDeviceGemmaService(runtime: adapter);

      const schema = LlmSchema<Map<String, dynamic>>(
        name: 'test',
        jsonSchema: {
          'type': 'object',
          'required': ['ok'],
        },
        fromJson: _identity,
      );

      final result = await service.structured(schema, 'TRIGGER_RETRY');
      expect(result.isSuccess, isTrue);
      expect(result.valueOrNull?['ok'], isTrue);
      expect(adapter.backendsAttempted, contains(PreferredBackend.cpu));
      expect(adapter.structuredCalls, 2);
    });
  });
}

Map<String, dynamic> _identity(Map<String, dynamic> m) => m;
