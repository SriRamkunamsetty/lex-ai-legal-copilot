import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lex_copilot/app/theme/lex_tokens.dart';
import 'package:lex_copilot/core/result.dart';
import 'package:lex_copilot/core/security/security_providers.dart';
import 'package:lex_copilot/core/widgets/widgets.dart';

/// Optional client-side End-to-End Encrypted Cloud Sync & Team Workspace UI.
///
/// Offline/local Lex usage never requires sign-in or recovery-key setup.
class WorkspaceSyncScreen extends ConsumerStatefulWidget {
  /// Creates a [WorkspaceSyncScreen].
  const new({super.key});

  @override
  ConsumerState<WorkspaceSyncScreen> createState() =>
      _WorkspaceSyncScreenState();
}

class _WorkspaceSyncScreenState extends ConsumerState<WorkspaceSyncScreen> {
  String? _recoveryPhrase;
  bool _hasKey = false;
  bool _syncEnabled = false;
  bool _syncCases = true;
  bool _syncDrafts = true;
  bool _syncBookmarks = true;
  bool _syncScanMeta = false;
  final TextEditingController _importController = TextEditingController();
  String? _statusMessage;

  @override
  void initState() {
    super.initState();
    unawaited(_loadKeyStatus());
  }

  @override
  void dispose() {
    _importController.dispose();
    super.dispose();
  }

  Future<void> _loadKeyStatus() async {
    final service = ref.read(e2eeSyncServiceProvider);
    final configured = await service.hasRecoveryKey();
    final phrase = await service.readFormattedRecoveryKey();
    if (!mounted) return;
    setState(() {
      _hasKey = configured;
      _recoveryPhrase = phrase;
    });
  }

  Future<void> _generateKey() async {
    final res = await ref.read(e2eeSyncServiceProvider).generateRecoveryKey();
    if (!mounted) return;
    switch (res) {
      case Success(:final value):
        setState(() {
          _hasKey = true;
          _recoveryPhrase = value;
          _statusMessage = '256-bit recovery key generated locally. Save it offline — Lex cannot recover it.';
        });
      case Err(:final failure):
        setState(() => _statusMessage = failure.message);
    }
  }

  Future<void> _importKey() async {
    final res = await ref
        .read(e2eeSyncServiceProvider)
        .importRecoveryKey(_importController.text);
    if (!mounted) return;
    switch (res) {
      case Success():
        _importController.clear();
        await _loadKeyStatus();
        setState(() => _statusMessage = 'Recovery key imported and verified.');
      case Err(:final failure):
        setState(() => _statusMessage = failure.message);
    }
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
              Expanded(
                child: Text(
                  'E2EE Sync & Workspaces',
                  style: Theme.of(context).textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          SizedBox(height: tokens.space(12)),
          LexCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Optional Zero-Knowledge Sync',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: tokens.text,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Offline & free local usage never requires an account. If you opt into multi-device sync or firm workspaces, data is encrypted on-device with HKDF + AES-256-GCM before leaving this phone.',
                  style: TextStyle(
                    fontSize: 13.5,
                    height: 1.4,
                    color: tokens.secondaryText,
                  ),
                ),
              ],
            ),
          ),
          if (_statusMessage != null) ...[
            SizedBox(height: tokens.space(10)),
            LexCard(
              child: Text(
                _statusMessage!,
                style: TextStyle(fontSize: 13, color: tokens.accent),
              ),
            ),
          ],
          SizedBox(height: tokens.space(14)),
          LexCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Recovery Key',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: tokens.text,
                  ),
                ),
                const SizedBox(height: 8),
                if (_hasKey && _recoveryPhrase != null) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: tokens.surface,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: tokens.hairline),
                    ),
                    child: SelectableText(
                      _recoveryPhrase!,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 12.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      OutlinedButton.icon(
                        onPressed: () {
                          unawaited(
                            Clipboard.setData(
                              ClipboardData(text: _recoveryPhrase!),
                            ),
                          );
                          setState(
                            () => _statusMessage = 'Recovery key copied — clear clipboard after saving.',
                          );
                        },
                        icon: const Icon(Icons.copy_rounded, size: 16),
                        label: const Text('Copy key'),
                      ),
                      const SizedBox(width: 8),
                      TextButton(
                        onPressed: () async {
                          await ref
                              .read(e2eeSyncServiceProvider)
                              .clearSyncCredentials();
                          await _loadKeyStatus();
                          setState(() => _syncEnabled = false);
                        },
                        child: Text(
                          'Remove key',
                          style: TextStyle(color: tokens.riskHigh),
                        ),
                      ),
                    ],
                  ),
                ] else ...[
                  Text(
                    'No recovery key generated yet.',
                    style: TextStyle(fontSize: 13, color: tokens.secondaryText),
                  ),
                  const SizedBox(height: 10),
                  FilledButton(
                    onPressed: _generateKey,
                    child: const Text('Generate 256-bit recovery key'),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _importController,
                    decoration: const InputDecoration(
                      labelText: 'Or paste existing LEX-... recovery key',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton(
                    onPressed: _importKey,
                    child: const Text('Import recovery key'),
                  ),
                ],
              ],
            ),
          ),
          SizedBox(height: tokens.space(14)),
          LexCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Enable selective E2EE sync'),
                  subtitle: Text(
                    _hasKey
                        ? 'Encrypts selected records with recovery key'
                        : 'Requires a recovery key above',
                  ),
                  value: _syncEnabled && _hasKey,
                  onChanged: _hasKey
                      ? (v) => setState(() => _syncEnabled = v)
                      : null,
                ),
                Divider(height: 1, color: tokens.hairline),
                SwitchListTile(
                  title: const Text('Case files & deadlines'),
                  value: _syncCases,
                  onChanged: (v) => setState(() => _syncCases = v),
                ),
                Divider(height: 1, color: tokens.hairline),
                SwitchListTile(
                  title: const Text('Draft revisions'),
                  value: _syncDrafts,
                  onChanged: (v) => setState(() => _syncDrafts = v),
                ),
                Divider(height: 1, color: tokens.hairline),
                SwitchListTile(
                  title: const Text('Statutory bookmarks'),
                  value: _syncBookmarks,
                  onChanged: (v) => setState(() => _syncBookmarks = v),
                ),
                Divider(height: 1, color: tokens.hairline),
                SwitchListTile(
                  title: const Text(
                    'Scan metadata only (raw scans stay local)',
                  ),
                  value: _syncScanMeta,
                  onChanged: (v) => setState(() => _syncScanMeta = v),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
