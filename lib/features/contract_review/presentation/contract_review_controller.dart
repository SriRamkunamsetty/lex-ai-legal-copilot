import 'dart:async';
import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:lex_copilot/ai/ai_providers.dart';
import 'package:lex_copilot/ai/pipelines/contract_pipeline.dart';
import 'package:lex_copilot/core/result.dart';
import 'package:lex_copilot/core/storage/app_database.dart';
import 'package:lex_copilot/core/storage/secure_file_pipeline.dart';
import 'package:lex_copilot/core/widgets/risk_pill.dart';
import 'package:lex_copilot/features/library/presentation/library_providers.dart';
import 'package:lex_copilot/legal_corpus/providers/corpus_providers.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'contract_review_controller.g.dart';

/// Lightweight persisted contract analysis snapshot for Risk Radar.
@immutable
class ContractSummarySnapshot {
  /// Creates a [ContractSummarySnapshot].
  const new({
    required this.id,
    required this.title,
    required this.overallScore,
    required this.summaryJson,
  });

  /// Analysis identifier.
  final String id;

  /// Document filename or title.
  final String title;

  /// Computed 0-100 risk score.
  final int overallScore;

  /// JSON summary containing high/medium counts and notes.
  final String summaryJson;
}

/// Streams the most recently persisted contract analysis for live Home widgets.
@riverpod
Stream<ContractSummarySnapshot?> latestContractAnalysisStream(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return (db.select(db.contractAnalyses)
        ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
        ..limit(1))
      .watchSingleOrNull()
      .map(
        (row) => row == null
            ? null
            : ContractSummarySnapshot(
                id: row.id,
                title: row.title,
                overallScore: row.overallScore,
                summaryJson: row.summaryJson,
              ),
      );
}

/// Immutable UI state for [ContractReviewController].
@immutable
class ContractReviewState {
  /// Creates a [ContractReviewState].
  const new({
    this.documentTitle = 'Pasted contract',
    this.sourceText = '',
    this.isReviewing = false,
    this.review,
    this.errorMessage,
  });

  /// Display title of the reviewed contract.
  final String documentTitle;

  /// Input contract text.
  final String sourceText;

  /// Whether [ContractPipeline.review] is currently running.
  final bool isReviewing;

  /// Latest contract review result.
  final ContractReviewResult? review;

  /// Recoverable error message.
  final String? errorMessage;

