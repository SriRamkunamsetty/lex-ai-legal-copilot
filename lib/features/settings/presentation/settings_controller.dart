import 'package:lex_copilot/features/settings/data/settings_repository.dart';
import 'package:lex_copilot/features/settings/domain/lex_settings.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'settings_controller.g.dart';

/// Provides the initialized [SharedPreferences] instance.
///
/// Overridden in `bootstrap` during app startup and in widget/unit tests.
@Riverpod(keepAlive: true)
SharedPreferences sharedPreferences(Ref ref) {
  throw UnimplementedError(
    'sharedPreferencesProvider must be overridden with an initialized instance.',
  );
}

/// Provides the [SettingsRepository].
@Riverpod(keepAlive: true)
SettingsRepository settingsRepository(Ref ref) {
  return SettingsRepository(ref.watch(sharedPreferencesProvider));
}

/// Live reactive controller for all [LexSettings] customization options.
@Riverpod(keepAlive: true)
class SettingsController extends _$SettingsController {
  @override
  LexSettings build() {
    final repo = ref.watch(settingsRepositoryProvider);
    return repo.load().fold(
      onSuccess: (settings) => settings,
      onFailure: (_) => const LexSettings(),
    );
  }

  /// Applies [transform] to the current settings immediately and persists it.
  Future<void> update(
    LexSettings Function(LexSettings current) transform,
  ) async {
    final next = transform(state);
    state = next;
    await ref.read(settingsRepositoryProvider).save(next);
  }

  /// Completes onboarding with the chosen [role] and [modelRouting].
  Future<void> completeOnboarding({
    required LexUserRole role,
    required LexModelRouting modelRouting,
  }) => update(
    (s) => s.copyWith(
      onboardingCompleted: true,
      userRole: role,
      modelRouting: modelRouting,
    ),
  );

  /// Updates theme mode (light / dark / system).
  Future<void> setThemeMode(LexThemeMode mode) =>
      update((s) => s.copyWith(themeMode: mode));

  /// Updates accent colour preset.
  Future<void> setAccentPreset(LexAccentPreset preset) =>
      update((s) => s.copyWith(accentPreset: preset));

  /// Updates corner roundness preset.
  Future<void> setCornerRadius(LexCornerRadius radius) =>
      update((s) => s.copyWith(cornerRadius: radius));

  /// Updates glass blur intensity clamped to `[0.0, 1.0]`.
  Future<void> setGlassBlurIntensity(double intensity) =>
      update((s) => s.copyWith(glassBlurIntensity: intensity.clamp(0.0, 1.0)));

  /// Updates font family preset.
  Future<void> setFontFamily(LexFontFamily family) =>
      update((s) => s.copyWith(fontFamily: family));

  /// Updates text scale clamped to `[0.85, 2.0]`.
  Future<void> setTextScale(double scale) =>
      update((s) => s.copyWith(textScale: scale.clamp(0.85, 2.0)));

  /// Toggles compact layout density.
  Future<void> setCompactDensity({required bool compact}) =>
      update((s) => s.copyWith(compactDensity: compact));

  /// Toggles visibility of a Home screen widget.
  Future<void> toggleHomeWidget(
    LexHomeWidget widget, {
    required bool enabled,
  }) => update((s) {
    final next = List<LexHomeWidget>.from(s.enabledHomeWidgets);
    if (enabled && !next.contains(widget)) {
      next.add(widget);
    } else if (!enabled) {
      next.remove(widget);
    }
    return s.copyWith(enabledHomeWidgets: next);
  });

  /// Reorders Home widgets by moving [oldIndex] to [newIndex] (already adjusted
  /// for removal, matching `ReorderableListView.onReorderItem`).
  Future<void> reorderHomeWidgets(int oldIndex, int newIndex) => update((s) {
    final order = List<LexHomeWidget>.from(s.homeWidgetOrder);
    if (oldIndex < 0 || oldIndex >= order.length) return s;
    final targetIndex = newIndex.clamp(0, order.length - 1);
    final item = order.removeAt(oldIndex);
    order.insert(targetIndex, item);
    return s.copyWith(homeWidgetOrder: order);
  });

  /// Updates AI answer verbosity style.
  Future<void> setAiAnswerStyle(LexAiAnswerStyle style) =>
      update((s) => s.copyWith(aiAnswerStyle: style));

  /// Toggles strict corpus-verified citations.
  Future<void> setStrictCitationsOnly({required bool value}) =>
      update((s) => s.copyWith(strictCitationsOnly: value));

  /// Toggles reasoning trail visibility in chat answers.
  Future<void> setShowReasoningTrail({required bool value}) =>
      update((s) => s.copyWith(showReasoningTrail: value));

  /// Updates model routing preference.
  Future<void> setModelRouting(LexModelRouting routing) =>
      update((s) => s.copyWith(modelRouting: routing));

  /// Toggles whether deep research may use cloud Gemma 4.
  Future<void> setDeepResearchUsesCloud({required bool value}) =>
      update((s) => s.copyWith(deepResearchUsesCloud: value));

  /// Updates legal jurisdiction label.
  Future<void> setJurisdiction(String jurisdiction) =>
      update((s) => s.copyWith(jurisdiction: jurisdiction));

  /// Updates ISO language code (`en`, `hi`, `te`).
  Future<void> setAppLanguage(String languageCode) =>
      update((s) => s.copyWith(appLanguage: languageCode));

  /// Toggles biometric app lock.
  Future<void> setBiometricLockEnabled({required bool value}) =>
      update((s) => s.copyWith(biometricLockEnabled: value));

  /// Toggles local file encryption.
  Future<void> setEncryptLocalFiles({required bool value}) =>
      update((s) => s.copyWith(encryptLocalFiles: value));

  /// Updates scan auto-delete retention window in days (`0` means never).
  Future<void> setAutoDeleteScansDays(int days) =>
      update((s) => s.copyWith(autoDeleteScansDays: days));

  /// Toggles deadline reminder notifications.
  Future<void> setDeadlineRemindersEnabled({required bool value}) =>
      update((s) => s.copyWith(deadlineRemindersEnabled: value));

  /// Toggles hearing alert notifications.
  Future<void> setHearingAlertsEnabled({required bool value}) =>
      update((s) => s.copyWith(hearingAlertsEnabled: value));

  /// Resets all settings to defaults.
  Future<void> resetAll() async {
    final result = await ref.read(settingsRepositoryProvider).reset();
    state = result.valueOrNull ?? const LexSettings();
  }
}
