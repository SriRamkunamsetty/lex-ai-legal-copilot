import 'package:drift/drift.dart';
import 'package:lex_copilot/core/errors/failure.dart';
import 'package:lex_copilot/core/result.dart';
import 'package:lex_copilot/core/storage/app_database.dart';

/// Persisted Indian compliance checklist item linked to official statutes.
class ComplianceItem {
  /// Creates a [ComplianceItem].
  const new({
    required this.id,
    required this.framework,
    required this.title,
    required this.citationRef,
    required this.sourceAuthority,
    required this.effectiveDate,
    required this.verificationStatus,
    required this.status,
    required this.notes,
  });

  /// Stable requirement ID.
  final String id;

  /// Regulatory framework (`DPDP_2023`, `IT_2000`, `STARTUP_ESSENTIALS`).
  final String framework;

  /// Actionable requirement description.
  final String title;

  /// Canonical statutory reference (`DPDP_2023:5`, `IT_2000:43A`).
  final String citationRef;

  /// Publishing authority (`MeitY`, `India Code`).
  final String sourceAuthority;

  /// Enactment or effective date status.
  final String effectiveDate;

  /// Trust verification badge (`verified`, `review_required`).
  final String verificationStatus;

  /// Progress status (`pending`, `in_progress`, `completed`, `not_applicable`).
  final String status;

  /// Optional user audit notes.
  final String notes;
}

/// Manages statutory compliance checklists in [AppDatabase] (`ComplianceRecords`),
/// seeded strictly with verifiable Indian DPDP Act 2023, IT Act 2000, and core
/// startup/employment compliance obligations.
class ComplianceRepository {
  /// Creates a [ComplianceRepository].
  const new(this._db);

  final AppDatabase _db;

  static const List<ComplianceRecordsCompanion> _seedItems = [
    ComplianceRecordsCompanion(
      id: Value('dpdp_notice_s5'),
      framework: Value('DPDP_2023'),
      title: Value(
        'Provide itemized Notice before requesting consent for personal data processing (Data Fiduciary duty)',
      ),
      citationRef: Value('DPDP_2023:5'),
      sourceAuthority: Value('MeitY / Gazette of India (Act No. 22 of 2023)'),
      effectiveDate: Value(
        '2023-08-11 (Rules commencement subject to Gazette notification)',
      ),
      verificationStatus: Value('verified'),
    ),
    ComplianceRecordsCompanion(
      id: Value('dpdp_consent_s6'),
      framework: Value('DPDP_2023'),
      title: Value(
        'Obtain free, specific, informed, unconditional and unambiguous consent with easy withdrawal mechanism',
      ),
      citationRef: Value('DPDP_2023:6'),
      sourceAuthority: Value('MeitY / Gazette of India (Act No. 22 of 2023)'),
      effectiveDate: Value(
        '2023-08-11 (Rules commencement subject to Gazette notification)',
      ),
      verificationStatus: Value('verified'),
    ),
    ComplianceRecordsCompanion(
      id: Value('dpdp_security_s8'),
      framework: Value('DPDP_2023'),
      title: Value(
        'Implement reasonable security safeguards and notify Data Protection Board + affected individuals on personal data breach',
      ),
      citationRef: Value('DPDP_2023:8'),
      sourceAuthority: Value('MeitY / Gazette of India (Act No. 22 of 2023)'),
      effectiveDate: Value(
        '2023-08-11 (Rules commencement subject to Gazette notification)',
      ),
      verificationStatus: Value('verified'),
    ),
    ComplianceRecordsCompanion(
      id: Value('dpdp_children_s9'),
      framework: Value('DPDP_2023'),
      title: Value(
        'Verify verifiable parental/lawful guardian consent before processing personal data of children (<18 years)',
      ),
      citationRef: Value('DPDP_2023:9'),
      sourceAuthority: Value('MeitY / Gazette of India (Act No. 22 of 2023)'),
      effectiveDate: Value('2023-08-11'),
      verificationStatus: Value('verified'),
    ),
    ComplianceRecordsCompanion(
      id: Value('dpdp_rights_s11'),
      framework: Value('DPDP_2023'),
      title: Value(
        'Establish Data Principal grievance redressal & access/correction/erasure workflow',
      ),
      citationRef: Value('DPDP_2023:11'),
      sourceAuthority: Value('MeitY / Gazette of India (Act No. 22 of 2023)'),
      effectiveDate: Value('2023-08-11'),
      verificationStatus: Value('verified'),
    ),
    ComplianceRecordsCompanion(
      id: Value('it_act_43a'),
      framework: Value('IT_2000'),
      title: Value(
        'Maintain reasonable security practices and procedures for sensitive personal data in body corporate systems',
      ),
      citationRef: Value('IT_2000:43A'),
      sourceAuthority: Value('India Code / Legislative Department'),
      effectiveDate: Value('2000-10-17'),
      verificationStatus: Value('verified'),
    ),
    ComplianceRecordsCompanion(
      id: Value('startup_nda_ip'),
      framework: Value('STARTUP_ESSENTIALS'),
      title: Value(
        'Execute written founder/employee confidentiality & IP assignment clauses aligned with Indian Contract Act, 1872 (check s.27 restraint of trade bounds)',
      ),
      citationRef: Value('ICA_1872:27'),
      sourceAuthority: Value(
        'Legislative Department (ICA full text pending external sync)',
      ),
      effectiveDate: Value('1872-09-01'),
      verificationStatus: Value('review_required'),
    ),
  ];

  /// Seeds default compliance items once without overwriting user progress.
  Future<Result<void>> ensureSeeded() => Result.guard(
    () async {
      final countExp = _db.complianceRecords.id.count();
      final row = await (_db.selectOnly(
        _db.complianceRecords,
      )..addColumns([countExp])).getSingle();
      if ((row.read(countExp) ?? 0) > 0) return;

      await _db.batch((b) {
        b.insertAllOnConflictUpdate(_db.complianceRecords, _seedItems);
      });
    },
    onError: (error, _) =>
        StorageFailure('Failed to seed compliance checklist.', cause: error),
  );

  /// Streams compliance checklist rows filtered optionally by [framework].
  Stream<List<ComplianceItem>> watchItems({String? framework}) {
    final stmt = _db.select(_db.complianceRecords);
    if (framework != null && framework.isNotEmpty) {
      stmt.where((t) => t.framework.equals(framework));
    }
    return stmt.watch().map(
      (rows) => rows
          .map(
            (r) => ComplianceItem(
              id: r.id,
              framework: r.framework,
              title: r.title,
              citationRef: r.citationRef,
              sourceAuthority: r.sourceAuthority,
              effectiveDate: r.effectiveDate,
              verificationStatus: r.verificationStatus,
              status: r.status,
              notes: r.notes,
            ),
          )
          .toList(),
    );
  }

  /// Updates the completion [status] of a compliance item.
  Future<Result<void>> updateStatus({
    required String id,
    required String status,
  }) => Result.guard(
    () => (_db.update(_db.complianceRecords)..where((t) => t.id.equals(id)))
        .write(
          ComplianceRecordsCompanion(
            status: Value(status),
            updatedAt: Value(DateTime.now()),
          ),
        ),
    onError: (error, _) =>
        StorageFailure('Failed to update compliance status.', cause: error),
  );
}
