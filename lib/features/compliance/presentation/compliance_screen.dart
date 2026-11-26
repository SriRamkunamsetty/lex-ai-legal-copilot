import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lex_copilot/app/theme/lex_tokens.dart';
import 'package:lex_copilot/core/widgets/widgets.dart';
import 'package:lex_copilot/features/compliance/data/compliance_repository.dart';
import 'package:lex_copilot/legal_corpus/providers/corpus_providers.dart';

/// Scoped Indian Compliance & Risk Intelligence screen (DPDP Act 2023,
/// IT Act 2000, and core startup checklist items).
class ComplianceScreen extends ConsumerStatefulWidget {
  /// Creates a [ComplianceScreen].
  const new({super.key});

  @override
  ConsumerState<ComplianceScreen> createState() => _ComplianceScreenState();
}

class _ComplianceScreenState extends ConsumerState<ComplianceScreen> {
  String _selectedFramework = '';
  late final ComplianceRepository _repo;
  bool _seeded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _repo = ComplianceRepository(ref.read(appDatabaseProvider));
    if (!_seeded) {
      _seeded = true;
      unawaited(_repo.ensureSeeded());
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.lexTokens;

    return LexScaffold(
      body: StreamBuilder<List<ComplianceItem>>(
        stream: _repo.watchItems(
          framework: _selectedFramework.isEmpty ? null : _selectedFramework,
        ),
        builder: (context, snapshot) {
          final items = snapshot.data ?? const <ComplianceItem>[];
          final completedCount = items
              .where((i) => i.status == 'completed')
              .length;
          final pct = items.isEmpty
              ? 0
              : ((completedCount / items.length) * 100).round();

          return ListView(
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Compliance',
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                        Text(
                          'DPDP Act 2023, IT Act 2000 & startup essentials',
                          style: TextStyle(
                            fontSize: 13,
                            color: tokens.secondaryText,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              LexCard(
                child: Row(
                  children: [
                    ScoreRing(score: pct, size: 58, strokeWidth: 6),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$completedCount of ${items.length} obligations ready',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: tokens.text,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Every obligation links to an indexed statutory provision or review-required status.',
                            style: TextStyle(
                              fontSize: 12,
                              color: tokens.secondaryText,
                            ),
                          ),
                        ],
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
                    LexChip(
                      label: 'All',
                      selected: _selectedFramework == '',
                      onTap: () => setState(() => _selectedFramework = ''),
                    ),
                    const SizedBox(width: 8),
                    LexChip(
                      label: 'DPDP 2023',
                      selected: _selectedFramework == 'DPDP_2023',
                      onTap: () =>
                          setState(() => _selectedFramework = 'DPDP_2023'),
                    ),
                    const SizedBox(width: 8),
                    LexChip(
                      label: 'IT Act 2000',
                      selected: _selectedFramework == 'IT_2000',
                      onTap: () =>
                          setState(() => _selectedFramework = 'IT_2000'),
                    ),
                    const SizedBox(width: 8),
                    LexChip(
                      label: 'Startup',
                      selected: _selectedFramework == 'STARTUP_ESSENTIALS',
                      onTap: () => setState(
                        () => _selectedFramework = 'STARTUP_ESSENTIALS',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              for (final item in items) ...[
                LexCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              item.title,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: tokens.text,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Checkbox(
                            value: item.status == 'completed',
                            onChanged: (checked) {
                              unawaited(
                                _repo.updateStatus(
                                  id: item.id,
                                  status: checked == true
                                      ? 'completed'
                                      : 'pending',
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${item.sourceAuthority} · ${item.effectiveDate}',
                        style: TextStyle(
                          fontSize: 11.5,
                          color: tokens.secondaryText,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        children: [
                          CitationChip(
                            citation: item.citationRef.replaceAll(':', ' '),
                            verified: item.verificationStatus == 'verified',
                            onTap: item.verificationStatus == 'verified'
                                ? () {
                                    final parts = item.citationRef.split(':');
                                    if (parts.length >= 2) {
                                      unawaited(
                                        context.push(
                                          '/section/${parts[0]}/${parts[1]}',
                                        ),
                                      );
                                    }
                                  }
                                : null,
                          ),
                          RiskPill(
                            level: item.verificationStatus == 'verified'
                                ? RiskLevel.low
                                : RiskLevel.medium,
                            label: item.verificationStatus == 'verified'
                                ? 'Verified Pack'
                                : 'Review Required',
                          ),
                        ],
                      ),
                    ],
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
