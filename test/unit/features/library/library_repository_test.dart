import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lex_copilot/core/storage/app_database.dart';
import 'package:lex_copilot/features/library/data/library_repository.dart';

void main() {
  group('LibraryRepository', () {
    late AppDatabase db;
    late LibraryRepository repo;

    setUp(() {
      db = AppDatabase.forTesting(NativeDatabase.memory());
      repo = LibraryRepository(db);
    });

    tearDown(() async {
      await db.close();
    });

    test('toggles bookmarks and streams updates', () async {
      final added = await repo.toggleBookmark(
        actCode: 'bns',
        sectionNumber: '304',
        note: 'Phone snatching reference',
      );
      expect(added.failureOrNull?.cause ?? added.failureOrNull, isNull);
      expect(added.valueOrNull, isTrue);

      final list1 = await repo.watchBookmarks().first;
      expect(list1.length, 1);
      expect(list1.first.actCode, 'BNS');

      final removed = await repo.toggleBookmark(
        actCode: 'BNS',
        sectionNumber: '304',
      );
      expect(removed.valueOrNull, isFalse);
      final list2 = await repo.watchBookmarks().first;
      expect(list2, isEmpty);
    });

    test(
      'saves scans, purges expired scans, saves drafts, and wipes data',
      () async {
        final now = DateTime(2026, 11, 25);
        await repo.saveScan(
          SavedScansCompanion.insert(
            id: 'scan-expired',
            title: 'Old_Notice.jpg',
            filePath: '/vault/old.enc',
            ocrText: const Value('30 days notice'),
            expiresAt: Value(now.subtract(const Duration(days: 1))),
          ),
        );
        await repo.saveScan(
          SavedScansCompanion.insert(
            id: 'scan-active',
            title: 'Lease_2026.pdf',
            filePath: '/vault/lease.enc',
            ocrText: const Value('Monthly rent 25000'),
            expiresAt: Value(now.add(const Duration(days: 20))),
          ),
        );

        final purged = await repo.purgeExpiredScans(now);
        expect(purged.valueOrNull, 1);
        final remainingScans = await repo.watchScans().first;
        expect(remainingScans.map((s) => s.id), ['scan-active']);

        await repo.saveDraft(
          SavedDraftsCompanion.insert(
            id: 'draft-1',
            templateType: 'rent_agreement',
            title: 'Flat 4B Rent Agreement',
            content: 'Agreement between [Landlord] and [Tenant]',
          ),
        );
        expect((await repo.watchDrafts(query: 'Flat').first).length, 1);

        await repo.recordActivity(
          kind: 'section_view',
          title: 'BNS 304',
          subtitle: 'Snatching',
          route: '/section/BNS/304',
        );
        expect((await repo.watchHistory().first).length, 1);

        final wiped = await repo.deleteAllUserData();
        expect(wiped.isSuccess, isTrue);
        expect(await repo.watchScans().first, isEmpty);
        expect(await repo.watchDrafts().first, isEmpty);
        expect(await repo.watchHistory().first, isEmpty);
      },
    );
  });
}
