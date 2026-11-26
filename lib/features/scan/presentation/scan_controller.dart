import 'dart:async';
import 'dart:convert';

import 'package:drift/drift.dart' show Value;
import 'package:flutter/foundation.dart';
import 'package:lex_copilot/ai/ai_providers.dart';
import 'package:lex_copilot/ai/pipelines/document_pipeline.dart';
import 'package:lex_copilot/core/result.dart';
import 'package:lex_copilot/core/security/security_providers.dart';
import 'package:lex_copilot/core/storage/app_database.dart';
import 'package:lex_copilot/features/library/presentation/library_providers.dart';
import 'package:lex_copilot/features/scan/data/document_scanner_service.dart';
import 'package:lex_copilot/features/settings/presentation/settings_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'scan_controller.g.dart';

/// Immutable UI state for [ScanController].
@immutable
class ScanState {
  /// Creates a [ScanState].
  const new({
    this.pages = const [],
    this.isCapturing = false,
    this.isAnalyzing = false,
    this.extraction,
    this.savedScanId,
    this.errorMessage,
  });

  /// Ordered captured document pages ready for OCR + extraction.
  final List<ScannedPageInput> pages;

  /// Whether a scanner/camera/gallery picker call is running.
  final bool isCapturing;

  /// Whether [DocumentPipeline] is currently extracting fields.
  final bool isAnalyzing;

  /// Extracted legal summary for [pages], if analyzed.
  final DocumentExtractionResult? extraction;

  /// Identifier of the persisted encrypted scan record, if saved.
  final String? savedScanId;

  /// Recoverable error message for the user.
  final String? errorMessage;

