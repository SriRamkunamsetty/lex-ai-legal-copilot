import 'package:flutter/material.dart';
import 'package:lex_copilot/app/theme/lex_tokens.dart';
import 'package:lex_copilot/features/settings/domain/lex_settings.dart';

/// Builds Material [ThemeData] configured with [LexTokens] from [LexSettings].
abstract final class LexTheme {
  /// Converts [LexThemeMode] to Flutter's [ThemeMode].
  static ThemeMode toMaterialThemeMode(LexThemeMode mode) => switch (mode) {
    LexThemeMode.light => ThemeMode.light,
    LexThemeMode.dark => ThemeMode.dark,
    LexThemeMode.system => ThemeMode.system,
  };

  /// Builds a complete [ThemeData] for [brightness] driven by [settings].
  static ThemeData build(LexSettings settings, Brightness brightness) {
    final tokens = LexTokens.fromSettings(settings, brightness);
    final isDark = brightness == Brightness.dark;

    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: tokens.accent,
      onPrimary: tokens.onAccent,
      secondary: tokens.accent,
      onSecondary: tokens.onAccent,
      error: tokens.riskHigh,
      onError: isDark ? tokens.background : Colors.white,
      surface: tokens.surface,
      onSurface: tokens.text,
      surfaceContainerHighest: tokens.neutralControlFill,
      onSurfaceVariant: tokens.secondaryText,
      outline: tokens.hairline,
    );

    final baseText = isDark
        ? Typography.material2021().white
        : Typography.material2021().black;

    final textTheme = baseText
        .apply(
          bodyColor: tokens.text,
          displayColor: tokens.text,
          fontFamily: tokens.fontFamily,
        )
        .copyWith(
          headlineLarge: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.6,
            color: tokens.text,
            fontFamily: tokens.fontFamily,
          ),
          headlineMedium: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.4,
            color: tokens.text,
            fontFamily: tokens.fontFamily,
          ),
          titleLarge: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: tokens.text,
            fontFamily: tokens.fontFamily,
          ),
          titleMedium: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: tokens.text,
            fontFamily: tokens.fontFamily,
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            height: 1.5,
            color: tokens.text,
            fontFamily: tokens.fontFamily,
          ),
          bodyMedium: TextStyle(
            fontSize: 15,
            height: 1.45,
            color: tokens.text,
            fontFamily: tokens.fontFamily,
          ),
          bodySmall: TextStyle(
            fontSize: 13,
            height: 1.4,
            color: tokens.secondaryText,
            fontFamily: tokens.fontFamily,
          ),
          labelSmall: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: tokens.secondaryText,
            fontFamily: tokens.fontFamily,
          ),
        );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: tokens.background,
      fontFamily: tokens.fontFamily,
      textTheme: textTheme,
      dividerColor: tokens.hairline,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        foregroundColor: tokens.text,
        centerTitle: false,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: tokens.accent,
          foregroundColor: tokens.onAccent,
          minimumSize: const Size(48, 54),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(tokens.pillRadius),
          ),
          textStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: tokens.fontFamily,
          ),
        ),
      ),
      extensions: <ThemeExtension<dynamic>>[tokens],
    );
  }
}
