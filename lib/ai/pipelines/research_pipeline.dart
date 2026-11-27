// Private fields use named public parameters for readability across pipelines.
// ignore_for_file: prefer_initializing_formals
import 'package:flutter/foundation.dart';
import 'package:lex_copilot/ai/cloud/cloud_gemma_service.dart';
import 'package:lex_copilot/ai/llm_service.dart';
import 'package:lex_copilot/ai/prompts/prompt_registry.dart';
import 'package:lex_copilot/ai/rag/local_rag_engine.dart';
import 'package:lex_copilot/ai/rag/query_intent_classifier.dart';
import 'package:lex_copilot/ai/router/model_router.dart';
import 'package:lex_copilot/core/result.dart';
import 'package:lex_copilot/core/widgets/confidence_badge.dart';
import 'package:lex_copilot/features/chat/domain/chat_models.dart';
import 'package:lex_copilot/features/settings/domain/lex_settings.dart';
import 'package:lex_copilot/legal_corpus/models/legal_section.dart';
import 'package:lex_copilot/legal_corpus/repository/legal_corpus_repository.dart';
import 'package:lex_copilot/legal_corpus/resolver/reference_resolver.dart';

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

/// Prepared retrieval context, intent classification, and formatted prompts.
@immutable
class ResearchQueryPlan {
  /// Creates a [ResearchQueryPlan].
  const new({
    required this.retrieved,
    required this.systemPrompt,
    required this.userPrompt,
    required this.intent,
    this.ragBundle,
  });

  /// Matched legal sections.
  final List<LegalSectionModel> retrieved;

  /// Grounded system instruction.
  final String systemPrompt;

  /// Formatted user prompt.
  final String userPrompt;

  /// Classified query intent (Module F).
  final ClassifiedQueryIntent intent;

  /// Optional rich RAG retrieval bundle (footnotes, KG links, unavailable external notices).
  final RagRetrievalBundle? ragBundle;
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
    this.provenance,
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

  /// Provenance-separated law vs footnote vs warning metadata (Module G).
  final ProvenanceAnswerBlocks? provenance;
}

/// Retrieval -> grounded generation -> corpus verifier pipeline for legal Q&A.
class ResearchPipeline {
  /// Creates a [ResearchPipeline].
  const new({
    required LegalCorpusRepository corpus,
    required LlmService llm,
    required PromptRegistry prompts,
    LocalRagEngine? ragEngine,
  }) : _corpus = corpus,
       _llm = llm,
       _prompts = prompts,
       _ragEngine = ragEngine;

  final LegalCorpusRepository _corpus;
  final LlmService _llm;
  final PromptRegistry _prompts;
  final LocalRagEngine? _ragEngine;

  /// Mandatory legal-trust notice appended to every grounded research answer.
  static const String verifyNotice =
      'Verify with official statutory text — not legal advice.';

  /// Retrieves relevant provisions, footnotes, external-act boundary warnings,
  /// and ranked overlapping document chunks for [question] + [documentContext].
  Future<ResearchQueryPlan> prepareQuery({
    required String question,
    required LexSettings settings,
    String? documentContext,
  }) async {
    final intent = QueryIntentClassifier.classify(
      question,
      hasAttachedDocument:
          documentContext != null && documentContext.trim().isNotEmpty,
    );
    final rewritten = _rewriteQuery(question);
    final rag = _ragEngine;
    late final List<LegalSectionModel> retrieved;
    RagRetrievalBundle? ragBundle;
    var extraKnowledgeNotes = '';
    var selectedDocChunks = const <DocumentTextChunk>[];

    if (rag != null) {
      final bundle = await rag.retrieve(
        query: rewritten,
        documentContext: documentContext,
      );
      ragBundle = bundle;
      retrieved = bundle.sections;
      selectedDocChunks = bundle.documentChunks;
      final noteBuf = StringBuffer();
      if (bundle.footnotes.isNotEmpty) {
        noteBuf.writeln('\nSeparated Amendment / Judicial Notes:');
        for (final fn in bundle.footnotes.take(4)) {
          noteBuf.writeln(
            '- [${fn.provisionRef} · ${fn.footnoteType} p.${fn.bookPage}] ${_truncate(fn.noteText, 240)}',
          );
        }
      }
      if (bundle.unavailableExternalRefs.isNotEmpty) {
        noteBuf.writeln(
          '\nExternal Acts Referenced (FULL STATUTORY TEXT NOT LOADED OFFLINE):',
        );
        for (final ext in bundle.unavailableExternalRefs.take(4)) {
          noteBuf.writeln(
            '- ${ext.title} (${ext.referenceNumber}) — referenced on p.${ext.bookPage}; never invent its missing statutory text.',
          );
        }
      }
      extraKnowledgeNotes = noteBuf.toString();
    } else {
      final searchRes = await _corpus.search(rewritten, limit: 4);
      retrieved = searchRes.valueOrNull ?? const <LegalSectionModel>[];
      if (documentContext != null && documentContext.trim().isNotEmpty) {
        selectedDocChunks = LocalRagEngine.retrieveDocumentChunks(
          query: rewritten,
          documentText: documentContext,
          maxChunks: 4,
        );
      }
    }

    final corpusContext = retrieved.isEmpty
        ? 'No matching local statutory section was retrieved.'
        : '${retrieved.map((s) => '[${s.actCode} ${s.sectionNumber}] ${s.title} (${s.chapter})${s.legacyMapping != null ? ' ${s.legacyMapping}' : ''}\n${_truncate(s.text, 700)}').join('\n\n')}$extraKnowledgeNotes';

    final docPrefix = selectedDocChunks.isNotEmpty
        ? 'Relevant excerpts from attached document (${selectedDocChunks.length} chunk(s)):\n${selectedDocChunks.map((c) => '[Page ${c.pageNumber}, Chunk ${c.chunkIndex + 1}] ${c.text}').join('\n\n')}\n\n'
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

    return ResearchQueryPlan(
      retrieved: retrieved,
      systemPrompt: systemPrompt,
      userPrompt: userPrompt,
      intent: intent,
      ragBundle: ragBundle,
    );
  }

