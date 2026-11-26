import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';
import 'package:lex_copilot/features/settings/domain/lex_settings.dart';

/// Design tokens for Lex's iOS-inspired liquid-glass aesthetic.
///
/// Exposed via [ThemeExtension] so theme mode, accent colour, corner radius,
/// glass blur intensity, font family, text scale, and density update live.
@immutable
class LexTokens extends ThemeExtension<LexTokens> {
  /// Creates a [LexTokens] instance.
  const new({
    required this.brightness,
    required this.background,
    required this.surface,
    required this.text,
    required this.secondaryText,
    required this.hairline,
    required this.accent,
    required this.onAccent,
    required this.accentTint,
    required this.glassFill,
    required this.glassHighlight,
    required this.glassShadow,
    required this.neutralControlFill,
    required this.riskHigh,
    required this.riskMedium,
    required this.riskLow,
    required this.statusOnline,
    required this.cardRadius,
    required this.pillRadius,
    required this.chipRadius,
    required this.blurSigma,
    required this.densityScale,
    required this.textScale,
    required this.fontFamily,
  });

  /// Builds [LexTokens] for a given [brightness] and user [settings].
  factory fromSettings(LexSettings settings, Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final accentPair = _accentFor(settings.accentPreset, isDark: isDark);
    final radii = _radiiFor(settings.cornerRadius);
    final densityScale = settings.compactDensity ? 0.84 : 1.0;
    final fontFamily = switch (settings.fontFamily) {
      LexFontFamily.system => null,
      LexFontFamily.serif => 'serif',
      LexFontFamily.mono => 'monospace',
    };

    if (isDark) {
      return LexTokens(
        brightness: Brightness.dark,
        background: const Color(0xFF0B0B0D),
        surface: const Color(0xFF17171A),
        text: const Color(0xFFF5F5F7),
        secondaryText: const Color(0xFFA0A0A8),
        hairline: const Color(0x1CFFFFFF),
        accent: accentPair.accent,
        onAccent: accentPair.onAccent,
        accentTint: accentPair.accent.withValues(alpha: 0.16),
        glassFill: const Color(0x9E26262C),
        glassHighlight: const Color(0x26FFFFFF),
        glassShadow: const Color(0x59000000),
        neutralControlFill: const Color(0x38787887),
        riskHigh: const Color(0xFFFDA29B),
        riskMedium: const Color(0xFFFEC84B),
        riskLow: const Color(0xFF6CE9A6),
        statusOnline: const Color(0xFF34D399),
        cardRadius: radii.card,
        pillRadius: radii.pill,
        chipRadius: radii.chip,
        blurSigma: 28.0 * settings.glassBlurIntensity.clamp(0.0, 1.0),
        densityScale: densityScale,
        textScale: settings.textScale.clamp(0.85, 2.0),
        fontFamily: fontFamily,
      );
    }

    return LexTokens(
      brightness: Brightness.light,
      background: settings.accentPreset == LexAccentPreset.navyGold
          ? const Color(0xFFFAF7F0)
          : const Color(0xFFFAFAF8),
      surface: const Color(0xFFFFFFFF),
      text: const Color(0xFF111113),
      secondaryText: const Color(0xFF66666C),
      hairline: const Color(0x17000000),
      accent: accentPair.accent,
      onAccent: accentPair.onAccent,
      accentTint: accentPair.accent.withValues(alpha: 0.10),
      glassFill: const Color(0xB8FFFFFF),
      glassHighlight: const Color(0x99FFFFFF),
      glassShadow: const Color(0x1F000000),
      neutralControlFill: const Color(0x29787887),
      riskHigh: const Color(0xFFB42318),
      riskMedium: const Color(0xFF8A5A00),
      riskLow: const Color(0xFF067647),
      statusOnline: const Color(0xFF34D399),
      cardRadius: radii.card,
      pillRadius: radii.pill,
      chipRadius: radii.chip,
      blurSigma: 28.0 * settings.glassBlurIntensity.clamp(0.0, 1.0),
      densityScale: densityScale,
      textScale: settings.textScale.clamp(0.85, 2.0),
      fontFamily: fontFamily,
    );
  }

  /// Light preset tokens using default settings.
  static final LexTokens light = LexTokens.fromSettings(
    const LexSettings(),
    Brightness.light,
  );

  /// Dark preset tokens using default settings.
  static final LexTokens dark = LexTokens.fromSettings(
    const LexSettings(),
    Brightness.dark,
  );

