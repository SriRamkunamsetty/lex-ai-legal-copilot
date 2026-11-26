import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:lex_copilot/ai/cloud/cloud_gemma_service.dart';
import 'package:lex_copilot/ai/on_device/device_capability_service.dart';
import 'package:lex_copilot/ai/on_device/on_device_gemma_service.dart';
import 'package:lex_copilot/ai/pipelines/contract_pipeline.dart';
import 'package:lex_copilot/ai/pipelines/document_pipeline.dart';
import 'package:lex_copilot/ai/pipelines/draft_pipeline.dart';
import 'package:lex_copilot/ai/pipelines/incident_pipeline.dart';
import 'package:lex_copilot/ai/pipelines/research_pipeline.dart';
import 'package:lex_copilot/ai/prompts/prompt_registry.dart';
import 'package:lex_copilot/ai/rag/local_rag_engine.dart';
import 'package:lex_copilot/ai/router/model_router.dart';
import 'package:lex_copilot/app/app.dart';
import 'package:lex_copilot/core/network/lex_http_client.dart';
import 'package:lex_copilot/core/security/device_auth_service.dart';
import 'package:lex_copilot/core/security/secure_key_store.dart';
import 'package:lex_copilot/features/scan/data/document_scanner_service.dart';
import 'package:lex_copilot/features/settings/presentation/settings_controller.dart';
import 'package:lex_copilot/legal_corpus/providers/corpus_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ai_providers.g.dart';

const String _rawPinnedCertSha256 = String.fromEnvironment(
  'LEX_PINNED_CERT_SHA256',
);

/// Provides the versioned [PromptRegistry].
@Riverpod(keepAlive: true)
PromptRegistry promptRegistry(Ref ref) => PromptRegistry();

/// Provides the device bearer-token manager calling `/v1/auth/device-token`.
@Riverpod(keepAlive: true)
DeviceAuthService deviceAuthService(Ref ref) {
  final flavor = ref.watch(flavorConfigProvider);
  return DeviceAuthService(
    flavorConfig: flavor,
    secretStore: SecureStorageSecretStore(),
  );
}

/// Provides the [LexHttpClient] configured with device auth & cert pinning.
@Riverpod(keepAlive: true)
LexHttpClient lexHttpClient(Ref ref) {
  final flavor = ref.watch(flavorConfigProvider);
  final deviceAuth = ref.watch(deviceAuthServiceProvider);
  final pins = _rawPinnedCertSha256
      .split(',')
      .map((e) => e.trim())
      .where((e) => e.isNotEmpty)
      .toList();

  return LexHttpClient(
    flavorConfig: flavor,
    tokenProvider: deviceAuth.getToken,
    onTokenRejected: deviceAuth.invalidateCachedToken,
    pinnedCertSha256List: pins,
  );
}

/// Evaluates device RAM, storage, and thermal limits for Gemma 4 tiers.
@Riverpod(keepAlive: true)
DeviceCapabilityService deviceCapabilityService(Ref ref) {
  return const DeviceCapabilityService();
}

/// Provides the on-device Gemma 4 service.
@Riverpod(keepAlive: true)
OnDeviceGemmaService onDeviceGemmaService(Ref ref) {
  return OnDeviceGemmaService(
    capabilityService: ref.watch(deviceCapabilityServiceProvider),
  );
}

/// Provides the cloud Gemma 4 proxy service.
@Riverpod(keepAlive: true)
CloudGemmaService cloudGemmaService(Ref ref) {
  return CloudGemmaService(ref.watch(lexHttpClientProvider));
}

/// Provides the [ModelRouter] coordinating on-device and cloud inference with
/// live connectivity checks and explicit cloud consent rules.
@Riverpod(keepAlive: true)
ModelRouter modelRouter(Ref ref) {
  final connectivity = Connectivity();
  return ModelRouter(
    onDevice: ref.watch(onDeviceGemmaServiceProvider),
    cloud: ref.watch(cloudGemmaServiceProvider),
    readSettings: () => ref.read(settingsControllerProvider),
    isOnline: () async {
      try {
        final results = await connectivity.checkConnectivity();
        return results.any((r) => r != ConnectivityResult.none);
      } on Object {
        return false;
      }
    },
  );
}

/// Provides the document scanner / camera / gallery capture service.
@Riverpod(keepAlive: true)
DocumentCaptureService documentCaptureService(Ref ref) {
  return MlKitDocumentCaptureService();
}

/// Provides the on-device ML Kit OCR engine.
@Riverpod(keepAlive: true)
OcrEngine ocrEngine(Ref ref) => const MlKitOcrEngine();

/// Provides the multi-page OCR + LLM [DocumentPipeline].
@Riverpod(keepAlive: true)
DocumentPipeline documentPipeline(Ref ref) {
  return DocumentPipeline(
    ocrEngine: ref.watch(ocrEngineProvider),
    llm: ref.watch(modelRouterProvider),
    prompts: ref.watch(promptRegistryProvider),
  );
}

/// Provides the offline [LocalRagEngine] combining FTS5 BM25, semantic vectors
/// via RRF, chunking, and 1-hop Knowledge Graph expansion.
@Riverpod(keepAlive: true)
LocalRagEngine localRagEngine(Ref ref) {
  return LocalRagEngine(
    db: ref.watch(appDatabaseProvider),
    corpus: ref.watch(legalCorpusRepositoryProvider),
  );
}

/// Provides the RAG + citation-verifier [ResearchPipeline].
@Riverpod(keepAlive: true)
ResearchPipeline researchPipeline(Ref ref) {
  return ResearchPipeline(
    corpus: ref.watch(legalCorpusRepositoryProvider),
    llm: ref.watch(modelRouterProvider),
    prompts: ref.watch(promptRegistryProvider),
    ragEngine: ref.watch(localRagEngineProvider),
  );
}

/// Provides the grounded [IncidentPipeline].
@Riverpod(keepAlive: true)
IncidentPipeline incidentPipeline(Ref ref) {
  return IncidentPipeline(
    corpus: ref.watch(legalCorpusRepositoryProvider),
    llm: ref.watch(modelRouterProvider),
    prompts: ref.watch(promptRegistryProvider),
  );
}

/// Provides the clause risk & redline [ContractPipeline].
@Riverpod(keepAlive: true)
ContractPipeline contractPipeline(Ref ref) {
  return ContractPipeline(
    llm: ref.watch(modelRouterProvider),
    prompts: ref.watch(promptRegistryProvider),
  );
}

/// Provides the template-based [DraftPipeline].
@Riverpod(keepAlive: true)
DraftPipeline draftPipeline(Ref ref) {
  return DraftPipeline(
    llm: ref.watch(modelRouterProvider),
    prompts: ref.watch(promptRegistryProvider),
  );
}
