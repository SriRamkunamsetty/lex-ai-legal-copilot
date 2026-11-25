import 'package:dio/dio.dart';
import 'package:flutter_edge_ai/flutter_edge_ai.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lex_copilot/ai/cloud/cloud_gemma_service.dart';
import 'package:lex_copilot/ai/llm_service.dart';
import 'package:lex_copilot/ai/on_device/on_device_gemma_service.dart';
import 'package:lex_copilot/ai/router/model_router.dart';
import 'package:lex_copilot/app/flavors.dart';
import 'package:lex_copilot/core/network/lex_http_client.dart';
import 'package:lex_copilot/features/settings/domain/lex_settings.dart';

class _StubAdapter implements EdgeAiRuntimeAdapter {
  new();
  final bool installed = true;

  @override
  Future<void> initialize() async {}

  @override
  Future<bool> isInstalled(String catalogId) async => installed;

  @override
  Future<void> installTier(
    Gemma4Tier tier, {
    required void Function(int progress) onProgress,
    String? huggingFaceToken,
  }) async {}

  @override
  Future<void> uninstall(Gemma4Tier tier) async {}

  @override
  Stream<String> generateStream({
    required List<LlmMessage> messages,
    required LlmGenerationOptions options,
    required PreferredBackend? preferredBackend,
  }) async* {
    yield 'on-device-reply';
  }
}

void main() {
  group('ModelRouter', () {
    test('honours onDevice routing and falls back to on-device when cloud is offline', () async {
      final onDevice = OnDeviceGemmaService(runtime: _StubAdapter());
      await onDevice.refreshAvailability();

      final cloud = CloudGemmaService(
        LexHttpClient(
          flavorConfig: FlavorConfig.forFlavor(LexFlavor.dev),
          dioOverride: Dio(BaseOptions(baseUrl: 'http://127.0.0.1:1')),
        ),
      );

      var settings = const LexSettings();
      var online = false;

      final router = ModelRouter(
        onDevice: onDevice,
        cloud: cloud,
        readSettings: () => settings,
        isOnline: () async => online,
      );

      final onDeviceRoute = await router.resolveRoute(
        taskKind: RoutingTaskKind.deepResearch,
      );
      expect(onDeviceRoute.primary.isOnDevice, isTrue);

      // Cloud requested while offline + on-device ready -> falls back to on-device
      settings = const LexSettings(modelRouting: LexModelRouting.cloud);
      final offlineCloudRoute = await router.resolveRoute();
      expect(offlineCloudRoute.primary.isOnDevice, isTrue);

      // Auto + online + deepResearch -> selects cloud primary with on-device fallback
      online = true;
      settings = const LexSettings(modelRouting: LexModelRouting.auto);
      final autoDeepRoute = await router.resolveRoute(
        taskKind: RoutingTaskKind.deepResearch,
      );
      expect(autoDeepRoute.primary.isOnDevice, isFalse);
      expect(autoDeepRoute.fallback?.isOnDevice, isTrue);

      // If cloud fails on unreachable port, chat degrades gracefully to on-device
      final reply = await router.chat(const [
        LlmMessage(role: LlmRole.user, content: 'Explain BNS 304'),
      ], taskKind: RoutingTaskKind.deepResearch).join();
      expect(reply, 'on-device-reply');
    });
  });
}
