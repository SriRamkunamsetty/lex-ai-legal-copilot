import 'package:flutter_test/flutter_test.dart';
import 'package:lex_copilot/core/errors/failure.dart';
import 'package:lex_copilot/core/result.dart';

void main() {
  group('Result', () {
    test('Success exposes value and transforms cleanly', () {
      const result = Success<int>(21);
      expect(result.isSuccess, isTrue);
      expect(result.isErr, isFalse);
      expect(result.valueOrNull, 21);
      expect(result.failureOrNull, isNull);

      final doubled = result.map((v) => v * 2);
      expect(doubled.valueOrNull, 42);

      final chained = doubled.flatMap((v) => Success('$v'));
      expect(chained.valueOrNull, '42');

      final folded = chained.fold(
        onSuccess: (v) => 'ok:$v',
        onFailure: (f) => 'err:${f.message}',
      );
      expect(folded, 'ok:42');
    });

    test('Err preserves failure across map and flatMap', () {
      const failure = NetworkFailure('Offline', statusCode: 503);
      const result = Err<int>(failure);
      expect(result.isSuccess, isFalse);
      expect(result.isErr, isTrue);
      expect(result.valueOrNull, isNull);
      expect(result.failureOrNull, failure);

      final mapped = result.map((v) => v * 2);
      expect(mapped, const Err<int>(failure));

      final chained = result.flatMap((v) => Success('$v'));
      expect(chained, const Err<String>(failure));

      final folded = result.fold(
        onSuccess: (v) => 'ok:$v',
        onFailure: (f) => 'err:${f.message}',
      );
      expect(folded, 'err:Offline');
    });

    test('Result.guard catches thrown exceptions into Err', () async {
      final ok = await Result.guard(() async => 'done');
      expect(ok, const Success<String>('done'));

      final failed = await Result.guard<String>(
        () async => throw StateError('boom'),
        onError: (e, _) => StorageFailure('mapped', cause: e),
      );
      expect(failed.isErr, isTrue);
      expect(failed.failureOrNull, isA<StorageFailure>());
      expect(failed.failureOrNull?.message, 'mapped');
    });
  });
}
