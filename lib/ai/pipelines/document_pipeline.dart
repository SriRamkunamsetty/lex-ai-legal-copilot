// Private fields use named public parameters for readability across pipelines.
// ignore_for_file: prefer_initializing_formals
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:lex_copilot/ai/llm_service.dart';
import 'package:lex_copilot/ai/prompts/prompt_registry.dart';
import 'package:lex_copilot/core/errors/failure.dart';
import 'package:lex_copilot/core/result.dart';
import 'package:lex_copilot/features/scan/data/document_scanner_service.dart';

/// Structured legal summary extracted from a scanned document.
@immutable
class DocumentExtractionResult {
  /// Creates a [DocumentExtractionResult].
  const new({
    required this.documentType,
    required this.parties,
    required this.dates,
    required this.deadlines,
    required this.amounts,
    required this.plainLanguageSummary,
    required this.ocrText,
    required this.pageCount,
    this.keyRisks = const [],
    this.usedMultimodalFallback = false,
  });

  /// Parses structured JSON output from the LLM.
  factory fromJson(
    Map<String, dynamic> json, {
    String ocrText = '',
    int pageCount = 1,
    bool usedMultimodalFallback = false,
  }) {
    List<String> stringList(String key) {
      final raw = json[key];
      if (raw is List) {
        return raw
            .map((e) => e.toString().trim())
            .where((s) => s.isNotEmpty)
            .toList();
      }
      return const [];
    }

    return DocumentExtractionResult(
      documentType: (json['document_type'] as String? ?? 'Legal document')
          .trim(),
      parties: stringList('parties'),
      dates: stringList('dates'),
      deadlines: stringList('deadlines'),
      amounts: stringList('amounts'),
      plainLanguageSummary: (json['plain_language_summary'] as String? ?? '')
          .trim(),
      keyRisks: stringList('key_risks'),
      ocrText: ocrText,
      pageCount: pageCount,
      usedMultimodalFallback: usedMultimodalFallback,
    );
  }

  /// Classified document type (e.g. `Rent Notice`, `Service Agreement`).
  final String documentType;

  /// Parties named in the document.
  final List<String> parties;

  /// Extracted dates.
  final List<String> dates;

  /// Actionable deadlines (e.g. `30 days to vacate`).
  final List<String> deadlines;

  /// Monetary amounts mentioned (e.g. `₹25,000`).
  final List<String> amounts;

  /// Plain-language explanation of the document.
  final String plainLanguageSummary;

  /// Flagged initial risks or points to verify.
  final List<String> keyRisks;

  /// Combined multi-page OCR / vision-extracted text.
  final String ocrText;

  /// Number of pages analyzed.
  final int pageCount;

  /// Whether low OCR confidence triggered multimodal Gemma vision extraction.
  final bool usedMultimodalFallback;

  /// Serializes summary fields for persistence in `SavedScans.summaryJson`.
  String toSummaryJson() => jsonEncode({
    'document_type': documentType,
    'parties': parties,
    'dates': dates,
    'deadlines': deadlines,
    'amounts': amounts,
    'plain_language_summary': plainLanguageSummary,
    'key_risks': keyRisks,
  });
}

/// Multi-page scan-to-structured-summary pipeline:
/// OCR -> low-confidence multimodal Gemma fallback -> JSON field extraction.
class DocumentPipeline {
  /// Creates a [DocumentPipeline].
  const new({
    required OcrEngine ocrEngine,
    required LlmService llm,
    required PromptRegistry prompts,
  }) : _ocr = ocrEngine,
       _llm = llm,
       _prompts = prompts;

  final OcrEngine _ocr;
  final LlmService _llm;
  final PromptRegistry _prompts;

  static const Map<String, dynamic> _jsonSchema = {
    'type': 'object',
    'required': [
      'document_type',
      'parties',
      'dates',
      'deadlines',
      'amounts',
      'plain_language_summary',
    ],
    'properties': {
      'document_type': {'type': 'string'},
      'parties': {'type': 'array'},
      'dates': {'type': 'array'},
      'deadlines': {'type': 'array'},
      'amounts': {'type': 'array'},
      'plain_language_summary': {'type': 'string'},
      'key_risks': {'type': 'array'},
    },
  };

