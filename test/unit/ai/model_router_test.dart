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
  bool installed = true;

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
    test(
      'never silently uploads to cloud in Auto mode without explicit consent',
      () async {
        final adapter = _StubAdapter();
        final onDevice = OnDeviceGemmaService(runtime: adapter);
        await onDevice.refreshAvailability();

        final cloud = CloudGemmaService(
          LexHttpClient(
            flavorConfig: FlavorConfig.forFlavor(LexFlavor.dev),
            dioOverride: Dio(BaseOptions(baseUrl: 'http://127.0.0.1:1')),
          ),
        );

        var settings = const LexSettings();
        var online = false;
        var consentGranted = false;

        final router = ModelRouter(
          onDevice: onDevice,
          cloud: cloud,
          readSettings: () => settings,
          isOnline: () async => online,
          requestCloudConsent: (_) async => consentGranted,
        );

        // 1. Default onDevice stays local with no fallback.
        final onDeviceRoute = await router.resolveRoute(
          taskKind: RoutingTaskKind.deepResearch,
        );
        expect(onDeviceRoute.primary.isOnDevice, isTrue);
        expect(onDeviceRoute.fallback, isNull);

        // 2. Cloud requested while offline + on-device ready -> falls back to on-device.
        settings = const LexSettings(modelRouting: LexModelRouting.cloud);
        final offlineCloudRoute = await router.resolveRoute();
        expect(offlineCloudRoute.primary.isOnDevice, isTrue);

        // 3. Auto + online + shortPrivate stays local with NO silent cloud fallback.
        online = true;
        settings = const LexSettings(modelRouting: LexModelRouting.auto);
        final autoShortRoute = await router.resolveRoute();
        expect(autoShortRoute.primary.isOnDevice, isTrue);
        expect(autoShortRoute.fallback, isNull);

        // 4. Auto + online + deepResearch with consent DENIED keeps on-device.
        consentGranted = false;
        final declinedRoute = await router.resolveRoute(
          taskKind: RoutingTaskKind.deepResearch,
        );
        expect(declinedRoute.primary.isOnDevice, isTrue);
        expect(declinedRoute.fallback, isNull);

        // 5. Auto + online + deepResearch with consent APPROVED selects cloud + on-device fallback.
        consentGranted = true;
        final approvedRoute = await router.resolveRoute(
          taskKind: RoutingTaskKind.deepResearch,
        );
        expect(approvedRoute.primary.isOnDevice, isFalse);
        expect(approvedRoute.fallback?.isOnDevice, isTrue);

        // If cloud fails on unreachable port, chat degrades gracefully to on-device.
        final reply = await router.chat(const [
          LlmMessage(role: LlmRole.user, content: 'Explain BNS 304'),
        ], taskKind: RoutingTaskKind.deepResearch).join();
        expect(reply, 'on-device-reply');

        // 6. Auto + on-device NOT installed + consent denied throws CloudConsentRequiredException.
        adapter.installed = false;
        await onDevice.refreshAvailability();
        consentGranted = false;
        expect(
          router.resolveRoute,
          throwsA(isA<CloudConsentRequiredException>()),
        );
      },
    );
  });
}
