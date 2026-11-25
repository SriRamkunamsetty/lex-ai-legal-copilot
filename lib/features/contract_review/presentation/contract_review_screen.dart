import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lex_copilot/ai/pipelines/contract_pipeline.dart';
import 'package:lex_copilot/app/theme/lex_tokens.dart';
import 'package:lex_copilot/core/widgets/widgets.dart';
import 'package:lex_copilot/features/contract_review/presentation/contract_review_controller.dart';
import 'package:lex_copilot/features/library/presentation/library_providers.dart';
import 'package:share_plus/share_plus.dart';

/// Contract review screen: paste text or import from scans, inspect 0-100 risk
/// score, clause-level severity flags, redline diffs, and apply safer wording.
class ContractReviewScreen extends ConsumerStatefulWidget {
  /// Creates a [ContractReviewScreen].
  const new({super.key});

  @override
  ConsumerState<ContractReviewScreen> createState() =>
      _ContractReviewScreenState();
}

class _ContractReviewScreenState extends ConsumerState<ContractReviewScreen> {
  final TextEditingController _textController = TextEditingController();
  final Set<String> _expandedRedlines = <String>{};

  @override
  void initState() {
    super.initState();
    final initial = ref.read(contractReviewControllerProvider).sourceText;
    if (initial.isNotEmpty) {
      _textController.text = initial;
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _loadSample() {
    const sample = '''
1. Indemnity
Service Provider shall indemnify Client against all losses without limit.

2. Termination
Client may terminate this agreement immediately without notice or cure period, whereas Service Provider may not terminate before 24 months.

3. Governing Law
Governed by Indian laws with arbitration seated at Bengaluru.''';
    _textController.text = sample;
    ref
        .read(contractReviewControllerProvider.notifier)
        .setSourceText(sample, title: 'Vendor_Agreement.txt');
  }

  Future<void> _shareRevisedText(String title, String content) async {
    await SharePlus.instance.share(
      ShareParams(
        text:
            '$title — Revised Draft\n\n$content\n\nVerify with official counsel — not legal advice.',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.lexTokens;
    final state = ref.watch(contractReviewControllerProvider);
    final controller = ref.read(contractReviewControllerProvider.notifier);
    final scansAsync = ref.watch(scansStreamProvider(''));

    if (_textController.text != state.sourceText &&
        state.review != null &&
        state.sourceText == state.review!.workingText) {
      _textController.text = state.sourceText;
    }

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
              Expanded(
                child: Text(
                  'Contract review',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ),
              if (state.review != null)
                IconButton(
                  tooltip: 'Share revised contract',
                  onPressed: () => _shareRevisedText(
                    state.documentTitle,
                    state.review!.workingText,
                  ),
                  icon: Icon(Icons.ios_share_rounded, color: tokens.text),
                ),
            ],
          ),
          Text(
            'Paste contract clauses or pick a saved scan to inspect risk scores and safer wording.',
            style: TextStyle(fontSize: 14, color: tokens.secondaryText),
          ),
          const SizedBox(height: 12),
          if (scansAsync.value case final scans? when scans.isNotEmpty) ...[
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (final scan in scans.take(4))
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: LexChip(
                        label: 'Use: ${scan.title}',
                        onTap: () {
                          _textController.text = scan.ocrText;
                          controller.setSourceText(
                            scan.ocrText,
                            title: scan.title,
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],
          LexCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _textController,
                  minLines: 4,
                  maxLines: 8,
                  onChanged: controller.setSourceText,
                  decoration: InputDecoration(
                    hintText: 'Paste indemnity, termination, deposit, or vendor clauses here…',
                    hintStyle: TextStyle(color: tokens.secondaryText),
                    border: InputBorder.none,
                    isDense: true,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    TextButton(
                      onPressed: _loadSample,
                      child: const Text('Load sample'),
                    ),
                    const Spacer(),
                    FilledButton(
                      onPressed: state.isReviewing
                          ? null
                          : () => controller.analyze(_textController.text),
                      child: Text(
                        state.isReviewing ? 'Reviewing…' : 'Review clauses',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (state.errorMessage != null) ...[
            const SizedBox(height: 12),
            ErrorState(
              title: 'Review interrupted',
              message: state.errorMessage!,
              onRetry: () => controller.analyze(_textController.text),
            ),
          ],
          if (state.review case final review?) ...[
            const SizedBox(height: 16),
            LexCard(
              child: Row(
                children: [
                  ScoreRing(score: review.riskScore),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          review.riskLabel,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: tokens.text,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${review.countByLevel(RiskLevel.high)} high · '
                          '${review.countByLevel(RiskLevel.medium)} medium · '
                          '${review.countByLevel(RiskLevel.low)} low',
                          style: TextStyle(
                            fontSize: 13,
                            color: tokens.secondaryText,
                          ),
                        ),
                        const SizedBox(height: 8),
                        if (review.clauses.any((c) => !c.applied))
                          OutlinedButton.icon(
                            onPressed: controller.applyAllSaferWording,
                            icon: const Icon(
                              Icons.auto_fix_high_rounded,
                              size: 16,
                            ),
                            label: const Text('Apply all safer wording'),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            for (final clause in review.clauses) ...[
              _ClauseFindingCard(
                clause: clause,
                showRedline: _expandedRedlines.contains(clause.id),
                onToggleRedline: () => setState(() {
                  if (_expandedRedlines.contains(clause.id)) {
                    _expandedRedlines.remove(clause.id);
                  } else {
                    _expandedRedlines.add(clause.id);
                  }
                }),
                onApply: clause.applied
                    ? null
                    : () => controller.applySaferWording(clause.id),
              ),
              const SizedBox(height: 10),
            ],
            const SizedBox(height: 6),
            Text(
              'Contract insights highlight clause-level risks; consult an advocate before executing amendments.',
              style: TextStyle(fontSize: 12, color: tokens.secondaryText),
            ),
          ],
        ],
      ),
    );
  }
}

class _ClauseFindingCard extends StatelessWidget {
  const new({
    required this.clause,
    required this.showRedline,
    required this.onToggleRedline,
    required this.onApply,
  });

  final ContractClauseFinding clause;
  final bool showRedline;
  final VoidCallback onToggleRedline;
  final VoidCallback? onApply;

  @override
  Widget build(BuildContext context) {
    final tokens = context.lexTokens;

    return LexCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  clause.clauseTitle,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: tokens.text,
                  ),
                ),
              ),
              RiskPill(level: clause.riskLevel),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            clause.reason,
            style: TextStyle(
              fontSize: 13,
              height: 1.45,
              color: tokens.secondaryText,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              TextButton.icon(
                onPressed: onToggleRedline,
                icon: Icon(
                  showRedline
                      ? Icons.visibility_off_outlined
                      : Icons.compare_arrows_rounded,
                  size: 16,
                ),
                label: Text(showRedline ? 'Hide redline' : 'Preview redline'),
              ),
              const Spacer(),
              if (clause.applied)
                Chip(
                  avatar: Icon(
                    Icons.check_circle_outline_rounded,
                    size: 16,
                    color: tokens.riskLow,
                  ),
                  label: const Text('Applied'),
                )
              else
                FilledButton.tonal(
                  onPressed: onApply,
                  child: const Text('Apply safer wording'),
                ),
            ],
          ),
          if (showRedline) ...[
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: tokens.riskHigh.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'Original: ${clause.originalExcerpt}',
                style: TextStyle(
                  fontSize: 12,
                  decoration: TextDecoration.lineThrough,
                  color: tokens.riskHigh,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: tokens.riskLow.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'Suggested: ${clause.suggestedRewrite}',
                style: TextStyle(fontSize: 12, color: tokens.riskLow),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
