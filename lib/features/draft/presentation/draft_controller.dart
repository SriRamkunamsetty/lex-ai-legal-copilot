import 'dart:async';
import 'dart:convert';

import 'package:drift/drift.dart' show Value;
import 'package:flutter/foundation.dart';
import 'package:lex_copilot/ai/ai_providers.dart';
import 'package:lex_copilot/ai/pipelines/draft_pipeline.dart';
import 'package:lex_copilot/core/errors/failure.dart';
import 'package:lex_copilot/core/result.dart';
import 'package:lex_copilot/core/storage/app_database.dart';
import 'package:lex_copilot/core/storage/secure_file_pipeline.dart';
import 'package:lex_copilot/features/library/presentation/library_providers.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'draft_controller.g.dart';

/// Immutable revision snapshot captured during drafting & editing.
@immutable
class DraftVersionSnapshot {
  /// Creates a [DraftVersionSnapshot].
  const new({
    required this.versionLabel,
    required this.createdAt,
    required this.content,
  });

  /// Human-readable version tag (`v1 · Generated`, `v2 · Edited`).
  final String versionLabel;

  /// Timestamp when snapshot was recorded.
  final DateTime createdAt;

  /// Full draft body at that revision.
  final String content;
}

/// Immutable UI state for [DraftController].
@immutable
class DraftState {
  /// Creates a [DraftState].
  const new({
    this.template = DraftTemplate.rentAgreement,
    this.fields = const {},
    this.isGenerating = false,
    this.result,
    this.editedContent = '',
    this.savedDraftId,
    this.versions = const [],
    this.errorMessage,
  });

  /// Selected drafting template.
  final DraftTemplate template;

  /// Current field values keyed by [DraftTemplate.fieldKeys].
  final Map<String, String> fields;

  /// Whether [DraftPipeline.generate] is currently running.
  final bool isGenerating;

  /// Latest generated draft result + self-check.
  final GeneratedDraftResult? result;

  /// Editable working text initialized from [result].
  final String editedContent;

  /// Identifier once saved into [SavedDrafts].
  final String? savedDraftId;

  /// Revision history snapshots captured in chronological order.
  final List<DraftVersionSnapshot> versions;

  /// Recoverable error message.
  final String? errorMessage;

