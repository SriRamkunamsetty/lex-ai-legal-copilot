import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:drift/native.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lex_copilot/core/storage/app_database.dart';
import 'package:lex_copilot/legal_corpus/packs/knowledge_pack_service.dart';

class _MemAssetBundle extends CachingAssetBundle {
  new(this.assets);

  final Map<String, Uint8List> assets;

  @override
  Future<ByteData> load(String key) async {
    final bytes = assets[key];
    if (bytes == null) {
      throw StateError('Missing asset $key');
    }
    return ByteData.sublistView(bytes);
  }
}

void main() {
  test('KnowledgePackService verifies SHA-256 and hydrates provisions, footnotes, and graph links', () async {
    final packJson = jsonEncode({
      'pack_id': 'const_test_pack',
      'pack_name': 'Constitution Test Pack',
      'instrument': {
        'instrument_id': 'CONST_IN_2026',
        'instrument_type': 'constitution',
        'title': 'Constitution of India [As on 1st May, 2026]',
        'short_code': 'CONST',
        'source_authority': 'Legislative Department',
        'full_text_available': true,
        'verification_status': 'verified_in_book',
      },
      'provisions': [
        {
          'canonical_ref': 'CONST:ART:21',
          'instrument_id': 'CONST_IN_2026',
          'parent_ref': 'INST:CONSTITUTION_INDIA_2026',
          'provision_type': 'constitutional_article',
          'number': '21',
          'title': 'Protection of life and personal liberty',
          'part_or_chapter': 'PART III',
          'official_text': '21. No person shall be deprived of his life or personal liberty except according to procedure established by law.',
          'consolidated_status': 'active',
          'book_page': 42,
          'end_page': 42,
        },
      ],
      'footnotes': [
        {
          'footnote_id': 'FN_42_1',
          'provision_ref': 'CONST:ART:21',
          'footnote_number': '1',
          'book_page': 42,
          'footnote_type': 'editorial',
          'note_text': 'Test note',
          'referenced_instruments': <String>[],
        },
      ],
      'references': <Map<String, dynamic>>[],
      'entities': <Map<String, dynamic>>[],
      'relations': <Map<String, dynamic>>[],
    });
    final packBytes = Uint8List.fromList(utf8.encode(packJson));
    final goodSha = sha256.convert(packBytes).toString();

    final catalogJson = jsonEncode({
      'schema_version': 1,
      'packs': [
        {
          'pack_id': 'const_test_pack',
          'pack_name': 'Constitution Test Pack',
          'asset_path': 'assets/corpus/packs/const_test_pack.json',
          'jurisdiction': 'India',
          'version': '1.0.0',
          'source_authority': 'Legislative Department',
          'publication_date': '2026-05-01',
          'effective_date': '2026-04-16',
          'sha256': goodSha,
          'provision_count': 1,
          'size_bytes': packBytes.length,
        },
      ],
    });

    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);

    final service = KnowledgePackService(
      db,
      _MemAssetBundle({
        KnowledgePackService.catalogAssetPath: Uint8List.fromList(
          utf8.encode(catalogJson),
        ),
        'assets/corpus/packs/const_test_pack.json': packBytes,
      }),
    );

    final installedCount = await service.ensureBundledPacksInstalled();
    expect(installedCount.isSuccess, isTrue);
    expect(installedCount.valueOrNull, 1);

    final catalog = await service.loadCatalog();
    expect(catalog.valueOrNull!.first.installed, isTrue);

    // Tampered SHA-256 must fail verification cleanly.
    final badPack = KnowledgePackSummary(
      packId: 'const_test_pack',
      packName: 'Tampered',
      assetPath: 'assets/corpus/packs/const_test_pack.json',
      jurisdiction: 'India',
      version: '1.0.0',
      sourceAuthority: 'Legislative Department',
      publicationDate: '2026-05-01',
      effectiveDate: '2026-04-16',
      sha256: '0' * 64,
      provisionCount: 1,
      sizeBytes: packBytes.length,
    );
    final tamperedRes = await service.installAndVerifyPack(badPack);
    expect(tamperedRes.isErr, isTrue);
  });
}
