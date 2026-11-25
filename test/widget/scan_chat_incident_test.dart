import 'dart:io';
import 'dart:typed_data';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lex_copilot/ai/ai_providers.dart';
import 'package:lex_copilot/ai/llm_service.dart';
import 'package:lex_copilot/ai/pipelines/document_pipeline.dart';
import 'package:lex_copilot/ai/pipelines/incident_pipeline.dart';
import 'package:lex_copilot/ai/pipelines/research_pipeline.dart';
import 'package:lex_copilot/ai/prompts/prompt_registry.dart';
import 'package:lex_copilot/app/theme/lex_theme.dart';
import 'package:lex_copilot/core/result.dart';
import 'package:lex_copilot/core/security/encrypted_file_store.dart';
import 'package:lex_copilot/core/security/secure_key_store.dart';
import 'package:lex_copilot/core/security/security_providers.dart';
import 'package:lex_copilot/core/storage/app_database.dart';
import 'package:lex_copilot/features/chat/presentation/ask_screen.dart';
import 'package:lex_copilot/features/incident/data/voice_input_service.dart';
import 'package:lex_copilot/features/incident/presentation/incident_controller.dart';
import 'package:lex_copilot/features/incident/presentation/incident_screen.dart';
import 'package:lex_copilot/features/scan/data/document_scanner_service.dart';
import 'package:lex_copilot/features/scan/presentation/scan_screen.dart';
import 'package:lex_copilot/features/settings/domain/lex_settings.dart';
import 'package:lex_copilot/features/settings/presentation/settings_controller.dart';
import 'package:lex_copilot/legal_corpus/providers/corpus_providers.dart';
import 'package:lex_copilot/legal_corpus/repository/legal_corpus_repository.dart';

class _StubCaptureService implements DocumentCaptureService {
  @override
  Future<Result<ScannedPageInput>> captureCamera() async =>
      Success(_samplePage);

  @override
  Future<Result<List<ScannedPageInput>>> pickFromGallery() async =>
      Success([_samplePage]);

  @override
  Future<Result<List<ScannedPageInput>>> scanDocument({
    int pageLimit = 5,
  }) async => Success([_samplePage]);

  static final _samplePage = ScannedPageInput(
    path: 'notice.jpg',
    bytes: Uint8List.fromList([1, 2, 3, 4]),
    fileName: 'Rent_Notice.jpg',
  );
}

class _StubOcr implements OcrEngine {
  @override
  Future<Result<OcrPageResult>> recognize(ScannedPageInput page) async {
    return const Success(
      OcrPageResult(
        text: 'Notice dated 01 Nov 2026 to vacate Flat 4B within 30 days. Rent due ₹18,000.',
        confidence: 0.94,
      ),
    );
  }
}

class _ToggleFailLlm implements LlmService {
  bool shouldFailChat = false;

  @override
  String get modelId => 'stub-gemma';

  @override
  bool get isOnDevice => true;

  @override
  bool get supportsAudio => false;

  @override
  bool get supportsImages => true;

  @override
  Stream<String> chat(
    List<LlmMessage> messages, {
    LlmGenerationOptions options = const LlmGenerationOptions(),
  }) async* {
    if (shouldFailChat) {
      throw StateError('Simulated inference timeout');
    }
    yield 'Under BNSS 173 you may record cognizable complaints; BNS 304 covers snatching.';
  }

  @override
  Future<Result<String>> describeImage(
    Uint8List imageBytes, {
    required String prompt,
  }) async => const Success('');

  @override
  Future<Result<T>> structured<T>(
    LlmSchema<T> schema,
    String prompt, {
    List<Uint8List> images = const [],
    LlmGenerationOptions options = const LlmGenerationOptions(),
  }) async {
    if (schema.name == 'incident_sections') {
      final json = <String, dynamic>{
        'category': 'Theft & Snatching',
        'summary': 'Phone snatching triggers BNS 304 and BNSS 173.',
        'cited_sections': [
          {
            'act_code': 'BNS',
            'section_number': '304',
            'rationale': 'Covers sudden seizing of movable property.',
          },
        ],
        'next_steps': ['Report at nearest police station'],
        'evidence_to_keep': ['IMEI receipt'],
        'where_to_report': 'Nearest Police Station / 112',
      };
      return Success(schema.fromJson(json));
    }

    final json = <String, dynamic>{
      'document_type': 'Rent Eviction Notice',
      'parties': ['Landlord A', 'Tenant B'],
      'dates': ['01 Nov 2026'],
      'deadlines': ['30 days to vacate'],
      'amounts': ['₹18,000'],
      'plain_language_summary': 'Landlord demands ₹18,000 and 30-day exit.',
      'key_risks': ['Verify notice period against state rent rules'],
    };
    return Success(schema.fromJson(json));
  }
}

class _StubVoiceService implements VoiceInputService {
  @override
  bool isListening = false;

  @override
  Future<Result<void>> startListening({
    required void Function(String transcript) onTranscript,
    String localeId = 'en_IN',
  }) async {
    isListening = true;
    onTranscript('My phone was snatched outside the bus stop');
    return const Success(null);
  }

  @override
  Future<void> stopListening() async {
    isListening = false;
  }
}

class _FixedSettingsController extends SettingsController {
  @override
  LexSettings build() => const LexSettings(onboardingCompleted: true);
}