  /// Active brightness.
  final Brightness brightness;

  /// Primary scaffold background (`#FAFAF8` light / `#0B0B0D` dark).
  final Color background;

  /// Flat content card surface (`#FFFFFF` light / `#17171A` dark).
  final Color surface;

  /// Primary high-contrast foreground text.
  final Color text;

  /// Muted secondary metadata text.
  final Color secondaryText;

  /// 1px hairline border colour.
  final Color hairline;

  /// Active accent colour.
  final Color accent;

  /// Contrasting foreground placed on solid [accent] surfaces.
  final Color onAccent;

  /// Translucent tint of [accent] for chips, active tabs, and radial glow.
  final Color accentTint;

  /// Translucent fill for liquid-glass bars and floating controls.
  final Color glassFill;

  /// Subtle inner top highlight for glass surfaces.
  final Color glassHighlight;

  /// Ambient shadow behind floating glass elements.
  final Color glassShadow;

  /// Neutral track fill for segmented controls and secondary pills.
  final Color neutralControlFill;

  /// High risk indicator colour (WCAG AA compliant).
  final Color riskHigh;

  /// Medium risk indicator colour (WCAG AA compliant).
  final Color riskMedium;

  /// Low risk indicator colour (WCAG AA compliant).
  final Color riskLow;

  /// On-device model ready indicator colour.
  final Color statusOnline;

  /// Standard card corner radius.
  final double cardRadius;

  /// Floating bar / button pill radius.
  final double pillRadius;

  /// Chip / badge corner radius.
  final double chipRadius;

  /// Gaussian blur sigma for glass surfaces (`0` disables blur).
  final double blurSigma;

  /// Spacing multiplier (`1.0` comfortable, `0.84` compact).
  final double densityScale;

  /// User-configured text scale multiplier.
  final double textScale;

  /// Optional custom font family (`null` uses platform sans-serif).
  final String? fontFamily;

  /// Convenience padding helper scaled by [densityScale].
  double space(double base) => base * densityScale;

  static ({Color accent, Color onAccent}) _accentFor(
    LexAccentPreset preset, {
    required bool isDark,
  }) => switch ((preset, isDark)) {
    (LexAccentPreset.navyGold, false) => (
      accent: const Color(0xFF13294B),
      onAccent: const Color(0xFFFDFBF7),
    ),
    (LexAccentPreset.navyGold, true) => (
      accent: const Color(0xFFD6AE52),
      onAccent: const Color(0xFF0E1624),
    ),
    (LexAccentPreset.indigo, false) => (
      accent: const Color(0xFF2F3FD8),
      onAccent: const Color(0xFFFFFFFF),
    ),
    (LexAccentPreset.indigo, true) => (
      accent: const Color(0xFF93A4FF),
      onAccent: const Color(0xFF0B0B0D),
    ),
    (LexAccentPreset.teal, false) => (
      accent: const Color(0xFF0B7A6D),
      onAccent: const Color(0xFFFFFFFF),
    ),
    (LexAccentPreset.teal, true) => (
      accent: const Color(0xFF4FD1C5),
      onAccent: const Color(0xFF0B0B0D),
    ),
    (LexAccentPreset.terracotta, false) => (
      accent: const Color(0xFFB83B0A),
      onAccent: const Color(0xFFFFFFFF),
    ),
    (LexAccentPreset.terracotta, true) => (
      accent: const Color(0xFFFB923C),
      onAccent: const Color(0xFF0B0B0D),
    ),
    (LexAccentPreset.violet, false) => (
      accent: const Color(0xFF6D28D9),
      onAccent: const Color(0xFFFFFFFF),
    ),
    (LexAccentPreset.violet, true) => (
      accent: const Color(0xFFC4B5FD),
      onAccent: const Color(0xFF0B0B0D),
    ),
    (LexAccentPreset.rose, false) => (
      accent: const Color(0xFFBE185D),
      onAccent: const Color(0xFFFFFFFF),
    ),
    (LexAccentPreset.rose, true) => (
      accent: const Color(0xFFF472B6),
      onAccent: const Color(0xFF0B0B0D),
    ),
  };

  static ({double card, double pill, double chip}) _radiiFor(
    LexCornerRadius preset,
  ) => switch (preset) {
    LexCornerRadius.sharp => (card: 12.0, pill: 16.0, chip: 8.0),
    LexCornerRadius.soft => (card: 22.0, pill: 28.0, chip: 14.0),
    LexCornerRadius.round => (card: 28.0, pill: 33.0, chip: 18.0),
  };

