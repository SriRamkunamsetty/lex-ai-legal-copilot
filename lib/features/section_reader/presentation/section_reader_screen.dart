import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lex_copilot/app/theme/lex_tokens.dart';
import 'package:lex_copilot/core/widgets/widgets.dart';
import 'package:lex_copilot/features/chat/presentation/chat_controller.dart';
import 'package:lex_copilot/features/library/presentation/library_providers.dart';
import 'package:lex_copilot/legal_corpus/models/legal_section.dart';
import 'package:lex_copilot/legal_corpus/packs/knowledge_pack_service.dart';
import 'package:lex_copilot/legal_corpus/providers/corpus_providers.dart';
import 'package:share_plus/share_plus.dart';

/// Offline Statutory & Constitutional Section Reader displaying official text,
/// separated amendment/judicial footnotes, plain-language summary, cross-refs,
/// bookmarks, and sharing.
class SectionReaderScreen extends ConsumerStatefulWidget {
  /// Creates a [SectionReaderScreen] for [act] and [sectionNumber].
  const new({required this.act, required this.sectionNumber, super.key});

  /// Short act identifier (e.g. `BNS`, `BNSS`, `BSA`).
  final String act;

  /// Section number string (e.g. `304`).
  final String sectionNumber;

  @override
  ConsumerState<SectionReaderScreen> createState() =>
      _SectionReaderScreenState();
}

class _SectionReaderScreenState extends ConsumerState<SectionReaderScreen> {
  int _tab = 1;
  double _readerFontDelta = 0;
  bool _recordedVisit = false;

  void _recordVisitIfNeeded(LegalSectionModel section) {
    if (_recordedVisit) return;
    _recordedVisit = true;
    unawaited(
      ref
          .read(libraryRepositoryProvider)
          .recordActivity(
            kind: 'section_view',
            title:
                '${section.actCode} ${section.sectionNumber} · ${section.title}',
            subtitle: section.chapter,
            route: '/section/${section.actCode}/${section.sectionNumber}',
          ),
    );
  }

