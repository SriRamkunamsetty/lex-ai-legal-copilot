import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:google_mlkit_document_scanner/google_mlkit_document_scanner.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lex_copilot/core/errors/failure.dart';
import 'package:lex_copilot/core/result.dart';

/// Raw captured or imported document page before OCR/AI extraction.
@immutable
class ScannedPageInput {
  /// Creates a [ScannedPageInput].
  const new({required this.path, required this.bytes, required this.fileName});

  /// Local image path on disk.
  final String path;

  /// Encoded image bytes (JPEG/PNG).
  final Uint8List bytes;

  /// Display filename.
  final String fileName;
}

/// OCR result for a single scanned page.
@immutable
class OcrPageResult {
  /// Creates an [OcrPageResult].
  const new({required this.text, required this.confidence});

  /// Recognized text content.
  final String text;

  /// Heuristic confidence score in `[0.0, 1.0]`.
  final double confidence;
}

/// Abstraction over platform document scanner + camera/gallery image pickers.
abstract interface class DocumentCaptureService {
  /// Launches the auto edge-detecting multi-page document scanner.
  Future<Result<List<ScannedPageInput>>> scanDocument({int pageLimit = 5});

  /// Captures a single document photo from the camera.
  Future<Result<ScannedPageInput>> captureCamera();

  /// Picks one or more document images from the photo library.
  Future<Result<List<ScannedPageInput>>> pickFromGallery();
}

/// Abstraction over on-device OCR text recognition.
abstract interface class OcrEngine {
  /// Recognizes text from [page].
  Future<Result<OcrPageResult>> recognize(ScannedPageInput page);
}

/// Production [DocumentCaptureService] using `google_mlkit_document_scanner`
/// and `image_picker`.
class MlKitDocumentCaptureService implements DocumentCaptureService {
  /// Creates an [MlKitDocumentCaptureService].
  new({ImagePicker? picker}) : _picker = picker ?? ImagePicker();

  final ImagePicker _picker;

  @override
  Future<Result<List<ScannedPageInput>>> scanDocument({int pageLimit = 5}) =>
      Result.guard(
        () async {
          final scanner = DocumentScanner(
            options: DocumentScannerOptions(
              mode: ScannerMode.filter,
              pageLimit: pageLimit,
              isGalleryImport: true,
            ),
          );
          try {
            final result = await scanner.scanDocument();
            final images = result.images ?? const <String>[];
            final pages = <ScannedPageInput>[];
            for (var i = 0; i < images.length; i++) {
              final imgPath = images[i];
              final file = File(imgPath);
              if (file.existsSync()) {
                pages.add(
                  ScannedPageInput(
                    path: imgPath,
                    bytes: await file.readAsBytes(),
                    fileName: 'Scan_Page_${i + 1}.jpg',
                  ),
                );
              }
            }
            return pages;
          } finally {
            await scanner.close();
          }
        },
        onError: (error, _) => StorageFailure(
          'Document scanner failed or was cancelled.',
          cause: error,
        ),
      );

  @override
  Future<Result<ScannedPageInput>> captureCamera() => Result.guard(
    () async {
      final picked = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 92,
      );
      if (picked == null) {
        throw StateError('Camera capture cancelled.');
      }
      return ScannedPageInput(
        path: picked.path,
        bytes: await picked.readAsBytes(),
        fileName: picked.name,
      );
    },
    onError: (error, _) =>
        StorageFailure('Camera capture failed.', cause: error),
  );

  @override
  Future<Result<List<ScannedPageInput>>> pickFromGallery() => Result.guard(
    () async {
      final picked = await _picker.pickMultiImage(imageQuality: 92);
      final pages = <ScannedPageInput>[];
      for (final file in picked) {
        pages.add(
          ScannedPageInput(
            path: file.path,
            bytes: await file.readAsBytes(),
            fileName: file.name,
          ),
        );
      }
      return pages;
    },
    onError: (error, _) =>
        StorageFailure('Gallery import failed.', cause: error),
  );
}

/// Production [OcrEngine] backed by `google_mlkit_text_recognition`.
class MlKitOcrEngine implements OcrEngine {
  /// Creates an [MlKitOcrEngine].
  const new();

  @override
  Future<Result<OcrPageResult>> recognize(ScannedPageInput page) =>
      Result.guard(
        () async {
          final recognizer = TextRecognizer();
          try {
            final input = InputImage.fromFilePath(page.path);
            final recognized = await recognizer.processImage(input);
            final text = recognized.text.trim();
            final blockCount = recognized.blocks.length;
            final confidence = computeConfidence(
              text: text,
              blockCount: blockCount,
            );
            return OcrPageResult(text: text, confidence: confidence);
          } finally {
            await recognizer.close();
          }
        },
        onError: (error, _) =>
            StorageFailure('On-device OCR failed.', cause: error),
      );

  /// Estimates OCR reliability from extracted text length and block structure.
  static double computeConfidence({
    required String text,
    required int blockCount,
  }) {
    if (text.isEmpty) return 0;
    final cleanLen = text.replaceAll(RegExp(r'\s+'), '').length;
    if (cleanLen < 20) return 0.25;
    if (cleanLen < 60 || blockCount == 0) return 0.5;
    final alphaRatio =
        RegExp('[A-Za-z0-9]').allMatches(text).length / text.length;
    return (0.55 + (alphaRatio * 0.45)).clamp(0.0, 0.99);
  }
}
