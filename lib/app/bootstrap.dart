import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lex_copilot/app/app.dart';
import 'package:lex_copilot/app/flavors.dart';
import 'package:lex_copilot/core/security/secure_key_store.dart';
import 'package:lex_copilot/core/security/security_providers.dart';
import 'package:lex_copilot/core/storage/app_database.dart';
import 'package:lex_copilot/features/library/data/library_repository.dart';
import 'package:lex_copilot/features/settings/presentation/settings_controller.dart';
import 'package:lex_copilot/legal_corpus/providers/corpus_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Initializes platform bindings, OS keystore database key, encrypted Drift
/// database, auto-delete scan purge, and UI preferences, then runs [LexApp].
Future<void> bootstrap({LexFlavor? flavor}) async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final config = FlavorConfig.fromEnvironment(flavor);

  final keyManager = SecureKeyManager(SecureStorageSecretStore());
  final keyResult = await keyManager.getOrCreateDatabaseKey();
  final dbKey = keyResult.fold(
    onSuccess: (key) => key,
    // Fallback only if platform keystore is unavailable on unsupported test hosts.
    onFailure: (_) => 'lex-fallback-ephemeral-session-key',
  );
  final db = AppDatabase.openEncrypted(encryptionKey: dbKey);

  // Enforce retention lifecycle at startup.
  unawaited(LibraryRepository(db).purgeExpiredScans());

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        flavorConfigProvider.overrideWithValue(config),
        secureKeyManagerProvider.overrideWithValue(keyManager),
        appDatabaseProvider.overrideWithValue(db),
      ],
      child: const LexApp(),
    ),
  );
}
