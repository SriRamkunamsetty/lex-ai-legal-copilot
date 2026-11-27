import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lex_copilot/app/app.dart';
import 'package:lex_copilot/app/flavors.dart';
import 'package:lex_copilot/core/storage/app_database.dart';
import 'package:lex_copilot/features/settings/presentation/settings_controller.dart';
import 'package:lex_copilot/legal_corpus/providers/corpus_providers.dart';
import 'package:lex_copilot/legal_corpus/repository/legal_corpus_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets(
    'Completes 3-step onboarding, switches tabs, reads BNS 304 offline, and toggles theme',
    (tester) async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final db = AppDatabase.forTesting(NativeDatabase.memory());
      addTearDown(db.close);
      await tester.runAsync(() => LegalCorpusRepository(db).ensureSeeded());

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(prefs),
            flavorConfigProvider.overrideWithValue(
              FlavorConfig.forFlavor(LexFlavor.dev),
            ),
            appDatabaseProvider.overrideWithValue(db),
          ],
          child: const LexApp(),
        ),
      );
      await tester.pumpAndSettle();

      // Step 1 -> Step 2
      expect(
        find.text('Snap any legal document. Understand it instantly.'),
        findsOneWidget,
      );
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      // Step 2 -> select Lawyer -> Step 3
      expect(find.text('How will you use Lex?'), findsOneWidget);
      await tester.tap(find.text('Lawyer / Advocate'));
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      // Step 3 -> complete onboarding
      expect(find.text('Choose your AI privacy mode'), findsOneWidget);
      await tester.tap(find.text('Open your legal desk'));
      await tester.pumpAndSettle();

      // Home screen + Claude 4-icon bottom navigation bar (no ask bar on Home)
      expect(find.text('Your legal desk'), findsOneWidget);
      expect(find.byTooltip('Home'), findsOneWidget);
      expect(find.byTooltip('Scan'), findsOneWidget);
      expect(find.byTooltip('Ask'), findsOneWidget);
      expect(find.byTooltip('Library'), findsOneWidget);
      expect(find.text('Type or hold to talk'), findsNothing);

      // Navigate to Scan, Ask, Library tabs
      await tester.tap(find.byTooltip('Scan'));
      await tester.pumpAndSettle();
      expect(find.text('Scan document'), findsOneWidget);
      expect(find.text('Type or hold to talk'), findsNothing);

      await tester.tap(find.byTooltip('Ask'));
      await tester.pumpAndSettle();
      expect(find.text('Type or hold to talk'), findsOneWidget);

      await tester.tap(find.byTooltip('Library'));
      await tester.pumpAndSettle();
      expect(find.text('Library'), findsWidgets);
      expect(find.text('Type or hold to talk'), findsNothing);

      // Search BNS 304 offline in Library and open Section Reader
      await tester.enterText(find.byType(TextField), '304');
      await tester.pumpAndSettle();
      expect(find.text('BNS 304'), findsWidgets);

      await tester.tap(find.text('BNS 304').first);
      await tester.pumpAndSettle();
      expect(find.text('Section 304'), findsOneWidget);
      expect(find.text('Snatching'), findsOneWidget);

      // Bookmark BNS 304 and switch to Official text tab
      await tester.tap(find.byTooltip('Bookmark section'));
      await tester.pumpAndSettle();
      expect(find.byTooltip('Remove bookmark'), findsOneWidget);

      await tester.tap(find.text('Official text'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Theft is snatching if'), findsOneWidget);

      // Back to Library then Bookmarks tab
      await tester.tap(find.byTooltip('Back'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Bookmarks'));
      await tester.pumpAndSettle();
      expect(find.text('BNS 304'), findsWidgets);

      // Open Customize and switch to Dark theme
      await tester.tap(find.byTooltip('Customize'));
      await tester.pumpAndSettle();
      expect(find.text('Customize'), findsOneWidget);

      await tester.tap(find.text('Dark'));
      await tester.pumpAndSettle();

      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold).first);
      expect(scaffold.backgroundColor, const Color(0xFF121211));

      // Unmount ProviderScope and flush Drift's StreamQueryStore zero-delay timer.
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump(Duration.zero);
    },
  );
}
