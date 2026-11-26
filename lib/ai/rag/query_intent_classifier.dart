import 'package:flutter/foundation.dart';

/// Legal query intent categories classified deterministically (Module F).
enum LexLegalIntent {
  /// Constitutional Articles, Fundamental Rights, Amendments, Schedules.
  constitutionalInterpretation('Constitutional Law', ['CONST']),

  /// Criminal offences, BNS / IPC / snatching / theft / fraud.
  criminalOffence('Criminal Law', ['BNS', 'BNSS', 'BSA']),

  /// Police / FIR / procedural / court jurisdiction guidance.
  proceduralRemedy('Procedural / Remedy', ['BNSS', 'CPC_1908', 'CONST']),

  /// Contract clauses, indemnity, termination, breach risk.
  contractRisk('Contract Analysis', ['ICA_1872']),

  /// Legal drafting templates & document structure.
  documentDraft('Document Drafting', ['ICA_1872']),

  /// Data privacy, consent, DPDP Act 2023, cyber duties.
  complianceDpdp('DPDP & Cyber Compliance', ['DPDP_2023', 'IT_2000']),

  /// Checking repealed, omitted, un-notified, or judicially struck-down provisions.
  amendmentStatusCheck('Amendment & Validity Check', ['CONST', 'BNS', 'BNSS']),

  /// General Indian statutory / legal Q&A.
  generalLegalQuery('General Legal Research', <String>[]);

  new(this.label, this.preferredActCodes);

  /// Human-readable intent classification label.
  final String label;

  /// Canonical act codes prioritized during hybrid retrieval.
  final List<String> preferredActCodes;
}

/// Classification output from [QueryIntentClassifier].
@immutable
class ClassifiedQueryIntent {
  /// Creates a [ClassifiedQueryIntent].
  const new({
    required this.intent,
    required this.preferredActCodes,
    required this.rationale,
  });

  /// Primary detected legal intent.
  final LexLegalIntent intent;

  /// Priority act codes to boost in RAG.
  final List<String> preferredActCodes;

  /// Brief deterministic explanation of why this intent matched.
  final String rationale;
}

/// Deterministic zero-latency Legal Query Intent Classifier (Module F).
abstract final class QueryIntentClassifier {
  /// Classifies [query] (plus whether a document is attached) into a
  /// structured [ClassifiedQueryIntent].
  static ClassifiedQueryIntent classify(
    String query, {
    bool hasAttachedDocument = false,
  }) {
    final lower = query.toLowerCase();

    if (_hasAny(lower, const [
      'struck down',
      'omitted',
      'repealed',
      'unnotified',
      'valid',
      'in force',
      'amendment',
      'effective date',
      '106th',
      '99th',
      'njac',
    ])) {
      return const ClassifiedQueryIntent(
        intent: LexLegalIntent.amendmentStatusCheck,
        preferredActCodes: ['CONST', 'BNS', 'BNSS'],
        rationale: 'Query checks amendment commencement, repeal, or judicial invalidation status.',
      );
    }

    if (_hasAny(lower, const [
      'dpdp',
      'personal data',
      'data fiduciary',
      'data principal',
      'consent manager',
      'privacy compliance',
      'cyber',
      'it act',
      'electronic signature',
      '66c',
      '43a',
    ])) {
      return const ClassifiedQueryIntent(
        intent: LexLegalIntent.complianceDpdp,
        preferredActCodes: ['DPDP_2023', 'IT_2000'],
        rationale: 'Matched Indian data protection or IT Act terms.',
      );
    }

    if (_hasAny(lower, const [
      'article ',
      'art.',
      'art ',
      'constitution',
      'fundamental right',
      'preamble',
      'schedule',
      'writ',
      'habeas corpus',
      '370',
      'c.o.',
    ])) {
      return const ClassifiedQueryIntent(
        intent: LexLegalIntent.constitutionalInterpretation,
        preferredActCodes: ['CONST'],
        rationale: 'Matched Constitutional Articles, Preamble, or Schedules.',
      );
    }

    if (_hasAny(lower, const [
          'indemnity',
          'termination',
          'non-compete',
          'arbitration clause',
          'liquidated damages',
          'contract risk',
          'redline',
          'vendor agreement',
        ]) ||
        (hasAttachedDocument && lower.contains('clause'))) {
      return const ClassifiedQueryIntent(
        intent: LexLegalIntent.contractRisk,
        preferredActCodes: ['ICA_1872'],
        rationale: 'Matched commercial contract risk and clause review terms.',
      );
    }

    if (_hasAny(lower, const [
      'draft ',
      'notice format',
      'nda',
      'rent agreement',
      'affidavit',
      'offer letter',
    ])) {
      return const ClassifiedQueryIntent(
        intent: LexLegalIntent.documentDraft,
        preferredActCodes: ['ICA_1872'],
        rationale: 'Matched legal document drafting intent.',
      );
    }

    if (_hasAny(lower, const [
      'fir',
      'zero fir',
      'police',
      'bail',
      'remand',
      'limitation period',
      'jurisdiction',
      'bnss',
      'cpc',
      'summons',
    ])) {
      return const ClassifiedQueryIntent(
        intent: LexLegalIntent.proceduralRemedy,
        preferredActCodes: ['BNSS', 'CPC_1908', 'CONST'],
        rationale: 'Matched procedural filing, FIR, or court remedy terms.',
      );
    }

    if (_hasAny(lower, const [
      'bns',
      'theft',
      'snatching',
      'robbery',
      'cheating',
      'fraud',
      'assault',
      'punishment',
      'offence',
      'bsa',
      'evidence',
    ])) {
      return const ClassifiedQueryIntent(
        intent: LexLegalIntent.criminalOffence,
        preferredActCodes: ['BNS', 'BNSS', 'BSA'],
        rationale: 'Matched Indian criminal & evidence code terms.',
      );
    }

    return const ClassifiedQueryIntent(
      intent: LexLegalIntent.generalLegalQuery,
      preferredActCodes: <String>[],
      rationale: 'Broad Indian statutory research query.',
    );
  }

  static bool _hasAny(String input, List<String> needles) {
    for (final n in needles) {
      if (input.contains(n)) return true;
    }
    return false;
  }
}
