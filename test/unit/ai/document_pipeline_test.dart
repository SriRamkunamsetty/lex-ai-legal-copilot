import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:lex_copilot/ai/llm_service.dart';
import 'package:lex_copilot/ai/pipelines/document_pipeline.dart';
import 'package:lex_copilot/ai/prompts/prompt_registry.dart';
import 'package:lex_copilot/core/result.dart';
import 'package:lex_copilot/features/scan/data/document_scanner_service.dart';

class _FakeOcrEngine implements OcrEngine {
  new(this.resultText, {this.confidence = 0.92});

  final String resultText;
  final double confidence;

  @override
  Future<Result<OcrPageResult>> recognize(ScannedPageInput page) async {
    return Success(OcrPageResult(text: resultText, confidence: confidence));
  }
}

class _FakeLlmService implements LlmService {
  List<Uint8List> lastImages = const [];
  String lastPrompt = '';

  @override
  String get modelId => 'stub-gemma-e4b';

  @override
  bool get isOnDevice => true;

  @override
  bool get supportsAudio => false;

  @override
  bool get supportsImages => true;

  @override
  Stream<String> chat(
    List<LlmMessage> messages, {
    LlmGenerationOptions options = const LlmGenerationOptions(),
  }) => const Stream.empty();

  @override
  Future<Result<String>> describeImage(
    Uint8List imageBytes, {
    required String prompt,
  }) async => const Success('Visual text extracted via multimodal fallback');

  @override
  Future<Result<T>> structured<T>(
    LlmSchema<T> schema,
    String prompt, {
    List<Uint8List> images = const [],
    LlmGenerationOptions options = const LlmGenerationOptions(),
  }) async {
    lastPrompt = prompt;
    lastImages = images;
    final json = <String, dynamic>{
      'document_type': 'Rent Eviction Notice',
      'parties': ['Ramesh Kumar', 'Anita Sharma'],
      'dates': ['15 Oct 2026'],
      'deadlines': ['Vacate within 30 days'],
      'amounts': ['₹24,000'],
      'plain_language_summary':
          'Landlord seeks vacation within 30 days over alleged arrears.',
      'key_risks': ['No prior notice cure period stated'],
    };
    return Success(schema.fromJson(json));
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('DocumentPipeline extracts structured fields across multi-page high-OCR scan', () async {
    final ocr = _FakeOcrEngine(
      'Legal Notice issued on 15 Oct 2026 by Ramesh Kumar to Anita Sharma regarding ₹24,000 rent arrears.',
    );
    final llm = _FakeLlmService();
    final pipeline = DocumentPipeline(
      ocrEngine: ocr,
      llm: llm,
      prompts: PromptRegistry(),
    );

    final result = await pipeline.analyzePages([
      ScannedPageInput(
        path: 'p1.jpg',
        bytes: Uint8List.fromList([1, 2, 3]),
        fileName: 'Page1.jpg',
      ),
      ScannedPageInput(
        path: 'p2.jpg',
        bytes: Uint8List.fromList([4, 5, 6]),
        fileName: 'Page2.jpg',
      ),
    ]);

    expect(result.isSuccess, isTrue);
    final extraction = result.valueOrNull!;
    expect(extraction.documentType, 'Rent Eviction Notice');
    expect(extraction.pageCount, 2);
    expect(extraction.usedMultimodalFallback, isFalse);
    expect(extraction.parties, contains('Ramesh Kumar'));
    expect(extraction.deadlines, contains('Vacate within 30 days'));
    expect(llm.lastImages, isEmpty);
  });

  test('DocumentPipeline attaches page images via multimodal fallback on low OCR confidence', () async {
    final ocr = _FakeOcrEngine('blur', confidence: 0.2);
    final llm = _FakeLlmService();
    final pipeline = DocumentPipeline(
      ocrEngine: ocr,
      llm: llm,
      prompts: PromptRegistry(),
    );

    final result = await pipeline.analyzePages([
      ScannedPageInput(
        path: 'blurry.jpg',
        bytes: Uint8List.fromList([9, 8, 7]),
        fileName: 'Blurry.jpg',
      ),
    ]);

    expect(result.isSuccess, isTrue);
    final extraction = result.valueOrNull!;
    expect(extraction.usedMultimodalFallback, isTrue);
    expect(llm.lastImages, hasLength(1));
  });
}
