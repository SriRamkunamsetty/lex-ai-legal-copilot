// Private fields use named public parameters for readability across pipelines.
// ignore_for_file: prefer_initializing_formals
import 'package:flutter/foundation.dart';
import 'package:lex_copilot/ai/llm_service.dart';
import 'package:lex_copilot/ai/prompts/prompt_registry.dart';
import 'package:lex_copilot/core/errors/failure.dart';
import 'package:lex_copilot/core/result.dart';
import 'package:lex_copilot/legal_corpus/models/legal_section.dart';
import 'package:lex_copilot/legal_corpus/repository/legal_corpus_repository.dart';

/// Preset incident categories shown on the Incident screen.
enum IncidentCategory {
  /// Phone/chain snatching, theft, robbery.
  theft('Theft', 'theft snatching robbery stolen BNS 303 304 309 BNSS 173'),

  /// Road/motor accident & rash driving.
  accident(
    'Accident',
    'rash driving negligent hurt death accident BNS 281 106',
  ),

  /// Dishonoured cheque / payment default.
  chequeBounce(
    'Cheque bounce',
    'cheating dishonesty property payment BNSS 173',
  ),

  /// Online / UPI / OTP / impersonation fraud.
  cyberFraud(
    'Cyber fraud',
    'cheating personation forgery electronic record BNS 318 319 BSA 63',
  ),

  /// Landlord/tenant lockout, trespass, or intimidation.
  tenancy(
    'Tenancy',
    'criminal trespass intimidation wrongful restraint BNS 329 351 126',
  ),

  /// Workplace harassment, assault, or wage/document withholding.
  workplace(
    'Workplace',
    'criminal intimidation assault insult modesty BNS 351 74 79',
  );

  new(this.label, this.searchExpansion);

  /// Chip label.
  final String label;

  /// Grounded statutory search expansion keywords.
  final String searchExpansion;
}

/// Verified statutory match paired with rationale.
@immutable
class IncidentProvisionMatch {
  /// Creates an [IncidentProvisionMatch].
  const new({required this.section, required this.rationale});

  /// Corpus-verified statutory section.
  final LegalSectionModel section;

  /// Plain-language reason why this provision applies.
  final String rationale;
}

/// Complete structured output from [IncidentPipeline].
@immutable
class IncidentAnalysisResult {
  /// Creates an [IncidentAnalysisResult].
  const new({
    required this.category,
    required this.summary,
    required this.provisions,
    required this.nextSteps,
    required this.evidenceToKeep,
    required this.whereToReport,
  });

  /// Classified incident category.
  final String category;

  /// Plain-language overview.
  final String summary;

  /// Corpus-verified provisions ONLY (never fabricated).
  final List<IncidentProvisionMatch> provisions;

  /// Practical immediate steps to take.
  final List<String> nextSteps;

  /// Evidence to preserve for police/court.
  final List<String> evidenceToKeep;

  /// Appropriate reporting authority / helpline.
  final String whereToReport;
}

/// Pipeline mapping a user incident description (and optional category/photo)
/// to verified provisions in [LegalCorpusRepository].
class IncidentPipeline {
  /// Creates an [IncidentPipeline].
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

  static const Map<String, dynamic> _schema = {
    'type': 'object',
    'required': [
      'category',
      'summary',
      'cited_sections',
      'next_steps',
      'evidence_to_keep',
      'where_to_report',
    ],
    'properties': {
      'category': {'type': 'string'},
      'summary': {'type': 'string'},
      'cited_sections': {'type': 'array'},
      'next_steps': {'type': 'array'},
      'evidence_to_keep': {'type': 'array'},
      'where_to_report': {'type': 'string'},
    },
  };