  /// Returns an updated copy of [ScanState].
  ScanState copyWith({
    List<ScannedPageInput>? pages,
    bool? isCapturing,
    bool? isAnalyzing,
    DocumentExtractionResult? extraction,
    bool clearExtraction = false,
    String? savedScanId,
    bool clearSavedId = false,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ScanState(
      pages: pages ?? this.pages,
      isCapturing: isCapturing ?? this.isCapturing,
      isAnalyzing: isAnalyzing ?? this.isAnalyzing,
      extraction: clearExtraction ? null : (extraction ?? this.extraction),
      savedScanId: clearSavedId ? null : (savedScanId ?? this.savedScanId),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

/// Manages document capture, multi-page OCR + LLM field extraction, and
/// encrypted persistence in [SavedScans].
@Riverpod(keepAlive: true)
class ScanController extends _$ScanController {
  @override
  ScanState build() => const ScanState();

  /// Captures pages via ML Kit auto edge-detection & perspective crop.
  Future<void> scanDocument() async {
    await _runCapture(
      () => ref.read(documentCaptureServiceProvider).scanDocument(),
    );
  }

  /// Captures a single page via the device camera.
  Future<void> captureFromCamera() async {
    await _runCapture(() async {
      final res = await ref
          .read(documentCaptureServiceProvider)
          .captureCamera();
      return res.map((page) => [page]);
    });
  }

  /// Picks one or more document images from the photo gallery.
  Future<void> pickFromGallery() async {
    await _runCapture(
      () => ref.read(documentCaptureServiceProvider).pickFromGallery(),
    );
  }

  /// Adds pages directly (useful for testing or programmatic imports).
  void addPages(List<ScannedPageInput> pages) {
    if (pages.isEmpty) return;
    state = state.copyWith(
      pages: [...state.pages, ...pages],
      clearExtraction: true,
      clearSavedId: true,
      clearError: true,
    );
  }

  /// Removes the page at [index].
  void removePage(int index) {
    if (index < 0 || index >= state.pages.length) return;
    final next = List<ScannedPageInput>.from(state.pages)..removeAt(index);
    state = state.copyWith(
      pages: next,
      clearExtraction: true,
      clearSavedId: true,
      clearError: true,
    );
  }

  /// Clears all captured pages and results.
  void reset() {
    state = const ScanState();
  }

  /// Runs [DocumentPipeline] on the captured pages, persists the scan record
  /// in the encrypted database, and returns the extraction if successful.
  Future<DocumentExtractionResult?> analyzeDocument() async {
    if (state.pages.isEmpty || state.isAnalyzing) {
      return null;
    }

    state = state.copyWith(
      isAnalyzing: true,
      clearError: true,
      clearExtraction: true,
      clearSavedId: true,
    );

    try {
      final res = await ref
          .read(documentPipelineProvider)
          .analyzePages(state.pages);

      switch (res) {
        case Err(:final failure):
          state = state.copyWith(
            isAnalyzing: false,
            errorMessage: failure.message,
          );
          return null;
        case Success(:final value):
          final scanId = 'scan_${DateTime.now().millisecondsSinceEpoch}';
          final title = state.pages.first.fileName.isNotEmpty
              ? '${value.documentType} · ${state.pages.first.fileName}'
              : value.documentType;
          final settings = ref.read(settingsControllerProvider);
          final retentionDays = settings.autoDeleteScansDays;
          final expiresAt = retentionDays > 0
              ? DateTime.now().add(Duration(days: retentionDays))
              : null;

          final storedPaths = <String>[];
          if (settings.encryptLocalFiles) {
            final fileStore = ref.read(encryptedFileStoreProvider);
            for (final page in state.pages) {
              if (page.bytes.isEmpty) {
                storedPaths.add(page.path);
                continue;
              }
              final encRes = await fileStore.writeBytes(
                fileName: page.fileName,
                plainBytes: page.bytes,
                encrypt: true,
              );
              if (encRes case Success(:final value)) {
                storedPaths.add(value);
              } else {
                storedPaths.add(page.path);
              }
            }
          } else {
            for (final page in state.pages) {
              storedPaths.add(page.path);
            }
          }
          final storedPath = storedPaths.isNotEmpty
              ? storedPaths.first
              : state.pages.first.path;

          final library = ref.read(libraryRepositoryProvider);
          await library.saveScan(
            SavedScansCompanion.insert(
              id: scanId,
              title: title,
              filePath: storedPath,
              ocrText: Value(value.ocrText),
              summaryJson: Value(
                jsonEncode({
                  'document_type': value.documentType,
                  'parties': value.parties,
                  'dates': value.dates,
                  'deadlines': value.deadlines,
                  'amounts': value.amounts,
                  'plain_language_summary': value.plainLanguageSummary,
                  'key_risks': value.keyRisks,
                  'stored_page_paths': storedPaths,
                }),
              ),
              pageCount: Value(value.pageCount),
              expiresAt: Value(expiresAt),
            ),
          );

          unawaited(
            library.recordActivity(
              kind: 'scan',
              title: title,
              subtitle:
                  '${value.pageCount} page${value.pageCount == 1 ? '' : 's'} analyzed',
              route: '/scan',
            ),
          );

          state = state.copyWith(
            isAnalyzing: false,
            extraction: value,
            savedScanId: scanId,
            clearError: true,
          );
          return value;
      }
    } on Object catch (error) {
      state = state.copyWith(
        isAnalyzing: false,
        errorMessage: 'Unexpected error while saving scan: $error',
      );
      return null;
    }
  }

  Future<void> _runCapture(
    Future<Result<List<ScannedPageInput>>> Function() action,
  ) async {
    if (state.isCapturing) return;
    state = state.copyWith(isCapturing: true, clearError: true);
    final res = await action();
    switch (res) {
      case Err(:final failure):
        state = state.copyWith(
          isCapturing: false,
          errorMessage: failure.message,
        );
      case Success(:final value):
        if (value.isEmpty) {
          state = state.copyWith(isCapturing: false);
          return;
        }
        state = state.copyWith(
          isCapturing: false,
          pages: [...state.pages, ...value],
          clearExtraction: true,
          clearSavedId: true,
          clearError: true,
        );
    }
  }
}
