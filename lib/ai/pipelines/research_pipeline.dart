// Private fields use named public parameters for readability across pipelines.
// ignore_for_file: prefer_initializing_formals
import 'package:flutter/foundation.dart';
import 'package:lex_copilot/ai/llm_service.dart';
import 'package:lex_copilot/ai/prompts/prompt_registry.dart';
import 'package:lex_copilot/core/result.dart';
import 'package:lex_copilot/core/widgets/confidence_badge.dart';
import 'package:lex_copilot/features/settings/domain/lex_settings.dart';
import 'package:lex_copilot/legal_corpus/models/legal_section.dart';
import 'package:lex_copilot/legal_corpus/repository/legal_corpus_repository.dart';

/// A citation parsed from an AI response and verified against the local corpus.
@immutable
class VerifiedCitation {
  /// Creates a [VerifiedCitation].
  const new({
    required this.actCode,
    required this.sectionNumber,
    required this.verified,
    this.sectionTitle,
  });

  /// Statute code (e.g. `BNS`, `BNSS`, `BSA`).
  final String actCode;

  /// Section identifier (e.g. `304`).
  final String sectionNumber;

  /// Whether the section was found in [LegalCorpusRepository].
  final bool verified;

  /// Official section title when [verified] is `true`.
  final String? sectionTitle;

  /// Display badge string (e.g. `BNS 304`).
  String get label => '$actCode $sectionNumber';
}

/// Final grounded research response produced after retrieval + verifier pass.
@immutable
class VerifiedResearchAnswer {
  /// Creates a [VerifiedResearchAnswer].
  const new({
    required this.answerText,
    required this.citations,
    required this.confidence,
    required this.reasoningTrail,
    required this.counterArguments,
    required this.droppedUnverifiedCount,
  });

  /// Main grounded answer text (always ending with verify notice).
  final String answerText;

  /// Citations extracted and checked against the corpus.
  final List<VerifiedCitation> citations;

  /// Computed confidence based on retrieval depth and citation verification.
  final ConfidenceLevel confidence;

  /// Brief explanation of retrieved sections and verification outcome.
  final String reasoningTrail;

  /// Edge cases / opposing arguments to consider.
  final String counterArguments;

  /// Count of hallucinated/unverified citations removed or flagged.
  final int droppedUnverifiedCount;
}

/// Retrieval -> grounded generation -> corpus verifier pipeline for legal Q&A.
class ResearchPipeline {
  /// Creates a [ResearchPipeline].
  const new({
    required LegalCorpusRepository corpus,
    required LlmService llm,
    required PromptRegistry prompts,
  }) : _corpus = corpus,
       _llm = llm,
       _prompts = prompts;

  final LegalCorpusRepository _corpus;
  final LlmService _llm;
  final PromptRegistry _prompts;

  /// Mandatory legal-trust notice appended to every grounded research answer.
  static const String verifyNotice =
      'Verify with official statutory text — not legal advice.';

  /// Retrieves relevant provisions for [question] + optional [documentContext]
  /// and prepares the grounded prompt + candidate sections.
  Future<
    ({
      List<LegalSectionModel> retrieved,
      String systemPrompt,
      String userPrompt,
    })
  >
  prepareQuery({
    required String question,
    required LexSettings settings,
    String? documentContext,
  }) async {
    final rewritten = _rewriteQuery(question);
    final searchRes = await _corpus.search(rewritten, limit: 4);
    final retrieved = searchRes.valueOrNull ?? const <LegalSectionModel>[];

    final corpusContext = retrieved.isEmpty
        ? 'No matching local statutory section was retrieved.'
        : retrieved
              .map(
                (s) =>
                    '[${s.actCode} ${s.sectionNumber}] ${s.title} (${s.chapter})\n${_truncate(s.text, 700)}',
              )
              .join('\n\n');

    final docPrefix =
        documentContext != null && documentContext.trim().isNotEmpty
        ? 'Attached document text:\n${_truncate(documentContext.trim(), 2500)}\n\n'
        : '';

    final systemPrompt = await _prompts.render(
      LexPromptId.systemLegalIndia,
      variables: {'answer_style': settings.aiAnswerStyle.name},
    );
    final userPrompt = await _prompts.render(
      LexPromptId.researchAnswer,
      variables: {
        'corpus_context': corpusContext,
        'question': '$docPrefix$question',
      },
    );

    return (
      retrieved: retrieved,
      systemPrompt: systemPrompt,
      userPrompt: userPrompt,
    );
  }

  /// Streams tokens from the LLM, then returns a verified [VerifiedResearchAnswer]
  /// via [verifyAnswer].
  Stream<String> streamAnswer({
    required String systemPrompt,
    required String userPrompt,
    List<LlmMessage> history = const [],
    LlmGenerationOptions options = const LlmGenerationOptions(),
  }) {
    final messages = <LlmMessage>[
      ...history,
      LlmMessage(role: LlmRole.user, content: userPrompt),
    ];
    return _llm.chat(
      messages,
      options: LlmGenerationOptions(
        temperature: options.temperature,
        maxOutputTokens: options.maxOutputTokens,
        systemInstruction: systemPrompt,
      ),
    );
  }

