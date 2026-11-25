import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lex_copilot/app/theme/lex_theme.dart';
import 'package:lex_copilot/core/widgets/widgets.dart';
import 'package:lex_copilot/features/settings/domain/lex_settings.dart';

void main() {
  Widget wrap(Widget child, {double textScale = 1.0}) {
    return MaterialApp(
      theme: LexTheme.build(const LexSettings(), Brightness.light),
      home: MediaQuery(
        data: MediaQueryData(textScaler: TextScaler.linear(textScale)),
        child: LexScaffold(
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: child,
          ),
        ),
      ),
    );
  }

  testWidgets('Design-system widgets render and fire interactions', (
    tester,
  ) async {
    var toggled = false;
    var segment = 0;
    var cited = false;
    var retried = false;

    await tester.pumpWidget(
      wrap(
        StatefulBuilder(
          builder: (context, setState) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GlassBar(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('GlassBar'),
                      LexToggle(
                        value: toggled,
                        semanticLabel: 'Test toggle',
                        onChanged: (v) => setState(() => toggled = v),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                SegmentedControl<int>(
                  selected: segment,
                  onChanged: (v) => setState(() => segment = v),
                  segments: const [
                    (value: 0, label: 'One'),
                    (value: 1, label: 'Two'),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  children: [
                    const RiskPill(level: RiskLevel.high),
                    const RiskPill(level: RiskLevel.medium),
                    const RiskPill(level: RiskLevel.low),
                    const ConfidenceBadge(
                      level: ConfidenceLevel.high,
                      sourceCount: 3,
                    ),
                    CitationChip(
                      citation: 'BNS 304',
                      onTap: () => cited = true,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const ScoreRing(score: 72),
                const SizedBox(height: 12),
                const SectionTile(
                  citation: 'BNSS 173',
                  title: 'FIR',
                  summary: 'Reporting cognizable offence',
                ),
                const SizedBox(height: 12),
                const ChatBubble(
                  text: 'Streaming answer',
                  isUser: false,
                  isStreaming: true,
                ),
                const SizedBox(height: 12),
                const DocumentThumb(fileName: 'Notice.pdf', subtitle: '1 page'),
                const SizedBox(height: 12),
                ErrorState(
                  message: 'Network unavailable',
                  onRetry: () => retried = true,
                ),
              ],
            );
          },
        ),
      ),
    );

    expect(find.text('High'), findsOneWidget);
    expect(find.text('72'), findsOneWidget);
    expect(find.text('Streaming answer ▌'), findsOneWidget);

    await tester.tap(find.text('Two'));
    await tester.tap(find.text('BNS 304'));
    await tester.ensureVisible(find.text('Try again'));
    await tester.tap(find.text('Try again'));
    await tester.ensureVisible(find.byType(LexToggle));
    await tester.tap(find.byType(LexToggle));
    await tester.pumpAndSettle();

    expect(cited, isTrue);
    expect(retried, isTrue);
    expect(toggled, isTrue);
  });

  testWidgets('Widgets lay out cleanly at 200% text scale', (tester) async {
    await tester.pumpWidget(
      wrap(
        const Column(
          children: [
            SectionTile(
              citation: 'BNS 303',
              title: 'Theft',
              summary: 'Dishonest taking of movable property.',
            ),
            SizedBox(height: 12),
            EmptyState(
              icon: Icons.folder_outlined,
              title: 'Nothing saved yet',
              message: 'Scan or bookmark a section to see it here.',
            ),
          ],
        ),
        textScale: 2,
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
