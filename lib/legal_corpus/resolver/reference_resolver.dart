import 'package:flutter/foundation.dart';

/// Supported legal provision families for canonical identification (Module B).
enum LegalInstrumentFamily {
  /// Constitution of India (`CONST:*`).
  constitution,

  /// Central Parliamentary Acts (`CENTRAL:*`).
  centralAct,

  /// State Acts (`STATE:*`).
  stateAct,

  /// Presidential Constitutional Orders (`CO:*`).
  constitutionalOrder,

  /// Supreme Court / High Court Judgments (`SC:*`).
  judicialDecision,
}

/// Normalized legal reference parsed from a user query or AI response.
@immutable
class CanonicalLegalReference {
  /// Creates a [CanonicalLegalReference].
  const new({
    required this.canonicalRef,
    required this.family,
    required this.actCode,
    required this.provisionNumber,
    required this.displayLabel,
    required this.rawMatch,
  });

  /// Canonical key (`CONST:ART:21`, `CENTRAL:BNS:304`, `CO:272`, `SC:...`).
  final String canonicalRef;

  /// Legal instrument classification.
  final LegalInstrumentFamily family;

  /// Normalized short code stored in `LegalSections` (`CONST`, `BNS`, `DPDP_2023`, `IT_2000`, etc.).
  final String actCode;

  /// Normalized provision number (`21`, `304`, `PREAMBLE`, `SCH:9`, `66C`).
  final String provisionNumber;

  /// Human-readable short citation badge (`Art. 21`, `BNS 304`, `IT Act 66C`).
  final String displayLabel;

  /// Exact matched substring from source text.
  final String rawMatch;
}

/// Canonical Indian Legal Reference Resolver & Normalizer (Module B).
///
/// Resolves Constitutional Articles, Schedules, Appendices, C.O.s, Criminal
/// Codes (`BNS`/`BNSS`/`BSA`), Priority Civil/Cyber/Data Acts (`DPDP_2023`,
/// `IT_2000`, `ICA_1872`, `NI_1881`, `CPC_1908`), and Supreme Court citations.
abstract final class LegalReferenceResolver {
  static final RegExp _articleRe = RegExp(
    r'\b(?:Articles?|Arts?\.?)\s+(\d+[A-Z]{0,2})(?:\(\d+\))?(?:\([a-z]{1,2}\))?\b',
    caseSensitive: false,
  );

  static final RegExp _preambleRe = RegExp(
    r'\bPreamble\b(?:\s+of\s+the\s+Constitution)?',
    caseSensitive: false,
  );

  static final RegExp _scheduleRe = RegExp(
    r'\b(1st|First|2nd|Second|3rd|Third|4th|Fourth|5th|Fifth|6th|Sixth|7th|Seventh|8th|Eighth|9th|Ninth|10th|Tenth|11th|Eleventh|12th|Twelfth)\s+Schedule\b',
    caseSensitive: false,
  );

  static final RegExp _criminalRe = RegExp(
    r'\b(BNS|BNSS|BSA)\s+(?:Sections?\s+|Secs?\.?\s+|s\.?\s*)?(\d+[A-Z]?)\b',
    caseSensitive: false,
  );

  static final RegExp _centralActRe = RegExp(
    r'\b(DPDP(?:\s+Act)?(?:\s*,?\s*2023)?|Digital Personal Data Protection Act(?:\s*,?\s*2023)?|IT\s+Act(?:\s*,?\s*2000)?|Information Technology Act(?:\s*,?\s*2000)?|NI\s+Act(?:\s*,?\s*1881)?|Negotiable Instruments Act(?:\s*,?\s*1881)?|Indian\s+Contract\s+Act(?:\s*,?\s*1872)?|ICA|CPC(?:\s*,?\s*1908)?)(?:,?\s*(?:(?:Sections?|Secs?\.?|s\.?)\s+)?(\d+[A-Z]?))?\b',
    caseSensitive: false,
  );

  static final RegExp _coRe = RegExp(
    r'\bC\.O\.\s*(\d+)\b',
    caseSensitive: false,
  );

  static final RegExp _scRe = RegExp(
    r'((?:AIR\s+\d{4}\s+SC\s+\d+)|(?:\(\d{4}\)\s+\d+\s+SCC\s+\d+))',
    caseSensitive: false,
  );

  static const Map<String, String> _scheduleWordToNum = {
    '1st': '1',
    'first': '1',
    '2nd': '2',
    'second': '2',
    '3rd': '3',
    'third': '3',
    '4th': '4',
    'fourth': '4',
    '5th': '5',
    'fifth': '5',
    '6th': '6',
    'sixth': '6',
    '7th': '7',
    'seventh': '7',
    '8th': '8',
    'eighth': '8',
    '9th': '9',
    'ninth': '9',
    '10th': '10',
    'tenth': '10',
    '11th': '11',
    'eleventh': '11',
    '12th': '12',
    'twelfth': '12',
  };

