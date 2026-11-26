import 'dart:math';

import 'package:drift/drift.dart' hide isNull;
import 'package:flutter/foundation.dart';
import 'package:lex_copilot/core/storage/app_database.dart';
import 'package:lex_copilot/legal_corpus/models/legal_section.dart';
import 'package:lex_copilot/legal_corpus/repository/legal_corpus_repository.dart';
import 'package:lex_copilot/legal_corpus/resolver/reference_resolver.dart';

/// A single text chunk extracted from an attached document with overlap & page
/// metadata for [LocalRagEngine].
@immutable
class DocumentTextChunk {
  /// Creates a [DocumentTextChunk].
  const new({
    required this.chunkIndex,
    required this.pageNumber,
    required this.text,
    required this.score,
  });

  /// Sequential 0-based index in the document.
  final int chunkIndex;

  /// Approximate 1-based page number (`[Page N]` markers if present).
  final int pageNumber;

  /// Chunk text.
  final String text;

  /// Hybrid relevance score relative to the query.
  final double score;
}

/// Grounded knowledge retrieved offline via FTS5 BM25 + semantic vector RRF +
/// 1-hop Knowledge Graph expansion.
@immutable
class RagRetrievalBundle {
  /// Creates a [RagRetrievalBundle].
  const new({
    required this.sections,
    required this.footnotes,
    required this.graphRelations,
    required this.documentChunks,
    required this.unavailableExternalRefs,
  });

  /// Top ranked statutory & constitutional provisions (`LegalSections`).
  final List<LegalSectionModel> sections;

  /// Linked separated footnotes (`amendment`, `judicial_invalidation`, `commencement_unnotified`).
  final List<
    ({String provisionRef, String footnoteType, String noteText, int bookPage})
  >
  footnotes;

  /// 1-hop verified knowledge graph relationships for cited provisions.
  final List<
    ({
      String fromEntity,
      String relationType,
      String toEntity,
      String sourceRef,
    })
  >
  graphRelations;

  /// Highest-ranked chunks from a long attached document (no 2,500-char cutoff).
  final List<DocumentTextChunk> documentChunks;

  /// External Acts referenced in retrieved provisions/footnotes where `full_text_available == false`.
  final List<({String title, String referenceNumber, int bookPage})>
  unavailableExternalRefs;
}

/// Offline Local Hybrid RAG Engine (Modules D & E):
/// - Overlapping chunker for long attached documents.
/// - Deterministic local 128-dim sparse-dense semantic vectorizer (cosine similarity).
/// - Reciprocal Rank Fusion (RRF) combining SQLite FTS5 BM25 + vector score +
///   canonical citation matches + 1-hop Knowledge Graph expansion.
class LocalRagEngine {
  /// Creates a [LocalRagEngine].
  const new({required this.db, required this.corpus});

  /// Encrypted database instance.
  final AppDatabase db;

  /// Offline statutory corpus repository.
  final LegalCorpusRepository corpus;

  /// Embedding dimension of local lightweight semantic vectors.
  static const int vectorDim = 128;

  /// Splits [documentText] into overlapping chunks (~650 chars, 120-char overlap),
  /// preserving optional `[Page N]` / `--- Page N ---` headers.
  static List<({int chunkIndex, int pageNumber, String text})> chunkDocument(
    String documentText, {
    int chunkSize = 650,
    int overlap = 120,
  }) {
    final normalized = documentText.trim();
    if (normalized.isEmpty) return const [];

    final step = max(120, chunkSize - overlap);
    final chunks = <({int chunkIndex, int pageNumber, String text})>[];
    var cursor = 0;
    var index = 0;
    var currentPage = 1;
    final pageMarkerRe = RegExp(
      r'\[Page\s+(\d+)\]|---\s*Page\s+(\d+)\s*---',
      caseSensitive: false,
    );

    while (cursor < normalized.length) {
      final end = min(normalized.length, cursor + chunkSize);
      final slice = normalized.substring(cursor, end).trim();
      final pageMatch = pageMarkerRe.allMatches(slice).lastOrNull;
      if (pageMatch != null) {
        final rawPage = pageMatch.group(1) ?? pageMatch.group(2);
        currentPage = int.tryParse(rawPage ?? '') ?? currentPage;
      }
      if (slice.isNotEmpty) {
        chunks.add((chunkIndex: index, pageNumber: currentPage, text: slice));
        index += 1;
      }
      if (end >= normalized.length) break;
      cursor += step;
    }
    return chunks;
  }

