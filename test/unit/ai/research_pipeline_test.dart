import 'dart:typed_data';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lex_copilot/ai/llm_service.dart';
import 'package:lex_copilot/ai/pipelines/research_pipeline.dart';
import 'package:lex_copilot/ai/prompts/prompt_registry.dart';
import 'package:lex_copilot/core/errors/failure.dart';
import 'package:lex_copilot/core/result.dart';
import 'package:lex_copilot/core/storage/app_database.dart';
import 'package:lex_copilot/core/widgets/confidence_badge.dart';
import 'package:lex_copilot/features/settings/domain/lex_settings.dart';
import 'package:lex_copilot/legal_corpus/repository/legal_corpus_repository.dart';

class _StubResearchLlm implements LlmService {
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
    yield 'Snatching is covered under BNS 304 and police FIR rules under BNSS 173. ';
    yield 'Also ignore fabricated BNS 9999.';
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
  }) async => const Err(AiFailure('Not used'));
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('ResearchPipeline verifies real citations against corpus and removes unverified ones under strict mode', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);
    final corpus = LegalCorpusRepository(db);
    await corpus.ensureSeeded();

    final pipeline = ResearchPipeline(
      corpus: corpus,
      llm: _StubResearchLlm(),
      prompts: PromptRegistry(),
    );

    final prepared = await pipeline.prepareQuery(
      question:
          'My phone was snatched on the street. Which BNS section applies?',
      settings: const LexSettings(),
    );

    final chunks = await pipeline
        .streamAnswer(
          systemPrompt: prepared.systemPrompt,
          userPrompt: prepared.userPrompt,
        )
        .toList();

    final verified = await pipeline.verifyAnswer(
      rawAnswer: chunks.join(),
      retrieved: prepared.retrieved,
      strictCitationsOnly: true,
    );

    expect(
      verified.citations.map((c) => c.label),
      containsAll(['BNS 304', 'BNSS 173']),
    );
    expect(verified.citations.any((c) => c.sectionNumber == '9999'), isFalse);
    expect(verified.droppedUnverifiedCount, 1);
    expect(verified.answerText, contains('[unverified citation removed]'));
    expect(verified.answerText, contains('not legal advice'));
    expect(verified.confidence, ConfidenceLevel.medium);
  });
}
