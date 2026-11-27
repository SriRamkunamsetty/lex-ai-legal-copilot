import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lex_copilot/app/theme/lex_tokens.dart';
import 'package:lex_copilot/core/widgets/widgets.dart';
import 'package:lex_copilot/features/settings/domain/lex_settings.dart';
import 'package:lex_copilot/features/settings/presentation/settings_controller.dart';

/// Main Customize hub matching the prototype ("Appearance", "AI model",
/// "Law and language", "Privacy") with live persistence.
class CustomizeScreen extends ConsumerWidget {
  /// Creates a [CustomizeScreen].
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = context.lexTokens;
    final settings = ref.watch(settingsControllerProvider);
    final controller = ref.read(settingsControllerProvider.notifier);

    return LexScaffold(
      showTopGlow: false,
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
              Text(
                'Customize',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ],
          ),
          SizedBox(height: tokens.space(16)),
          const _SectionHeader('Appearance'),
          LexCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: SegmentedControl<LexThemeMode>(
                    selected: settings.themeMode,
                    onChanged: controller.setThemeMode,
                    segments: const [
                      (value: LexThemeMode.light, label: 'Light'),
                      (value: LexThemeMode.dark, label: 'Dark'),
                      (value: LexThemeMode.system, label: 'Auto'),
                    ],
                  ),
                ),
                Divider(height: 1, color: tokens.hairline),
                _SettingsRow(
                  title: 'Accent',
                  trailing: _AccentSwatches(
                    selected: settings.accentPreset,
                    onSelected: controller.setAccentPreset,
                  ),
                ),
                Divider(height: 1, color: tokens.hairline),
                _SettingsRow(
                  title: 'Appearance studio',
                  subtitle: 'Radius, glass blur, typography, home widgets',
                  onTap: () => context.push('/customize/appearance'),
                  trailing: Icon(
                    Icons.chevron_right_rounded,
                    color: tokens.secondaryText,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: tokens.space(16)),
          const _SectionHeader('AI model'),
          LexCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                _SettingsRow(
                  title: 'On-device · Gemma 4 E4B',
                  onTap: () =>
                      controller.setModelRouting(LexModelRouting.onDevice),
                  trailing: settings.modelRouting == LexModelRouting.onDevice
                      ? Icon(Icons.check_rounded, color: tokens.accent)
                      : Text(
                          'Private',
                          style: TextStyle(
                            fontSize: 13,
                            color: tokens.secondaryText,
                          ),
                        ),
                ),
                Divider(height: 1, color: tokens.hairline),
                _SettingsRow(
                  title: 'Auto · Private + Cloud fallback',
                  onTap: () => controller.setModelRouting(LexModelRouting.auto),
                  trailing: settings.modelRouting == LexModelRouting.auto
                      ? Icon(Icons.check_rounded, color: tokens.accent)
                      : Text(
                          'Smart routing',
                          style: TextStyle(
                            fontSize: 13,
                            color: tokens.secondaryText,
                          ),
                        ),
                ),
                Divider(height: 1, color: tokens.hairline),
                _SettingsRow(
                  title: 'Cloud · Gemma 4 31B',
                  onTap: () =>
                      controller.setModelRouting(LexModelRouting.cloud),
                  trailing: settings.modelRouting == LexModelRouting.cloud
                      ? Icon(Icons.check_rounded, color: tokens.accent)
                      : Text(
                          'Deep research',
                          style: TextStyle(
                            fontSize: 13,
                            color: tokens.secondaryText,
                          ),
                        ),
                ),
                Divider(height: 1, color: tokens.hairline),
                _SettingsRow(
                  title: 'AI and privacy controls',
                  onTap: () => context.push('/customize/ai-privacy'),
                  trailing: Icon(
                    Icons.chevron_right_rounded,
                    color: tokens.secondaryText,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: tokens.space(16)),
          const _SectionHeader('Law and language'),
          LexCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                _SettingsRow(
                  title: 'Jurisdiction',
                  trailing: Text(
                    settings.jurisdiction,
                    style: TextStyle(fontSize: 14, color: tokens.secondaryText),
                  ),
                ),
                Divider(height: 1, color: tokens.hairline),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: SegmentedControl<String>(
                    selected: settings.appLanguage,
                    onChanged: controller.setAppLanguage,
                    segments: const [
                      (value: 'en', label: 'English'),
                      (value: 'hi', label: 'हिन्दी'),
                      (value: 'te', label: 'తెలుగు'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: tokens.space(16)),
          const _SectionHeader('Privacy'),
          LexCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                _SettingsRow(
                  title: 'Keep scans on device',
                  trailing: LexToggle(
                    value: settings.modelRouting == LexModelRouting.onDevice,
                    semanticLabel: 'Keep scans on device',
                    onChanged: (on) => controller.setModelRouting(
                      on ? LexModelRouting.onDevice : LexModelRouting.auto,
                    ),
                  ),
                ),
                Divider(height: 1, color: tokens.hairline),
                _SettingsRow(
                  title: 'Auto-delete scans',
                  onTap: () {
                    final next = switch (settings.autoDeleteScansDays) {
                      7 => 30,
                      30 => 90,
                      90 => 0,
                      _ => 7,
                    };
                    unawaited(controller.setAutoDeleteScansDays(next));
                  },
                  trailing: Text(
                    settings.autoDeleteScansDays == 0
                        ? 'Never'
                        : '${settings.autoDeleteScansDays} days',
                    style: TextStyle(fontSize: 14, color: tokens.secondaryText),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const new(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    final tokens = context.lexTokens;
    return Padding(
      padding: const EdgeInsets.fromLTRB(6, 0, 6, 6),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          letterSpacing: 0.6,
          fontWeight: FontWeight.w500,
          color: tokens.secondaryText,
        ),
      ),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  const new({
    required this.title,
    required this.trailing,
    this.subtitle,
    this.onTap,
  });

  final String title;
  final String? subtitle;
  final Widget trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.lexTokens;
    return InkWell(
      onTap: onTap,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 52),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(fontSize: 15, color: tokens.text),
                    ),
                    if (subtitle != null)
                      Text(
                        subtitle!,
                        style: TextStyle(
                          fontSize: 12,
                          color: tokens.secondaryText,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              trailing,
            ],
          ),
        ),
      ),
    );
  }
}