  /// Computes a normalized deterministic 128-dimensional local semantic feature
  /// vector using signed token + character-trigram hashing. Runs cleanly on all
  /// devices offline with zero external dependencies.
  static Float32List embedText(String text) {
    final vec = Float32List(vectorDim);
    final lower = text.toLowerCase();
    final tokens = lower
        .split(RegExp('[^a-z0-9]+'))
        .where((t) => t.length >= 2)
        .toList();

    void project(String feature, double weight) {
      var hash = 2166136261;
      for (var i = 0; i < feature.length; i++) {
        hash ^= feature.codeUnitAt(i);
        hash = (hash * 16777619) & 0x7FFFFFFF;
      }
      final idx = hash % vectorDim;
      final sign = ((hash >> 8) & 1) == 0 ? 1.0 : -1.0;
      vec[idx] += sign * weight;
    }

    for (final token in tokens) {
      project('tok:$token', 2);
      if (token.length >= 4) {
        for (var i = 0; i <= token.length - 3; i++) {
          project('tri:${token.substring(i, i + 3)}', 0.6);
        }
      }
    }

    double normSq = 0;
    for (var i = 0; i < vectorDim; i++) {
      normSq += vec[i] * vec[i];
    }
    if (normSq > 0) {
      final inv = 1.0 / sqrt(normSq);
      for (var i = 0; i < vectorDim; i++) {
        vec[i] *= inv;
      }
    }
    return vec;
  }

  /// Computes cosine similarity in `[-1.0, 1.0]` between two L2-normalized vectors.
  static double cosineSimilarity(Float32List a, Float32List b) {
    final len = min(a.length, b.length);
    double dot = 0;
    for (var i = 0; i < len; i++) {
      dot += a[i] * b[i];
    }
    return dot;
  }

  /// Ranks document chunks using hybrid lexical + semantic cosine similarity.
  static List<DocumentTextChunk> retrieveDocumentChunks({
    required String query,
    required String documentText,
    int maxChunks = 5,
  }) {
    final rawChunks = chunkDocument(documentText);
    if (rawChunks.isEmpty) return const [];
    if (rawChunks.length <= maxChunks) {
      return rawChunks
          .map(
            (c) => DocumentTextChunk(
              chunkIndex: c.chunkIndex,
              pageNumber: c.pageNumber,
              text: c.text,
              score: 1,
            ),
          )
          .toList();
    }

    final queryVec = embedText(query);
    final queryTerms = query
        .toLowerCase()
        .split(RegExp('[^a-z0-9]+'))
        .where((t) => t.length >= 3)
        .toSet();

    final scored = rawChunks.map((c) {
      final vec = embedText(c.text);
      final semScore = cosineSimilarity(queryVec, vec);
      final lowerChunk = c.text.toLowerCase();
      var lexHits = 0;
      for (final term in queryTerms) {
        if (lowerChunk.contains(term)) lexHits += 1;
      }
      final lexScore = queryTerms.isEmpty ? 0.0 : lexHits / queryTerms.length;
      final totalScore = (semScore * 0.6) + (lexScore * 0.4);
      return DocumentTextChunk(
        chunkIndex: c.chunkIndex,
        pageNumber: c.pageNumber,
        text: c.text,
        score: totalScore,
      );
    }).toList()..sort((a, b) => b.score.compareTo(a.score));

    // Always preserve chunk 0 (parties/preamble context) alongside highest matches.
    final picked = <DocumentTextChunk>[];
    final seenIndices = <int>{};
    for (final c in scored.take(maxChunks)) {
      if (seenIndices.add(c.chunkIndex)) picked.add(c);
    }
    if (!seenIndices.contains(0)) {
      final first = DocumentTextChunk(
        chunkIndex: rawChunks.first.chunkIndex,
        pageNumber: rawChunks.first.pageNumber,
        text: rawChunks.first.text,
        score: 0.5,
      );
      if (picked.length >= maxChunks && picked.isNotEmpty) {
        picked.removeLast();
      }
      picked.insert(0, first);
    }
    return picked..sort((a, b) => a.chunkIndex.compareTo(b.chunkIndex));
  }

