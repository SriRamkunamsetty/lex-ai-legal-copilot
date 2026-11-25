import 'package:flutter/foundation.dart';

/// Saved case matter summary stored in the encrypted database.
@immutable
class CaseFileRecord {
  /// Creates a [CaseFileRecord].
  const new({
    required this.id,
    required this.title,
    required this.category,
    required this.status,
    required this.summary,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Unique case identifier.
  final String id;

  /// Case/dispute title.
  final String title;

  /// Category (`Tenancy`, `Criminal`, `Consumer`, `Employment`, `General`).
  final String category;

  /// Current matter stage (`Open`, `Notice sent`, `In progress`, `Closed`).
  final String status;

  /// Short factual summary.
  final String summary;

  /// Creation timestamp.
  final DateTime createdAt;

  /// Last modified timestamp.
  final DateTime updatedAt;
}

/// Deadline or hearing item attached to a [CaseFileRecord].
@immutable
class CaseDeadlineRecord {
  /// Creates a [CaseDeadlineRecord].
  const new({
    required this.id,
    required this.caseId,
    required this.title,
    required this.dueAt,
    required this.reminderScheduled,
    required this.completed,
  });

  /// Database row ID.
  final int id;

  /// Owning case ID.
  final String caseId;

  /// Deadline description.
  final String title;

  /// Scheduled due date/time.
  final DateTime dueAt;

  /// Whether a local OS notification was scheduled.
  final bool reminderScheduled;

  /// Completion status.
  final bool completed;
}

/// Compliance checklist step or attached document event in a case timeline.
@immutable
class CaseChecklistRecord {
  /// Creates a [CaseChecklistRecord].
  const new({
    required this.id,
    required this.caseId,
    required this.title,
    required this.kind,
    required this.done,
    required this.createdAt,
    this.referenceId,
  });

  /// Database row ID.
  final int id;

  /// Owning case ID.
  final String caseId;

  /// Step or event description.
  final String title;

  /// Kind (`checklist`, `timeline`, `scan`, `draft`, `chat`).
  final String kind;

  /// Optional linked resource route or ID.
  final String? referenceId;

  /// Whether completed.
  final bool done;

  /// Creation timestamp.
  final DateTime createdAt;
}

/// Aggregated view of a case matter with deadlines and checklist/timeline.
@immutable
class CaseBundle {
  /// Creates a [CaseBundle].
  const new({
    required this.matter,
    required this.deadlines,
    required this.items,
  });

  /// Core matter details.
  final CaseFileRecord matter;

  /// Ordered deadlines.
  final List<CaseDeadlineRecord> deadlines;

  /// Compliance checklist & attached document timeline items.
  final List<CaseChecklistRecord> items;

  /// Only user-checkable compliance tasks.
  List<CaseChecklistRecord> get checklistItems =>
      items.where((i) => i.kind == 'checklist').toList();

  /// Attached scans, drafts, and timeline events.
  List<CaseChecklistRecord> get timelineEvents =>
      items.where((i) => i.kind != 'checklist').toList();
}
