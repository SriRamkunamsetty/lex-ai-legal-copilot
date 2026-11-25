import 'package:flutter_test/flutter_test.dart';
import 'package:lex_copilot/ai/schemas/schema_validator.dart';
import 'package:lex_copilot/core/errors/failure.dart';

void main() {
  group('SchemaValidator', () {
    const schema = {
      'type': 'object',
      'required': ['risk_score', 'clauses'],
      'properties': {
        'risk_score': {'type': 'integer'},
        'clauses': {'type': 'array'},
      },
    };

    test('parses fenced JSON object and validates required types', () {
      const raw = '''
Here is the review:
```json
{"risk_score": 72, "clauses": [{"title": "Indemnity"}]}
```
''';
      final result = SchemaValidator.parseAndValidate(raw, schema);
      expect(result.isSuccess, isTrue);
      expect(result.valueOrNull?['risk_score'], 72);
    });

    test('returns ValidationFailure on missing field or type mismatch', () {
      final missing = SchemaValidator.parseAndValidate(
        '{"risk_score": 40}',
        schema,
      );
      expect(missing.isErr, isTrue);
      expect(missing.failureOrNull, isA<ValidationFailure>());

      final wrongType = SchemaValidator.parseAndValidate(
        '{"risk_score": "high", "clauses": []}',
        schema,
      );
      expect(wrongType.isErr, isTrue);
      expect(wrongType.failureOrNull, isA<ValidationFailure>());
    });
  });
}