class _AccentSwatches extends StatelessWidget {
  const new({required this.selected, required this.onSelected});

  final LexAccentPreset selected;
  final ValueChanged<LexAccentPreset> onSelected;

  static const List<({LexAccentPreset preset, Color color, String name})>
  _swatches = [
    (
      preset: LexAccentPreset.navyGold,
      color: Color(0xFF13294B),
      name: 'Navy & Gold',
    ),
    (preset: LexAccentPreset.indigo, color: Color(0xFF2F3FD8), name: 'Indigo'),
    (preset: LexAccentPreset.teal, color: Color(0xFF0B7A6D), name: 'Teal'),
    (
      preset: LexAccentPreset.terracotta,
      color: Color(0xFFB83B0A),
      name: 'Terracotta',
    ),
    (preset: LexAccentPreset.violet, color: Color(0xFF6D28D9), name: 'Violet'),
    (preset: LexAccentPreset.rose, color: Color(0xFFBE185D), name: 'Rose'),
  ];

  @override
  Widget build(BuildContext context) {
    final tokens = context.lexTokens;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final item in _swatches)
          Semantics(
            button: true,
            selected: item.preset == selected,
            label: '${item.name} accent colour',
            child: GestureDetector(
              onTap: () => onSelected(item.preset),
              child: Container(
                margin: const EdgeInsets.only(left: 8),
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: item.color,
                  border: item.preset == selected
                      ? Border.all(color: tokens.text, width: 2.2)
                      : null,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
