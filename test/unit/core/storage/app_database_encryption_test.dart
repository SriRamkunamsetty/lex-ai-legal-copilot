import 'dart:io';

import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lex_copilot/core/storage/app_database.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart' as sq;

void main() {
  group('Encrypted AppDatabase (sqlite3mc)', () {
    test('encrypts database file at rest with PRAGMA key', () async {
      final tempDir = await Directory.systemTemp.createTemp('lex_enc_test_');
      addTearDown(() async {
        if (tempDir.existsSync()) {
          await tempDir.delete(recursive: true);
        }
      });

      final dbFile = File(p.join(tempDir.path, 'vault.sqlite'));
      const secretKey =
          '0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef';

      final encryptedDb = AppDatabase.forTesting(
        NativeDatabase(
          dbFile,
          setup: (rawDb) {
            rawDb
              ..execute("PRAGMA key = '$secretKey';")
              ..execute("PRAGMA cipher = 'sqlcipher';");
          },
        ),
      );

      await encryptedDb
          .into(encryptedDb.bookmarks)
          .insert(
            BookmarksCompanion.insert(
              actCode: 'BNS',
              sectionNumber: '304',
              note: const Value('CONFIDENTIAL_NOTE_TOKEN'),
            ),
          );
      await encryptedDb.close();

      final bytes = await dbFile.readAsBytes();
      final header = String.fromCharCodes(bytes.take(15));
      expect(header, isNot('SQLite format 3'));
      expect(
        String.fromCharCodes(bytes).contains('CONFIDENTIAL_NOTE_TOKEN'),
        isFalse,
      );

      // Opening without key must fail to read encrypted pages
      final unkeyed = sq.sqlite3.open(dbFile.path);
      addTearDown(unkeyed.close);
      expect(
        () => unkeyed.select('SELECT * FROM bookmarks'),
        throwsA(isA<sq.SqliteException>()),
      );
    });
  });
}