  /// Analyzes [description] (with optional [category]) and returns ONLY
  /// provisions verified to exist in [LegalCorpusRepository].
  Future<Result<IncidentAnalysisResult>> analyze({
    required String description,
    IncidentCategory? category,
    List<Uint8List> images = const [],
  }) async {
    final trimmed = description.trim();
    if (trimmed.isEmpty && category == null) {
      return const Err(
        ValidationFailure('Describe the incident or choose an incident type.'),
      );
    }

    final query = [
      if (category != null) category.searchExpansion,
      trimmed,
    ].join(' ');

    final candidateRes = await _corpus.search(query, limit: 6);
    final candidates = candidateRes.valueOrNull ?? const <LegalSectionModel>[];

    // Always include BNSS 173 (FIR) when reporting a criminal incident.
    if (!candidates.any(
      (s) => s.actCode == 'BNSS' && s.sectionNumber == '173',
    )) {
      final firRes = await _corpus.getSection('BNSS', '173');
      if (firRes case Success(:final value)) {
        candidates.add(value);
      }
    }

    final candidateText = candidates
        .map(
          (s) =>
              '${s.actCode} ${s.sectionNumber} (${s.title}): ${s.plainLanguage ?? _firstLines(s.text)}',
        )
        .join('\n');

    final prompt = await _prompts.render(
      LexPromptId.incidentClassify,
      variables: {
        'candidates': candidateText,
        'incident_text': trimmed.isEmpty ? category!.label : trimmed,
      },
    );

    final schema = LlmSchema<Map<String, dynamic>>(
      name: 'incident_sections',
      jsonSchema: _schema,
      fromJson: (m) => m,
    );

    final aiRes = await _llm.structured(schema, prompt, images: images);

    if (aiRes case Success(:final value)) {
      final verifiedProvisions = <IncidentProvisionMatch>[];
      final rawCited = value['cited_sections'];
      if (rawCited is List) {
        for (final item in rawCited.whereType<Map<String, dynamic>>()) {
          final act = ((item['act_code'] ?? item['act']) as String? ?? '')
              .trim()
              .toUpperCase();
          final num =
              ((item['section_number'] ?? item['section']) as String? ?? '')
                  .trim();
          if (act.isEmpty || num.isEmpty) continue;
          // Corpus-only enforcement: drop anything absent from corpus.
          final check = await _corpus.getSection(act, num);
          if (check case Success(:final value)) {
            verifiedProvisions.add(
              IncidentProvisionMatch(
                section: value,
                rationale:
                    (item['rationale'] as String? ??
                            value.plainLanguage ??
                            value.title)
                        .trim(),
              ),
            );
          }
        }
      }

      if (verifiedProvisions.isEmpty) {
        verifiedProvisions.addAll(
          candidates
              .take(3)
              .map(
                (s) => IncidentProvisionMatch(
                  section: s,
                  rationale: s.plainLanguage ?? _firstLines(s.text),
                ),
              ),
        );
      }

      List<String> strList(String k) {
        final raw = value[k];
        return raw is List
            ? raw
                  .map((e) => e.toString().trim())
                  .where((s) => s.isNotEmpty)
                  .toList()
            : const [];
      }

      return Success(
        IncidentAnalysisResult(
          category:
              (value['category'] as String? ?? category?.label ?? 'Incident')
                  .trim(),
          summary: (value['summary'] as String? ?? '').trim(),
          provisions: verifiedProvisions,
          nextSteps: strList('next_steps').isNotEmpty
              ? strList('next_steps')
              : _defaultNextSteps(category),
          evidenceToKeep: strList('evidence_to_keep').isNotEmpty
              ? strList('evidence_to_keep')
              : _defaultEvidence(category),
          whereToReport:
              (value['where_to_report'] as String? ?? _defaultWhere(category))
                  .trim(),
        ),
      );
    }

    // Offline corpus-grounded deterministic fallback when AI is unavailable.
    return Success(
      IncidentAnalysisResult(
        category: category?.label ?? 'Incident analysis',
        summary:
            'Matched ${candidates.length} statutory provision(s) offline. Verify with official text — not legal advice.',
        provisions: candidates
            .take(4)
            .map(
              (s) => IncidentProvisionMatch(
                section: s,
                rationale: s.plainLanguage ?? _firstLines(s.text),
              ),
            )
            .toList(),
        nextSteps: _defaultNextSteps(category),
        evidenceToKeep: _defaultEvidence(category),
        whereToReport: _defaultWhere(category),
      ),
    );
  }

  static String _firstLines(String text) {
    final flat = text.replaceAll('\n', ' ').trim();
    return flat.length <= 140 ? flat : '${flat.substring(0, 140)}…';
  }

  static List<String> _defaultNextSteps(
    IncidentCategory? category,
  ) => switch (category) {
    IncidentCategory.cyberFraud => const [
      'Call 1930 immediately or report on cybercrime.gov.in to freeze disputed transfers.',
      'Notify your bank/UPI provider in writing to block compromised accounts.',
      'Register an FIR / Zero FIR under BNSS 173 at your nearest police station.',
    ],
    IncidentCategory.chequeBounce => const [
      'Obtain the bank cheque return memo stating the reason and date of dishonour.',
      'Send a formal written demand notice within 30 days of receiving the return memo.',
      'Consult an advocate regarding filing a complaint if unpaid after 15 days of notice.',
    ],
    _ => const [
      'Ensure immediate safety and dial 112 in an emergency.',
      'Submit an oral or written complaint / Zero FIR under BNSS 173 at the nearest police station.',
      'Obtain a free copy of the recorded FIR/acknowledgment.',
    ],
  };

  static List<String> _defaultEvidence(
    IncidentCategory? category,
  ) => switch (category) {
    IncidentCategory.cyberFraud => const [
      'UTR / transaction IDs, bank SMS alerts, and account statements.',
      'Screenshots of messages, caller IDs, and phishing links (keep original device data intact per BSA 63).',
    ],
    IncidentCategory.chequeBounce => const [
      'Original dishonoured cheque and bank return memo.',
      'Invoice/agreement establishing debt and postal/courier tracking receipt for the notice.',
    ],
    _ => const [
      'Purchase invoice/IMEI (if phone/property), photos of damage or injuries, and medical reports.',
      'Nearby CCTV locations/timestamps and contact details of any witnesses.',
    ],
  };

  static String _defaultWhere(IncidentCategory? category) => switch (category) {
    IncidentCategory.cyberFraud => 'National Cyber Crime Helpline 1930, cybercrime.gov.in, or nearest Police Station',
    IncidentCategory.workplace => 'Internal Committee (POSH), Labour Commissioner, or nearest Police Station',
    _ => 'Nearest Police Station (Zero FIR under BNSS 173) or Emergency 112',
  };
}