class _InMemSecretStore implements KeyValueSecretStore {
  final Map<String, String> _m = {};
  @override
  Future<void> delete(String key) async => _m.remove(key);
  @override
  Future<String?> read(String key) async => _m[key];
  @override
  Future<void> write(String key, String value) async => _m[key] = value;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<({AppDatabase db, _ToggleFailLlm llm})> setupEnv(
    WidgetTester tester,
  ) async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    await tester.runAsync(() => LegalCorpusRepository(db).ensureSeeded());
    addTearDown(() async {
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump(Duration.zero);
      await db.close();
    });
    return (db: db, llm: _ToggleFailLlm());
  }

  testWidgets('ScanScreen captures, extracts summary, and renders cards', (
    tester,
  ) async {
    final env = await setupEnv(tester);
    final corpus = LegalCorpusRepository(env.db);
    final prompts = PromptRegistry();
    final tempDir = Directory.systemTemp.createTempSync('lex_scan_test_');
    addTearDown(() {
      if (tempDir.existsSync()) tempDir.deleteSync(recursive: true);
    });
    final keyManager = SecureKeyManager(_InMemSecretStore());

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(env.db),
          legalCorpusRepositoryProvider.overrideWithValue(corpus),
          settingsControllerProvider.overrideWith(_FixedSettingsController.new),
          secureKeyManagerProvider.overrideWithValue(keyManager),
          encryptedFileStoreProvider.overrideWithValue(
            EncryptedFileStore(
              keyManager: keyManager,
              baseDirProvider: () async => tempDir,
            ),
          ),
          documentCaptureServiceProvider.overrideWithValue(
            _StubCaptureService(),
          ),
          ocrEngineProvider.overrideWithValue(_StubOcr()),
          documentPipelineProvider.overrideWithValue(
            DocumentPipeline(
              ocrEngine: _StubOcr(),
              llm: env.llm,
              prompts: prompts,
            ),
          ),
        ],
        child: MaterialApp(
          theme: LexTheme.build(const LexSettings(), Brightness.light),
          home: const Scaffold(body: ScanScreen()),
        ),
      ),
    );

    await tester.tap(find.text('Auto-scan pages'));
    await tester.pumpAndSettle();
    expect(find.text('Rent_Notice.jpg'), findsOneWidget);

    await tester.runAsync(() async {
      // Allow real crypto / file write inside EncryptedFileStore cleanly.
      await Future<void>.delayed(Duration.zero);
    });
    await tester.tap(find.text('Extract & summarize'));
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 50));
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 30)),
      );
    }
    await tester.pumpAndSettle();

    expect(find.text('Rent Eviction Notice'), findsOneWidget);
    expect(find.text('30 days to vacate'), findsOneWidget);
    expect(find.text('Ask Lex about this document'), findsOneWidget);
  });

  testWidgets(
    'AskScreen preserves prompt on error, retries successfully, and displays verified citations',
    (tester) async {
      final env = await setupEnv(tester);
      final corpus = LegalCorpusRepository(env.db);
      final prompts = PromptRegistry();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appDatabaseProvider.overrideWithValue(env.db),
            legalCorpusRepositoryProvider.overrideWithValue(corpus),
            settingsControllerProvider.overrideWith(
              _FixedSettingsController.new,
            ),
            researchPipelineProvider.overrideWithValue(
              ResearchPipeline(corpus: corpus, llm: env.llm, prompts: prompts),
            ),
          ],
          child: MaterialApp(
            theme: LexTheme.build(const LexSettings(), Brightness.light),
            home: const Scaffold(body: AskScreen()),
          ),
        ),
      );

      env.llm.shouldFailChat = true;
      await tester.enterText(
        find.byType(TextField),
        'Is phone snatching covered under BNS?',
      );
      await tester.tap(find.byTooltip('Send message'));
      await tester.pumpAndSettle();

      expect(find.text('Answer interrupted'), findsOneWidget);
      expect(find.text('Try again'), findsOneWidget);

      env.llm.shouldFailChat = false;
      await tester.tap(find.text('Try again'));
      await tester.pumpAndSettle();

      expect(find.text('BNSS 173'), findsOneWidget);
      expect(find.text('BNS 304'), findsOneWidget);
      expect(find.textContaining('Reasoning trail:'), findsOneWidget);

      await tester.tap(find.text('Counters'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Counter-arguments:'), findsOneWidget);
    },
  );

  testWidgets(
    'IncidentScreen accepts voice input and displays verified provisions, steps, and evidence',
    (tester) async {
      final env = await setupEnv(tester);
      final corpus = LegalCorpusRepository(env.db);
      final prompts = PromptRegistry();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appDatabaseProvider.overrideWithValue(env.db),
            legalCorpusRepositoryProvider.overrideWithValue(corpus),
            settingsControllerProvider.overrideWith(
              _FixedSettingsController.new,
            ),
            voiceInputServiceProvider.overrideWithValue(_StubVoiceService()),
            incidentPipelineProvider.overrideWithValue(
              IncidentPipeline(corpus: corpus, llm: env.llm, prompts: prompts),
            ),
          ],
          child: MaterialApp(
            theme: LexTheme.build(const LexSettings(), Brightness.light),
            home: const IncidentScreen(),
          ),
        ),
      );

      await tester.tap(find.byTooltip('Describe by voice'));
      await tester.pumpAndSettle();
      expect(
        find.text('My phone was snatched outside the bus stop'),
        findsOneWidget,
      );

      await tester.tap(find.text('Find provisions'));
      await tester.pumpAndSettle();

      expect(find.text('BNS 304'), findsOneWidget);

      await tester.tap(find.text('Next steps'));
      await tester.pumpAndSettle();
      expect(find.text('Nearest Police Station / 112'), findsOneWidget);

      await tester.tap(find.text('Evidence'));
      await tester.pumpAndSettle();
      expect(find.text('IMEI receipt'), findsOneWidget);
    },
  );
}
