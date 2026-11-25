import 'dart:convert';

import 'package:lex_copilot/core/errors/failure.dart';
import 'package:lex_copilot/core/result.dart';

/// Validates and repairs raw LLM JSON text against required keys and types.
abstract final class SchemaValidator {
  /// Extracts the first JSON object from [rawOutput], stripping markdown fences
  /// if present, and checks all `required` fields in [jsonSchema].
  static Result<Map<String, dynamic>> parseAndValidate(
    String rawOutput,
    Map<String, dynamic> jsonSchema,
  ) {
    final cleaned = _extractJsonObject(rawOutput);
    if (cleaned == null) {
      return const Err(
        ValidationFailure('Model output did not contain a valid JSON object.'),
      );
    }

    try {
      final decoded = jsonDecode(cleaned);
      if (decoded is! Map<String, dynamic>) {
        return const Err(
          ValidationFailure('Parsed JSON root is not an object.'),
        );
      }

      final requiredFields = jsonSchema['required'];
      if (requiredFields is List) {
        for (final key in requiredFields.whereType<String>()) {
          if (!decoded.containsKey(key) || decoded[key] == null) {
            return Err(
              ValidationFailure('Missing required JSON field "$key".'),
            );
          }
        }
      }

      final properties = jsonSchema['properties'];
      if (properties is Map<String, dynamic>) {
        for (final entry in properties.entries) {
          if (!decoded.containsKey(entry.key) || decoded[entry.key] == null) {
            continue;
          }
          final propDef = entry.value;
          if (propDef is Map<String, dynamic>) {
            final expectedType = propDef['type'] as String?;
            if (expectedType != null &&
                !_matchesType(decoded[entry.key], expectedType)) {
              return Err(
                ValidationFailure(
                  'Field "${entry.key}" expected $expectedType.',
                ),
              );
            }
          }
        }
      }

      return Success(decoded);
    } on FormatException catch (error) {
      return Err(
        ValidationFailure('Malformed JSON: ${error.message}', cause: error),
      );
    }
  }

  static String? _extractJsonObject(String raw) {
    final trimmed = raw.trim();
    final fenceMatch = RegExp(
      r'```(?:json)?\s*([\s\S]*?)\s*```',
      caseSensitive: false,
    ).firstMatch(trimmed);
    final candidate = fenceMatch != null
        ? fenceMatch.group(1)!.trim()
        : trimmed;

    final start = candidate.indexOf('{');
    final end = candidate.lastIndexOf('}');
    if (start < 0 || end <= start) return null;
    return candidate.substring(start, end + 1);
  }

  static bool _matchesType(Object? value, String expectedType) =>
      switch (expectedType) {
        'string' => value is String,
        'integer' => value is int,
        'number' => value is num,
        'boolean' => value is bool,
        'array' => value is List,
        'object' => value is Map,
        _ => true,
      };
}