  /// Performs hybrid retrieval (Canonical lookup + FTS5 BM25 + semantic RRF +
  /// 1-hop graph expansion + separated footnotes + `full_text_available` boundary check).
  Future<RagRetrievalBundle> retrieve({
    required String query,
    String? documentContext,
    int maxSections = 5,
    int maxDocChunks = 5,
  }) async {
    final docChunks =
        documentContext != null && documentContext.trim().isNotEmpty
        ? retrieveDocumentChunks(
            query: query,
            documentText: documentContext,
            maxChunks: maxDocChunks,
          )
        : const <DocumentTextChunk>[];

    // 1. Canonical citations mentioned explicitly in query
    final directRefs = LegalReferenceResolver.extractAll(query);
    final candidateMap = <String, LegalSectionModel>{};
    final rrfScores = <String, double>{};
    const rrfK = 60.0;

    for (var rank = 0; rank < directRefs.length; rank++) {
      final r = directRefs[rank];
      final res = await corpus.getSection(r.actCode, r.provisionNumber);
      if (res.valueOrNull case final sec?) {
        final key = '${sec.actCode}:${sec.sectionNumber}';
        candidateMap[key] = sec;
        rrfScores[key] = (rrfScores[key] ?? 0) + (2.0 / (rrfK + rank + 1));
      }
    }

    // 2. Lexical FTS5 candidates
    final ftsRes = await corpus.search(query, limit: maxSections * 3);
    final ftsList = ftsRes.valueOrNull ?? const <LegalSectionModel>[];
    for (var rank = 0; rank < ftsList.length; rank++) {
      final sec = ftsList[rank];
      final key = '${sec.actCode}:${sec.sectionNumber}';
      candidateMap[key] = sec;
      rrfScores[key] = (rrfScores[key] ?? 0) + (1.0 / (rrfK + rank + 1));
    }

    // 3. Semantic re-ranking over candidate pool using local feature vectors
    final queryVec = embedText(query);
    final semanticList = candidateMap.entries.map((entry) {
      final secVec = embedText('${entry.value.title} ${entry.value.text}');
      return (key: entry.key, sim: cosineSimilarity(queryVec, secVec));
    }).toList()..sort((a, b) => b.sim.compareTo(a.sim));

    for (var rank = 0; rank < semanticList.length; rank++) {
      final key = semanticList[rank].key;
      rrfScores[key] = (rrfScores[key] ?? 0) + (1.0 / (rrfK + rank + 1));
    }

    final rankedKeys = rrfScores.keys.toList()
      ..sort((a, b) => (rrfScores[b] ?? 0).compareTo(rrfScores[a] ?? 0));
    final topSections = rankedKeys
        .take(maxSections)
        .map((k) => candidateMap[k]!)
        .toList();

    // 4. Fetch separated footnotes & 1-hop Knowledge Graph links from AppDatabase
    final canonicalRefs = topSections
        .map(
          (s) => s.actCode == 'CONST'
              ? (s.sectionNumber == 'PREAMBLE' ||
                        s.sectionNumber.startsWith('SCH:') ||
                        s.sectionNumber.startsWith('APP:')
                    ? 'CONST:${s.sectionNumber}'
                    : 'CONST:ART:${s.sectionNumber}')
              : 'CENTRAL:${s.actCode}:${s.sectionNumber}',
        )
        .toList();

    final footnotes =
        <
          ({
            String provisionRef,
            String footnoteType,
            String noteText,
            int bookPage,
          })
        >[];
    final graphRelations =
        <
          ({
            String fromEntity,
            String relationType,
            String toEntity,
            String sourceRef,
          })
        >[];
    final unavailableRefs =
        <({String title, String referenceNumber, int bookPage})>[];

    if (canonicalRefs.isNotEmpty) {
      try {
        final fnRows =
            await (db.select(db.legalFootnotes)
                  ..where((t) => t.provisionRef.isIn(canonicalRefs))
                  ..limit(12))
                .get();
        for (final row in fnRows) {
          footnotes.add((
            provisionRef: row.provisionRef,
            footnoteType: row.footnoteType,
            noteText: row.noteText,
            bookPage: row.bookPage,
          ));
        }

        final relRows =
            await (db.select(db.legalRelations)
                  ..where(
                    (t) =>
                        t.fromEntity.isIn(canonicalRefs) |
                        t.toEntity.isIn(canonicalRefs),
                  )
                  ..limit(15))
                .get();
        for (final rel in relRows) {
          graphRelations.add((
            fromEntity: rel.fromEntity,
            relationType: rel.relationType,
            toEntity: rel.toEntity,
            sourceRef: rel.sourceRef,
          ));
        }

        final refRows =
            await (db.select(db.legalReferences)
                  ..where(
                    (t) =>
                        t.sourceProvisionRef.isIn(canonicalRefs) &
                        t.fullTextAvailable.equals(false),
                  )
                  ..limit(10))
                .get();
        for (final ext in refRows) {
          unavailableRefs.add((
            title: ext.title,
            referenceNumber: ext.referenceNumber,
            bookPage: ext.bookPage,
          ));
        }
      } on Object {
        // Safely return lexical/semantic results if KG tables haven't hydrated yet.
      }
    }

    // Also inspect any direct Central Acts referenced by the query whose full text
    // is marked unavailable in LegalInstruments (e.g., ICA_1872 / NI_1881 / CPC_1908).
    for (final direct in directRefs) {
      if (direct.family == LegalInstrumentFamily.centralAct) {
        try {
          final inst =
              await (db.select(db.legalInstruments)
                    ..where((t) => t.shortCode.equals(direct.actCode)))
                  .getSingleOrNull();
          if (inst != null && !inst.fullTextAvailable) {
            unavailableRefs.add((
              title: inst.title,
              referenceNumber: '${inst.shortCode} s.${direct.provisionNumber}',
              bookPage: 0,
            ));
          }
        } on Object {
          // Non-fatal check.
        }
      }
    }

    return RagRetrievalBundle(
      sections: topSections,
      footnotes: footnotes,
      graphRelations: graphRelations,
      documentChunks: docChunks,
      unavailableExternalRefs: unavailableRefs,
    );
  }
}
