// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lex_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LexSettings _$LexSettingsFromJson(Map<String, dynamic> json) => _LexSettings(
  onboardingCompleted: json['onboardingCompleted'] as bool? ?? false,
  userRole:
      $enumDecodeNullable(_$LexUserRoleEnumMap, json['userRole']) ??
      LexUserRole.individual,
  themeMode:
      $enumDecodeNullable(_$LexThemeModeEnumMap, json['themeMode']) ??
      LexThemeMode.system,
  accentPreset:
      $enumDecodeNullable(_$LexAccentPresetEnumMap, json['accentPreset']) ??
      LexAccentPreset.navyGold,
  cornerRadius:
      $enumDecodeNullable(_$LexCornerRadiusEnumMap, json['cornerRadius']) ??
      LexCornerRadius.soft,
  glassBlurIntensity: (json['glassBlurIntensity'] as num?)?.toDouble() ?? 0.65,
  fontFamily:
      $enumDecodeNullable(_$LexFontFamilyEnumMap, json['fontFamily']) ??
      LexFontFamily.system,
  textScale: (json['textScale'] as num?)?.toDouble() ?? 1.0,
  compactDensity: json['compactDensity'] as bool? ?? false,
  homeWidgetOrder:
      (json['homeWidgetOrder'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$LexHomeWidgetEnumMap, e))
          .toList() ??
      const <LexHomeWidget>[
        LexHomeWidget.scanCta,
        LexHomeWidget.askBar,
        LexHomeWidget.quickActions,
        LexHomeWidget.deadlines,
        LexHomeWidget.riskRadar,
        LexHomeWidget.recent,
      ],
  enabledHomeWidgets:
      (json['enabledHomeWidgets'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$LexHomeWidgetEnumMap, e))
          .toList() ??
      const <LexHomeWidget>[
        LexHomeWidget.scanCta,
        LexHomeWidget.askBar,
        LexHomeWidget.quickActions,
        LexHomeWidget.recent,
      ],
  aiAnswerStyle:
      $enumDecodeNullable(_$LexAiAnswerStyleEnumMap, json['aiAnswerStyle']) ??
      LexAiAnswerStyle.balanced,
  strictCitationsOnly: json['strictCitationsOnly'] as bool? ?? true,
  showReasoningTrail: json['showReasoningTrail'] as bool? ?? true,
  modelRouting:
      $enumDecodeNullable(_$LexModelRoutingEnumMap, json['modelRouting']) ??
      LexModelRouting.onDevice,
  deepResearchUsesCloud: json['deepResearchUsesCloud'] as bool? ?? true,
  jurisdiction: json['jurisdiction'] as String? ?? 'India · BNS, BNSS, BSA',
  appLanguage: json['appLanguage'] as String? ?? 'en',
  biometricLockEnabled: json['biometricLockEnabled'] as bool? ?? false,
  encryptLocalFiles: json['encryptLocalFiles'] as bool? ?? true,
  autoDeleteScansDays: (json['autoDeleteScansDays'] as num?)?.toInt() ?? 30,
  deadlineRemindersEnabled: json['deadlineRemindersEnabled'] as bool? ?? true,
  hearingAlertsEnabled: json['hearingAlertsEnabled'] as bool? ?? true,
);

Map<String, dynamic> _$LexSettingsToJson(_LexSettings instance) =>
    <String, dynamic>{
      'onboardingCompleted': instance.onboardingCompleted,
      'userRole': _$LexUserRoleEnumMap[instance.userRole]!,
      'themeMode': _$LexThemeModeEnumMap[instance.themeMode]!,
      'accentPreset': _$LexAccentPresetEnumMap[instance.accentPreset]!,
      'cornerRadius': _$LexCornerRadiusEnumMap[instance.cornerRadius]!,
      'glassBlurIntensity': instance.glassBlurIntensity,
      'fontFamily': _$LexFontFamilyEnumMap[instance.fontFamily]!,
      'textScale': instance.textScale,
      'compactDensity': instance.compactDensity,
      'homeWidgetOrder': instance.homeWidgetOrder
          .map((e) => _$LexHomeWidgetEnumMap[e]!)
          .toList(),
      'enabledHomeWidgets': instance.enabledHomeWidgets
          .map((e) => _$LexHomeWidgetEnumMap[e]!)
          .toList(),
      'aiAnswerStyle': _$LexAiAnswerStyleEnumMap[instance.aiAnswerStyle]!,
      'strictCitationsOnly': instance.strictCitationsOnly,
      'showReasoningTrail': instance.showReasoningTrail,
      'modelRouting': _$LexModelRoutingEnumMap[instance.modelRouting]!,
      'deepResearchUsesCloud': instance.deepResearchUsesCloud,
      'jurisdiction': instance.jurisdiction,
      'appLanguage': instance.appLanguage,
      'biometricLockEnabled': instance.biometricLockEnabled,
      'encryptLocalFiles': instance.encryptLocalFiles,
      'autoDeleteScansDays': instance.autoDeleteScansDays,
      'deadlineRemindersEnabled': instance.deadlineRemindersEnabled,
      'hearingAlertsEnabled': instance.hearingAlertsEnabled,
    };

const _$LexUserRoleEnumMap = {
  LexUserRole.individual: 'individual',
  LexUserRole.business: 'business',
  LexUserRole.lawyer: 'lawyer',
};

const _$LexThemeModeEnumMap = {
  LexThemeMode.light: 'light',
  LexThemeMode.dark: 'dark',
  LexThemeMode.system: 'system',
};

const _$LexAccentPresetEnumMap = {
  LexAccentPreset.navyGold: 'navyGold',
  LexAccentPreset.indigo: 'indigo',
  LexAccentPreset.teal: 'teal',
  LexAccentPreset.terracotta: 'terracotta',
  LexAccentPreset.violet: 'violet',
  LexAccentPreset.rose: 'rose',
};

const _$LexCornerRadiusEnumMap = {
  LexCornerRadius.sharp: 'sharp',
  LexCornerRadius.soft: 'soft',
  LexCornerRadius.round: 'round',
};

const _$LexFontFamilyEnumMap = {
  LexFontFamily.system: 'system',
  LexFontFamily.serif: 'serif',
  LexFontFamily.mono: 'mono',
};

const _$LexHomeWidgetEnumMap = {
  LexHomeWidget.scanCta: 'scanCta',
  LexHomeWidget.askBar: 'askBar',
  LexHomeWidget.quickActions: 'quickActions',
  LexHomeWidget.riskRadar: 'riskRadar',
  LexHomeWidget.deadlines: 'deadlines',
  LexHomeWidget.recent: 'recent',
};

const _$LexAiAnswerStyleEnumMap = {
  LexAiAnswerStyle.concise: 'concise',
  LexAiAnswerStyle.balanced: 'balanced',
  LexAiAnswerStyle.detailed: 'detailed',
};

const _$LexModelRoutingEnumMap = {
  LexModelRouting.auto: 'auto',
  LexModelRouting.onDevice: 'onDevice',
  LexModelRouting.cloud: 'cloud',
};