  Future<void> _shareSection(LegalSectionModel section) async {
    final text =
        '${section.actName} — Section ${section.sectionNumber}: ${section.title}\n\n'
        '${section.text}\n\n'
        'Source: ${section.sourceUrl}\n'
        'Verify with official statutory text. Not legal advice.';
    await SharePlus.instance.share(ShareParams(text: text));
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.lexTokens;
    final sectionAsync = ref.watch(
      legalSectionProvider(widget.act, widget.sectionNumber),
    );
    final bookmarkedAsync = ref.watch(
      isSectionBookmarkedProvider(widget.act, widget.sectionNumber),
    );
    final isBookmarked = bookmarkedAsync.value ?? false;

    return LexScaffold(
      bottomOverlay: GlassBar(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Row(
          children: [
            Semantics(
              button: true,
              label: 'Decrease reader text size',
              child: InkWell(
                onTap: () => setState(
                  () =>
                      _readerFontDelta = (_readerFontDelta - 1.5).clamp(-3, 6),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 8,
                  ),
                  child: Text(
                    'A−',
                    style: TextStyle(fontSize: 13, color: tokens.secondaryText),
                  ),
                ),
              ),
            ),
            Semantics(
              button: true,
              label: 'Increase reader text size',
              child: InkWell(
                onTap: () => setState(
                  () =>
                      _readerFontDelta = (_readerFontDelta + 1.5).clamp(-3, 6),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 8,
                  ),
                  child: Text(
                    'A+',
                    style: TextStyle(fontSize: 13, color: tokens.secondaryText),
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  unawaited(
                    ref
                        .read(chatControllerProvider.notifier)
                        .sendMessage(
                          'Explain ${widget.act} Section ${widget.sectionNumber} in plain practical terms.',
                        ),
                  );
                  context.go('/ask');
                },
                child: Text(
                  'Ask Lex about this section',
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: tokens.text,
                  ),
                ),
              ),
            ),
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: tokens.accent,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                tooltip: 'Ask Lex about this section',
                padding: EdgeInsets.zero,
                onPressed: () {
                  unawaited(
                    ref
                        .read(chatControllerProvider.notifier)
                        .sendMessage(
                          'Explain ${widget.act} Section ${widget.sectionNumber} in plain practical terms.',
                        ),
                  );
                  context.go('/ask');
                },
                icon: Icon(Icons.chevron_right_rounded, color: tokens.onAccent),
              ),
            ),
          ],
        ),
      ),
      body: sectionAsync.when(
        loading: () => ListView(
          padding: EdgeInsets.fromLTRB(
            tokens.space(22),
            tokens.space(16),
            tokens.space(22),
            112,
          ),
          children: [
            _TopBar(
              tokens: tokens,
              isBookmarked: isBookmarked,
              onBack: () => context.pop(),
              onBookmark: null,
              onShare: null,
            ),
            const SizedBox(height: 20),
            const LexSkeleton(width: 140, height: 22),
            const SizedBox(height: 14),
            const LexSkeleton(width: 220, height: 36),
            const SizedBox(height: 20),
            const LexCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LexSkeleton(),
                  SizedBox(height: 10),
                  LexSkeleton(),
                  SizedBox(height: 10),
                  LexSkeleton(width: 180),
                ],
              ),
            ),
          ],
        ),
        error: (err, _) => Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            children: [
              _TopBar(
                tokens: tokens,
                isBookmarked: false,
                onBack: () => context.pop(),
                onBookmark: null,
                onShare: null,
              ),
              const SizedBox(height: 24),
              ErrorState(
                message: err.toString(),
                onRetry: () => ref.invalidate(
                  legalSectionProvider(widget.act, widget.sectionNumber),
                ),
              ),
            ],
          ),
        ),
        data: (result) => result.fold(
          onFailure: (failure) => Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              children: [
                _TopBar(
                  tokens: tokens,
                  isBookmarked: false,
                  onBack: () => context.pop(),
                  onBookmark: null,
                  onShare: null,
                ),
                const SizedBox(height: 24),
                ErrorState(
                  title: 'Section not found',
                  message: failure.message,
                  onRetry: () => ref.invalidate(
                    legalSectionProvider(widget.act, widget.sectionNumber),
                  ),
                ),
              ],
            ),
          ),
          onSuccess: (section) {
            _recordVisitIfNeeded(section);
            return ListView(
              padding: EdgeInsets.fromLTRB(
                tokens.space(22),
                tokens.space(16),
                tokens.space(22),
                112,
              ),
              children: [
                _TopBar(
                  tokens: tokens,
                  isBookmarked: isBookmarked,
                  onBack: () => context.pop(),
                  onBookmark: () => unawaited(
                    ref
                        .read(libraryRepositoryProvider)
                        .toggleBookmark(
                          actCode: section.actCode,
                          sectionNumber: section.sectionNumber,
                        ),
                  ),
                  onShare: () => unawaited(_shareSection(section)),
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerLeft,
                  child: CitationChip(
                    citation: '${section.actCode} · ${section.chapter}',
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Section ${section.sectionNumber}',
                  style: Theme.of(context).textTheme.headlineLarge
                      ?.copyWith(fontSize: 36),
                ),
                const SizedBox(height: 4),
                Text(
                  section.title,
                  style: TextStyle(fontSize: 20, color: tokens.secondaryText),
                ),
                const SizedBox(height: 16),
                SegmentedControl<int>(
                  selected: _tab,
                  onChanged: (value) => setState(() => _tab = value),
                  segments: const [
                    (value: 0, label: 'Official text'),
                    (value: 1, label: 'Plain language'),
                    (value: 2, label: 'Cross-ref'),
                  ],
                ),
                const SizedBox(height: 14),
                if (_tab == 0)
                  LexCard(
                    child: SelectableText(
                      section.text,
                      style: TextStyle(
                        fontSize: 15.5 + _readerFontDelta,
                        height: 1.55,
                        color: tokens.text,
                      ),
                    ),
                  )
                else if (_tab == 1)
                  LexCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          section.plainLanguage ?? 'Plain-language note: Verify the verbatim provision below before relying on any summary.',
                          style: TextStyle(
                            fontSize: 16 + _readerFontDelta,
                            height: 1.55,
                            color: tokens.text,
                          ),
                        ),
                        if (section.plainLanguage == null) ...[
                          const SizedBox(height: 12),
                          Text(
                            section.text,
                            maxLines: 6,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14 + _readerFontDelta,
                              height: 1.45,
                              color: tokens.secondaryText,
                            ),
                          ),
                        ],
                      ],
                    ),
                  )
                else
                  LexCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Legacy IPC / CrPC / IEA mapping',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: tokens.text,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          section.legacyMapping ??
                              // TODO(verify): Populate from full official BPR&D / MHA concordance table.
                              'No mapped legacy section recorded yet. Verify against the official BPR&D concordance table.',
                          style: TextStyle(
                            fontSize: 14 + _readerFontDelta,
                            height: 1.45,
                            color: tokens.secondaryText,
                          ),
                        ),
                      ],
                    ),
                  ),
                if (section.punishment != null) ...[
                  const SizedBox(height: 10),
                  LexCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Punishment',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: tokens.text,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          section.punishment!,
                          style: TextStyle(
                            fontSize: 14 + _readerFontDelta,
                            height: 1.45,
                            color: tokens.secondaryText,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                if (section.relatedSections.isNotEmpty) ...[
                  const SizedBox(height: 14),
                  Text(
                    'Related',
                    style: TextStyle(fontSize: 13, color: tokens.secondaryText),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final refKey in section.relatedSections)
                        _RelatedChip(refKey: refKey),
                    ],
                  ),
                ],
                const SizedBox(height: 16),
                if (section.actCode == 'CONST' ||
                    section.actCode == 'DPDP_2023' ||
                    section.actCode == 'IT_2000')
                  Text(
                    KnowledgePackService.stalenessNotice,
                    style: TextStyle(
                      fontSize: 12,
                      height: 1.45,
                      color: tokens.secondaryText,
                    ),
                  ),
                Text(
                  'Source: ${section.actName} (${section.sourceUrl}). Verify with official text — not legal advice.',
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.45,
                    color: tokens.secondaryText,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const new({
    required this.tokens,
    required this.isBookmarked,
    required this.onBack,
    required this.onBookmark,
    required this.onShare,
  });

  final LexTokens tokens;
  final bool isBookmarked;
  final VoidCallback onBack;
  final VoidCallback? onBookmark;
  final VoidCallback? onShare;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          tooltip: 'Back',
          onPressed: onBack,
          icon: Icon(Icons.chevron_left_rounded, color: tokens.text),
        ),
        Row(
          children: [
            IconButton(
              tooltip: isBookmarked ? 'Remove bookmark' : 'Bookmark section',
              onPressed: onBookmark,
              icon: Icon(
                isBookmarked
                    ? Icons.bookmark_rounded
                    : Icons.bookmark_border_rounded,
                color: isBookmarked ? tokens.accent : tokens.text,
              ),
            ),
            IconButton(
              tooltip: 'Share section',
              onPressed: onShare,
              icon: Icon(Icons.ios_share_rounded, color: tokens.text),
            ),
          ],
        ),
      ],
    );
  }
}

class _RelatedChip extends StatelessWidget {
  const new({required this.refKey});

  final String refKey;

  @override
  Widget build(BuildContext context) {
    final parts = refKey.split(':');
    final act = parts.isNotEmpty ? parts[0] : 'BNS';
    final num = parts.length > 1 ? parts[1] : refKey;

    return CitationChip(
      citation: '$act $num',
      onTap: () => context.push('/section/$act/$num'),
    );
  }
}
