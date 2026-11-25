import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lex_copilot/app/theme/lex_tokens.dart';
import 'package:lex_copilot/core/widgets/widgets.dart';
import 'package:lex_copilot/features/library/presentation/library_providers.dart';
import 'package:lex_copilot/legal_corpus/providers/corpus_providers.dart';

/// Offline Library screen supporting full-text search across India's statutory
/// corpus plus encrypted Bookmarks, Scans, Drafts, and Activity History.
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
        tokens.space(22),
        tokens.space(20),
        tokens.space(22),
        112,
      ),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Library', style: Theme.of(context).textTheme.headlineLarge),
            IconButton(
              tooltip: 'Customize',
              onPressed: () => context.push('/customize'),
              icon: Icon(Icons.tune_rounded, color: tokens.text),
            ),
          ],
        ),
        const SizedBox(height: 12),
        LexCard(
          borderRadius: tokens.pillRadius,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          child: Row(
            children: [
              Icon(Icons.search_rounded, size: 20, color: tokens.secondaryText),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) => setState(() => _query = value),
                  decoration: InputDecoration(
                    hintText: 'Search BNS, BNSS, BSA, bookmarks, scans…',
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
        if (_tab == 0) ...[
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              for (final act in [null, 'BNS', 'BNSS', 'BSA'])
                LexChip(
                  label: act ?? 'All acts',
                  selected: _selectedAct == act,
                  onTap: () => setState(() => _selectedAct = act),
                ),
            ],
          ),
        ],
        const SizedBox(height: 14),
        switch (_tab) {
          0 => _SectionsView(query: _query, actCode: _selectedAct),
          1 => _BookmarksView(query: _query),
          2 => _ScansView(query: _query),
          3 => _DraftsView(query: _query),
          _ => _HistoryView(query: _query),
        },
      ],
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
          LexSkeleton(height: 76),
          SizedBox(height: 10),
          LexSkeleton(height: 76),
          SizedBox(height: 10),
          LexSkeleton(height: 76),
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
              message: 'Try a section number like "304" or keywords like "theft" or "FIR".',
            );
          }
          return Column(
            children: [
              for (final section in sections) ...[
                SectionTile(
                  citation: '${section.actCode} ${section.sectionNumber}',
                  title: section.title,
                  summary:
                      section.plainLanguage ??
                      section.text.replaceAll('\n', ' '),
                  onTap: () => context.push(
                    '/section/${section.actCode}/${section.sectionNumber}',
                  ),
                ),
                const SizedBox(height: 10),
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
      loading: () => const LexSkeleton(height: 76),
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
              SectionTile(
                citation: '${bookmark.actCode} ${bookmark.sectionNumber}',
                title: 'Bookmarked section',
                summary: bookmark.note ?? 'Tap to open in Section Reader',
                onTap: () => context.push(
                  '/section/${bookmark.actCode}/${bookmark.sectionNumber}',
                ),
              ),
              const SizedBox(height: 10),
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
      loading: () => const LexSkeleton(height: 76),
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
              const SizedBox(height: 10),
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
      loading: () => const LexSkeleton(height: 76),
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
              LexCard(
                onTap: () => context.push('/draft'),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      draft.title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      draft.templateType,
                      style: const TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
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
    final tokens = context.lexTokens;
    final historyAsync = ref.watch(historyStreamProvider(query));

    return historyAsync.when(
      loading: () => const LexSkeleton(height: 76),
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
              LexCard(
                onTap: () => context.push(item.route),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: tokens.text,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            item.subtitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 13,
                              color: tokens.secondaryText,
                            ),
                          ),
                        ],
                      ),
                    ),
                    CitationChip(citation: item.kind),
                  ],
                ),
              ),
              const SizedBox(height: 10),
            ],
          ],
        );
      },
    );
  }
}
