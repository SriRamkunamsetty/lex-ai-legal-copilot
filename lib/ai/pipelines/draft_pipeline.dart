// Private fields use named public parameters for readability across pipelines.
// ignore_for_file: prefer_initializing_formals
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:lex_copilot/ai/llm_service.dart';
import 'package:lex_copilot/ai/prompts/prompt_registry.dart';
import 'package:lex_copilot/core/errors/failure.dart';
import 'package:lex_copilot/core/result.dart';

/// Supported legal document drafting templates.
enum DraftTemplate {
  /// Residential or commercial leave & licence / rent agreement.
  rentAgreement(
    'Rent agreement',
    'rent_agreement',
    [
      'Landlord Name',
      'Tenant Name',
      'Property Address',
      'Monthly Rent (INR)',
      'Security Deposit (INR)',
      'Notice Period Days',
    ],
    ['parties', 'rent', 'deposit', 'notice', 'jurisdiction'],
  ),

  /// Mutual or one-way non-disclosure agreement.
  nda(
    'NDA',
    'nda',
    [
      'Disclosing Party',
      'Receiving Party',
      'Purpose',
      'Term (Years)',
      'Jurisdiction City',
    ],
    ['confidential', 'purpose', 'term', 'return', 'governing law'],
  ),

  /// Formal pre-litigation legal notice.
  legalNotice(
    'Legal notice',
    'legal_notice',
    [
      'Sender Name',
      'Recipient Name',
      'Subject Matter',
      'Amount Claimed (INR)',
      'Compliance Days',
    ],
    ['notice', 'facts', 'demand', 'compliance', 'consequences'],
  ),

  /// General sworn statement / declaration affidavit.
  affidavit(
    'Affidavit',
    'affidavit',
    [
      'Deponent Full Name',
      'Parent/Spouse Name',
      'Age & Occupation',
      'Residential Address',
      'Statement Subject',
    ],
    ['solemnly affirm', 'verification', 'deponent'],
  ),

  /// Employment offer letter & terms.
  employmentOffer(
    'Employment offer',
    'employment_offer',
    [
      'Company Name',
      'Candidate Name',
      'Role Title',
      'Annual CTC (INR)',
      'Joining Date',
      'Work Location',
    ],
    ['compensation', 'joining', 'probation', 'confidentiality', 'termination'],
  );

  new(this.label, this.storageKey, this.fieldKeys, this.mandatoryKeywords);

  /// Display name.
  final String label;

  /// Stable database key.
  final String storageKey;

  /// Ordered prompt form fields.
  final List<String> fieldKeys;

  /// Keywords checked by the mandatory-clause self-check.
  final List<String> mandatoryKeywords;
}

/// Result of [DraftPipeline.checkMandatoryClauses].
@immutable
class DraftSelfCheckResult {
  /// Creates a [DraftSelfCheckResult].
  const new({
    required this.placeholders,
    required this.missingMandatoryClauses,
    required this.hasLawyerNotice,
  });

  /// Unfilled `[Placeholder]` tokens still remaining in the generated draft.
  final List<String> placeholders;

  /// Mandatory template keywords absent from the generated text.
  final List<String> missingMandatoryClauses;

  /// Whether the mandatory advocate-review disclaimer is present.
  final bool hasLawyerNotice;
}

/// Generated draft artifact with self-check metadata.
@immutable
class GeneratedDraftResult {
  /// Creates a [GeneratedDraftResult].
  const new({
    required this.template,
    required this.content,
    required this.selfCheck,
  });

  /// Template used for generation.
  final DraftTemplate template;

  /// Draft body guaranteed to end with [DraftPipeline.lawyerReviewNotice].
  final String content;

  /// Self-check results over placeholders and mandatory clauses.
  final DraftSelfCheckResult selfCheck;
}

/// Template + field prefill + AI generation + mandatory-clause self-check.
class DraftPipeline {
  /// Creates a [DraftPipeline].
  const new({required LlmService llm, required PromptRegistry prompts})
    : _llm = llm,
      _prompts = prompts;

  final LlmService _llm;
  final PromptRegistry _prompts;

  /// Mandatory disclaimer always appended to every generated draft.
  static const String lawyerReviewNotice =
      'LAWYER REVIEW NOTICE: This draft is an AI-assisted starting template for informational use only. Review and customize it with a qualified advocate licensed in India before signing, notarizing, or filing.';