  /// Engine label of the active/most-recent LLM execution.
  String get activeEngineLabel {
    final llm = _llm;
    if (llm is ModelRouter) {
      return llm.lastResolvedEngineLabel;
    }
    return llm.isOnDevice ? 'Gemma 4 · On-Device' : 'Cloud · Gemma 4';
  }

  /// Streams tokens from the LLM, then returns a verified [VerifiedResearchAnswer]
  /// via [verifyAnswer].
  Stream<String> streamAnswer({
    required String systemPrompt,
    required String userPrompt,
    List<LlmMessage> history = const [],
    LlmGenerationOptions options = const LlmGenerationOptions(),
    RoutingTaskKind taskKind = RoutingTaskKind.shortPrivate,
    CloudConsentRequester? consentOverride,
  }) {
    final messages = <LlmMessage>[
      ...history,
      LlmMessage(role: LlmRole.user, content: userPrompt),
    ];
    final llm = _llm;
    final genOptions = LlmGenerationOptions(
      temperature: options.temperature,
      maxOutputTokens: options.maxOutputTokens,
      systemInstruction: systemPrompt,
    );
    if (llm is ModelRouter) {
      return llm.chat(
        messages,
        options: genOptions,
        taskKind: taskKind,
        consentOverride: consentOverride,
      );
    }
    return llm.chat(messages, options: genOptions);
  }

  /// Calls the bounded cloud `/v1/research/verified` workflow when cloud inference
  /// is explicitly chosen and maps its Module G provenance blocks into [VerifiedResearchAnswer].
  Future<VerifiedResearchAnswer?> tryCloudVerifiedResearch({
    required CloudGemmaService cloudService,
    required String question,
  }) async {
    final res = await cloudService.verifiedResearch(question);
    final data = res.valueOrNull;
    if (data == null) return null;

    final rawCitations =
        data['verified_citations'] as List<dynamic>? ?? const [];
    final citations = rawCitations.whereType<Map<String, dynamic>>().map((c) {
      final ref = (c['canonical_ref'] as String? ?? '').trim();
      final parts = ref.split(':');
      final act = parts.length >= 2 ? parts[0] : 'CONST';
      final num = parts.isNotEmpty ? parts.last : ref;
      return VerifiedCitation(
        actCode: act,
        sectionNumber: num,
        verified: c['verified'] as bool? ?? true,
        sectionTitle: c['title'] as String?,
      );
    }).toList();

    final prov = data['provenance'] as Map<String, dynamic>? ?? const {};
    final officialExcerpts =
        (prov['official_provisions'] as List<dynamic>? ?? const [])
            .whereType<Map<String, dynamic>>()
            .map(
              (p) =>
                  '${p['canonical_ref']} (${p['title']}): ${p['excerpt'] ?? ''}',
            )
            .toList();
    final footnoteWarnings =
        (prov['lifecycle_warnings'] as List<dynamic>? ?? const [])
            .map((e) => e.toString())
            .toList();
    final externalNotices =
        (prov['unloaded_external_acts'] as List<dynamic>? ?? const [])
            .whereType<Map<String, dynamic>>()
            .map((e) => '${e['title']} (Pending Review / Not Loaded)')
            .toList();

    final answerText = (data['answer_text'] as String? ?? '').trim();
    return VerifiedResearchAnswer(
      answerText: answerText.isEmpty ? verifyNotice : answerText,
      citations: citations,
      confidence: citations.isNotEmpty
          ? ConfidenceLevel.high
          : ConfidenceLevel.medium,
      reasoningTrail:
          'Cloud bounded workflow (${data['intent'] ?? 'legal_research'}) via ${data['provider'] ?? 'gemini'} (${data['model'] ?? 'gemma-4'}).',
      counterArguments: 'Verify all statutory & constitutional amendments against the official India Code portal.',
      droppedUnverifiedCount: 0,
      provenance: ProvenanceAnswerBlocks(
        intentLabel: data['intent'] as String? ?? 'Legal Research',
        officialTextExcerpts: officialExcerpts,
        footnoteWarnings: footnoteWarnings,
        unavailableExternalNotices: externalNotices,
      ),
    );
  }

