// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the versioned [PromptRegistry].

@ProviderFor(promptRegistry)
final promptRegistryProvider = PromptRegistryProvider._();

/// Provides the versioned [PromptRegistry].

final class PromptRegistryProvider
    extends $FunctionalProvider<PromptRegistry, PromptRegistry, PromptRegistry>
    with $Provider<PromptRegistry> {
  /// Provides the versioned [PromptRegistry].
  PromptRegistryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'promptRegistryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$promptRegistryHash();

  @$internal
  @override
  $ProviderElement<PromptRegistry> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PromptRegistry create(Ref ref) {
    return promptRegistry(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PromptRegistry value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PromptRegistry>(value),
    );
  }
}

String _$promptRegistryHash() => r'e5e7261c7a36cbf0ffd5583d5c77ab44e29a84a7';

/// Provides the device bearer-token manager calling `/v1/auth/device-token`.

@ProviderFor(deviceAuthService)
final deviceAuthServiceProvider = DeviceAuthServiceProvider._();

/// Provides the device bearer-token manager calling `/v1/auth/device-token`.

final class DeviceAuthServiceProvider
    extends
        $FunctionalProvider<
          DeviceAuthService,
          DeviceAuthService,
          DeviceAuthService
        >
    with $Provider<DeviceAuthService> {
  /// Provides the device bearer-token manager calling `/v1/auth/device-token`.
  DeviceAuthServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'deviceAuthServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$deviceAuthServiceHash();

  @$internal
  @override
  $ProviderElement<DeviceAuthService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DeviceAuthService create(Ref ref) {
    return deviceAuthService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DeviceAuthService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DeviceAuthService>(value),
    );
  }
}

String _$deviceAuthServiceHash() => r'ee3344cfe713f16151a90c668f65ae72f6b37706';

/// Provides the [LexHttpClient] configured with device auth & cert pinning.

@ProviderFor(lexHttpClient)
final lexHttpClientProvider = LexHttpClientProvider._();

/// Provides the [LexHttpClient] configured with device auth & cert pinning.

final class LexHttpClientProvider
    extends $FunctionalProvider<LexHttpClient, LexHttpClient, LexHttpClient>
    with $Provider<LexHttpClient> {
  /// Provides the [LexHttpClient] configured with device auth & cert pinning.
  LexHttpClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'lexHttpClientProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$lexHttpClientHash();

  @$internal
  @override
  $ProviderElement<LexHttpClient> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LexHttpClient create(Ref ref) {
    return lexHttpClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LexHttpClient value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LexHttpClient>(value),
    );
  }
}

String _$lexHttpClientHash() => r'd709eda717529623b4294d10a1956a8eb01c2550';

/// Evaluates device RAM, storage, and thermal limits for Gemma 4 tiers.

@ProviderFor(deviceCapabilityService)
final deviceCapabilityServiceProvider = DeviceCapabilityServiceProvider._();

/// Evaluates device RAM, storage, and thermal limits for Gemma 4 tiers.

final class DeviceCapabilityServiceProvider
    extends
        $FunctionalProvider<
          DeviceCapabilityService,
          DeviceCapabilityService,
          DeviceCapabilityService
        >
    with $Provider<DeviceCapabilityService> {
  /// Evaluates device RAM, storage, and thermal limits for Gemma 4 tiers.
  DeviceCapabilityServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'deviceCapabilityServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$deviceCapabilityServiceHash();

  @$internal
  @override
  $ProviderElement<DeviceCapabilityService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DeviceCapabilityService create(Ref ref) {
    return deviceCapabilityService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DeviceCapabilityService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DeviceCapabilityService>(value),
    );
  }
}

String _$deviceCapabilityServiceHash() =>
    r'aa8212b088828fb093b30eb2f9d793626ca3bb15';

/// Provides the on-device Gemma 4 service.

@ProviderFor(onDeviceGemmaService)
final onDeviceGemmaServiceProvider = OnDeviceGemmaServiceProvider._();

/// Provides the on-device Gemma 4 service.

final class OnDeviceGemmaServiceProvider
    extends
        $FunctionalProvider<
          OnDeviceGemmaService,
          OnDeviceGemmaService,
          OnDeviceGemmaService
        >
    with $Provider<OnDeviceGemmaService> {
  /// Provides the on-device Gemma 4 service.
  OnDeviceGemmaServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'onDeviceGemmaServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$onDeviceGemmaServiceHash();

  @$internal
  @override
  $ProviderElement<OnDeviceGemmaService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  OnDeviceGemmaService create(Ref ref) {
    return onDeviceGemmaService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OnDeviceGemmaService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OnDeviceGemmaService>(value),
    );
  }
}