  /// Extracts initial field values for [template] from a saved scan summary/OCR.
  Map<String, String> prefillFieldsFromScan({
    required DraftTemplate template,
    required String ocrText,
    String? summaryJson,
  }) {
    final fields = <String, String>{};
    var parties = const <String>[];
    var amounts = const <String>[];
    var dates = const <String>[];

    if (summaryJson != null && summaryJson.trim().isNotEmpty) {
      try {
        final decoded = jsonDecode(summaryJson);
        if (decoded is Map<String, dynamic>) {
          parties = (decoded['parties'] as List? ?? const [])
              .map((e) => e.toString().trim())
              .where((s) => s.isNotEmpty)
              .toList();
          amounts = (decoded['amounts'] as List? ?? const [])
              .map((e) => e.toString().trim())
              .where((s) => s.isNotEmpty)
              .toList();
          dates = (decoded['dates'] as List? ?? const [])
              .map((e) => e.toString().trim())
              .where((s) => s.isNotEmpty)
              .toList();
        }
      } on FormatException {
        // Ignore malformed historical summary JSON.
      }
    }

    for (var i = 0; i < template.fieldKeys.length; i++) {
      final key = template.fieldKeys[i];
      final lower = key.toLowerCase();
      if ((lower.contains('party') ||
              lower.contains('landlord') ||
              lower.contains('tenant') ||
              lower.contains('sender') ||
              lower.contains('recipient') ||
              lower.contains('company') ||
              lower.contains('candidate') ||
              lower.contains('deponent')) &&
          parties.isNotEmpty) {
        fields[key] = i < parties.length ? parties[i] : parties.first;
      } else if ((lower.contains('amount') ||
              lower.contains('rent') ||
              lower.contains('ctc')) &&
          amounts.isNotEmpty) {
        fields[key] = amounts.first;
      } else if (lower.contains('date') && dates.isNotEmpty) {
        fields[key] = dates.first;
      } else if (lower.contains('subject') && ocrText.trim().isNotEmpty) {
        final snippet = ocrText.trim().replaceAll(RegExp(r'\s+'), ' ');
        fields[key] = snippet.length > 90
            ? '${snippet.substring(0, 90)}…'
            : snippet;
      }
    }
    return fields;
  }

  /// Generates a draft for [template] with [fields], ensures `[placeholders]`
  /// for blanks and [lawyerReviewNotice] at the bottom, and runs self-check.
  Future<Result<GeneratedDraftResult>> generate({
    required DraftTemplate template,
    required Map<String, String> fields,
  }) async {
    final normalizedFields = <String, String>{
      for (final key in template.fieldKeys)
        key: (fields[key]?.trim().isNotEmpty ?? false)
            ? fields[key]!.trim()
            : '[$key]',
    };

    final prompt = await _prompts.render(
      LexPromptId.draftGenerate,
      variables: {
        'template_name': template.label,
        'fields_json': jsonEncode(normalizedFields),
      },
    );

    final buffer = StringBuffer();
    try {
      await _llm
          .chat([
            LlmMessage(role: LlmRole.user, content: prompt),
          ], options: const LlmGenerationOptions(maxOutputTokens: 1400))
          .forEach(buffer.write);
    } on Object catch (error) {
      if (buffer.isEmpty) {
        // Fallback template ensures offline usability even before model download.
        final fallback = _renderFallbackTemplate(template, normalizedFields);
        return Success(_finalizeDraft(template, fallback));
      }
      return Err(
        AiFailure('Draft generation interrupted: $error', cause: error),
      );
    }

    final raw = buffer.toString().trim();
    final draftBody = raw.length < 40
        ? _renderFallbackTemplate(template, normalizedFields)
        : raw;

    return Success(_finalizeDraft(template, draftBody));
  }

  /// Inspects [content] for remaining `[Placeholder]` markers, mandatory
  /// clauses required for [template], and presence of [lawyerReviewNotice].
  DraftSelfCheckResult checkMandatoryClauses({
    required DraftTemplate template,
    required String content,
  }) {
    final placeholderMatches = RegExp(r'\[([^\[\]\n]{2,60})\]')
        .allMatches(content)
        .map((m) => '[${m.group(1)!.trim()}]')
        .toSet()
        .toList();

    final lower = content.toLowerCase();
    final missingClauses = <String>[
      for (final keyword in template.mandatoryKeywords)
        if (!lower.contains(keyword.toLowerCase())) keyword,
    ];

    final hasNotice = lower.contains('lawyer review notice');

    return DraftSelfCheckResult(
      placeholders: placeholderMatches,
      missingMandatoryClauses: missingClauses,
      hasLawyerNotice: hasNotice,
    );
  }

