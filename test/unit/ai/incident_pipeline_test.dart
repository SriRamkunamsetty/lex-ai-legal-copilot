import 'dart:typed_data';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lex_copilot/ai/llm_service.dart';
import 'package:lex_copilot/ai/pipelines/incident_pipeline.dart';
import 'package:lex_copilot/ai/prompts/prompt_registry.dart';
import 'package:lex_copilot/core/result.dart';
import 'package:lex_copilot/core/storage/app_database.dart';
import 'package:lex_copilot/legal_corpus/repository/legal_corpus_repository.dart';

class _StubIncidentLlm implements LlmService {
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
  }) => const Stream.empty();

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
    final json = <String, dynamic>{
      'category': 'Snatching / Theft',
      'summary': 'Sudden grabbing of a mobile phone attracts snatching and theft provisions.',
      'cited_sections': [
        {
          'act_code': 'BNS',
          'section_number': '304',
          'rationale': 'Applies when movable property is suddenly seized.',
        },
        {
          'act_code': 'BNSS',
          'section_number': '173',
          'rationale': 'Governs registration of FIR for cognizable offences.',
        },
        {
          'act_code': 'BNS',
          'section_number': '9999',
          'rationale': 'Hallucinated section that must be filtered out.',
        },
      ],
      'next_steps': [
        'Call 112 and report to the nearest police station.',
        'Block SIM and register IMEI on CEIR.',
      ],
      'evidence_to_keep': ['IMEI invoice', 'CCTV location details'],
      'where_to_report': 'Nearest Police Station / 112',
    };
    return Success(schema.fromJson(json));
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('IncidentPipeline drops hallucinated provisions and retains only corpus-verified sections', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);
    final corpus = LegalCorpusRepository(db);
    await corpus.ensureSeeded();

    final pipeline = IncidentPipeline(
      corpus: corpus,
      llm: _StubIncidentLlm(),
      prompts: PromptRegistry(),
    );

    final result = await pipeline.analyze(
      description: 'Someone snatched my mobile phone near the metro gate.',
      category: IncidentCategory.theft,
    );

    expect(result.isSuccess, isTrue);
    final analysis = result.valueOrNull!;
    expect(
      analysis.provisions.map(
        (p) => '${p.section.actCode} ${p.section.sectionNumber}',
      ),
      containsAll(['BNS 304', 'BNSS 173']),
    );
    expect(
      analysis.provisions.any((p) => p.section.sectionNumber == '9999'),
      isFalse,
    );
    expect(analysis.nextSteps, hasLength(2));
    expect(analysis.evidenceToKeep, contains('IMEI invoice'));
  });
}