String _$onDeviceGemmaServiceHash() =>
    r'b714dcf6ba5d2f360f8b9b6269825240bdbdf773';

/// Provides the cloud Gemma 4 proxy service.

@ProviderFor(cloudGemmaService)
final cloudGemmaServiceProvider = CloudGemmaServiceProvider._();

/// Provides the cloud Gemma 4 proxy service.

final class CloudGemmaServiceProvider
    extends
        $FunctionalProvider<
          CloudGemmaService,
          CloudGemmaService,
          CloudGemmaService
        >
    with $Provider<CloudGemmaService> {
  /// Provides the cloud Gemma 4 proxy service.
  CloudGemmaServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cloudGemmaServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cloudGemmaServiceHash();

  @$internal
  @override
  $ProviderElement<CloudGemmaService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CloudGemmaService create(Ref ref) {
    return cloudGemmaService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CloudGemmaService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CloudGemmaService>(value),
    );
  }
}

String _$cloudGemmaServiceHash() => r'18e054a49b9e40b5491364e428cfddf1685b8988';

/// Provides the [ModelRouter] coordinating on-device and cloud inference with
/// live connectivity checks and explicit cloud consent rules.

@ProviderFor(modelRouter)
final modelRouterProvider = ModelRouterProvider._();

/// Provides the [ModelRouter] coordinating on-device and cloud inference with
/// live connectivity checks and explicit cloud consent rules.

final class ModelRouterProvider
    extends $FunctionalProvider<ModelRouter, ModelRouter, ModelRouter>
    with $Provider<ModelRouter> {
  /// Provides the [ModelRouter] coordinating on-device and cloud inference with
  /// live connectivity checks and explicit cloud consent rules.
  ModelRouterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'modelRouterProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$modelRouterHash();

  @$internal
  @override
  $ProviderElement<ModelRouter> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ModelRouter create(Ref ref) {
    return modelRouter(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ModelRouter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ModelRouter>(value),
    );
  }
}

String _$modelRouterHash() => r'6e1586ab241f3d49b6e825c0f72d5690a1fec812';

/// Provides the document scanner / camera / gallery capture service.

@ProviderFor(documentCaptureService)
final documentCaptureServiceProvider = DocumentCaptureServiceProvider._();

/// Provides the document scanner / camera / gallery capture service.

final class DocumentCaptureServiceProvider
    extends
        $FunctionalProvider<
          DocumentCaptureService,
          DocumentCaptureService,
          DocumentCaptureService
        >
    with $Provider<DocumentCaptureService> {
  /// Provides the document scanner / camera / gallery capture service.
  DocumentCaptureServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'documentCaptureServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$documentCaptureServiceHash();

  @$internal
  @override
  $ProviderElement<DocumentCaptureService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DocumentCaptureService create(Ref ref) {
    return documentCaptureService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DocumentCaptureService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DocumentCaptureService>(value),
    );
  }
}

String _$documentCaptureServiceHash() =>
    r'2a850d93226646f7dd214341c7d299c9d297fc9c';

/// Provides the on-device ML Kit OCR engine.

@ProviderFor(ocrEngine)
final ocrEngineProvider = OcrEngineProvider._();

/// Provides the on-device ML Kit OCR engine.

final class OcrEngineProvider
    extends $FunctionalProvider<OcrEngine, OcrEngine, OcrEngine>
    with $Provider<OcrEngine> {
  /// Provides the on-device ML Kit OCR engine.
  OcrEngineProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ocrEngineProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ocrEngineHash();

  @$internal
  @override
  $ProviderElement<OcrEngine> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  OcrEngine create(Ref ref) {
    return ocrEngine(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OcrEngine value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OcrEngine>(value),
    );
  }
}

String _$ocrEngineHash() => r'b8cda2f882785f18fbf38f9a33b67aca6d7051cd';

/// Provides the multi-page OCR + LLM [DocumentPipeline].

@ProviderFor(documentPipeline)
final documentPipelineProvider = DocumentPipelineProvider._();

/// Provides the multi-page OCR + LLM [DocumentPipeline].

final class DocumentPipelineProvider
    extends
        $FunctionalProvider<
          DocumentPipeline,
          DocumentPipeline,
          DocumentPipeline
        >
    with $Provider<DocumentPipeline> {
  /// Provides the multi-page OCR + LLM [DocumentPipeline].
  DocumentPipelineProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'documentPipelineProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$documentPipelineHash();

  @$internal
  @override
  $ProviderElement<DocumentPipeline> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DocumentPipeline create(Ref ref) {
    return documentPipeline(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DocumentPipeline value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DocumentPipeline>(value),
    );
  }
}

String _$documentPipelineHash() => r'a984b4981a2c30723785f82e9e848529efdab18f';