  /// Runs the deterministic VERIFIER PASS over [rawAnswer] against the corpus
  /// using canonical [LegalReferenceResolver] extraction (Constitution, BNS/BNSS/BSA,
  /// DPDP, IT Act, etc.).
  Future<VerifiedResearchAnswer> verifyAnswer({
    required String rawAnswer,
    required List<LegalSectionModel> retrieved,
    required bool strictCitationsOnly,
    RagRetrievalBundle? ragBundle,
    ClassifiedQueryIntent? intent,
  }) async {
    final extractedRefs = LegalReferenceResolver.extractAll(rawAnswer);

    final verified = <VerifiedCitation>[];
    final seen = <String>{};
    var droppedCount = 0;
    var sanitizedText = rawAnswer.trim();

    for (final ref in extractedRefs) {
      if (ref.family == LegalInstrumentFamily.judicialDecision ||
          ref.family == LegalInstrumentFamily.constitutionalOrder) {
        continue;
      }
      final key = '${ref.actCode}:${ref.provisionNumber}';
      if (!seen.add(key)) continue;

      final lookup = await _corpus.getSection(ref.actCode, ref.provisionNumber);
      if (lookup case Success(:final value)) {
        verified.add(
          VerifiedCitation(
            actCode: ref.actCode,
            sectionNumber: ref.provisionNumber,
            verified: true,
            sectionTitle: value.title,
          ),
        );
      } else {
        droppedCount += 1;
        if (strictCitationsOnly) {
          sanitizedText = sanitizedText.replaceAll(
            ref.rawMatch,
            '[unverified citation removed]',
          );
        } else {
          verified.add(
            VerifiedCitation(
              actCode: ref.actCode,
              sectionNumber: ref.provisionNumber,
              verified: false,
            ),
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

    final bundle = ragBundle;
    final intentLabel = intent?.intent.label ?? 'General Legal Research';
    final officialExcerpts = retrieved
        .take(3)
        .map(
          (s) =>
              '${s.actCode} ${s.sectionNumber} (${s.title}): ${_truncate(s.text, 220)}',
        )
        .toList();
    final footnoteWarnings = bundle == null
        ? const <String>[]
        : bundle.footnotes
              .where(
                (f) =>
                    f.footnoteType == 'judicial_invalidation' ||
                    f.footnoteType == 'commencement_unnotified' ||
                    f.footnoteType == 'amendment',
              )
              .take(3)
              .map(
                (f) =>
                    '[${f.provisionRef} · ${f.footnoteType} p.${f.bookPage}] ${_truncate(f.noteText, 180)}',
              )
              .toList();
    final judicialRulings = extractedRefs
        .where((r) => r.family == LegalInstrumentFamily.judicialDecision)
        .map((r) => r.displayLabel)
        .toList();
    final unavailableNotices = bundle == null
        ? const <String>[]
        : bundle.unavailableExternalRefs
              .take(3)
              .map(
                (ext) =>
                    '${ext.title} (${ext.referenceNumber}): referenced in book, full statutory text not loaded offline.',
              )
              .toList();

    return VerifiedResearchAnswer(
      answerText: sanitizedText,
      citations: verified,
      confidence: confidence,
      reasoningTrail: reasoning,
      counterArguments: counter,
      droppedUnverifiedCount: droppedCount,
      provenance: ProvenanceAnswerBlocks(
        intentLabel: intentLabel,
        officialTextExcerpts: officialExcerpts,
        footnoteWarnings: footnoteWarnings,
        judicialRulings: judicialRulings,
        unavailableExternalNotices: unavailableNotices,
      ),
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
