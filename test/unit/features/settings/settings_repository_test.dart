import 'package:flutter_test/flutter_test.dart';
import 'package:lex_copilot/core/errors/failure.dart';
import 'package:lex_copilot/features/settings/data/settings_repository.dart';
import 'package:lex_copilot/features/settings/domain/lex_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('SettingsRepository', () {
    test('returns default LexSettings when storage is empty', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final repo = SettingsRepository(prefs);

      final loaded = repo.load();
      expect(loaded.isSuccess, isTrue);
      expect(loaded.valueOrNull, const LexSettings());
    });

    test('saves and reloads customized LexSettings', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final repo = SettingsRepository(prefs);

      const custom = LexSettings(
        onboardingCompleted: true,
        userRole: LexUserRole.lawyer,
        themeMode: LexThemeMode.dark,
        accentPreset: LexAccentPreset.teal,
        cornerRadius: LexCornerRadius.round,
        glassBlurIntensity: 0.9,
        fontFamily: LexFontFamily.serif,
        textScale: 1.25,
        compactDensity: true,
        appLanguage: 'hi',
        biometricLockEnabled: true,
        autoDeleteScansDays: 7,
      );

      final saved = await repo.save(custom);
      expect(saved.isSuccess, isTrue);

      final reloaded = repo.load();
      expect(reloaded.valueOrNull, custom);
    });

    test('returns StorageFailure on corrupted JSON payload', () async {
      SharedPreferences.setMockInitialValues({
        SettingsRepository.settingsKey: '{not valid json',
      });
      final prefs = await SharedPreferences.getInstance();
      final repo = SettingsRepository(prefs);

      final loaded = repo.load();
      expect(loaded.isErr, isTrue);
      expect(loaded.failureOrNull, isA<StorageFailure>());
    });

    test('reset restores default settings', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final repo = SettingsRepository(prefs);

      await repo.save(const LexSettings(onboardingCompleted: true));
      final reset = await repo.reset();
      expect(reset.valueOrNull, const LexSettings());
      expect(repo.load().valueOrNull, const LexSettings());
    });
  });
}
