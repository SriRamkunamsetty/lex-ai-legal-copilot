import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lex_copilot/core/result.dart';
import 'package:lex_copilot/core/storage/app_database.dart';
import 'package:lex_copilot/features/case_file/data/case_file_repository.dart';
import 'package:lex_copilot/features/legal_aid/data/legal_help_directory_source.dart';
import 'package:lex_copilot/features/legal_aid/domain/legal_help_models.dart';

void main() {
  test('CaseFileRepository creates case, adds deadlines & compliance tasks, and builds shareable summary', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);
    final repo = CaseFileRepository(db);

    final createRes = await repo.createCase(
      title: 'Security Deposit Recovery',
      category: 'Tenancy',
      summary: 'Landlord withholding ₹45,000 deposit beyond 30 days.',
    );
    expect(createRes.isSuccess, isTrue);
    final caseId = createRes.valueOrNull!;

    final dlRes = await repo.addDeadline(
      caseId: caseId,
      title: 'Notice cure expiry',
      dueAt: DateTime(2026, 12, 15),
    );
    expect(dlRes.isSuccess, isTrue);

    await repo.addChecklistOrTimelineItem(
      caseId: caseId,
      title: 'Scan: Rent_Agreement.pdf',
      kind: 'scan',
      referenceId: 'scan_1',
    );

    final bundleRes = await repo.getCaseBundle(caseId);
    expect(bundleRes.isSuccess, isTrue);
    final bundle = bundleRes.valueOrNull!;
    expect(bundle.matter.title, 'Security Deposit Recovery');
    expect(bundle.deadlines, hasLength(1));
    expect(bundle.checklistItems.length, greaterThanOrEqualTo(3));

    final summary = repo.buildShareableSummary(bundle);
    expect(summary, contains('Security Deposit Recovery'));
    expect(summary, contains('Notice cure expiry'));
    expect(summary, contains('not legal advice'));
  });

  test('PlaceholderLegalHelpDirectorySource marks entries as placeholders and sorts by proximity', () async {
    const source = PlaceholderLegalHelpDirectorySource();
    final res = await source.fetchEntries(
      category: LegalHelpCategory.legalAid,
      latitude: 12.97,
      longitude: 77.58,
    );
    expect(res, isA<Success<List<LegalHelpEntry>>>());
    final entries = res.valueOrNull!;
    expect(entries, isNotEmpty);
    expect(entries.every((e) => e.isPlaceholder), isTrue);
    expect(entries.first.city, contains('Bengaluru'));
    expect(entries.first.distanceKm, lessThan(entries.last.distanceKm!));
  });
}
