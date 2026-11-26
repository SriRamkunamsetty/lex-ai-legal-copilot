import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lex_copilot/app/theme/lex_tokens.dart';
import 'package:lex_copilot/core/widgets/widgets.dart';
import 'package:lex_copilot/features/case_file/presentation/case_file_providers.dart';
import 'package:lex_copilot/features/contract_review/presentation/contract_review_controller.dart';
import 'package:lex_copilot/features/library/presentation/library_providers.dart';
import 'package:lex_copilot/features/settings/domain/lex_settings.dart';
import 'package:lex_copilot/features/settings/presentation/settings_controller.dart';
import 'package:lex_copilot/l10n/app_localizations.dart';

/// Primary Home dashboard ("Your legal desk") driven exclusively by live
/// encrypted Riverpod streams and enabled/ordered Home widgets from [LexSettings].
class HomeScreen extends ConsumerWidget {
  /// Creates a [HomeScreen].
  const new({super.key});

  String _modelBadgeLabel(LexModelRouting routing) => switch (routing) {
    LexModelRouting.onDevice => 'Gemma 4 · On-device',
    LexModelRouting.auto => 'Gemma 4 · Auto',
    LexModelRouting.cloud => 'Gemma 4 · Cloud',
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = context.lexTokens;
    final settings = ref.watch(settingsControllerProvider);
    final l10n = Localizations.of<AppLocalizations>(context, AppLocalizations);

    return ListView(
      padding: EdgeInsets.fromLTRB(
        tokens.space(22),
        tokens.space(20),
        tokens.space(22),
        112,
      ),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n?.homeGreeting ?? 'Good day',
                    style: TextStyle(fontSize: 14, color: tokens.secondaryText),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    l10n?.homeHeading ?? 'Your legal desk',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                ],
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () => context.push('/customize/ai-privacy'),
                  child: GlassBar(
                    borderRadius: 16,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 7,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 7,
                          height: 7,
                          decoration: BoxDecoration(
                            color: tokens.statusOnline,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          _modelBadgeLabel(settings.modelRouting),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: tokens.text,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                IconButton(
                  tooltip: 'Customize Lex',
                  onPressed: () => context.push('/customize'),
                  icon: Icon(Icons.tune_rounded, color: tokens.text),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: tokens.space(18)),
        for (final widgetKey in settings.homeWidgetOrder)
          if (settings.enabledHomeWidgets.contains(widgetKey)) ...[
            _buildHomeWidget(context, ref, tokens, widgetKey),
            SizedBox(height: tokens.space(14)),
          ],
      ],
    );
  }

  Widget _buildHomeWidget(
    BuildContext context,
    WidgetRef ref,
    LexTokens tokens,
    LexHomeWidget widgetKey,
  ) => switch (widgetKey) {
    LexHomeWidget.scanCta => Semantics(
      button: true,
      label: 'Scan a document: Notice, contract or order',
      child: Material(
        color: tokens.accent,
        borderRadius: BorderRadius.circular(tokens.pillRadius),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => context.go('/scan'),
          child: Padding(
            padding: EdgeInsets.all(tokens.space(22)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Scan a document',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: tokens.onAccent,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Notice, contract or order',
                        style: TextStyle(
                          fontSize: 14,
                          color: tokens.onAccent.withValues(alpha: 0.85),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.document_scanner_outlined,
                    color: tokens.onAccent,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
    LexHomeWidget.askBar => LexCard(
      borderRadius: tokens.pillRadius,
      onTap: () => context.go('/ask'),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      child: Row(
        children: [
          Icon(
            Icons.chat_bubble_outline_rounded,
            size: 20,
            color: tokens.secondaryText,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Ask Lex anything legal…',
              style: TextStyle(fontSize: 15, color: tokens.secondaryText),
            ),
          ),
        ],
      ),
    ),
    LexHomeWidget.quickActions => SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          LexChip(label: 'Incident', onTap: () => context.push('/incident')),
          const SizedBox(width: 8),
          LexChip(label: 'Draft', onTap: () => context.push('/draft')),
          const SizedBox(width: 8),
          LexChip(
            label: 'Contract review',
            onTap: () => context.push('/contract-review'),
          ),
          const SizedBox(width: 8),
          LexChip(label: 'Case file', onTap: () => context.push('/case-file')),
          const SizedBox(width: 8),
          LexChip(
            label: 'Compliance',
            onTap: () => context.push('/compliance'),
          ),
          const SizedBox(width: 8),
          LexChip(
            label: 'Legal help',
            onTap: () => context.push('/legal-help'),
          ),
        ],
      ),
    ),
    LexHomeWidget.deadlines => _LiveDeadlineCard(tokens: tokens),
    LexHomeWidget.riskRadar => _LiveRiskRadarCard(tokens: tokens),
    LexHomeWidget.recent => _LiveRecentList(tokens: tokens),
  };
}

class _LiveDeadlineCard extends ConsumerWidget {
  const new({required this.tokens});

