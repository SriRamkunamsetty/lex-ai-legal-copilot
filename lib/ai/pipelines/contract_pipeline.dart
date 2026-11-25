// Private fields use named public parameters for readability across pipelines.
// ignore_for_file: prefer_initializing_formals
import 'package:flutter/foundation.dart';
import 'package:lex_copilot/ai/llm_service.dart';
import 'package:lex_copilot/ai/prompts/prompt_registry.dart';
import 'package:lex_copilot/core/errors/failure.dart';
import 'package:lex_copilot/core/result.dart';
import 'package:lex_copilot/core/widgets/risk_pill.dart';

/// Clause-level risk assessment and suggested safer rewrite.
@immutable
class ContractClauseFinding {
  /// Creates a [ContractClauseFinding].
  const new({
    required this.id,
    required this.clauseTitle,
    required this.originalExcerpt,
    required this.riskLevel,
    required this.reason,
    required this.suggestedRewrite,
    this.applied = false,
  });

  /// Stable clause identifier within the review session.
  final String id;

  /// Clause heading or topic (e.g. `Indemnity`, `Termination`).
  final String clauseTitle;

  /// Original contract excerpt flagged during review.
  final String originalExcerpt;

  /// High / Medium / Low risk severity.
  final RiskLevel riskLevel;

  /// Plain-language explanation of the legal or commercial risk.
  final String reason;

  /// Balanced alternative clause wording.
  final String suggestedRewrite;

  /// Whether the user has applied [suggestedRewrite] to the working text.
  final bool applied;

  /// Returns a copy with [applied] updated.
  ContractClauseFinding copyWith({bool? applied}) {
    return ContractClauseFinding(
      id: id,
      clauseTitle: clauseTitle,
      originalExcerpt: originalExcerpt,
      riskLevel: riskLevel,
      reason: reason,
      suggestedRewrite: suggestedRewrite,
      applied: applied ?? this.applied,
    );
  }
}

/// Complete structured contract review output produced by [ContractPipeline].
@immutable
class ContractReviewResult {
  /// Creates a [ContractReviewResult].
  const new({
    required this.riskScore,
    required this.riskLabel,
    required this.clauses,
    required this.workingText,
    required this.segmentedClauseCount,
  });

  /// Overall contract risk score in `0..100` (higher = riskier).
  final int riskScore;

  /// Summary tier (`Low risk`, `Moderate risk`, `High risk`).
  final String riskLabel;

  /// Clause-level risk findings and redlines.
  final List<ContractClauseFinding> clauses;

  /// Current contract text reflecting any applied safer rewrites.
  final String workingText;

  /// Number of logical clauses segmented from the contract.
  final int segmentedClauseCount;

  /// Count of clauses at a given [RiskLevel].
  int countByLevel(RiskLevel level) =>
      clauses.where((c) => c.riskLevel == level).length;

  /// Returns a copy with updated [clauses] and [workingText].
  ContractReviewResult copyWith({
    List<ContractClauseFinding>? clauses,
    String? workingText,
    int? riskScore,
    String? riskLabel,
  }) {
    return ContractReviewResult(
      riskScore: riskScore ?? this.riskScore,
      riskLabel: riskLabel ?? this.riskLabel,
      clauses: clauses ?? this.clauses,
      workingText: workingText ?? this.workingText,
      segmentedClauseCount: segmentedClauseCount,
    );
  }
}

/// Contract risk analysis pipeline:
/// clause segmentation -> LLM JSON risk classification -> redline application.
class ContractPipeline {
  /// Creates a [ContractPipeline].
  const new({required LlmService llm, required PromptRegistry prompts})
    : _llm = llm,
      _prompts = prompts;

  final LlmService _llm;
  final PromptRegistry _prompts;

  static const Map<String, dynamic> _schema = {
    'type': 'object',
    'required': ['risk_score', 'risk_label', 'clauses'],
    'properties': {
      'risk_score': {'type': 'integer'},
      'risk_label': {'type': 'string'},
      'clauses': {'type': 'array'},
    },
  };

