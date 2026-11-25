import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lex_copilot/features/settings/domain/lex_settings.dart';
import 'package:lex_copilot/features/settings/presentation/settings_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('SettingsController', () {
    Future<ProviderContainer> createContainer() async {
      final prefs = await SharedPreferences.getInstance();
      return ProviderContainer(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      );
    }

    test('updates and persists settings across container rebuilds', () async {
      SharedPreferences.setMockInitialValues({});
      final container1 = await createContainer();
      addTearDown(container1.dispose);

      final notifier = container1.read(settingsControllerProvider.notifier);
      await notifier.completeOnboarding(
        role: LexUserRole.business,
        modelRouting: LexModelRouting.auto,
      );
      await notifier.setThemeMode(LexThemeMode.dark);
      await notifier.setAccentPreset(LexAccentPreset.violet);
      await notifier.setCornerRadius(LexCornerRadius.sharp);
      await notifier.setGlassBlurIntensity(1.5); // clamped to 1.0
      await notifier.setTextScale(2.8); // clamped to 2.0
      await notifier.setCompactDensity(compact: true);
      await notifier.setAppLanguage('te');

      final container2 = await createContainer();
      addTearDown(container2.dispose);
      final restored = container2.read(settingsControllerProvider);

      expect(restored.onboardingCompleted, isTrue);
      expect(restored.userRole, LexUserRole.business);
      expect(restored.modelRouting, LexModelRouting.auto);
      expect(restored.themeMode, LexThemeMode.dark);
      expect(restored.accentPreset, LexAccentPreset.violet);
      expect(restored.cornerRadius, LexCornerRadius.sharp);
      expect(restored.glassBlurIntensity, 1.0);
      expect(restored.textScale, 2.0);
      expect(restored.compactDensity, isTrue);
      expect(restored.appLanguage, 'te');
    });

    test('toggles and reorders home widgets cleanly', () async {
      SharedPreferences.setMockInitialValues({});
      final container = await createContainer();
      addTearDown(container.dispose);

      final notifier = container.read(settingsControllerProvider.notifier);
      await notifier.toggleHomeWidget(LexHomeWidget.riskRadar, enabled: true);
      expect(
        container.read(settingsControllerProvider).enabledHomeWidgets,
        contains(LexHomeWidget.riskRadar),
      );

      final before = List<LexHomeWidget>.from(
        container.read(settingsControllerProvider).homeWidgetOrder,
      );
      await notifier.reorderHomeWidgets(0, 2);
      final after = container.read(settingsControllerProvider).homeWidgetOrder;
      expect(after[2], before[0]);
    });
  });
}
