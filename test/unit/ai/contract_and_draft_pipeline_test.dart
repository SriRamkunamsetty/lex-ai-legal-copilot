import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:lex_copilot/ai/llm_service.dart';
import 'package:lex_copilot/ai/pipelines/contract_pipeline.dart';
import 'package:lex_copilot/ai/pipelines/draft_pipeline.dart';
import 'package:lex_copilot/ai/prompts/prompt_registry.dart';
import 'package:lex_copilot/core/result.dart';
import 'package:lex_copilot/core/widgets/risk_pill.dart';

class _StubContractDraftLlm implements LlmService {
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
    yield 'RENT AGREEMENT\n\nBetween Landlord Ramesh and [Tenant Name] for rent ₹15,000, refundable deposit ₹30,000, 30 days notice, parties under Bengaluru jurisdiction.';
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
    final json = <String, dynamic>{
      'risk_score': 78,
      'risk_label': 'High risk',
      'clauses': [
        {
          'clause_title': 'Unlimited Indemnity',
          'original_excerpt':
              'Vendor shall indemnify Client for all unlimited claims.',
          'risk_level': 'high',
          'reason':
              'Uncapped liability exposes Vendor to disproportionate losses.',
          'suggested_rewrite': 'Vendor shall indemnify Client up to fees paid in the prior 12 months.',
        },
        {
          'clause_title': 'Termination',
          'original_excerpt': 'Client may terminate without notice.',
          'risk_level': 'medium',
          'reason': 'One-sided termination without cure period.',
          'suggested_rewrite':
              'Either party may terminate with 30 days written notice.',
        },
      ],
    };
    return Success(schema.fromJson(json));
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('ContractPipeline scores clauses, computes redlines, and applies safer wording', () async {
    final pipeline = ContractPipeline(
      llm: _StubContractDraftLlm(),
      prompts: PromptRegistry(),
    );

    const original =
        '1. Indemnity\nVendor shall indemnify Client for all unlimited claims.\n\n'
        '2. Termination\nClient may terminate without notice.';

    final reviewRes = await pipeline.review(original);
    expect(reviewRes.isSuccess, isTrue);
    final review = reviewRes.valueOrNull!;
    expect(review.riskScore, 78);
    expect(review.countByLevel(RiskLevel.high), 1);
    expect(review.countByLevel(RiskLevel.medium), 1);

    final updated = pipeline.applySaferWording(
      review: review,
      clauseId: review.clauses.first.id,
    );
    expect(updated.clauses.first.applied, isTrue);
    expect(
      updated.workingText,
      contains('up to fees paid in the prior 12 months'),
    );
    expect(updated.riskScore, lessThan(review.riskScore));
  });

  test('DraftPipeline prefills from scans, preserves placeholders, checks clauses, and appends lawyer notice', () async {
    final pipeline = DraftPipeline(
      llm: _StubContractDraftLlm(),
      prompts: PromptRegistry(),
    );

    final prefilled = pipeline.prefillFieldsFromScan(
      template: DraftTemplate.rentAgreement,
      ocrText: 'Rent agreement for Flat 9A',
      summaryJson: jsonEncode({
        'parties': ['Ramesh Kumar'],
        'amounts': ['₹15,000'],
      }),
    );
    expect(prefilled['Landlord Name'], 'Ramesh Kumar');

    final res = await pipeline.generate(
      template: DraftTemplate.rentAgreement,
      fields: prefilled,
    );
    expect(res.isSuccess, isTrue);
    final draft = res.valueOrNull!;
    expect(draft.selfCheck.placeholders, contains('[Tenant Name]'));
    expect(draft.selfCheck.hasLawyerNotice, isTrue);
    expect(draft.selfCheck.missingMandatoryClauses, isEmpty);
    expect(draft.content, contains('LAWYER REVIEW NOTICE'));
  });
}
