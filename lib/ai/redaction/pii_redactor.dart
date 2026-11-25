import 'package:flutter/foundation.dart';

/// Result of redacting PII before sending text to a cloud LLM.
@immutable
class RedactionResult {
  /// Creates a [RedactionResult].
  const new({required this.redactedText, required this.tokenMap});

  /// Text with PII replaced by deterministic placeholders such as `[AADHAAR_1]`.
  final String redactedText;

  /// Mapping from placeholder token back to original sensitive value.
  final Map<String, String> tokenMap;

  /// Restores original values into [text] after receiving a cloud response.
  String restore(String text) => PiiRedactor.restore(text, tokenMap);
}

/// Deterministic PII redactor and restorer for Indian legal documents and chats.
///
/// Always runs before any cloud AI request and before emitting diagnostic logs.
abstract final class PiiRedactor {
  static final RegExp _aadhaarRegex = RegExp(
    r'\b\d{4}[\s-]?\d{4}[\s-]?\d{4}\b',
  );
  static final RegExp _panRegex = RegExp(r'\b[A-Z]{5}\d{4}[A-Z]\b');
  static final RegExp _phoneRegex = RegExp(
    r'(?<!\d)(?:\+91[\s-]?)?[6-9]\d{9}(?!\d)',
  );
  static final RegExp _emailRegex = RegExp(
    r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}\b',
  );
  static final RegExp _ifscRegex = RegExp(r'\b[A-Z]{4}0[A-Z0-9]{6}\b');
  static final RegExp _upiRegex = RegExp(
    r'\b[a-zA-Z0-9._-]{2,}@(?:okaxis|okicici|okhdfcbank|oksbi|ybl|paytm|upi|ibl)\b',
    caseSensitive: false,
  );
  static final RegExp _accountRegex = RegExp(
    r'\b(?:a/c|acct|account)\s*(?:no\.?|number|#)?\s*[:\-]?\s*(\d{9,18})\b',
    caseSensitive: false,
  );

  /// Redacts detected PII patterns and any explicit [knownNames] from [input].
  static RedactionResult redact(
    String input, {
    List<String> knownNames = const [],
  }) {
    if (input.isEmpty) {
      return const RedactionResult(redactedText: '', tokenMap: {});
    }

    var current = input;
    final tokenMap = <String, String>{};
    final valueToToken = <String, String>{};
    final counters = <String, int>{};

    String tokenFor(String category, String original) {
      final existing = valueToToken[original];
      if (existing != null) return existing;
      final next = (counters[category] ?? 0) + 1;
      counters[category] = next;
      final token = '[${category}_$next]';
      valueToToken[original] = token;
      tokenMap[token] = original;
      return token;
    }

    // Replace explicit party names longest-first to avoid partial matches.
    final sortedNames =
        knownNames.map((n) => n.trim()).where((n) => n.length >= 2).toList()
          ..sort((a, b) => b.length.compareTo(a.length));

    for (final name in sortedNames) {
      final escaped = RegExp.escape(name);
      final nameRegex = RegExp('\\b$escaped\\b', caseSensitive: false);
      current = current.replaceAllMapped(
        nameRegex,
        (m) => tokenFor('PERSON', m.group(0)!),
      );
    }

    current = current.replaceAllMapped(
      _emailRegex,
      (m) => tokenFor('EMAIL', m.group(0)!),
    );
    current = current.replaceAllMapped(
      _upiRegex,
      (m) => tokenFor('UPI', m.group(0)!),
    );
    current = current.replaceAllMapped(
      _panRegex,
      (m) => tokenFor('PAN', m.group(0)!),
    );
    current = current.replaceAllMapped(
      _ifscRegex,
      (m) => tokenFor('IFSC', m.group(0)!),
    );
    current = current.replaceAllMapped(_accountRegex, (m) {
      final acct = m.group(1)!;
      final token = tokenFor('ACCOUNT', acct);
      return m.group(0)!.replaceFirst(acct, token);
    });
    current = current.replaceAllMapped(
      _aadhaarRegex,
      (m) => tokenFor('AADHAAR', m.group(0)!),
    );
    current = current.replaceAllMapped(
      _phoneRegex,
      (m) => tokenFor('PHONE', m.group(0)!),
    );

    return RedactionResult(redactedText: current, tokenMap: tokenMap);
  }

  /// Restores redacted tokens in [text] using [tokenMap].
  static String restore(String text, Map<String, String> tokenMap) {
    if (tokenMap.isEmpty || text.isEmpty) return text;
    var restored = text;
    for (final entry in tokenMap.entries) {
      restored = restored.replaceAll(entry.key, entry.value);
    }
    return restored;
  }

  /// Irreversibly scrubs PII before writing safe diagnostic log messages.
  static String redactForLogging(String input) => redact(input).redactedText;
}
