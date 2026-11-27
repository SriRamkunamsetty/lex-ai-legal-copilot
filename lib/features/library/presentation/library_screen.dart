import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lex_copilot/app/theme/lex_tokens.dart';
import 'package:lex_copilot/core/widgets/widgets.dart';
import 'package:lex_copilot/features/library/presentation/library_providers.dart';
import 'package:lex_copilot/legal_corpus/providers/corpus_providers.dart';

/// Clean, interactive Indian Law Library browser with Statute cards and
/// scannable compact provision rows (no multi-line paragraph walls).
class LibraryScreen extends ConsumerStatefulWidget {
  /// Creates a [LibraryScreen].
  const new({super.key});

  @override
  ConsumerState<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends ConsumerState<LibraryScreen> {
  final TextEditingController _searchController = TextEditingController();
  int _tab = 0;
  String? _selectedAct;
  String _query = '';

  static const List<({int value, String label})> _tabs = [
    (value: 0, label: 'Sections'),
    (value: 1, label: 'Bookmarks'),
    (value: 2, label: 'Scans'),
    (value: 3, label: 'Drafts'),
    (value: 4, label: 'History'),
  ];

  static const List<
    ({String code, String title, String subtitle, String count, IconData icon})
  >
  _statuteCards = [
    (
      code: 'CONST',
      title: 'Constitution of India',
      subtitle: 'Articles, Schedules & Amendments',
      count: '513 items',
      icon: Icons.account_balance_outlined,
    ),
    (
      code: 'BNS',
      title: 'Bharatiya Nyaya Sanhita',
      subtitle: 'Criminal Substantive Code (2023)',
      count: '358 sec',
      icon: Icons.gavel_outlined,
    ),
    (
      code: 'BNSS',
      title: 'Bharatiya Nagarik Suraksha',
      subtitle: 'Criminal Procedure & FIR (2023)',
      count: '531 sec',
      icon: Icons.balance_outlined,
    ),
    (
      code: 'BSA',
      title: 'Bharatiya Sakshya Adhiniyam',
      subtitle: 'Electronic & Documentary Evidence',
      count: '170 sec',
      icon: Icons.fact_check_outlined,
    ),
    (
      code: 'DPDP_2023',
      title: 'DPDP Act, 2023',
      subtitle: 'Personal Data & Consent Obligations',
      count: '31 sec',
      icon: Icons.shield_outlined,
    ),
    (
      code: 'IT_2000',
      title: 'IT Act, 2000',
      subtitle: 'Cyber Offences & Intermediaries',
      count: '30 sec',
      icon: Icons.devices_outlined,
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.lexTokens;

    return ListView(
      padding: EdgeInsets.fromLTRB(
        tokens.space(20),
        tokens.space(18),
        tokens.space(20),
        24 + ClaudeBottomBarInset.of(context),
      ),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Library', style: Theme.of(context).textTheme.headlineLarge),
            TextButton.icon(
              onPressed: () => context.push('/customize/knowledge-packs'),
              icon: const Icon(Icons.inventory_2_outlined, size: 18),
              label: const Text('Packs'),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 3),
          decoration: BoxDecoration(
            color: tokens.neutralControlFill,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            children: [
              Icon(Icons.search_rounded, size: 20, color: tokens.secondaryText),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) => setState(() => _query = value),
                  decoration: InputDecoration(
                    hintText: 'Search Article 21, BNS 304, DPDP…',
                    hintStyle: TextStyle(
                      fontSize: 14,
                      color: tokens.secondaryText,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                  ),
                ),
              ),
              if (_query.isNotEmpty)
                IconButton(
                  tooltip: 'Clear search',
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _query = '');
                  },
                  icon: Icon(
                    Icons.close_rounded,
                    size: 18,
                    color: tokens.secondaryText,
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (final item in _tabs) ...[
                LexChip(
                  label: item.label,
                  selected: _tab == item.value,
                  onTap: () => setState(() => _tab = item.value),
                ),
                const SizedBox(width: 8),
              ],
            ],
          ),
        ),
        if (_tab == 0 && _query.trim().isEmpty && _selectedAct == null) ...[
          const SizedBox(height: 14),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1.38,
            ),
            itemCount: _statuteCards.length,
            itemBuilder: (context, idx) {
              final card = _statuteCards[idx];
              return LexCard(
                padding: const EdgeInsets.all(14),
                onTap: () => setState(() => _selectedAct = card.code),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(card.icon, size: 20, color: tokens.accent),
                        Text(
                          card.count,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: tokens.secondaryText,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          card.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w600,
                            color: tokens.text,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          card.subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11.5,
                            color: tokens.secondaryText,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ] else if (_tab == 0) ...[
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final act in [
                  null,
                  'CONST',
                  'BNS',
                  'BNSS',
                  'BSA',
                  'DPDP_2023',
                  'IT_2000',
                ]) ...[
                  LexChip(
                    label: act ?? 'All acts',
                    selected: _selectedAct == act,
                    onTap: () => setState(() => _selectedAct = act),
                  ),
                  const SizedBox(width: 6),
                ],
              ],
            ),
          ),
        ],
        const SizedBox(height: 14),
        switch (_tab) {
          0 when _query.trim().isNotEmpty || _selectedAct != null =>
            _SectionsView(query: _query, actCode: _selectedAct),
          0 => const SizedBox.shrink(),
          1 => _BookmarksView(query: _query),
          2 => _ScansView(query: _query),
          3 => _DraftsView(query: _query),
          _ => _HistoryView(query: _query),
        },
      ],
    );
  }
}

