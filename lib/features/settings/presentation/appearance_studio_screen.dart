import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lex_copilot/app/theme/lex_tokens.dart';
import 'package:lex_copilot/core/widgets/widgets.dart';
import 'package:lex_copilot/features/settings/domain/lex_settings.dart';
import 'package:lex_copilot/features/settings/presentation/settings_controller.dart';

/// Appearance studio for live customization of theme, radius, glass blur,
/// font family, text scale, density, and Home widgets.
class AppearanceStudioScreen extends ConsumerWidget {
  /// Creates an [AppearanceStudioScreen].
  const new({super.key});

  String _widgetLabel(LexHomeWidget widgetKey) => switch (widgetKey) {
    LexHomeWidget.scanCta => 'Scan CTA',
    LexHomeWidget.askBar => 'Ask search bar',
    LexHomeWidget.quickActions => 'Quick actions',
    LexHomeWidget.riskRadar => 'Risk radar',
    LexHomeWidget.deadlines => 'Deadlines',
    LexHomeWidget.recent => 'Recent',
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = context.lexTokens;
    final settings = ref.watch(settingsControllerProvider);
    final controller = ref.read(settingsControllerProvider.notifier);

    return LexScaffold(
      body: ListView(
        padding: EdgeInsets.fromLTRB(
          tokens.space(22),
          tokens.space(16),
          tokens.space(22),
          tokens.space(32),
        ),
        children: [
          Row(
            children: [
              IconButton(
                tooltip: 'Back',
                onPressed: () => context.pop(),
                icon: Icon(Icons.chevron_left_rounded, color: tokens.text),
              ),
              const SizedBox(width: 4),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Appearance',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  Text(
                    'Make Lex yours',
                    style: TextStyle(fontSize: 14, color: tokens.secondaryText),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: tokens.space(16)),
          Text(
            'SHAPE',
            style: TextStyle(
              fontSize: 12,
              letterSpacing: 0.6,
              color: tokens.secondaryText,
            ),
          ),
          const SizedBox(height: 6),
          LexCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: SegmentedControl<LexCornerRadius>(
                    selected: settings.cornerRadius,
                    onChanged: controller.setCornerRadius,
                    segments: const [
                      (value: LexCornerRadius.sharp, label: 'Sharp'),
                      (value: LexCornerRadius.soft, label: 'Soft'),
                      (value: LexCornerRadius.round, label: 'Round'),
                    ],
                  ),
                ),
                Divider(height: 1, color: tokens.hairline),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      const Text('Glass blur', style: TextStyle(fontSize: 15)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Slider(
                          value: settings.glassBlurIntensity,
                          onChanged: controller.setGlassBlurIntensity,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: tokens.space(16)),
          Text(
            'TYPE & DENSITY',
            style: TextStyle(
              fontSize: 12,
              letterSpacing: 0.6,
              color: tokens.secondaryText,
            ),
          ),
          const SizedBox(height: 6),
          LexCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: SegmentedControl<LexFontFamily>(
                    selected: settings.fontFamily,
                    onChanged: controller.setFontFamily,
                    segments: const [
                      (value: LexFontFamily.system, label: 'System'),
                      (value: LexFontFamily.serif, label: 'Serif'),
                      (value: LexFontFamily.mono, label: 'Mono'),
                    ],
                  ),
                ),
                Divider(height: 1, color: tokens.hairline),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      const Text('Text size', style: TextStyle(fontSize: 15)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Slider(
                          min: 0.85,
                          max: 2,
                          divisions: 11,
                          label: '${(settings.textScale * 100).round()}%',
                          value: settings.textScale,
                          onChanged: controller.setTextScale,
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(height: 1, color: tokens.hairline),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Compact density',
                        style: TextStyle(fontSize: 15),
                      ),
                      LexToggle(
                        value: settings.compactDensity,
                        semanticLabel: 'Compact density',
                        onChanged: (v) =>
                            controller.setCompactDensity(compact: v),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: tokens.space(16)),
          Text(
            'HOME WIDGETS (DRAG TO REORDER)',
            style: TextStyle(
              fontSize: 12,
              letterSpacing: 0.6,
              color: tokens.secondaryText,
            ),
          ),
          const SizedBox(height: 6),
          LexCard(
            padding: EdgeInsets.zero,
            child: ReorderableListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: settings.homeWidgetOrder.length,
              onReorderItem: controller.reorderHomeWidgets,
              itemBuilder: (context, index) {
                final item = settings.homeWidgetOrder[index];
                final enabled = settings.enabledHomeWidgets.contains(item);
                return Container(
                  key: ValueKey(item),
                  decoration: BoxDecoration(
                    border: index > 0
                        ? Border(top: BorderSide(color: tokens.hairline))
                        : null,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  child: Row(
                    children: [
                      ReorderableDragStartListener(
                        index: index,
                        child: Icon(
                          Icons.drag_handle_rounded,
                          color: tokens.secondaryText,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _widgetLabel(item),
                          style: TextStyle(fontSize: 15, color: tokens.text),
                        ),
                      ),
                      LexToggle(
                        value: enabled,
                        semanticLabel: 'Toggle ${_widgetLabel(item)}',
                        onChanged: (value) =>
                            controller.toggleHomeWidget(item, enabled: value),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
