import 'dart:io';
import 'dart:typed_data';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lex_copilot/ai/ai_providers.dart';
import 'package:lex_copilot/ai/llm_service.dart';
import 'package:lex_copilot/ai/pipelines/document_pipeline.dart';
import 'package:lex_copilot/ai/pipelines/draft_pipeline.dart';
import 'package:lex_copilot/ai/pipelines/research_pipeline.dart';
import 'package:lex_copilot/ai/prompts/prompt_registry.dart';
import 'package:lex_copilot/app/app.dart';
import 'package:lex_copilot/app/flavors.dart';
import 'package:lex_copilot/core/result.dart';
import 'package:lex_copilot/core/security/encrypted_file_store.dart';
import 'package:lex_copilot/core/security/secure_key_store.dart';
import 'package:lex_copilot/core/security/security_providers.dart';
import 'package:lex_copilot/core/storage/app_database.dart';
import 'package:lex_copilot/features/draft/presentation/draft_controller.dart';
import 'package:lex_copilot/features/library/presentation/library_providers.dart';
import 'package:lex_copilot/features/scan/data/document_scanner_service.dart';
import 'package:lex_copilot/features/settings/presentation/settings_controller.dart';
import 'package:lex_copilot/legal_corpus/providers/corpus_providers.dart';
import 'package:lex_copilot/legal_corpus/repository/legal_corpus_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FakeMemSecretStore implements KeyValueSecretStore {
  final Map<String, String> _store = {};
  @override
  Future<void> delete(String key) async => _store.remove(key);
  @override
  Future<String?> read(String key) async => _store[key];
  @override
  Future<void> write(String key, String value) async => _store[key] = value;
}

class _FlowCapture implements DocumentCaptureService {
  @override
  Future<Result<ScannedPageInput>> captureCamera() async => Success(_page);
  @override
  Future<Result<List<ScannedPageInput>>> pickFromGallery() async =>
      Success([_page]);
  @override
  Future<Result<List<ScannedPageInput>>> scanDocument({
    int pageLimit = 5,
  }) async => Success([_page]);

  static final _page = ScannedPageInput(
    path: 'rent_notice.jpg',
    bytes: Uint8List.fromList([10, 20, 30, 40]),
    fileName: 'Rent_Notice.jpg',
  );
}

class _FlowOcr implements OcrEngine {
  @override
  Future<Result<OcrPageResult>> recognize(ScannedPageInput page) async =>
      const Success(
        OcrPageResult(
          text: 'Rent Notice from Ramesh Kumar to Tenant Priya dated 10 Nov 2026 demanding ₹15,000.',
          confidence: 0.95,
        ),
      );
}

class _FlowLlm implements LlmService {
  @override
  String get modelId => 'flow-gemma';
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
    yield 'Review BNS 329 on trespass and BNSS 173 for reporting cognizable acts.';
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
  }) async => Success(
    schema.fromJson({
      'document_type': 'Rent Notice',
      'parties': ['Ramesh Kumar', 'Priya'],
      'dates': ['10 Nov 2026'],
      'deadlines': ['30 days reply'],
      'amounts': ['₹15,000'],
      'plain_language_summary': 'Landlord seeks ₹15,000 or 30-day vacation.',
      'key_risks': ['Check lease registration'],
    }),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'End-to-end Scan -> Chat -> Draft prefill + PDF export -> Data Wipe preserves corpus',
    (tester) async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final db = AppDatabase.forTesting(NativeDatabase.memory());
      await tester.runAsync(() => LegalCorpusRepository(db).ensureSeeded());
      addTearDown(db.close);

      final llm = _FlowLlm();
      final prompts = PromptRegistry();
      final corpus = LegalCorpusRepository(db);
      final keyManager = SecureKeyManager(_FakeMemSecretStore());
      final tempDir = Directory.systemTemp.createTempSync('lex_flow_test_');
      addTearDown(() {
        if (tempDir.existsSync()) tempDir.deleteSync(recursive: true);
      });

      late ProviderContainer container;
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(prefs),
            flavorConfigProvider.overrideWithValue(
              FlavorConfig.fromEnvironment(LexFlavor.dev),
            ),
            appDatabaseProvider.overrideWithValue(db),
            legalCorpusRepositoryProvider.overrideWithValue(corpus),
            secureKeyManagerProvider.overrideWithValue(keyManager),
            encryptedFileStoreProvider.overrideWithValue(
              EncryptedFileStore(
                keyManager: keyManager,
                baseDirProvider: () async => tempDir,
              ),
            ),
            documentCaptureServiceProvider.overrideWithValue(_FlowCapture()),
            ocrEngineProvider.overrideWithValue(_FlowOcr()),
            documentPipelineProvider.overrideWithValue(
              DocumentPipeline(
                ocrEngine: _FlowOcr(),
                llm: llm,
                prompts: prompts,
              ),
            ),
            researchPipelineProvider.overrideWithValue(
              ResearchPipeline(corpus: corpus, llm: llm, prompts: prompts),
            ),
            draftPipelineProvider.overrideWithValue(
              DraftPipeline(llm: llm, prompts: prompts),
            ),
          ],
          child: Builder(
            builder: (context) {
              container = ProviderScope.containerOf(context);
              return const LexApp();
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Complete 3-step onboarding quickly.
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Open your legal desk'));
      await tester.pumpAndSettle();

      // 1. Scan tab -> auto-scan -> extract summary -> open in chat.
      await tester.tap(find.text('Scan'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Auto-scan pages'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Extract & summarize'));
      for (var i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 50));
        await tester.runAsync(
          () => Future<void>.delayed(const Duration(milliseconds: 30)),
        );
      }
      await tester.pumpAndSettle();
      expect(find.text('Rent Notice'), findsOneWidget);

      await tester.ensureVisible(find.text('Ask Lex about this document'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Ask Lex about this document'));
      await tester.pumpAndSettle();

      // 2. Ask tab has scan context attached & asks question with verified citations.
      expect(find.text('Ask Lex'), findsOneWidget);
      await tester.enterText(
        find.byType(TextField),
        'Can landlord lock me out without notice?',
      );
      await tester.tap(find.byTooltip('Send message'));
      await tester.pumpAndSettle();
      expect(find.text('BNS 329'), findsOneWidget);
      expect(find.text('BNSS 173'), findsOneWidget);

      // 3. Draft controller prefills from the persisted scan and generates PDF.
      final scans = await tester.runAsync(
        () => container.read(libraryRepositoryProvider).watchScans().first,
      );
      expect(scans, isNotEmpty);

      final draftCtrl = container.read(draftControllerProvider.notifier)
        ..prefillFromScan(
          ocrText: scans!.first.ocrText,
          summaryJson: scans.first.summaryJson,
        );
      await tester.runAsync(draftCtrl.generateDraft);
      final pdfBytes = await tester.runAsync(draftCtrl.buildPdfBytes);
      expect(pdfBytes!.length, greaterThan(200));

      // 4. Delete all user data keeps offline legal corpus intact.
      await tester.runAsync(
        () => container.read(libraryRepositoryProvider).deleteAllUserData(),
      );
      final afterWipe = await tester.runAsync(
        () => container.read(libraryRepositoryProvider).watchScans().first,
      );
      expect(afterWipe, isEmpty);
      final sectionCheck = await tester.runAsync(
        () => corpus.getSection('BNS', '304'),
      );
      expect(sectionCheck!.isSuccess, isTrue);

      await tester.pumpWidget(const MaterialApp(home: SizedBox.shrink()));
      await tester.pumpAndSettle();
    },
  );
}
