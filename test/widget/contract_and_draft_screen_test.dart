import 'dart:typed_data';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lex_copilot/ai/ai_providers.dart';
import 'package:lex_copilot/ai/llm_service.dart';
import 'package:lex_copilot/ai/pipelines/contract_pipeline.dart';
import 'package:lex_copilot/ai/pipelines/draft_pipeline.dart';
import 'package:lex_copilot/ai/prompts/prompt_registry.dart';
import 'package:lex_copilot/app/theme/lex_theme.dart';
import 'package:lex_copilot/core/result.dart';
import 'package:lex_copilot/core/storage/app_database.dart';
import 'package:lex_copilot/features/contract_review/presentation/contract_review_screen.dart';
import 'package:lex_copilot/features/draft/presentation/draft_controller.dart';
import 'package:lex_copilot/features/draft/presentation/draft_screen.dart';
import 'package:lex_copilot/features/settings/domain/lex_settings.dart';
import 'package:lex_copilot/legal_corpus/providers/corpus_providers.dart';

class _WidgetContractDraftLlm implements LlmService {
  @override
  String get modelId => 'stub-gemma';

  @override
  bool get isOnDevice => true;

  @override
  bool get supportsAudio => false;

  @override
  bool get supportsImages => false;

  @override
  Stream<String> chat(
    List<LlmMessage> messages, {
    LlmGenerationOptions options = const LlmGenerationOptions(),
  }) async* {
    yield 'OFFER OF EMPLOYMENT\n\nTo [Candidate Name], compensation ₹12,00,000, joining [Joining Date], probation, confidentiality, termination with 30 days notice.';
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
    return Success(
      schema.fromJson({
        'risk_score': 72,
        'risk_label': 'Moderate risk',
        'clauses': [
          {
            'clause_title': 'Indemnity',
            'original_excerpt': 'Service Provider shall indemnify Client against all losses without limit.',
            'risk_level': 'high',
            'reason': 'Liability is uncapped.',
            'suggested_rewrite': 'Liability is capped at 12 months fees.',
          },
        ],
      }),
    );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'ContractReviewScreen scores clauses, toggles redline, and applies safer wording',
    (tester) async {
      final db = AppDatabase.forTesting(NativeDatabase.memory());
      addTearDown(db.close);

      final llm = _WidgetContractDraftLlm();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appDatabaseProvider.overrideWithValue(db),
            contractPipelineProvider.overrideWithValue(
              ContractPipeline(llm: llm, prompts: PromptRegistry()),
            ),
          ],
          child: MaterialApp(
            theme: LexTheme.build(const LexSettings(), Brightness.light),
            home: const ContractReviewScreen(),
          ),
        ),
      );

      await tester.tap(find.text('Load sample'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Review clauses'));
      await tester.pumpAndSettle();

      expect(find.text('Moderate risk'), findsOneWidget);
      expect(find.text('Indemnity'), findsOneWidget);

      await tester.ensureVisible(find.text('Preview redline'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Preview redline'));
      await tester.pumpAndSettle();
      await tester.ensureVisible(
        find.text('Suggested: Liability is capped at 12 months fees.'),
      );
      await tester.pumpAndSettle();
      expect(
        find.text('Suggested: Liability is capped at 12 months fees.'),
        findsOneWidget,
      );

      await tester.ensureVisible(find.text('Apply safer wording'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Apply safer wording'));
      await tester.pumpAndSettle();
      expect(find.text('Applied'), findsOneWidget);

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump(Duration.zero);
    },
  );

  testWidgets(
    'DraftScreen switches templates, generates draft with lawyer-review notice, and builds valid PDF bytes',
    (tester) async {
      final db = AppDatabase.forTesting(NativeDatabase.memory());
      addTearDown(db.close);

      final llm = _WidgetContractDraftLlm();
      late ProviderContainer container;
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appDatabaseProvider.overrideWithValue(db),
            draftPipelineProvider.overrideWithValue(
              DraftPipeline(llm: llm, prompts: PromptRegistry()),
            ),
          ],
          child: Builder(
            builder: (context) {
              container = ProviderScope.containerOf(context);
              return MaterialApp(
                theme: LexTheme.build(const LexSettings(), Brightness.light),
                home: const DraftScreen(),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('Employment offer'));
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.text('Generate Employment offer'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Generate Employment offer'));
      await tester.pumpAndSettle();

      await tester.ensureVisible(
        find.textContaining('LAWYER REVIEW NOTICE').first,
      );
      await tester.pumpAndSettle();
      expect(find.textContaining('LAWYER REVIEW NOTICE'), findsWidgets);
      expect(find.textContaining('placeholder'), findsOneWidget);

      final pdfBytes = await tester.runAsync(
        () => container.read(draftControllerProvider.notifier).buildPdfBytes(),
      );
      expect(pdfBytes, isNotNull);
      expect(pdfBytes!.length, greaterThan(200));

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump(Duration.zero);
    },
  );
}