  /// Analyzes [pages] and returns a structured [DocumentExtractionResult].
  Future<Result<DocumentExtractionResult>> analyzePages(
    List<ScannedPageInput> pages,
  ) async {
    if (pages.isEmpty) {
      return const Err(
        ValidationFailure('At least one scanned page is required.'),
      );
    }

    final textChunks = <String>[];
    var usedMultimodal = false;

    for (var i = 0; i < pages.length; i++) {
      final page = pages[i];
      final ocrRes = await _ocr.recognize(page);
      var pageText = ocrRes.valueOrNull?.text ?? '';
      final confidence = ocrRes.valueOrNull?.confidence ?? 0.0;

      if ((confidence < 0.55 || pageText.length < 40) && _llm.supportsImages) {
        final visionRes = await _llm.describeImage(
          page.bytes,
          prompt:
              'Transcribe all visible text, dates, party names, amounts, and legal headers from page ${i + 1}.',
        );
        final visionText = visionRes.valueOrNull?.trim() ?? '';
        if (visionText.length > pageText.length) {
          pageText = visionText;
          usedMultimodal = true;
        }
      }

      if (pageText.isNotEmpty) {
        textChunks.add('--- Page ${i + 1} ---\n$pageText');
      }
    }

    final combinedText = textChunks.join('\n\n');
    if (combinedText.isEmpty) {
      return const Err(
        ValidationFailure(
          'Could not read text from the document image. Please retake in brighter light.',
        ),
      );
    }

    final prompt = await _prompts.render(
      LexPromptId.documentExtract,
      variables: {'document_text': combinedText},
    );

    final schema = LlmSchema<DocumentExtractionResult>(
      name: 'document_extract',
      jsonSchema: _jsonSchema,
      fromJson: (json) => DocumentExtractionResult.fromJson(
        json,
        ocrText: combinedText,
        pageCount: pages.length,
        usedMultimodalFallback: usedMultimodal,
      ),
    );

    final aiResult = await _llm.structured(
      schema,
      prompt,
      images: usedMultimodal ? [pages.first.bytes] : const [],
    );

    if (aiResult case Success(:final value)) {
      return Success(value);
    }

    // Deterministic offline extraction fallback so scanned text is never lost.
    return Success(
      _heuristicExtract(
        combinedText,
        pageCount: pages.length,
        usedMultimodal: usedMultimodal,
      ),
    );
  }

  static DocumentExtractionResult _heuristicExtract(
    String ocrText, {
    required int pageCount,
    required bool usedMultimodal,
  }) {
    final dates = RegExp(
      r'\b\d{1,2}[/-]\d{1,2}[/-]\d{2,4}\b|\b\d{1,2}\s+(?:Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)[a-z]*\s+\d{4}\b',
      caseSensitive: false,
    ).allMatches(ocrText).map((m) => m.group(0)!).toSet().toList();

    final amounts = RegExp(
      r'(?:Rs\.?|INR|₹)\s?[\d,]+(?:\.\d{1,2})?',
      caseSensitive: false,
    ).allMatches(ocrText).map((m) => m.group(0)!).toSet().toList();

    final deadlines = RegExp(
      r'\bwithin\s+\d+\s+days\b|\bdue\s+(?:on|by)\s+[^\n.]+',
      caseSensitive: false,
    ).allMatches(ocrText).map((m) => m.group(0)!).toSet().toList();

    final lower = ocrText.toLowerCase();
    final docType = lower.contains('notice')
        ? 'Legal Notice'
        : lower.contains('agreement') || lower.contains('lease')
        ? 'Agreement / Contract'
        : lower.contains('order') || lower.contains('court')
        ? 'Court / Official Order'
        : 'Scanned Document';

    final preview = ocrText.replaceAll('\n', ' ').trim();
    final summary = preview.length > 220
        ? '${preview.substring(0, 220)}…'
        : preview;

    return DocumentExtractionResult(
      documentType: docType,
      parties: const [],
      dates: dates,
      deadlines: deadlines,
      amounts: amounts,
      plainLanguageSummary:
          'Offline OCR summary ($docType): $summary. Verify with the original text.',
      ocrText: ocrText,
      pageCount: pageCount,
      usedMultimodalFallback: usedMultimodal,
    );
  }
}
