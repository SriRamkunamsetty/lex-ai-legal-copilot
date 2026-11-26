import 'package:flutter_test/flutter_test.dart';
import 'package:lex_copilot/ai/rag/local_rag_engine.dart';
import 'package:lex_copilot/legal_corpus/resolver/reference_resolver.dart';

void main() {
  group('LegalReferenceResolver (Module B)', () {
    test('resolves Constitutional, Criminal, Central Act, CO, and SC citations cleanly', () {
      const sample =
          'Under Article 21 and Article 239AA(2)(ba) of the Constitution, '
          'read with Preamble and Ninth Schedule, and also BNS 304, BNSS Section 173, '
          'DPDP Act Section 8, IT Act 66C, NI Act s. 138, C.O. 272, and '
          'Supreme Court ruling AIR 2016 SC 117.';

      final refs = LegalReferenceResolver.extractAll(sample);
      final keys = refs.map((r) => r.canonicalRef).toSet();

      expect(keys, contains('CONST:ART:21'));
      expect(keys, contains('CONST:ART:239AA'));
      expect(keys, contains('CONST:PREAMBLE'));
      expect(keys, contains('CONST:SCH:9'));
      expect(keys, contains('CENTRAL:BNS:304'));
      expect(keys, contains('CENTRAL:BNSS:173'));
      expect(keys, contains('CENTRAL:DPDP_2023:8'));
      expect(keys, contains('CENTRAL:IT_2000:66C'));
      expect(keys, contains('CENTRAL:NI_1881:138'));
      expect(keys, contains('CO:272'));
      expect(keys, contains('SC:AIR_2016_SC_117'));
    });
  });

  group('LocalRagEngine Document Chunker & Hybrid Retrieval (Module E)', () {
    test(
      'chunks long 12,000+ char documents without silent 2,500-char cutoff',
      () {
        final buffer = StringBuffer()
          ..writeln('[Page 1] AGREEMENT BETWEEN ALPHA AND BETA.')
          ..writeln('Standard boilerplate terms repeated for spacing. ' * 90)
          ..writeln('[Page 4] CLAUSE 19. INDEMNITY CAP AND LIABILITY.')
          ..writeln(
            'Supplier indemnity shall never exceed 12 months fees paid under Section 73 of Indian Contract Act.',
          )
          ..writeln('Additional miscellaneous boilerplate tail. ' * 90);

        final doc = buffer.toString();
        expect(doc.length, greaterThan(8000));

        final chunks = LocalRagEngine.chunkDocument(doc);
        expect(chunks.length, greaterThan(10));

        final top = LocalRagEngine.retrieveDocumentChunks(
          query: 'indemnity cap liability months fees',
          documentText: doc,
          maxChunks: 4,
        );
        expect(top, isNotEmpty);
        expect(top.any((c) => c.text.contains('12 months fees')), isTrue);
        expect(top.first.chunkIndex, 0); // Keeps preamble context chunk 0
      },
    );

    test('computes deterministic normalized semantic vectors', () {
      final vArticle = LocalRagEngine.embedText(
        'Right to life and personal liberty under Article 21 Constitution of India',
      );
      final vRelated = LocalRagEngine.embedText(
        'Article 21 personal liberty protection constitutional right',
      );
      final vUnrelated = LocalRagEngine.embedText(
        'Cheque dishonour insufficiency of funds bank memo stamp duty',
      );

      final simRel = LocalRagEngine.cosineSimilarity(vArticle, vRelated);
      final simUnrel = LocalRagEngine.cosineSimilarity(vArticle, vUnrelated);
      expect(simRel, greaterThan(simUnrel));
      expect(simRel, greaterThan(0.3));
    });
  });
}