  @override
  LexTokens copyWith({
    Brightness? brightness,
    Color? background,
    Color? surface,
    Color? text,
    Color? secondaryText,
    Color? hairline,
    Color? accent,
    Color? onAccent,
    Color? accentTint,
    Color? glassFill,
    Color? glassHighlight,
    Color? glassShadow,
    Color? neutralControlFill,
    Color? riskHigh,
    Color? riskMedium,
    Color? riskLow,
    Color? statusOnline,
    double? cardRadius,
    double? pillRadius,
    double? chipRadius,
    double? blurSigma,
    double? densityScale,
    double? textScale,
    String? fontFamily,
  }) {
    return LexTokens(
      brightness: brightness ?? this.brightness,
      background: background ?? this.background,
      surface: surface ?? this.surface,
      text: text ?? this.text,
      secondaryText: secondaryText ?? this.secondaryText,
      hairline: hairline ?? this.hairline,
      accent: accent ?? this.accent,
      onAccent: onAccent ?? this.onAccent,
      accentTint: accentTint ?? this.accentTint,
      glassFill: glassFill ?? this.glassFill,
      glassHighlight: glassHighlight ?? this.glassHighlight,
      glassShadow: glassShadow ?? this.glassShadow,
      neutralControlFill: neutralControlFill ?? this.neutralControlFill,
      riskHigh: riskHigh ?? this.riskHigh,
      riskMedium: riskMedium ?? this.riskMedium,
      riskLow: riskLow ?? this.riskLow,
      statusOnline: statusOnline ?? this.statusOnline,
      cardRadius: cardRadius ?? this.cardRadius,
      pillRadius: pillRadius ?? this.pillRadius,
      chipRadius: chipRadius ?? this.chipRadius,
      blurSigma: blurSigma ?? this.blurSigma,
      densityScale: densityScale ?? this.densityScale,
      textScale: textScale ?? this.textScale,
      fontFamily: fontFamily ?? this.fontFamily,
    );
  }

  @override
  LexTokens lerp(covariant ThemeExtension<LexTokens>? other, double t) {
    if (other is! LexTokens) return this;
    return LexTokens(
      brightness: t < 0.5 ? brightness : other.brightness,
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      text: Color.lerp(text, other.text, t)!,
      secondaryText: Color.lerp(secondaryText, other.secondaryText, t)!,
      hairline: Color.lerp(hairline, other.hairline, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      onAccent: Color.lerp(onAccent, other.onAccent, t)!,
      accentTint: Color.lerp(accentTint, other.accentTint, t)!,
      glassFill: Color.lerp(glassFill, other.glassFill, t)!,
      glassHighlight: Color.lerp(glassHighlight, other.glassHighlight, t)!,
      glassShadow: Color.lerp(glassShadow, other.glassShadow, t)!,
      neutralControlFill: Color.lerp(
        neutralControlFill,
        other.neutralControlFill,
        t,
      )!,
      riskHigh: Color.lerp(riskHigh, other.riskHigh, t)!,
      riskMedium: Color.lerp(riskMedium, other.riskMedium, t)!,
      riskLow: Color.lerp(riskLow, other.riskLow, t)!,
      statusOnline: Color.lerp(statusOnline, other.statusOnline, t)!,
      cardRadius: lerpDouble(cardRadius, other.cardRadius, t)!,
      pillRadius: lerpDouble(pillRadius, other.pillRadius, t)!,
      chipRadius: lerpDouble(chipRadius, other.chipRadius, t)!,
      blurSigma: lerpDouble(blurSigma, other.blurSigma, t)!,
      densityScale: lerpDouble(densityScale, other.densityScale, t)!,
      textScale: lerpDouble(textScale, other.textScale, t)!,
      fontFamily: t < 0.5 ? fontFamily : other.fontFamily,
    );
  }
}

/// Convenient accessor for [LexTokens] from [BuildContext].
extension LexTokensContextX on BuildContext {
  /// Returns the active [LexTokens] from the nearest [Theme], falling back to
  /// [LexTokens.light] or [LexTokens.dark] matching current brightness.
  LexTokens get lexTokens {
    final theme = Theme.of(this);
    return theme.extension<LexTokens>() ??
        (theme.brightness == Brightness.dark
            ? LexTokens.dark
            : LexTokens.light);
  }
}