  /// Returns an updated copy of [DraftState].
  DraftState copyWith({
    DraftTemplate? template,
    Map<String, String>? fields,
    bool? isGenerating,
    GeneratedDraftResult? result,
    bool clearResult = false,
    String? editedContent,
    String? savedDraftId,
    bool clearSavedId = false,
    List<DraftVersionSnapshot>? versions,
    String? errorMessage,
    bool clearError = false,
  }) {
    return DraftState(
      template: template ?? this.template,
      fields: fields ?? this.fields,
      isGenerating: isGenerating ?? this.isGenerating,
      result: clearResult ? null : (result ?? this.result),
      editedContent: editedContent ?? this.editedContent,
      savedDraftId: clearSavedId ? null : (savedDraftId ?? this.savedDraftId),
      versions: versions ?? this.versions,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

/// Manages legal drafting templates, scan prefill, `[placeholder]` self-check,
/// encrypted Library save, and PDF export.
@Riverpod(keepAlive: true)
class DraftController extends _$DraftController {
  @override
  DraftState build() => const DraftState();

  /// Switches the active drafting template.
  void selectTemplate(DraftTemplate template) {
    state = state.copyWith(
      template: template,
      fields: const {},
      clearResult: true,
      editedContent: '',
      clearSavedId: true,
      clearError: true,
    );
  }

  /// Updates a single template field value.
  void setField(String key, String value) {
    final next = Map<String, String>.from(state.fields)..[key] = value;
    state = state.copyWith(fields: next, clearError: true);
  }

  /// Prefills form fields for the active template from a saved scan's OCR + JSON.
  void prefillFromScan({required String ocrText, String? summaryJson}) {
    final prefilled = ref
        .read(draftPipelineProvider)
        .prefillFieldsFromScan(
          template: state.template,
          ocrText: ocrText,
          summaryJson: summaryJson,
        );
    state = state.copyWith(
      fields: {...state.fields, ...prefilled},
      clearError: true,
    );
  }

  /// Updates the editable draft body and re-runs [DraftPipeline.checkMandatoryClauses].
  void updateEditedContent(String text) {
    final check = ref
        .read(draftPipelineProvider)
        .checkMandatoryClauses(template: state.template, content: text);
    final updatedResult = state.result == null
        ? null
        : GeneratedDraftResult(
            template: state.template,
            content: text,
            selfCheck: check,
          );
    state = state.copyWith(editedContent: text, result: updatedResult);
  }

  /// Generates a draft using [DraftPipeline].
  Future<GeneratedDraftResult?> generateDraft() async {
    if (state.isGenerating) return null;
    state = state.copyWith(
      isGenerating: true,
      clearError: true,
      clearSavedId: true,
    );

    final res = await ref
        .read(draftPipelineProvider)
        .generate(template: state.template, fields: state.fields);

    switch (res) {
      case Err(:final failure):
        state = state.copyWith(
          isGenerating: false,
          errorMessage: failure.message,
        );
        return null;
      case Success(:final value):
        final nextVersions = List<DraftVersionSnapshot>.from(state.versions)
          ..add(
            DraftVersionSnapshot(
              versionLabel: 'v${state.versions.length + 1} · Generated',
              createdAt: DateTime.now(),
              content: value.content,
            ),
          );
        state = state.copyWith(
          isGenerating: false,
          result: value,
          editedContent: value.content,
          versions: nextVersions,
          clearError: true,
        );
        return value;
    }
  }

  /// Saves the current draft into the encrypted Library database.
  Future<Result<String>> saveToLibrary() async {
    final body = state.editedContent.trim();
    if (body.isEmpty) {
      return const Err(
        ValidationFailure('Generate or enter draft text before saving.'),
      );
    }

    final id =
        state.savedDraftId ?? 'draft_${DateTime.now().millisecondsSinceEpoch}';
    final library = ref.read(libraryRepositoryProvider);
    final saveRes = await library.saveDraft(
      SavedDraftsCompanion.insert(
        id: id,
        templateType: state.template.storageKey,
        title: '${state.template.label} Draft',
        content: body,
        fieldsJson: Value(jsonEncode(state.fields)),
      ),
    );

    if (saveRes case Err(:final failure)) {
      return Err(failure);
    }

    unawaited(
      library.recordActivity(
        kind: 'draft',
        title: '${state.template.label} Draft',
        subtitle:
            '${state.result?.selfCheck.placeholders.length ?? 0} placeholders',
        route: '/draft',
      ),
    );
    state = state.copyWith(savedDraftId: id);
    return Success(id);
  }

  /// Renders a clean A4 PDF document of the current draft including the mandatory
  /// lawyer-review notice.
  Future<Uint8List> buildPdfBytes() {
    final rawBody = state.editedContent.trim();
    final combined = rawBody.toLowerCase().contains('lawyer review notice')
        ? rawBody
        : '$rawBody\n\n---\n${DraftPipeline.lawyerReviewNotice}';
    // Built-in PDF Type1 fonts lack Rupee, em-dash, and ellipsis glyphs.
    final fullText = combined
        .replaceAll('₹', 'INR ')
        .replaceAll('—', '-')
        .replaceAll('–', '-')
        .replaceAll('…', '...');
    final pdfTitle = '${state.template.label} - Lex Draft';

    final doc = pw.Document()
      ..addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(40),
          build: (context) => [
            pw.Header(
              level: 0,
              child: pw.Text(
                pdfTitle,
                style: const pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.SizedBox(height: 8),
            for (final paragraph in fullText.split('\n\n'))
              pw.Padding(
                padding: const pw.EdgeInsets.only(bottom: 10),
                child: pw.Text(
                  paragraph,
                  style: const pw.TextStyle(fontSize: 11, lineSpacing: 4),
                ),
              ),
          ],
        ),
      );
    return doc.save();
  }

  /// Captures a manual revision snapshot inside [DraftState.versions].
  void saveVersionSnapshot({String label = 'Edited revision'}) {
    final text = state.editedContent.trim();
    if (text.isEmpty) return;
    final next = List<DraftVersionSnapshot>.from(state.versions)
      ..add(
        DraftVersionSnapshot(
          versionLabel: 'v${state.versions.length + 1} · $label',
          createdAt: DateTime.now(),
          content: text,
        ),
      );
    state = state.copyWith(versions: next);
  }

  /// Restores an earlier draft revision by index cleanly.
  void restoreVersion(int index) {
    if (index < 0 || index >= state.versions.length) return;
    updateEditedContent(state.versions[index].content);
  }

  /// Generates a Word OOXML `.docx` archive of the current draft.
  Uint8List buildDocxBytes() {
    final rawBody = state.editedContent.trim();
    final combined = rawBody.toLowerCase().contains('lawyer review notice')
        ? rawBody
        : '$rawBody\n\n---\n${DraftPipeline.lawyerReviewNotice}';
    return SecureFilePipeline.buildDocxBytes(
      title: '${state.template.label} - Lex Draft',
      bodyText: combined,
    );
  }
}
