import 'package:freezed_annotation/freezed_annotation.dart';

part 'lex_settings.freezed.dart';
part 'lex_settings.g.dart';

/// Theme mode selection for Lex.
enum LexThemeMode {
  /// Always use light theme.
  light,

  /// Always use dark theme.
  dark,

  /// Follow the operating system appearance.
  system,
}

/// Curated accent colour presets matching the Appearance Studio.
enum LexAccentPreset {
  /// Signature Deep Navy & Restrained Gold on Warm Ivory (`#13294B` light / `#D6AE52` dark).
  navyGold,

  /// Royal indigo (`#2F3FD8` light / `#93A4FF` dark).
  indigo,

  /// Calm legal teal (`#0E9F8E`).
  teal,

  /// Warm terracotta (`#C2410C`).
  terracotta,

  /// Deep violet (`#7C3AED`).
  violet,

  /// Crisp rose (`#BE185D`).
  rose,
}

/// Corner roundness presets for cards, buttons, and pills.
enum LexCornerRadius {
  /// Compact architectural corners.
  sharp,

  /// Balanced iOS liquid-glass corners (default).
  soft,

  /// Extra-pillowy organic corners.
  round,
}

/// Typography presets for reading and UI surfaces.
enum LexFontFamily {
  /// Platform native UI sans-serif.
  system,

  /// Editorial serif suitable for long statutory reading.
  serif,

  /// Monospace suitable for redlines and citations.
  mono,
}

/// User persona selected during onboarding.
enum LexUserRole {
  /// Citizen or individual seeking everyday legal clarity.
  individual,

  /// Small business owner reviewing contracts and compliance.
  business,

  /// Legal practitioner or advocate using rapid lookup and drafting.
  lawyer,
}

/// Preferred verbosity for AI answers.
enum LexAiAnswerStyle {
  /// Short, action-first summary.
  concise,

  /// Clear summary with key citations and reasoning (default).
  balanced,

  /// Comprehensive analysis with full statutory context.
  detailed,
}

/// Routing policy across on-device Gemma 4 and cloud Gemma 4.
enum LexModelRouting {
  /// Automatically picks on-device for short/private/offline tasks and cloud for deep research.
  auto,

  /// Force on-device Gemma 4 inference only.
  onDevice,

  /// Prefer cloud Gemma 4 via backend proxy.
  cloud,
}

/// Reorderable and toggleable widgets on the Home screen.
enum LexHomeWidget {
  /// Primary "Scan a document" hero action card.
  scanCta,

  /// Floating "Ask Lex anything legal..." search/chat entry bar.
  askBar,

  /// Horizontal quick-action pills (Incident, Draft, Contract review, Case file, Legal help).
  quickActions,

  /// Active contract risk summary card.
  riskRadar,

  /// Upcoming case-file deadlines card.
  deadlines,

  /// Recent scans, reviews, and research queries.
  recent,
}

/// Complete, persisted user customization and privacy settings for Lex.
@freezed
abstract class LexSettings with _$LexSettings {
  /// Creates an immutable [LexSettings] snapshot.
  const factory({
    @Default(false) bool onboardingCompleted,
    @Default(LexUserRole.individual) LexUserRole userRole,
    @Default(LexThemeMode.system) LexThemeMode themeMode,
    @Default(LexAccentPreset.navyGold) LexAccentPreset accentPreset,
    @Default(LexCornerRadius.soft) LexCornerRadius cornerRadius,
    @Default(0.65) double glassBlurIntensity,
    @Default(LexFontFamily.system) LexFontFamily fontFamily,
    @Default(1.0) double textScale,
    @Default(false) bool compactDensity,
    @Default(<LexHomeWidget>[
      LexHomeWidget.scanCta,
      LexHomeWidget.askBar,
      LexHomeWidget.quickActions,
      LexHomeWidget.deadlines,
      LexHomeWidget.riskRadar,
      LexHomeWidget.recent,
    ])
    List<LexHomeWidget> homeWidgetOrder,
    @Default(<LexHomeWidget>[
      LexHomeWidget.scanCta,
      LexHomeWidget.quickActions,
      LexHomeWidget.deadlines,
      LexHomeWidget.riskRadar,
      LexHomeWidget.recent,
    ])
    List<LexHomeWidget> enabledHomeWidgets,
    @Default(LexAiAnswerStyle.balanced) LexAiAnswerStyle aiAnswerStyle,
    @Default(true) bool strictCitationsOnly,
    @Default(true) bool showReasoningTrail,
    @Default(LexModelRouting.onDevice) LexModelRouting modelRouting,
    @Default(true) bool deepResearchUsesCloud,
    @Default('India · BNS, BNSS, BSA') String jurisdiction,
    @Default('en') String appLanguage,
    @Default(false) bool biometricLockEnabled,
    @Default(true) bool encryptLocalFiles,
    @Default(30) int autoDeleteScansDays,
    @Default(true) bool deadlineRemindersEnabled,
    @Default(true) bool hearingAlertsEnabled,
  }) = _LexSettings;

  /// Deserializes [LexSettings] from JSON.
  factory fromJson(Map<String, dynamic> json) => _$LexSettingsFromJson(json);
}
