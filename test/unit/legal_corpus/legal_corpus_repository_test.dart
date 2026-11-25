import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lex_copilot/core/errors/failure.dart';
import 'package:lex_copilot/core/storage/app_database.dart';
import 'package:lex_copilot/legal_corpus/repository/legal_corpus_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('LegalCorpusRepository', () {
    late AppDatabase db;
    late LegalCorpusRepository repo;

    setUp(() {
      db = AppDatabase.forTesting(NativeDatabase.memory());
      repo = LegalCorpusRepository(db);
    });

    tearDown(() async {
      await db.close();
    });

    test(
      'seeds 1059 sections and verifies BNS 303, 304, 309 and BNSS 173',
      () async {
        final seedResult = await repo.ensureSeeded();
        expect(seedResult.isSuccess, isTrue);
        expect(seedResult.valueOrNull, 1059);

        // Idempotent second call
        final secondSeed = await repo.ensureSeeded();
        expect(secondSeed.valueOrNull, 1059);

        final bns303 = await repo.getSection('BNS', '303');
        expect(bns303.valueOrNull?.title, 'Theft');
        expect(bns303.valueOrNull?.legacyMapping, contains('IPC 378'));

        final bns304 = await repo.getSection('BNS', '304');
        expect(bns304.valueOrNull?.title, 'Snatching');
        expect(bns304.valueOrNull?.punishment, contains('three years'));

        final bns309 = await repo.getSection('BNS', '309');
        expect(bns309.valueOrNull?.title, 'Robbery');

        final bnss173 = await repo.getSection('BNSS', '173');
        expect(bnss173.valueOrNull?.title, 'Information in cognizable cases');
        expect(bnss173.valueOrNull?.legacyMapping, 'CrPC 154');
      },
    );

    test(
      'supports citation search, FTS5 keyword search, and NotFoundFailure',
      () async {
        await repo.ensureSeeded();

        final byCitation = await repo.search('BNS 304');
        expect(byCitation.isSuccess, isTrue);
        expect(byCitation.valueOrNull?.first.sectionNumber, '304');

        final byKeyword = await repo.search('snatching', actCode: 'BNS');
        expect(byKeyword.isSuccess, isTrue);
        expect(
          byKeyword.valueOrNull?.any((s) => s.sectionNumber == '304'),
          isTrue,
        );

        final missing = await repo.getSection('BNS', '9999');
        expect(missing.isErr, isTrue);
        expect(missing.failureOrNull, isA<NotFoundFailure>());
      },
    );
  });
}
