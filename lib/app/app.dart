import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lex_copilot/app/flavors.dart';
import 'package:lex_copilot/app/router.dart';
import 'package:lex_copilot/app/theme/lex_theme.dart';
import 'package:lex_copilot/core/security/biometric_lock_service.dart';
import 'package:lex_copilot/core/security/security_providers.dart';
import 'package:lex_copilot/features/settings/presentation/settings_controller.dart';
import 'package:lex_copilot/l10n/app_localizations.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app.g.dart';

/// Provides the active [FlavorConfig] for the running build.
@Riverpod(keepAlive: true)
FlavorConfig flavorConfig(Ref ref) => FlavorConfig.fromEnvironment();

/// Root application widget for Lex.
class LexApp extends ConsumerWidget {
  /// Creates a [LexApp].
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsControllerProvider);
    final router = ref.watch(lexRouterProvider);
    final flavor = ref.watch(flavorConfigProvider);
    final securityService = ref.watch(appSecurityServiceProvider);

    return MaterialApp.router(
      title: flavor.appName,
      debugShowCheckedModeBanner: false,
      themeMode: LexTheme.toMaterialThemeMode(settings.themeMode),
      theme: LexTheme.build(settings, Brightness.light),
      darkTheme: LexTheme.build(settings, Brightness.dark),
      locale: Locale(settings.appLanguage),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routerConfig: router,
      builder: (context, child) {
        final mediaQuery = MediaQuery.of(context);
        return MediaQuery(
          data: mediaQuery.copyWith(
            textScaler: TextScaler.linear(settings.textScale),
          ),
          child: BiometricLockGate(
            locked: settings.biometricLockEnabled,
            securityService: securityService,
            child: child ?? const SizedBox.shrink(),
          ),
        );
      },
    );
  }
}