  GeneratedDraftResult _finalizeDraft(DraftTemplate template, String body) {
    var finalText = body.trim();
    if (!finalText.toLowerCase().contains('lawyer review notice')) {
      finalText = '$finalText\n\n---\n$lawyerReviewNotice';
    }
    return GeneratedDraftResult(
      template: template,
      content: finalText,
      selfCheck: checkMandatoryClauses(template: template, content: finalText),
    );
  }

  String _renderFallbackTemplate(
    DraftTemplate template,
    Map<String, String> f,
  ) {
    String v(String k) => f[k] ?? '[$k]';
    return switch (template) {
      DraftTemplate.rentAgreement =>
        '''
RESIDENTIAL RENTAL / LEAVE & LICENCE AGREEMENT

This Rent Agreement is made between ${v('Landlord Name')} ("Landlord") and ${v('Tenant Name')} ("Tenant") regarding the premises situated at ${v('Property Address')}.

1. PARTIES & PREMISES
The Landlord agrees to let out the above-mentioned premises for residential use only.

2. MONTHLY RENT & SECURITY DEPOSIT
The Tenant shall pay a monthly rent of ${v('Monthly Rent (INR)')} on or before the 5th day of each calendar month, together with a refundable security deposit of ${v('Security Deposit (INR)')} payable upon handover.

3. TERM & NOTICE PERIOD
Either party may terminate this Agreement by providing ${v('Notice Period Days')} days prior written notice.

4. REPAIRS & UTILITIES
Routine minor maintenance and electricity/water charges as per actual meter readings shall be borne by the Tenant.

5. JURISDICTION & GOVERNING LAW
This Agreement shall be governed by applicable Indian tenancy laws and subject to local civil court jurisdiction.''',
      DraftTemplate.nda =>
        '''
MUTUAL NON-DISCLOSURE AGREEMENT (NDA)

This Agreement is entered into between ${v('Disclosing Party')} and ${v('Receiving Party')} for the sole Purpose of ${v('Purpose')}.

1. CONFIDENTIAL INFORMATION
Non-public business, technical, or client data shared in connection with the Purpose shall remain strictly confidential.

2. OBLIGATIONS & TERM
This obligation of confidentiality remains effective for a term of ${v('Term (Years)')} years from the date of disclosure.

3. RETURN OR DESTRUCTION
Upon written request, all confidential materials and copies shall be returned or certified destroyed within 15 days.

4. GOVERNING LAW
Governed by the laws of India; courts at ${v('Jurisdiction City')} shall have exclusive jurisdiction.''',
      DraftTemplate.legalNotice =>
        '''
LEGAL NOTICE

To: ${v('Recipient Name')}
From / On behalf of: ${v('Sender Name')}

SUBJECT: Legal Notice regarding ${v('Subject Matter')}

1. STATEMENT OF FACTS
Under instructions from ${v('Sender Name')}, you are hereby placed on formal notice regarding ${v('Subject Matter')}.

2. DEMAND & COMPLIANCE
You are called upon to remit ${v('Amount Claimed (INR)')} / rectify the default within ${v('Compliance Days')} days from receipt of this notice.

3. LEGAL CONSEQUENCES
Failing compliance within the stipulated compliance window, my client reserves all civil and criminal remedies under Indian law at your sole cost and risk.''',
      DraftTemplate.affidavit =>
        '''
AFFIDAVIT

I, ${v('Deponent Full Name')}, S/o / D/o / W/o ${v('Parent/Spouse Name')}, ${v('Age & Occupation')}, residing at ${v('Residential Address')}, do hereby solemnly affirm and declare on oath as under:

1. That I am the deponent herein and competent to swear this affidavit.
2. That this statement relates to ${v('Statement Subject')}.
3. That the facts stated above are true and correct to the best of my personal knowledge and belief.

DEPONENT: ${v('Deponent Full Name')}

VERIFICATION
Verified at [Place] on [Date] that the contents of this affidavit are true and correct and nothing material has been concealed therefrom.''',
      DraftTemplate.employmentOffer =>
        '''
OFFER OF EMPLOYMENT

To: ${v('Candidate Name')}
Organization: ${v('Company Name')}

1. ROLE & JOINING
We are pleased to offer you the position of ${v('Role Title')} at ${v('Work Location')}, effective ${v('Joining Date')}.

2. COMPENSATION
Your total fixed annual CTC shall be ${v('Annual CTC (INR)')}, payable monthly subject to statutory deductions.

3. PROBATION, CONFIDENTIALITY & TERMINATION
You will undergo a [Probation Months]-month probation period, remain bound by standard workplace confidentiality policies, and termination thereafter requires [Notice Period Days] days written notice from either side.''',
    };
  }
}
