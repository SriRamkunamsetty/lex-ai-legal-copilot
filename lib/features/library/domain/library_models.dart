import 'package:flutter/foundation.dart';

/// Bookmarked statutory section saved by the user.
@immutable
class BookmarkRecord {
  /// Creates a [BookmarkRecord].
  const new({
    required this.id,
    required this.actCode,
    required this.sectionNumber,
    required this.createdAt,
    this.note,
  });

  /// Database row ID.
  final int id;

  /// Short act code (`BNS`, `BNSS`, `BSA`).
  final String actCode;

  /// Section number string.
  final String sectionNumber;

  /// Optional user note.
  final String? note;

  /// Timestamp when bookmarked.
  final DateTime createdAt;
}

/// Saved document scan entry in the encrypted vault.
@immutable
class SavedScanRecord {
  /// Creates a [SavedScanRecord].
  const new({
    required this.id,
    required this.title,
    required this.filePath,
    required this.ocrText,
    required this.summaryJson,
    required this.pageCount,
    required this.createdAt,
    this.expiresAt,
  });

  /// Stable scan ID.
  final String id;

  /// Document filename or title.
  final String title;

  /// App-private local file path.
  final String filePath;

  /// Extracted OCR text.
  final String ocrText;

  /// JSON-encoded extracted metadata.
  final String summaryJson;

  /// Number of scanned pages.
  final int pageCount;

  /// Creation timestamp.
  final DateTime createdAt;

  /// Optional auto-delete expiration timestamp.
  final DateTime? expiresAt;
}

/// Saved legal document draft entry.
@immutable
class SavedDraftRecord {
  /// Creates a [SavedDraftRecord].
  const new({
    required this.id,
    required this.templateType,
    required this.title,
    required this.content,
    required this.fieldsJson,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Stable draft ID.
  final String id;

  /// Template identifier.
  final String templateType;

  /// Draft display title.
  final String title;

  /// Draft body text.
  final String content;

  /// JSON-encoded template fields.
  final String fieldsJson;

  /// Creation timestamp.
  final DateTime createdAt;

  /// Last modification timestamp.
  final DateTime updatedAt;
}

/// Local activity history entry.
@immutable
class ActivityRecord {
  /// Creates an [ActivityRecord].
  const new({
    required this.id,
    required this.kind,
    required this.title,
    required this.subtitle,
    required this.route,
    required this.createdAt,
  });

  /// Row ID.
  final int id;

  /// Activity category (`section_view`, `chat`, `scan`, `incident`, `contract`, `draft`).
  final String kind;

  /// Display title.
  final String title;

  /// Secondary description.
  final String subtitle;

  /// GoRouter location to reopen the item.
  final String route;

  /// Event timestamp.
  final DateTime createdAt;
}
