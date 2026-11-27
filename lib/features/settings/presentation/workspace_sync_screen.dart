import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lex_copilot/ai/ai_providers.dart';
import 'package:lex_copilot/app/theme/lex_tokens.dart';
import 'package:lex_copilot/core/result.dart';
import 'package:lex_copilot/core/security/e2ee_sync_service.dart';
import 'package:lex_copilot/core/security/security_providers.dart';
import 'package:lex_copilot/core/widgets/widgets.dart';
import 'package:lex_copilot/features/case_file/presentation/case_file_providers.dart';
import 'package:lex_copilot/features/library/presentation/library_providers.dart';

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
  bool _signedIn = false;
  bool _busy = false;
  bool _syncEnabled = false;
  bool _syncCases = true;
  bool _syncDrafts = true;
  bool _syncBookmarks = true;
  bool _syncScanMeta = false;
  final TextEditingController _importController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _orgNameController = TextEditingController();
  final TextEditingController _orgIdController = TextEditingController();
  List<Map<String, dynamic>> _devices = const [];
  String? _statusMessage;

  @override
  void initState() {
    super.initState();
    unawaited(_loadKeyStatus());
  }

  @override
  void dispose() {
    _importController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _orgNameController.dispose();
    _orgIdController.dispose();
    super.dispose();
  }

  E2eeSyncTransport _transport() => E2eeSyncTransport(
    crypto: ref.read(e2eeSyncServiceProvider),
    httpClient: ref.read(lexHttpClientProvider),
  );

  Future<void> _loadKeyStatus() async {
    final service = ref.read(e2eeSyncServiceProvider);
    final configured = await service.hasRecoveryKey();
    final phrase = await service.readFormattedRecoveryKey();
    final token = await service.readWorkspaceToken();
    if (!mounted) return;
    setState(() {
      _hasKey = configured;
      _recoveryPhrase = phrase;
      _signedIn = token != null && token.isNotEmpty;
    });
    if (_signedIn) {
      unawaited(_refreshDevices());
    }
  }

  Future<void> _refreshDevices() async {
    final res = await _transport().listDevices();
    if (!mounted) return;
    if (res case Success(:final value)) {
      setState(() => _devices = value);
    }
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

  Future<void> _authenticate({required bool register}) async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    if (email.isEmpty || password.length < 8) {
      setState(
        () => _statusMessage = 'Enter a valid email and >= 8 char password.',
      );
      return;
    }
    setState(() {
      _busy = true;
      _statusMessage = null;
    });
    final deviceId = await ref
        .read(deviceAuthServiceProvider)
        .getOrCreateDeviceId();
    final transport = _transport();
    final res = register
        ? await transport.registerAccount(
            email: email,
            password: password,
            deviceId: deviceId,
          )
        : await transport.loginAccount(
            email: email,
            password: password,
            deviceId: deviceId,
          );
    if (!mounted) return;
    setState(() => _busy = false);
    switch (res) {
      case Success(:final value):
        _passwordController.clear();
        await _loadKeyStatus();
        setState(() => _statusMessage = 'Workspace authenticated ($value).');
      case Err(:final failure):
        setState(() => _statusMessage = failure.message);
    }
  }

  Future<void> _createOrg() async {
    final name = _orgNameController.text.trim();
    if (name.length < 2) return;
    setState(() => _busy = true);
    final res = await _transport().createOrganization(name);
    if (!mounted) return;
    setState(() => _busy = false);
    switch (res) {
      case Success(:final value):
        final orgId = value['org_id'] as String? ?? '';
        _orgNameController.clear();
        _orgIdController.text = orgId;
        setState(() => _statusMessage = 'Organization created: $orgId (Owner)');
      case Err(:final failure):
        setState(() => _statusMessage = failure.message);
    }
  }

  Future<void> _syncNow() async {
    if (!_hasKey || !_signedIn) {
      setState(
        () => _statusMessage =
            'Generate a recovery key and sign in before syncing.',
      );
      return;
    }
    setState(() => _busy = true);
    final records =
        <
          ({String recordType, String recordId, Map<String, dynamic> payload})
        >[];

    if (_syncCases) {
      final cases = await ref
          .read(caseFileRepositoryProvider)
          .watchCases()
          .first;
      for (final c in cases) {
        records.add((
          recordType: 'case_file',
          recordId: c.id,
          payload: {
            'title': c.title,
            'category': c.category,
            'status': c.status,
            'summary': c.summary,
          },
        ));
      }
    }
    final lib = ref.read(libraryRepositoryProvider);
    if (_syncDrafts) {
      final drafts = await lib.watchDrafts().first;
      for (final d in drafts) {
        records.add((
          recordType: 'draft',
          recordId: d.id,
          payload: {
            'title': d.title,
            'template_type': d.templateType,
            'content': d.content,
          },
        ));
      }
    }
    if (_syncBookmarks) {
      final bookmarks = await lib.watchBookmarks().first;
      for (final b in bookmarks) {
        records.add((
          recordType: 'bookmark',
          recordId: '${b.actCode}_${b.sectionNumber}',
          payload: {
            'act_code': b.actCode,
            'section_number': b.sectionNumber,
            'note': b.note,
          },
        ));
      }
    }
    if (_syncScanMeta) {
      final scans = await lib.watchScans().first;
      for (final s in scans) {
        records.add((
          recordType: 'scan_meta',
          recordId: s.id,
          payload: {'title': s.title, 'page_count': s.pageCount},
        ));
      }
    }

    final orgId = _orgIdController.text.trim();
    final res = await _transport().pushAndPullRecords(
      records: records,
      orgId: orgId.isEmpty ? null : orgId,
    );
    if (!mounted) return;
    setState(() => _busy = false);
    switch (res) {
      case Success(:final value):
        setState(
          () => _statusMessage =
              'Encrypted sync complete: pushed ${value.pushedCount}, pulled & verified ${value.decryptedRecords.length}/${value.pulledCount}.',
        );
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _signedIn
                      ? 'Sync Account & Team Workspace (Signed In)'
                      : 'Optional Sync Account (Sign In / Create)',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: tokens.text,
                  ),
                ),
                const SizedBox(height: 8),
                if (!_signedIn) ...[
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Work or personal email',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Strong passphrase (min 8 chars)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _busy
                              ? null
                              : () => _authenticate(register: false),
                          child: const Text('Sign In'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: FilledButton(
                          onPressed: _busy
                              ? null
                              : () => _authenticate(register: true),
                          child: const Text('Create Account'),
                        ),
                      ),
                    ],
                  ),
                ] else ...[
                  TextField(
                    controller: _orgIdController,
                    decoration: const InputDecoration(
                      labelText:
                          'Optional Team Org ID (blank = personal vault)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _orgNameController,
                          decoration: const InputDecoration(
                            labelText: 'New firm/team name',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton(
                        onPressed: _busy ? null : _createOrg,
                        child: const Text('Create Org'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: _busy ? null : _syncNow,
                          icon: const Icon(Icons.cloud_upload_outlined),
                          label: Text(
                            _busy
                                ? 'Encrypting & syncing…'
                                : 'Encrypt & Sync Now',
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      TextButton(
                        onPressed: _busy
                            ? null
                            : () async {
                                await _transport().logoutAllSessions();
                                await _loadKeyStatus();
                              },
                        child: Text(
                          'Logout All',
                          style: TextStyle(color: tokens.riskHigh),
                        ),
                      ),
                    ],
                  ),
                  if (_devices.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    for (final d in _devices)
                      ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          '${d['device_name'] ?? d['device_id']} (${d['platform'] ?? ''})',
                        ),
                        subtitle: Text(
                          (d['revoked'] as bool? ?? false)
                              ? 'Revoked'
                              : 'Active',
                        ),
                        trailing: (d['revoked'] as bool? ?? false)
                            ? null
                            : TextButton(
                                onPressed: () async {
                                  await _transport().revokeDevice(
                                    d['device_id'] as String,
                                  );
                                  await _refreshDevices();
                                },
                                child: const Text('Revoke'),
                              ),
                      ),
                  ],
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
