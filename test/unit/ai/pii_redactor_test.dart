import 'package:flutter_test/flutter_test.dart';
import 'package:lex_copilot/ai/redaction/pii_redactor.dart';

void main() {
  group('PiiRedactor', () {
    test('redacts Aadhaar, PAN, phone, email, IFSC, UPI, account, and names then restores', () {
      const original =
          'Notice to Aarav Sharma (Phone: +91 9876543210, Email: aarav@example.in, '
          'Aadhaar 1234 5678 9012, PAN ABCDE1234F, Account No: 123456789012, '
          'IFSC HDFC0001234, UPI aarav@oksbi).';

      final result = PiiRedactor.redact(original, knownNames: ['Aarav Sharma']);
      expect(result.redactedText, isNot(contains('Aarav Sharma')));
      expect(result.redactedText, isNot(contains('9876543210')));
      expect(result.redactedText, isNot(contains('aarav@example.in')));
      expect(result.redactedText, isNot(contains('1234 5678 9012')));
      expect(result.redactedText, isNot(contains('ABCDE1234F')));
      expect(result.redactedText, isNot(contains('123456789012')));
      expect(result.redactedText, isNot(contains('HDFC0001234')));
      expect(result.redactedText, isNot(contains('aarav@oksbi')));

      final restored = result.restore('Advise ${result.redactedText}');
      expect(restored, 'Advise $original');
    });
  });
}
