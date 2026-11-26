import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lex_copilot/app/app.dart';
import 'package:lex_copilot/app/flavors.dart';
import 'package:lex_copilot/core/result.dart';
import 'package:lex_copilot/core/security/secure_key_store.dart';
import 'package:lex_copilot/core/security/security_providers.dart';
import 'package:lex_copilot/core/storage/app_database.dart';
import 'package:lex_copilot/features/library/data/library_repository.dart';
import 'package:lex_copilot/features/settings/presentation/settings_controller.dart';
import 'package:lex_copilot/legal_corpus/providers/corpus_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Initializes platform bindings, OS keystore database key, encrypted Drift
/// database, auto-delete scan purge, and UI preferences, then runs [LexApp].
///
/// Never uses a hardcoded static fallback passphrase if the OS keystore fails.
Future<void> bootstrap({LexFlavor? flavor}) async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final config = FlavorConfig.fromEnvironment(flavor);

  final keyManager = SecureKeyManager(SecureStorageSecretStore());
  final keyResult = await keyManager.getOrCreateDatabaseKey();

  switch (keyResult) {
    case Err(:final failure):
      runApp(
        _KeystoreRecoveryApp(
          errorMessage: failure.message,
          onRetry: () => bootstrap(flavor: flavor),
        ),
      );
      return;
    case Success(:final value):
      final db = AppDatabase.openEncrypted(encryptionKey: value);
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
}

class _KeystoreRecoveryApp extends StatelessWidget {
  const new({required this.errorMessage, required this.onRetry});

  final String errorMessage;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.security_outlined, size: 48),
                const SizedBox(height: 16),
                const Text(
                  'Encrypted Vault Locked',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                Text(
                  '$errorMessage Unlock your device screen or verify OS Keystore access to open Lex.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 18),
                FilledButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('Retry Vault Unlock'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