  /// Runs the deterministic VERIFIER PASS over [rawAnswer] against the corpus.
  Future<VerifiedResearchAnswer> verifyAnswer({
    required String rawAnswer,
    required List<LegalSectionModel> retrieved,
    required bool strictCitationsOnly,
  }) async {
    final citationRegex = RegExp(
      r'\b(BNS|BNSS|BSA)\s+(?:Section\s+)?(\d+[A-Z]?)\b',
      caseSensitive: false,
    );

    final verified = <VerifiedCitation>[];
    final seen = <String>{};
    var droppedCount = 0;
    var sanitizedText = rawAnswer.trim();

    for (final match in citationRegex.allMatches(rawAnswer)) {
      final act = match.group(1)!.toUpperCase();
      final num = match.group(2)!;
      final key = '$act:$num';
      if (!seen.add(key)) continue;

      final lookup = await _corpus.getSection(act, num);
      if (lookup case Success(:final value)) {
        verified.add(
          VerifiedCitation(
            actCode: act,
            sectionNumber: num,
            verified: true,
            sectionTitle: value.title,
          ),
        );
      } else {
        droppedCount += 1;
        if (strictCitationsOnly) {
          sanitizedText = sanitizedText.replaceAll(
            match.group(0)!,
            '[unverified citation removed]',
          );
        } else {
          verified.add(
            VerifiedCitation(actCode: act, sectionNumber: num, verified: false),
          );
        }
      }
    }

    if (sanitizedText.isEmpty) {
      sanitizedText = retrieved.isEmpty
          ? 'No matching statutory section was found locally. $verifyNotice'
          : 'Based on ${retrieved.map((s) => '${s.actCode} ${s.sectionNumber}').join(', ')}: ${_truncate(retrieved.first.plainLanguage ?? retrieved.first.text, 240)} $verifyNotice';
    } else if (!sanitizedText.toLowerCase().contains('not legal advice')) {
      sanitizedText = '$sanitizedText\n\n$verifyNotice';
    }

    final reasoning = _extractSection(
      sanitizedText,
      'Reasoning trail:',
      fallback: retrieved.isEmpty
          ? 'No local corpus provisions matched the query keywords directly.'
          : 'Retrieved ${retrieved.map((s) => '${s.actCode} ${s.sectionNumber} (${s.title})').join(', ')}; verified ${verified.where((c) => c.verified).length} citation(s) against official statutory text.',
    );

    final counter = _extractSection(
      sanitizedText,
      'Counter-arguments',
      fallback: 'Statutory applicability depends on exact facts, dates, jurisdiction, and state-level amendments.',
    );

    final verifiedCount = verified.where((c) => c.verified).length;
    final ConfidenceLevel confidence;
    if (verifiedCount >= 1 && droppedCount == 0 && retrieved.isNotEmpty) {
      confidence = ConfidenceLevel.high;
    } else if (retrieved.isNotEmpty || verifiedCount >= 1) {
      confidence = ConfidenceLevel.medium;
    } else {
      confidence = ConfidenceLevel.low;
    }

    return VerifiedResearchAnswer(
      answerText: sanitizedText,
      citations: verified,
      confidence: confidence,
      reasoningTrail: reasoning,
      counterArguments: counter,
      droppedUnverifiedCount: droppedCount,
    );
  }

  static String _rewriteQuery(String raw) {
    final lower = raw.toLowerCase();
    final expansions = <String>[raw];
    if (lower.contains('snatch') ||
        lower.contains('chain') ||
        lower.contains('phone')) {
      expansions.add('snatching theft BNS 304 303');
    }
    if (lower.contains('fir') ||
        lower.contains('police') ||
        lower.contains('report')) {
      expansions.add('information cognizable cases BNSS 173');
    }
    if (lower.contains('robbery') || lower.contains('weapon')) {
      expansions.add('robbery BNS 309');
    }
    if (lower.contains('electronic') ||
        lower.contains('screenshot') ||
        lower.contains('digital')) {
      expansions.add('electronic record BSA 63');
    }
    return expansions.join(' ');
  }

  static String _extractSection(
    String text,
    String heading, {
    required String fallback,
  }) {
    final idx = text.toLowerCase().indexOf(heading.toLowerCase());
    if (idx < 0) return fallback;
    final after = text.substring(idx);
    final lines = after.split('\n').take(4).join(' ').trim();
    return lines.isEmpty ? fallback : lines;
  }

  static String _truncate(String s, int maxChars) =>
      s.length <= maxChars ? s : '${s.substring(0, maxChars)}…';
}
