import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:flutter/foundation.dart';
import 'package:lex_copilot/core/errors/failure.dart';
import 'package:lex_copilot/core/result.dart';
import 'package:lex_copilot/core/security/encrypted_file_store.dart';
import 'package:xml/xml.dart';

/// Supported input document formats for Contract Review, Drafting & RAG.
enum LegalDocumentFormat {
  /// Plain UTF-8 text (`.txt`).
  plainText,

  /// Microsoft Word OOXML document (`.docx`).
  docx,

  /// Portable Document Format (`.pdf`).
  pdf,

  /// Image document (JPEG / PNG) requiring OCR / Vision.
  image,
}

/// Extracted text and per-page metadata returned by [SecureFilePipeline].
@immutable
class ParsedDocumentPayload {
  /// Creates a [ParsedDocumentPayload].
  const new({
    required this.fileName,
    required this.format,
    required this.extractedText,
    required this.pageCount,
    required this.requiresOcrFallback,
  });

  /// Original file basename.
  final String fileName;

  /// Detected document format.
  final LegalDocumentFormat format;

  /// Extracted text formatted with `[Page N]` markers where applicable.
  final String extractedText;

  /// Estimated or explicit page count.
  final int pageCount;

  /// `true` when PDF had scanned image pages with little/no embedded text.
  final bool requiresOcrFallback;
}

/// Validated multi-format legal file extraction pipeline (TXT, DOCX, PDF, image)
/// enforcing size caps and magic-byte security checks before text extraction.
abstract final class SecureFilePipeline {
  /// Validates [bytes] and extracts structured page text safely for [fileName].
  static Result<ParsedDocumentPayload> extractFromBytes({
    required String fileName,
    required Uint8List bytes,
  }) {
    final validRes = EncryptedFileStore.validateDocumentBytes(bytes);
    if (validRes case Err(:final failure)) {
      return Err(failure);
    }

    try {
      final format = _detectFormat(fileName, bytes);
      switch (format) {
        case LegalDocumentFormat.plainText:
          final text = utf8.decode(bytes, allowMalformed: true).trim();
          return Success(
            ParsedDocumentPayload(
              fileName: fileName,
              format: format,
              extractedText: text,
              pageCount: 1,
              requiresOcrFallback: false,
            ),
          );
        case LegalDocumentFormat.docx:
          final text = _extractDocxText(bytes);
          return Success(
            ParsedDocumentPayload(
              fileName: fileName,
              format: format,
              extractedText: text,
              pageCount: 1,
              requiresOcrFallback: text.isEmpty,
            ),
          );
        case LegalDocumentFormat.pdf:
          final parsed = _extractPdfText(bytes);
          return Success(
            ParsedDocumentPayload(
              fileName: fileName,
              format: format,
              extractedText: parsed.text,
              pageCount: parsed.pageCount,
              requiresOcrFallback: parsed.text.trim().length < 40,
            ),
          );
        case LegalDocumentFormat.image:
          return Success(
            ParsedDocumentPayload(
              fileName: fileName,
              format: format,
              extractedText: '',
              pageCount: 1,
              requiresOcrFallback: true,
            ),
          );
      }
    } on Object catch (error) {
      return Err(
        ValidationFailure('Failed to parse document $fileName.', cause: error),
      );
    }
  }

  /// Generates a clean offline OOXML `.docx` byte archive from plain paragraphs.
  static Uint8List buildDocxBytes({
    required String title,
    required String bodyText,
  }) {
    final archive = Archive();

    String esc(String s) => s
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;');

    const contentTypes = '''
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">
  <Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/>
  <Default Extension="xml" ContentType="application/xml"/>
  <Override PartName="/word/document.xml" ContentType="application/vnd.openxmlformats-officedocument.wordprocessingml.document.main+xml"/>
</Types>''';

    const rels = '''
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
  <Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" Target="word/document.xml"/>
</Relationships>''';

    final paragraphs = [
      title,
      ...bodyText.split('\n'),
    ].map((line) => '<w:p><w:r><w:t>${esc(line)}</w:t></w:r></w:p>').join();

    final documentXml =
        '''
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<w:document xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
  <w:body>$paragraphs<w:sectPr/></w:body>
</w:document>''';

    void addStr(String name, String content) {
      final bytes = utf8.encode(content);
      archive.addFile(ArchiveFile(name, bytes.length, bytes));
    }

    addStr('[Content_Types].xml', contentTypes);
    addStr('_rels/.rels', rels);
    addStr('word/document.xml', documentXml);

    final encoded = ZipEncoder().encode(archive);
    return Uint8List.fromList(encoded);
  }

