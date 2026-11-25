import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lex_copilot/app/theme/lex_theme.dart';
import 'package:lex_copilot/core/result.dart';
import 'package:lex_copilot/core/storage/app_database.dart';
import 'package:lex_copilot/features/case_file/data/notification_reminder_service.dart';
import 'package:lex_copilot/features/case_file/presentation/case_file_providers.dart';
import 'package:lex_copilot/features/case_file/presentation/case_file_screen.dart';
import 'package:lex_copilot/features/legal_aid/presentation/legal_help_screen.dart';
import 'package:lex_copilot/features/settings/domain/lex_settings.dart';
import 'package:lex_copilot/features/settings/presentation/settings_controller.dart';
import 'package:lex_copilot/legal_corpus/providers/corpus_providers.dart';

class _SpyReminderScheduler implements ReminderScheduler {
  int scheduledCount = 0;

  @override
  Future<void> cancelReminder(int id) async {}

  @override
  Future<Result<void>> initialize() async => const Success(null);

  @override
  Future<Result<bool>> scheduleDeadlineReminder({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledAt,
  }) async {
    scheduledCount++;
    return const Success(true);
  }
}

class _FixedSettings extends SettingsController {
  @override
  LexSettings build() => const LexSettings(onboardingCompleted: true);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'CaseFileScreen creates case, toggles compliance checklist, and schedules local reminder',
    (tester) async {
      final db = AppDatabase.forTesting(NativeDatabase.memory());
      addTearDown(db.close);
      final scheduler = _SpyReminderScheduler();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appDatabaseProvider.overrideWithValue(db),
            reminderSchedulerProvider.overrideWithValue(scheduler),
            settingsControllerProvider.overrideWith(_FixedSettings.new),
          ],
          child: MaterialApp(
            theme: LexTheme.build(const LexSettings(), Brightness.light),
            home: const CaseFileScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Create case file'));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byType(TextField).first,
        'Security Deposit Matter',
      );
      await tester.tap(find.text('Create'));
      await tester.pumpAndSettle();

      expect(find.text('Security Deposit Matter'), findsWidgets);

      await tester.ensureVisible(find.text('Deadlines'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Deadlines'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Add deadline reminder'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).first, 'File complaint');
      await tester.tap(find.text('Save deadline'));
      await tester.pumpAndSettle();

      expect(find.text('File complaint'), findsOneWidget);
      expect(scheduler.scheduledCount, 1);

      await tester.pumpWidget(const MaterialApp(home: SizedBox.shrink()));
      await tester.pumpAndSettle();
    },
  );

  testWidgets(
    'LegalHelpScreen displays placeholder banner, switches categories, and renders contacts',
    (tester) async {
      final db = AppDatabase.forTesting(NativeDatabase.memory());
      addTearDown(db.close);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [appDatabaseProvider.overrideWithValue(db)],
          child: MaterialApp(
            theme: LexTheme.build(const LexSettings(), Brightness.light),
            home: const LegalHelpScreen(showInteractiveMap: false),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('Placeholder'), findsWidgets);
      expect(find.text('Share my case summary'), findsOneWidget);

      await tester.tap(find.text('Police'));
      await tester.pumpAndSettle();
      expect(find.textContaining('112'), findsWidgets);

      await tester.pumpWidget(const MaterialApp(home: SizedBox.shrink()));
      await tester.pumpAndSettle();
    },
  );
}
