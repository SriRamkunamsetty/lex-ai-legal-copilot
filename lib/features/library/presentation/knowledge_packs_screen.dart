import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lex_copilot/app/theme/lex_tokens.dart';
import 'package:lex_copilot/core/result.dart';
import 'package:lex_copilot/core/widgets/widgets.dart';
import 'package:lex_copilot/legal_corpus/packs/knowledge_pack_service.dart';
import 'package:lex_copilot/legal_corpus/providers/corpus_providers.dart';

/// Offline Knowledge Pack manager showing version, publishing authority,
/// SHA-256 verification state, effective dates, and staleness warnings.
class KnowledgePacksScreen extends ConsumerStatefulWidget {
  /// Creates a [KnowledgePacksScreen].
  const new({super.key});

  @override
  ConsumerState<KnowledgePacksScreen> createState() =>
      _KnowledgePacksScreenState();
}

class _KnowledgePacksScreenState extends ConsumerState<KnowledgePacksScreen> {
  List<KnowledgePackSummary> _packs = const [];
  bool _loading = true;
  String? _busyPackId;
  String? _error;

  @override
  void initState() {
    super.initState();
    unawaited(_load());
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    final res = await ref.read(knowledgePackServiceProvider).loadCatalog();
    if (!mounted) return;
    switch (res) {
      case Err(:final failure):
        setState(() {
          _loading = false;
          _error = failure.message;
        });
      case Success(:final value):
        setState(() {
          _loading = false;
          _packs = value;
        });
    }
  }

  Future<void> _install(KnowledgePackSummary pack) async {
    setState(() {
      _busyPackId = pack.packId;
      _error = null;
    });
    final res = await ref
        .read(knowledgePackServiceProvider)
        .installAndVerifyPack(pack);
    if (!mounted) return;
    setState(() => _busyPackId = null);
    if (res case Err(:final failure)) {
      setState(() => _error = failure.message);
      return;
    }
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.lexTokens;
    return LexScaffold(
      body: ListView(
        padding: EdgeInsets.fromLTRB(
          tokens.space(20),
          tokens.space(16),
          tokens.space(20),
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
                      'Offline Knowledge Packs',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    Text(
                      'SHA-256 verified Indian statutory & constitutional bundles',
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
          SizedBox(height: tokens.space(14)),
          LexCard(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline_rounded, color: tokens.accent),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    KnowledgePackService.stalenessNotice,
                    style: TextStyle(fontSize: 13, color: tokens.secondaryText),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          if (_error != null) ...[
            ErrorState(
              title: 'Knowledge Pack error',
              message: _error!,
              onRetry: _load,
            ),
            const SizedBox(height: 12),
          ],
          if (_loading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: CircularProgressIndicator(),
              ),
            )
          else if (_packs.isEmpty)
            const EmptyState(
              icon: Icons.inventory_2_outlined,
              title: 'No bundled packs found',
              message: 'Knowledge pack catalog entries will appear here.',
            )
          else
            for (final pack in _packs) ...[
              LexCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            pack.packName,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: tokens.text,
                            ),
                          ),
                        ),
                        RiskPill(
                          level: pack.installed
                              ? RiskLevel.low
                              : RiskLevel.medium,
                          label: pack.installed ? 'Verified' : 'Available',
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Version ${pack.version} · Effective ${pack.effectiveDate} · ${(pack.sizeBytes / 1024).toStringAsFixed(0)} KB',
                      style: TextStyle(
                        fontSize: 12,
                        color: tokens.secondaryText,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${pack.provisionCount} provisions · ${pack.footnoteCount} footnotes · ${pack.relationCount} KG links',
                      style: TextStyle(
                        fontSize: 12,
                        color: tokens.secondaryText,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Source: ${pack.sourceAuthority}',
                      style: TextStyle(
                        fontSize: 12,
                        color: tokens.secondaryText,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'SHA-256: ${pack.sha256.length >= 16 ? '${pack.sha256.substring(0, 16)}…' : pack.sha256}',
                      style: TextStyle(
                        fontSize: 11,
                        color: tokens.secondaryText,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: FilledButton.tonal(
                        onPressed: _busyPackId == pack.packId
                            ? null
                            : () => _install(pack),
                        child: Text(
                          _busyPackId == pack.packId
                              ? 'Verifying…'
                              : pack.installed
                              ? 'Re-verify & Refresh'
                              : 'Verify & Install Offline',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
            ],
        ],
      ),
    );
  }
}