  static LegalDocumentFormat _detectFormat(String fileName, Uint8List bytes) {
    final lower = fileName.toLowerCase();
    if (bytes.length >= 4 &&
        bytes[0] == 0x50 &&
        bytes[1] == 0x4B &&
        bytes[2] == 0x03 &&
        bytes[3] == 0x04) {
      return LegalDocumentFormat.docx;
    }
    if (bytes.length >= 5 &&
        bytes[0] == 0x25 &&
        bytes[1] == 0x50 &&
        bytes[2] == 0x44 &&
        bytes[3] == 0x46 &&
        bytes[4] == 0x2D) {
      return LegalDocumentFormat.pdf;
    }
    if ((bytes.length >= 3 &&
            bytes[0] == 0xFF &&
            bytes[1] == 0xD8 &&
            bytes[2] == 0xFF) ||
        (bytes.length >= 4 &&
            bytes[0] == 0x89 &&
            bytes[1] == 0x50 &&
            bytes[2] == 0x4E &&
            bytes[3] == 0x47)) {
      return LegalDocumentFormat.image;
    }
    if (lower.endsWith('.docx')) return LegalDocumentFormat.docx;
    if (lower.endsWith('.pdf')) return LegalDocumentFormat.pdf;
    return LegalDocumentFormat.plainText;
  }

  static String _extractDocxText(Uint8List bytes) {
    final archive = ZipDecoder().decodeBytes(bytes);
    final docEntry = archive.files
        .where((f) => f.name == 'word/document.xml')
        .firstOrNull;
    if (docEntry == null) {
      throw const FormatException(
        'Invalid DOCX archive: missing word/document.xml.',
      );
    }
    final xmlBytes = docEntry.readBytes();
    if (xmlBytes == null) return '';
    final xmlDoc = XmlDocument.parse(
      utf8.decode(xmlBytes, allowMalformed: true),
    );
    final paragraphs = <String>[];
    for (final pNode in xmlDoc.findAllElements('w:p')) {
      final buf = StringBuffer();
      for (final tNode in pNode.findAllElements('w:t')) {
        buf.write(tNode.innerText);
      }
      final line = buf.toString().trim();
      if (line.isNotEmpty) {
        paragraphs.add(line);
      }
    }
    if (paragraphs.isEmpty) {
      for (final tNode in xmlDoc.findAllElements('t')) {
        final s = tNode.innerText.trim();
        if (s.isNotEmpty) paragraphs.add(s);
      }
    }
    return paragraphs.join('\n\n').trim();
  }

  static ({String text, int pageCount}) _extractPdfText(Uint8List bytes) {
    final rawLatin = latin1.decode(bytes, allowInvalid: true);
    final pageMatches = RegExp(r'/Type\s*/Page\b').allMatches(rawLatin).length;
    final pageCount = pageMatches > 0 ? pageMatches : 1;

    final extractedBlocks = <String>[];
    // 1. Decompress FlateDecode content streams when present and extract PDF text operators.
    final streamRe = RegExp(r'stream[\r\n]+([\s\S]*?)[\r\n]*endstream');
    for (final match in streamRe.allMatches(rawLatin)) {
      final startIdx = match.start + match.group(0)!.indexOf(match.group(1)!);
      final endIdx = startIdx + match.group(1)!.length;
      if (startIdx < 0 || endIdx > bytes.length) continue;

      final slice = bytes.sublist(startIdx, endIdx);
      String streamContent;
      try {
        final inflated = zlib.decode(slice);
        streamContent = latin1.decode(inflated, allowInvalid: true);
      } on Object {
        streamContent = latin1.decode(slice, allowInvalid: true);
      }

      if (streamContent.contains('BT') && streamContent.contains('ET')) {
        final textOps = _extractPdfTextOperators(streamContent);
        if (textOps.isNotEmpty) {
          extractedBlocks.add(textOps);
        }
      }
    }

    return (text: extractedBlocks.join('\n').trim(), pageCount: pageCount);
  }

  static String _extractPdfTextOperators(String content) {
    final buf = StringBuffer();
    final tjRe = RegExp(r'\(([^()\\]*(?:\\.[^()\\]*)*)\)\s*(?:Tj|\x27|")');
    for (final m in tjRe.allMatches(content)) {
      final token = m
          .group(1)!
          .replaceAll(r'\n', '\n')
          .replaceAll(r'\r', '')
          .replaceAll(r'\(', '(')
          .replaceAll(r'\)', ')')
          .replaceAll(r'\\', r'\');
      buf.write(token);
      if (!token.endsWith(' ')) buf.write(' ');
    }
    final tjArrRe = RegExp(r'\[([^\]]+)\]\s*TJ');
    for (final arrMatch in tjArrRe.allMatches(content)) {
      final inner = arrMatch.group(1)!;
      for (final strM in RegExp(
        r'\(([^()\\]*(?:\\.[^()\\]*)*)\)',
      ).allMatches(inner)) {
        buf.write(
          strM
              .group(1)!
              .replaceAll(r'\(', '(')
              .replaceAll(r'\)', ')')
              .replaceAll(r'\\', r'\'),
        );
      }
      buf.write(' ');
    }
    return buf.toString().replaceAll(RegExp(r'\s+'), ' ').trim();
  }
}