  /// Returns an updated copy of [ContractReviewState].
  ContractReviewState copyWith({
    String? documentTitle,
    String? sourceText,
    bool? isReviewing,
    ContractReviewResult? review,
    bool clearReview = false,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ContractReviewState(
      documentTitle: documentTitle ?? this.documentTitle,
      sourceText: sourceText ?? this.sourceText,
      isReviewing: isReviewing ?? this.isReviewing,
      review: clearReview ? null : (review ?? this.review),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

/// Manages contract input/scan import, risk scoring, redlines, and rewrites.
@Riverpod(keepAlive: true)
class ContractReviewController extends _$ContractReviewController {
  @override
  ContractReviewState build() => const ContractReviewState();

  /// Updates the raw contract text before/after loading a scan.
  void setSourceText(String text, {String? title}) {
    state = state.copyWith(
      sourceText: text,
      documentTitle: title ?? state.documentTitle,
      clearError: true,
    );
  }

  /// Extracts text from PDF, DOCX, or TXT bytes via [SecureFilePipeline].
  Result<ParsedDocumentPayload> importFileBytes({
    required String fileName,
    required Uint8List bytes,
  }) {
    final parsed = SecureFilePipeline.extractFromBytes(
      fileName: fileName,
      bytes: bytes,
    );
    switch (parsed) {
      case Err(:final failure):
        state = state.copyWith(errorMessage: failure.message);
        return Err(failure);
      case Success(:final value):
        if (value.requiresOcrFallback && value.extractedText.isEmpty) {
          state = state.copyWith(
            errorMessage:
                '${value.fileName} appears to be image/scanned (${value.pageCount} page(s)). Use Scan to extract OCR text first.',
          );
        } else {
          state = state.copyWith(
            sourceText: value.extractedText,
            documentTitle: value.fileName,
            clearError: true,
          );
        }
        return Success(value);
    }
  }

  /// Compares an earlier baseline contract against the current working text.
  ContractComparisonSummary compareWithBaseline(String baselineText) {
    final current = state.review?.workingText ?? state.sourceText;
    return ref
        .read(contractPipelineProvider)
        .compareContracts(baselineText, current);
  }

  /// Builds a downloadable A4 PDF Risk Report for the active [ContractReviewResult].
  Future<Uint8List> buildRiskReportPdfBytes() {
    final review = state.review;
    final title = state.documentTitle;
    final doc = pw.Document()
      ..addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(36),
          build: (_) => [
            pw.Header(
              level: 0,
              child: pw.Text(
                'Lex Contract Risk Report: $title',
                style: const pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            if (review != null) ...[
              pw.Text(
                'Overall Risk Score: ${review.riskScore}/100 (${review.riskLabel})',
                style: const pw.TextStyle(fontSize: 13),
              ),
              pw.SizedBox(height: 12),
              for (final c in review.clauses) ...[
                pw.Container(
                  margin: const pw.EdgeInsets.only(bottom: 10),
                  padding: const pw.EdgeInsets.all(8),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.grey400),
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        '[${c.riskLevel.name.toUpperCase()}] ${c.clauseTitle} (p.${c.pageNumber})',
                        style: const pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.SizedBox(height: 4),
                      pw.Text('Reason: ${c.reason}'),
                      pw.SizedBox(height: 4),
                      pw.Text('Suggested rewrite: ${c.suggestedRewrite}'),
                    ],
                  ),
                ),
              ],
            ],
            pw.SizedBox(height: 12),
            pw.Text(
              'Generated by Lex. Verify clauses with a qualified Indian advocate before execution.',
              style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
            ),
          ],
        ),
      );
    return doc.save();
  }

  /// Runs [ContractPipeline.review] on [ContractReviewState.sourceText] and logs activity.
  Future<ContractReviewResult?> analyze([String? overrideText]) async {
    if (state.isReviewing) return null;
    final text = (overrideText ?? state.sourceText).trim();
    if (text.isEmpty) {
      state = state.copyWith(
        errorMessage:
            'Paste contract clauses or load a scanned document first.',
      );
      return null;
    }

    state = state.copyWith(
      sourceText: text,
      isReviewing: true,
      clearError: true,
    );

    final res = await ref.read(contractPipelineProvider).review(text);
    switch (res) {
      case Err(:final failure):
        state = state.copyWith(
          isReviewing: false,
          errorMessage: failure.message,
        );
        return null;
      case Success(:final value):
        final analysisId = 'ctr_${DateTime.now().microsecondsSinceEpoch}';
        final db = ref.read(appDatabaseProvider);
        unawaited(
          _persistContractAnalysis(
            db: db,
            analysisId: analysisId,
            title: state.documentTitle,
            result: value,
          ),
        );
        unawaited(
          ref
              .read(libraryRepositoryProvider)
              .recordActivity(
                kind: 'contract_review',
                title: state.documentTitle,
                subtitle: 'Risk ${value.riskScore}/100 · ${value.riskLabel}',
                route: '/contract-review',
              ),
        );
        state = state.copyWith(
          isReviewing: false,
          review: value,
          clearError: true,
        );
        return value;
    }
  }

  /// Applies the safer suggested wording for [clauseId] into [ContractReviewState.review].
  void applySaferWording(String clauseId) {
    final current = state.review;
    if (current == null) return;
    final updated = ref
        .read(contractPipelineProvider)
        .applySaferWording(review: current, clauseId: clauseId);
    state = state.copyWith(review: updated, sourceText: updated.workingText);
  }

  /// Applies all remaining un-applied safer rewrites.
  void applyAllSaferWording() {
    var current = state.review;
    if (current == null) return;
    final pipeline = ref.read(contractPipelineProvider);
    for (final clause in current.clauses) {
      if (!clause.applied) {
        current = pipeline.applySaferWording(
          review: current!,
          clauseId: clause.id,
        );
      }
    }
    state = state.copyWith(review: current, sourceText: current!.workingText);
  }

  Future<void> _persistContractAnalysis({
    required AppDatabase db,
    required String analysisId,
    required String title,
    required ContractReviewResult result,
  }) async {
    try {
      final highCount = result.countByLevel(RiskLevel.high);
      final mediumCount = result.countByLevel(RiskLevel.medium);
      await db.transaction(() async {
        await db
            .into(db.contractAnalyses)
            .insertOnConflictUpdate(
              ContractAnalysesCompanion.insert(
                id: analysisId,
                title: title,
                overallScore: result.riskScore,
                summaryJson: Value(
                  jsonEncode({
                    'risk_label': result.riskLabel,
                    'high_count': highCount,
                    'medium_count': mediumCount,
                  }),
                ),
              ),
            );
        for (final clause in result.clauses) {
          await db
              .into(db.riskFindings)
              .insertOnConflictUpdate(
                RiskFindingsCompanion.insert(
                  id: '${analysisId}_${clause.id}',
                  analysisId: analysisId,
                  clauseTitle: clause.clauseTitle,
                  riskLevel: clause.riskLevel.name,
                  originalText: clause.originalExcerpt,
                  explanation: clause.reason,
                  suggestedRewrite: clause.suggestedRewrite,
                  applied: Value(clause.applied),
                ),
              );
        }
      });
    } on Object {
      // Non-fatal persistence safeguard.
    }
  }
}