/// Provides the offline [LocalRagEngine] combining FTS5 BM25, semantic vectors
/// via RRF, chunking, and 1-hop Knowledge Graph expansion.

@ProviderFor(localRagEngine)
final localRagEngineProvider = LocalRagEngineProvider._();

/// Provides the offline [LocalRagEngine] combining FTS5 BM25, semantic vectors
/// via RRF, chunking, and 1-hop Knowledge Graph expansion.

final class LocalRagEngineProvider
    extends $FunctionalProvider<LocalRagEngine, LocalRagEngine, LocalRagEngine>
    with $Provider<LocalRagEngine> {
  /// Provides the offline [LocalRagEngine] combining FTS5 BM25, semantic vectors
  /// via RRF, chunking, and 1-hop Knowledge Graph expansion.
  LocalRagEngineProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'localRagEngineProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$localRagEngineHash();

  @$internal
  @override
  $ProviderElement<LocalRagEngine> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LocalRagEngine create(Ref ref) {
    return localRagEngine(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LocalRagEngine value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LocalRagEngine>(value),
    );
  }
}

String _$localRagEngineHash() => r'9bb85975f3f74481c42d9d3d33992845e9a6065e';

/// Provides the RAG + citation-verifier [ResearchPipeline].

@ProviderFor(researchPipeline)
final researchPipelineProvider = ResearchPipelineProvider._();

/// Provides the RAG + citation-verifier [ResearchPipeline].

final class ResearchPipelineProvider
    extends
        $FunctionalProvider<
          ResearchPipeline,
          ResearchPipeline,
          ResearchPipeline
        >
    with $Provider<ResearchPipeline> {
  /// Provides the RAG + citation-verifier [ResearchPipeline].
  ResearchPipelineProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'researchPipelineProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$researchPipelineHash();

  @$internal
  @override
  $ProviderElement<ResearchPipeline> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ResearchPipeline create(Ref ref) {
    return researchPipeline(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ResearchPipeline value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ResearchPipeline>(value),
    );
  }
}

String _$researchPipelineHash() => r'97e6a170e2ac460bc1399f2af145a7f30bb6969d';

/// Provides the grounded [IncidentPipeline].

@ProviderFor(incidentPipeline)
final incidentPipelineProvider = IncidentPipelineProvider._();

/// Provides the grounded [IncidentPipeline].

final class IncidentPipelineProvider
    extends
        $FunctionalProvider<
          IncidentPipeline,
          IncidentPipeline,
          IncidentPipeline
        >
    with $Provider<IncidentPipeline> {
  /// Provides the grounded [IncidentPipeline].
  IncidentPipelineProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'incidentPipelineProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$incidentPipelineHash();

  @$internal
  @override
  $ProviderElement<IncidentPipeline> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  IncidentPipeline create(Ref ref) {
    return incidentPipeline(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(IncidentPipeline value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<IncidentPipeline>(value),
    );
  }
}

String _$incidentPipelineHash() => r'6f63364dc7fe758304dec391ab69ba6fabfc7ce1';

/// Provides the clause risk & redline [ContractPipeline].

@ProviderFor(contractPipeline)
final contractPipelineProvider = ContractPipelineProvider._();

/// Provides the clause risk & redline [ContractPipeline].

final class ContractPipelineProvider
    extends
        $FunctionalProvider<
          ContractPipeline,
          ContractPipeline,
          ContractPipeline
        >
    with $Provider<ContractPipeline> {
  /// Provides the clause risk & redline [ContractPipeline].
  ContractPipelineProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'contractPipelineProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$contractPipelineHash();

  @$internal
  @override
  $ProviderElement<ContractPipeline> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ContractPipeline create(Ref ref) {
    return contractPipeline(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ContractPipeline value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ContractPipeline>(value),
    );
  }
}

String _$contractPipelineHash() => r'b875f2d37ece3453e89919e4ecc0630ef60f9eb1';

/// Provides the template-based [DraftPipeline].

@ProviderFor(draftPipeline)
final draftPipelineProvider = DraftPipelineProvider._();

/// Provides the template-based [DraftPipeline].

final class DraftPipelineProvider
    extends $FunctionalProvider<DraftPipeline, DraftPipeline, DraftPipeline>
    with $Provider<DraftPipeline> {
  /// Provides the template-based [DraftPipeline].
  DraftPipelineProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'draftPipelineProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$draftPipelineHash();

  @$internal
  @override
  $ProviderElement<DraftPipeline> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DraftPipeline create(Ref ref) {
    return draftPipeline(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DraftPipeline value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DraftPipeline>(value),
    );
  }
}

String _$draftPipelineHash() => r'c95b62b30691bc605e1c209aa080d3a6cb5aa001';
