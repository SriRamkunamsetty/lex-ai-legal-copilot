import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lex_copilot/app/theme/lex_theme.dart';
import 'package:lex_copilot/core/widgets/widgets.dart';
import 'package:lex_copilot/features/settings/domain/lex_settings.dart';

Widget _buildDesignSystemShowcase(Brightness brightness) {
  const settings = LexSettings();
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: LexTheme.build(settings, brightness),
    home: SizedBox(
      width: 420,
      height: 1020,
      child: LexScaffold(
        bottomOverlay: LexNavBar(currentIndex: 0, onSelected: (_) {}),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      brightness == Brightness.light
                          ? 'Lex UI · Light'
                          : 'Lex UI · Dark',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const GlassBar(
                    borderRadius: 16,
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: Text(
                      'Gemma 4 · On-device',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              SegmentedControl<int>(
                selected: 1,
                onChanged: (_) {},
                segments: const [
                  (value: 0, label: 'Text'),
                  (value: 1, label: 'Plain language'),
                  (value: 2, label: 'Cases'),
                ],
              ),
              const SizedBox(height: 14),
              const Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  LexChip(label: 'Theft', selected: true),
                  LexChip(label: 'Cheque bounce'),
                  RiskPill(level: RiskLevel.high),
                  RiskPill(level: RiskLevel.medium),
                  RiskPill(level: RiskLevel.low),
                  CitationChip(citation: 'BNS 304'),
                ],
              ),
              const SizedBox(height: 14),
              LexCard(
                child: Row(
                  children: [
                    const ScoreRing(score: 72, size: 78),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ConfidenceBadge(
                            level: ConfidenceLevel.medium,
                            sourceCount: 2,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Indemnity liability uncapped',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                    LexToggle(value: true, onChanged: (_) {}),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              const SectionTile(
                citation: 'BNS 304',
                title: 'Snatching',
                summary: 'Sudden grabbing of property. Up to 3 years and fine.',
              ),
              const SizedBox(height: 14),
              const ChatBubble(text: 'Can my landlord do this?', isUser: true),
              const SizedBox(height: 10),
              const ChatBubble(
                text: 'Valid notice depends on your lease and tenancy statute. Verify with official text.',
                isUser: false,
                footer: DocumentThumb(
                  fileName: 'Rent_Notice.jpg',
                  subtitle: '2 pages · text read',
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

void main() {
  testWidgets('Design system matches light golden', (tester) async {
    tester.view.physicalSize = const Size(420, 1020);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(_buildDesignSystemShowcase(Brightness.light));
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/design_system_light.png'),
    );
  });

  testWidgets('Design system matches dark golden', (tester) async {
    tester.view.physicalSize = const Size(420, 1020);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(_buildDesignSystemShowcase(Brightness.dark));
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/design_system_dark.png'),
    );
  });
}