  /// Extracts all normalized canonical legal references found in [input].
  static List<CanonicalLegalReference> extractAll(String input) {
    final results = <CanonicalLegalReference>[];
    final seen = <String>{};

    void addRef(CanonicalLegalReference ref) {
      if (seen.add(ref.canonicalRef)) {
        results.add(ref);
      }
    }

    for (final m in _criminalRe.allMatches(input)) {
      final act = m.group(1)!.toUpperCase();
      final num = m.group(2)!.toUpperCase();
      addRef(
        CanonicalLegalReference(
          canonicalRef: 'CENTRAL:$act:$num',
          family: LegalInstrumentFamily.centralAct,
          actCode: act,
          provisionNumber: num,
          displayLabel: '$act $num',
          rawMatch: m.group(0)!,
        ),
      );
    }

    for (final m in _articleRe.allMatches(input)) {
      final num = m.group(1)!.toUpperCase();
      addRef(
        CanonicalLegalReference(
          canonicalRef: 'CONST:ART:$num',
          family: LegalInstrumentFamily.constitution,
          actCode: 'CONST',
          provisionNumber: num,
          displayLabel: 'Art. $num',
          rawMatch: m.group(0)!,
        ),
      );
    }

    for (final m in _preambleRe.allMatches(input)) {
      addRef(
        CanonicalLegalReference(
          canonicalRef: 'CONST:PREAMBLE',
          family: LegalInstrumentFamily.constitution,
          actCode: 'CONST',
          provisionNumber: 'PREAMBLE',
          displayLabel: 'Preamble',
          rawMatch: m.group(0)!,
        ),
      );
    }

    for (final m in _scheduleRe.allMatches(input)) {
      final word = m.group(1)!.toLowerCase();
      final num = _scheduleWordToNum[word];
      if (num != null) {
        addRef(
          CanonicalLegalReference(
            canonicalRef: 'CONST:SCH:$num',
            family: LegalInstrumentFamily.constitution,
            actCode: 'CONST',
            provisionNumber: 'SCH:$num',
            displayLabel: 'Schedule $num',
            rawMatch: m.group(0)!,
          ),
        );
      }
    }

    for (final m in _centralActRe.allMatches(input)) {
      final rawAct = m.group(1)!.toLowerCase();
      final sec = m.group(2)?.toUpperCase();
      final String actCode;
      final String shortName;
      if (rawAct.contains('dpdp') || rawAct.contains('data protection')) {
        actCode = 'DPDP_2023';
        shortName = 'DPDP Act';
      } else if (rawAct.contains('it') ||
          rawAct.contains('information technology')) {
        actCode = 'IT_2000';
        shortName = 'IT Act';
      } else if (rawAct.contains('negotiable') || rawAct.startsWith('ni')) {
        actCode = 'NI_1881';
        shortName = 'NI Act';
      } else if (rawAct.contains('contract') || rawAct == 'ica') {
        actCode = 'ICA_1872';
        shortName = 'Contract Act';
      } else {
        actCode = 'CPC_1908';
        shortName = 'CPC';
      }
      if (sec != null && sec.isNotEmpty) {
        addRef(
          CanonicalLegalReference(
            canonicalRef: 'CENTRAL:$actCode:$sec',
            family: LegalInstrumentFamily.centralAct,
            actCode: actCode,
            provisionNumber: sec,
            displayLabel: '$shortName s.$sec',
            rawMatch: m.group(0)!,
          ),
        );
      }
    }

    for (final m in _coRe.allMatches(input)) {
      final coNum = m.group(1)!;
      addRef(
        CanonicalLegalReference(
          canonicalRef: 'CO:$coNum',
          family: LegalInstrumentFamily.constitutionalOrder,
          actCode: 'CO',
          provisionNumber: coNum,
          displayLabel: 'C.O. $coNum',
          rawMatch: m.group(0)!,
        ),
      );
    }

    for (final m in _scRe.allMatches(input)) {
      final rawCit = m.group(1)!.trim();
      final slug = rawCit
          .replaceAll(RegExp('[^A-Za-z0-9]+'), '_')
          .replaceAll(RegExp(r'^_+|_+$'), '')
          .toUpperCase();
      addRef(
        CanonicalLegalReference(
          canonicalRef: 'SC:$slug',
          family: LegalInstrumentFamily.judicialDecision,
          actCode: 'SC',
          provisionNumber: slug,
          displayLabel: rawCit,
          rawMatch: rawCit,
        ),
      );
    }

    return results;
  }

  /// Resolves a single short citation query (e.g. `"Art 21"`, `"BNS 304"`,
  /// `"Constitution 368"`, `"Schedule 9"`) or returns `null`.
  static CanonicalLegalReference? parseSingle(String query) {
    final all = extractAll(query);
    if (all.isNotEmpty) return all.first;

    final plainConst = RegExp(
      r'^(?:CONST(?:ITUTION)?\s+)?(\d+[A-Z]{0,2})$',
      caseSensitive: false,
    ).firstMatch(query.trim());
    if (plainConst != null && query.trim().toLowerCase().contains('const')) {
      final num = plainConst.group(1)!.toUpperCase();
      return CanonicalLegalReference(
        canonicalRef: 'CONST:ART:$num',
        family: LegalInstrumentFamily.constitution,
        actCode: 'CONST',
        provisionNumber: num,
        displayLabel: 'Art. $num',
        rawMatch: query,
      );
    }
    return null;
  }
}