  final LexTokens tokens;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncDeadlines = ref.watch(upcomingDeadlinesStreamProvider);
    final deadlines = asyncDeadlines.value ?? const [];

    if (deadlines.isEmpty) {
      return LexCard(
        onTap: () => context.push('/case-file'),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Deadlines',
                    style: TextStyle(fontSize: 12, color: tokens.secondaryText),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'No upcoming deadlines · Add in Case File',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: tokens.text,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.event_available_outlined, color: tokens.secondaryText),
          ],
        ),
      );
    }

    final next = deadlines.first;
    final daysRemaining = next.dueAt.difference(DateTime.now()).inDays;
    final badgeText = daysRemaining <= 0
        ? 'Due today'
        : '$daysRemaining day${daysRemaining == 1 ? '' : 's'}';
    final level = daysRemaining <= 2 ? RiskLevel.high : RiskLevel.medium;

    return LexCard(
      onTap: () => context.push('/case-file'),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Upcoming deadline',
                  style: TextStyle(fontSize: 12, color: tokens.secondaryText),
                ),
                const SizedBox(height: 4),
                Text(
                  next.title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: tokens.text,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          RiskPill(level: level, label: badgeText),
        ],
      ),
    );
  }
}

class _LiveRiskRadarCard extends ConsumerWidget {
  const new({required this.tokens});

  final LexTokens tokens;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final latestAsync = ref.watch(latestContractAnalysisStreamProvider);
    final latest = latestAsync.value;

    if (latest == null) {
      return LexCard(
        onTap: () => context.push('/contract-review'),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: tokens.neutralControlFill,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.radar_outlined, color: tokens.accent),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Risk radar ready',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: tokens.text,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'Review a contract to inspect clause-level risk scores',
                    style: TextStyle(fontSize: 13, color: tokens.secondaryText),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    var detail = 'Clause analysis saved locally';
    try {
      final decoded = jsonDecode(latest.summaryJson) as Map<String, dynamic>;
      final high = (decoded['high_count'] as num?)?.toInt() ?? 0;
      final med = (decoded['medium_count'] as num?)?.toInt() ?? 0;
      detail = '$high high-risk, $med medium-risk clause flagged';
    } on Object {
      // Fallback safely to default summary subtitle.
    }

    return LexCard(
      onTap: () => context.push('/contract-review'),
      child: Row(
        children: [
          ScoreRing(score: latest.overallScore, size: 54, strokeWidth: 6),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Risk radar · ${latest.title}',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: tokens.text,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  detail,
                  style: TextStyle(fontSize: 13, color: tokens.secondaryText),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LiveRecentList extends ConsumerWidget {
  const new({required this.tokens});

  final LexTokens tokens;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(historyStreamProvider(''));
    final items = (historyAsync.value ?? const []).take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: tokens.text,
          ),
        ),
        SizedBox(height: tokens.space(10)),
        if (items.isEmpty)
          LexCard(
            onTap: () => context.go('/library'),
            child: Text(
              'No recent activity yet. Your scans, chats, drafts, and statutory lookups will appear here.',
              style: TextStyle(fontSize: 13, color: tokens.secondaryText),
            ),
          )
        else
          for (var i = 0; i < items.length; i++) ...[
            if (i > 0) const SizedBox(height: 10),
            _RecentTile(
              title: items[i].title,
              subtitle: items[i].subtitle,
              tag: _tagForKind(items[i].kind),
              onTap: () => context.push(items[i].route),
            ),
          ],
      ],
    );
  }

  static String _tagForKind(String kind) => switch (kind) {
    'scan' => 'Scan',
    'chat' => 'Ask',
    'contract_review' => 'Review',
    'draft' => 'Draft',
    'section_view' => 'Section',
    'incident' => 'Incident',
    _ => 'Item',
  };
}

class _RecentTile extends StatelessWidget {
  const new({
    required this.title,
    required this.subtitle,
    required this.tag,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final String tag;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.lexTokens;

    return LexCard(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: tokens.text,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 13, color: tokens.secondaryText),
                ),
              ],
            ),
          ),
          CitationChip(citation: tag),
        ],
      ),
    );
  }
}