  /// Splits raw contract text into numbered or paragraph-level clauses.
  List<String> segmentClauses(String text) {
    final normalized = text.replaceAll('\r\n', '\n').trim();
    if (normalized.isEmpty) return const [];
    final rawParts = normalized
        .split(RegExp(r'\n\s*\n+|(?=\n\s*\d+[\.\)]\s+)'))
        .map((p) => p.trim())
        .where((p) => p.length >= 12)
        .toList();
    if (rawParts.isEmpty) return [normalized];
    return rawParts;
  }

  /// Reviews [contractText] and returns overall risk score + clause redlines.
  Future<Result<ContractReviewResult>> review(String contractText) async {
    final trimmed = contractText.trim();
    if (trimmed.isEmpty) {
      return const Err(
        ValidationFailure('Paste or import contract text to review.'),
      );
    }

    final segments = segmentClauses(trimmed);
    final prompt = await _prompts.render(
      LexPromptId.contractReview,
      variables: {'contract_text': trimmed},
    );

    final schema = LlmSchema<Map<String, dynamic>>(
      name: 'contract_review',
      jsonSchema: _schema,
      fromJson: (m) => m,
    );

    final aiRes = await _llm.structured(schema, prompt);

    if (aiRes case Success(:final value)) {
      final rawClauses = value['clauses'];
      final parsed = <ContractClauseFinding>[];
      if (rawClauses is List) {
        var idx = 1;
        for (final item in rawClauses.whereType<Map<String, dynamic>>()) {
          final levelStr = (item['risk_level'] as String? ?? 'medium')
              .trim()
              .toLowerCase();
          final level = switch (levelStr) {
            'high' => RiskLevel.high,
            'low' => RiskLevel.low,
            _ => RiskLevel.medium,
          };
          parsed.add(
            ContractClauseFinding(
              id: 'clause_${idx++}',
              clauseTitle: (item['clause_title'] as String? ?? 'Clause').trim(),
              originalExcerpt: (item['original_excerpt'] as String? ?? '')
                  .trim(),
              riskLevel: level,
              reason: (item['reason'] as String? ?? '').trim(),
              suggestedRewrite: (item['suggested_rewrite'] as String? ?? '')
                  .trim(),
            ),
          );
        }
      }

      if (parsed.isNotEmpty) {
        final scoreRaw = value['risk_score'];
        final score = (scoreRaw is num ? scoreRaw.round() : 55).clamp(0, 100);
        final label = (value['risk_label'] as String? ?? _labelForScore(score))
            .trim();
        return Success(
          ContractReviewResult(
            riskScore: score,
            riskLabel: label.isEmpty ? _labelForScore(score) : label,
            clauses: parsed,
            workingText: trimmed,
            segmentedClauseCount: segments.length,
          ),
        );
      }
    }

    // Deterministic offline heuristic review fallback when model is unavailable.
    return Success(_heuristicFallback(trimmed, segments));
  }

  /// Applies the clause rewrite matching [clauseId] cleanly to [review],
  /// replacing `originalExcerpt` in place or appending an amended addendum.
  ContractReviewResult applySaferWording({
    required ContractReviewResult review,
    required String clauseId,
  }) {
    final targetIndex = review.clauses.indexWhere((c) => c.id == clauseId);
    if (targetIndex < 0) return review;

    final target = review.clauses[targetIndex];
    if (target.applied || target.suggestedRewrite.trim().isEmpty) {
      return review;
    }

    var nextText = review.workingText;
    final excerpt = target.originalExcerpt.trim();
    if (excerpt.isNotEmpty && nextText.contains(excerpt)) {
      nextText = nextText.replaceFirst(excerpt, target.suggestedRewrite.trim());
    } else {
      nextText =
          '$nextText\n\n[Amended ${target.clauseTitle}]: ${target.suggestedRewrite.trim()}';
    }

    final updatedClauses = List<ContractClauseFinding>.from(review.clauses);
    updatedClauses[targetIndex] = target.copyWith(applied: true);

    final reducedScore = _recomputeScore(updatedClauses);
    return review.copyWith(
      clauses: updatedClauses,
      workingText: nextText,
      riskScore: reducedScore,
      riskLabel: _labelForScore(reducedScore),
    );
  }