class _CompactProvisionCard extends StatelessWidget {
  const new({
    required this.badge,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final String badge;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.lexTokens;
    return LexCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      onTap: onTap,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
            decoration: BoxDecoration(
              color: tokens.neutralControlFill,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              badge,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
                color: tokens.accent,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w600,
                    color: tokens.text,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12, color: tokens.secondaryText),
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right_rounded,
            size: 20,
            color: tokens.secondaryText,
          ),
        ],
      ),
    );
  }
}

class _SectionsView extends ConsumerWidget {
  const new({required this.query, required this.actCode});

  final String query;
  final String? actCode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchAsync = ref.watch(
      corpusSearchProvider(query, actCode: actCode),
    );

    return searchAsync.when(
      loading: () => const Column(
        children: [
          LexSkeleton(height: 60),
          SizedBox(height: 8),
          LexSkeleton(height: 60),
          SizedBox(height: 8),
          LexSkeleton(height: 60),
        ],
      ),
      error: (err, _) => ErrorState(
        message: err.toString(),
        onRetry: () =>
            ref.invalidate(corpusSearchProvider(query, actCode: actCode)),
      ),
      data: (result) => result.fold(
        onFailure: (f) => ErrorState(
          message: f.message,
          onRetry: () =>
              ref.invalidate(corpusSearchProvider(query, actCode: actCode)),
        ),
        onSuccess: (sections) {
          if (sections.isEmpty) {
            return const EmptyState(
              icon: Icons.search_off_rounded,
              title: 'No matching sections',
              message: 'Try an Article/Section number like "21" or "304", or pick another Act.',
            );
          }
          return Column(
            children: [
              for (final section in sections) ...[
                _CompactProvisionCard(
                  badge: '${section.actCode} ${section.sectionNumber}',
                  title: section.title,
                  subtitle: section.chapter.isNotEmpty
                      ? section.chapter
                      : section.actName,
                  onTap: () => context.push(
                    '/section/${section.actCode}/${section.sectionNumber}',
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _BookmarksView extends ConsumerWidget {
  const new({required this.query});

  final String query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarksAsync = ref.watch(bookmarksStreamProvider);

    return bookmarksAsync.when(
      loading: () => const LexSkeleton(height: 60),
      error: (err, _) => ErrorState(message: err.toString()),
      data: (bookmarks) {
        final q = query.trim().toLowerCase();
        final filtered = q.isEmpty
            ? bookmarks
            : bookmarks
                  .where(
                    (b) =>
                        b.actCode.toLowerCase().contains(q) ||
                        b.sectionNumber.toLowerCase().contains(q),
                  )
                  .toList();

        if (filtered.isEmpty) {
          return const EmptyState(
            icon: Icons.bookmark_border_rounded,
            title: 'No bookmarks yet',
            message: 'Tap the bookmark icon inside any Section Reader to save it offline.',
          );
        }

        return Column(
          children: [
            for (final bookmark in filtered) ...[
              _CompactProvisionCard(
                badge: '${bookmark.actCode} ${bookmark.sectionNumber}',
                title: 'Saved provision',
                subtitle: bookmark.note ?? 'Open in Section Reader',
                onTap: () => context.push(
                  '/section/${bookmark.actCode}/${bookmark.sectionNumber}',
                ),
              ),
              const SizedBox(height: 8),
            ],
          ],
        );
      },
    );
  }
}

class _ScansView extends ConsumerWidget {
  const new({required this.query});

  final String query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scansAsync = ref.watch(scansStreamProvider(query));

    return scansAsync.when(
      loading: () => const LexSkeleton(height: 60),
      error: (err, _) => ErrorState(message: err.toString()),
      data: (scans) {
        if (scans.isEmpty) {
          return EmptyState(
            icon: Icons.document_scanner_outlined,
            title: 'No encrypted scans yet',
            message: 'Scanned notices and agreements are encrypted locally in your vault.',
            actionLabel: 'Scan a document',
            onAction: () => context.go('/scan'),
          );
        }
        return Column(
          children: [
            for (final scan in scans) ...[
              DocumentThumb(
                fileName: scan.title,
                subtitle: '${scan.pageCount} page(s)',
                onTap: () => context.go('/ask'),
              ),
              const SizedBox(height: 8),
            ],
          ],
        );
      },
    );
  }
}

class _DraftsView extends ConsumerWidget {
  const new({required this.query});

  final String query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draftsAsync = ref.watch(draftsStreamProvider(query));

    return draftsAsync.when(
      loading: () => const LexSkeleton(height: 60),
      error: (err, _) => ErrorState(message: err.toString()),
      data: (drafts) {
        if (drafts.isEmpty) {
          return EmptyState(
            icon: Icons.description_outlined,
            title: 'No saved drafts yet',
            message:
                'Generated agreements, NDAs, and notices appear here offline.',
            actionLabel: 'Create a draft',
            onAction: () => context.push('/draft'),
          );
        }
        return Column(
          children: [
            for (final draft in drafts) ...[
              _CompactProvisionCard(
                badge: 'DRAFT',
                title: draft.title,
                subtitle: draft.templateType,
                onTap: () => context.push('/draft'),
              ),
              const SizedBox(height: 8),
            ],
          ],
        );
      },
    );
  }
}

class _HistoryView extends ConsumerWidget {
  const new({required this.query});

  final String query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(historyStreamProvider(query));

    return historyAsync.when(
      loading: () => const LexSkeleton(height: 60),
      error: (err, _) => ErrorState(message: err.toString()),
      data: (items) {
        if (items.isEmpty) {
          return const EmptyState(
            icon: Icons.history_rounded,
            title: 'No history yet',
            message: 'Viewed sections, chats, and document analyses appear here locally.',
          );
        }
        return Column(
          children: [
            for (final item in items) ...[
              _CompactProvisionCard(
                badge: item.kind.toUpperCase(),
                title: item.title,
                subtitle: item.subtitle,
                onTap: () => context.push(item.route),
              ),
              const SizedBox(height: 8),
            ],
          ],
        );
      },
    );
  }
}
