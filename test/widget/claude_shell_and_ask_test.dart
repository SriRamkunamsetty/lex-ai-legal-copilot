import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lex_copilot/app/theme/lex_theme.dart';
import 'package:lex_copilot/core/widgets/widgets.dart';
import 'package:lex_copilot/features/chat/domain/chat_models.dart';
import 'package:lex_copilot/features/chat/presentation/ask_screen.dart';
import 'package:lex_copilot/features/chat/presentation/chat_controller.dart';
import 'package:lex_copilot/features/settings/domain/lex_settings.dart';
import 'package:lex_copilot/features/settings/presentation/settings_controller.dart';

class _StubSettingsController extends SettingsController {
  @override
  LexSettings build() => const LexSettings(
    onboardingCompleted: true,
    userRole: LexUserRole.lawyer,
  );
}

class _EmptyChatController extends ChatController {
  @override
  ChatThreadState build() => const ChatThreadState();
}

void main() {
  testWidgets(
    'ClaudeShellScaffold renders empty Ask AI layout with greeting, plan pill, and bottom composer ONLY on Ask tab',
    (tester) async {
      var activeIndex = 2; // Ask tab
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            settingsControllerProvider.overrideWith(
              _StubSettingsController.new,
            ),
            chatControllerProvider.overrideWith(_EmptyChatController.new),
          ],
          child: StatefulBuilder(
            builder: (context, setState) {
              return MaterialApp(
                theme: LexTheme.build(const LexSettings(), Brightness.light),
                home: ClaudeShellScaffold(
                  currentIndex: activeIndex,
                  onSelectTab: (idx) => setState(() => activeIndex = idx),
                  onOpenMenu: () {},
                  onSearchTap: () => setState(() => activeIndex = 3),
                  onPrivateModeToggle: () {},
                  isPrivateMode: true,
                  body: switch (activeIndex) {
                    2 => const AskScreen(),
                    _ => const Center(child: Text('Other Tab')),
                  },
                ),
              );
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Ask tab hero & bottom composer present
      expect(find.byType(BackdropFilter), findsOneWidget);
      expect(find.byTooltip('Open Lex menu'), findsOneWidget);
      expect(find.byTooltip('Search statutes & saved items'), findsOneWidget);
      expect(find.byTooltip('Local-only private mode on'), findsOneWidget);
      expect(find.textContaining('Counsel'), findsOneWidget);
      expect(find.textContaining('Local Gemma 4'), findsOneWidget);
      expect(find.text('Type or hold to talk'), findsOneWidget);
      expect(find.byIcon(Icons.graphic_eq_rounded), findsOneWidget);

      // Tapping + opens the redesigned Ask Tools & Context modal sheet
      await tester.tap(find.byTooltip('Attach or options'));
      await tester.pumpAndSettle();
      expect(find.text('Ask Tools & Context'), findsOneWidget);
      expect(find.text('Scan Notice'), findsOneWidget);
      expect(find.text('Voice Incident'), findsOneWidget);
      expect(find.text('Reasoning trail'), findsOneWidget);
      expect(find.text('Counter-arguments'), findsOneWidget);
      expect(find.text('Start fresh conversation'), findsOneWidget);
      await tester.tapAt(const Offset(20, 20));
      await tester.pumpAndSettle();

      // Typing text swaps waveform icon for upward send arrow
      await tester.enterText(find.byType(TextField), 'Article 21 scope');
      await tester.pump();
      expect(find.byIcon(Icons.arrow_upward_rounded), findsOneWidget);

      // Switching to another tab removes the Ask bar above the nav bar
      await tester.tap(find.byTooltip('Home'));
      await tester.pumpAndSettle();
      expect(find.text('Other Tab'), findsOneWidget);
      expect(find.text('Type or hold to talk'), findsNothing);
      expect(find.byTooltip('Send message'), findsNothing);
    },
  );
}