  int _recomputeScore(List<ContractClauseFinding> clauses) {
    var score = 15;
    for (final c in clauses) {
      if (c.applied) {
        score += 5;
        continue;
      }
      score += switch (c.riskLevel) {
        RiskLevel.high => 32,
        RiskLevel.medium => 18,
        RiskLevel.low => 6,
      };
    }
    return score.clamp(5, 100);
  }

  String _labelForScore(int score) {
    if (score >= 70) return 'High risk';
    if (score >= 40) return 'Moderate risk';
    return 'Low risk';
  }

  ContractReviewResult _heuristicFallback(String text, List<String> segments) {
    final findings = <ContractClauseFinding>[];
    final lower = text.toLowerCase();
    var idx = 1;

    if (lower.contains('indemn') ||
        lower.contains('unlimited') ||
        lower.contains('all losses')) {
      final excerpt = segments.firstWhere(
        (s) => s.toLowerCase().contains('indemn'),
        orElse: () => 'Indemnify against all claims and unlimited losses.',
      );
      findings.add(
        ContractClauseFinding(
          id: 'clause_${idx++}',
          clauseTitle: 'Indemnity & Liability Cap',
          originalExcerpt: excerpt,
          riskLevel: RiskLevel.high,
          reason: 'Liability appears broad or uncapped. Indian commercial practice caps liability at 12 months of fees paid.',
          suggestedRewrite: 'Each party shall indemnify the other only for direct, proven third-party claims, subject to an aggregate liability cap equal to the fees paid in the preceding twelve (12) months.',
        ),
      );
    }

    if (lower.contains('terminat') || lower.contains('notice')) {
      final excerpt = segments.firstWhere(
        (s) => s.toLowerCase().contains('terminat'),
        orElse: () => 'Agreement may be terminated immediately without notice.',
      );
      findings.add(
        ContractClauseFinding(
          id: 'clause_${idx++}',
          clauseTitle: 'Mutual Termination & Cure Period',
          originalExcerpt: excerpt,
          riskLevel: RiskLevel.medium,
          reason: 'Asymmetric or immediate termination creates disruption without a cure period.',
          suggestedRewrite: 'Either party may terminate this Agreement for convenience on thirty (30) days prior written notice, or for material breach remaining uncured fifteen (15) days after written notice.',
        ),
      );
    }

    if (lower.contains('lock-in') || lower.contains('forfeit')) {
      findings.add(
        ContractClauseFinding(
          id: 'clause_${idx++}',
          clauseTitle: 'Security Deposit / Lock-in',
          originalExcerpt: segments.first,
          riskLevel: RiskLevel.medium,
          reason: 'Check whether forfeiture or lock-in terms are reciprocal and clearly quantified.',
          suggestedRewrite: 'The refundable security deposit shall be returned within fifteen (15) days of handover, subject only to documented unpaid dues or repairs.',
        ),
      );
    }

    if (findings.isEmpty) {
      findings.add(
        ContractClauseFinding(
          id: 'clause_${idx++}',
          clauseTitle: 'General Terms & Governing Law',
          originalExcerpt: segments.first,
          riskLevel: RiskLevel.low,
          reason: 'Ensure governing law, jurisdiction city, and dispute resolution clause are stated explicitly.',
          suggestedRewrite: 'This Agreement is governed by the laws of India, with courts at [City, State] holding jurisdiction after good-faith mediation.',
        ),
      );
    }

    final score = _recomputeScore(findings);
    return ContractReviewResult(
      riskScore: score,
      riskLabel: _labelForScore(score),
      clauses: findings,
      workingText: text,
      segmentedClauseCount: segments.length,
    );
  }
}
