import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lex_copilot/ai/ai_providers.dart';
import 'package:lex_copilot/ai/on_device/on_device_gemma_service.dart';
import 'package:lex_copilot/app/theme/lex_tokens.dart';
import 'package:lex_copilot/core/security/security_providers.dart';
import 'package:lex_copilot/core/widgets/widgets.dart';
import 'package:lex_copilot/features/case_file/presentation/case_file_providers.dart';
import 'package:lex_copilot/features/chat/presentation/chat_controller.dart';
import 'package:lex_copilot/features/library/presentation/library_providers.dart';
import 'package:lex_copilot/features/settings/domain/lex_settings.dart';
import 'package:lex_copilot/features/settings/presentation/settings_controller.dart';
import 'package:lex_copilot/l10n/app_localizations.dart';
import 'package:share_plus/share_plus.dart';

/// AI answer behavior, Gemma 4 model management, routing, privacy,
/// encrypted vault export/wipe, and alert controls.
class AiPrivacyScreen extends ConsumerWidget {
  /// Creates an [AiPrivacyScreen].
  const new({super.key});

  Future<void> _exportUserData(BuildContext context, WidgetRef ref) async {
    final library = ref.read(libraryRepositoryProvider);
    final casesRepo = ref.read(caseFileRepositoryProvider);
    final bookmarks = await library.watchBookmarks().first;
    final scans = await library.watchScans().first;
    final drafts = await library.watchDrafts().first;
    final cases = await casesRepo.watchCases().first;

    final exportPayload = {
      'exported_at': DateTime.now().toIso8601String(),
      'app': 'Lex Copilot',
      'bookmarks': bookmarks
          .map(
            (b) => {
              'act': b.actCode,
              'section': b.sectionNumber,
              'note': b.note,
            },
          )
          .toList(),
      'scans': scans
          .map(
            (s) => {
              'id': s.id,
              'title': s.title,
              'page_count': s.pageCount,
              'created_at': s.createdAt.toIso8601String(),
            },
          )
          .toList(),
      'drafts': drafts
          .map(
            (d) => {
              'id': d.id,
              'template': d.templateType,
              'title': d.title,
              'content': d.content,
            },
          )
          .toList(),
      'cases': cases
          .map(
            (c) => {
              'id': c.id,
              'title': c.title,
              'category': c.category,
              'status': c.status,
              'summary': c.summary,
            },
          )
          .toList(),
    };

    await SharePlus.instance.share(
      ShareParams(
        text: const JsonEncoder.withIndent('  ').convert(exportPayload),
        subject: 'Lex Copilot Local Data Export',
      ),
    );
  }

  Future<void> _confirmDeleteAll(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete all local data?'),
        content: const Text(
          'This permanently erases all saved scans, drafts, bookmarks, case files, activity history, and encrypted vault files on this device. Official legal statutes remain offline.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete everything'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;
    await ref.read(libraryRepositoryProvider).deleteAllUserData();
    await ref.read(chatRepositoryProvider).deleteAllChatData();
    await ref.read(caseFileRepositoryProvider).deleteAllCases();
    await ref.read(encryptedFileStoreProvider).wipeAll();
    await ref.read(settingsControllerProvider.notifier).resetAll();

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All local personal data wiped.')),
      );
    }
  }

  void _showPrivacyNotice(BuildContext context) {
    unawaited(
      showModalBottomSheet<void>(
        context: context,
        builder: (ctx) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: ListView(
              shrinkWrap: true,
              children: const [
                Text(
                  'Lex Privacy & AI Grounding Notice',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 10),
                Text(
                  '1. On-device storage: Bookmarks, scans, drafts, and case files stay in a SQLCipher-encrypted database keyed via the OS Keystore/Keychain.\n\n'
                  '2. Scan file protection: Scanned images are sealed using LEX1 authenticated encryption when Encrypt local files is enabled and expire automatically after your configured retention window.\n\n'
                  '3. Cloud PII redaction: Before any cloud inference call leaves your device, Aadhaar, PAN, phone numbers, IFSC, UPI IDs, and bank account numbers are redacted locally and restored on-device.\n\n'
                  '4. Trust notice: AI answers are informational and grounded against local statutory texts; always verify official Gazette/India Code text before legal reliance.',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = context.lexTokens;
    final settings = ref.watch(settingsControllerProvider);
    final controller = ref.read(settingsControllerProvider.notifier);
    final gemmaService = ref.watch(onDeviceGemmaServiceProvider);
    final l10n = Localizations.of<AppLocalizations>(context, AppLocalizations);

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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AI and privacy',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    Text(
                      'Control how Lex thinks and what it keeps',
                      style: TextStyle(
                        fontSize: 14,
                        color: tokens.secondaryText,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: tokens.space(16)),
          Text(
            'ANSWERS',
            style: TextStyle(
              fontSize: 12,
              letterSpacing: 0.6,
              color: tokens.secondaryText,
            ),
          ),
          const SizedBox(height: 6),
          LexCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: SegmentedControl<LexAiAnswerStyle>(
                    selected: settings.aiAnswerStyle,
                    onChanged: controller.setAiAnswerStyle,
                    segments: const [
                      (value: LexAiAnswerStyle.concise, label: 'Concise'),
                      (value: LexAiAnswerStyle.balanced, label: 'Balanced'),
                      (value: LexAiAnswerStyle.detailed, label: 'Detailed'),
                    ],
                  ),
                ),
                Divider(height: 1, color: tokens.hairline),
                _ToggleRow(
                  label: 'Only verified citations',
                  value: settings.strictCitationsOnly,
                  onChanged: (v) => controller.setStrictCitationsOnly(value: v),
                ),
                Divider(height: 1, color: tokens.hairline),
                _ToggleRow(
                  label: 'Show reasoning trail',
                  value: settings.showReasoningTrail,
                  onChanged: (v) => controller.setShowReasoningTrail(value: v),
                ),
              ],
            ),
          ),
          SizedBox(height: tokens.space(16)),
          Text(
            'MODEL & ON-DEVICE GEMMA 4',
            style: TextStyle(
              fontSize: 12,
              letterSpacing: 0.6,
              color: tokens.secondaryText,
            ),
          ),
          const SizedBox(height: 6),
          LexCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: SegmentedControl<LexModelRouting>(
                    selected: settings.modelRouting,
                    onChanged: controller.setModelRouting,
                    segments: const [
                      (value: LexModelRouting.auto, label: 'Auto'),
                      (value: LexModelRouting.onDevice, label: 'On-device'),
                      (value: LexModelRouting.cloud, label: 'Cloud'),
                    ],
                  ),
                ),
                Divider(height: 1, color: tokens.hairline),
                _ToggleRow(
                  label: 'Deep research uses cloud',
                  value: settings.deepResearchUsesCloud,
                  onChanged: (v) =>
                      controller.setDeepResearchUsesCloud(value: v),
                ),
                Divider(height: 1, color: tokens.hairline),
                ValueListenableBuilder<OnDeviceModelState>(
                  valueListenable: gemmaService.stateListenable,
                  builder: (context, modelState, _) {
                    final statusLabel = switch (modelState.status) {
                      OnDeviceModelStatus.notInstalled => 'Not downloaded',
                      OnDeviceModelStatus.downloading =>
                        'Downloading ${modelState.progress}%',
                      OnDeviceModelStatus.paused =>
                        'Paused at ${modelState.progress}%',
                      OnDeviceModelStatus.ready =>
                        'Ready (${modelState.tier.displayName})',
                      OnDeviceModelStatus.lowMemoryFallback =>
                        'E2B CPU/Memory Fallback active',
                      OnDeviceModelStatus.error =>
                        'Unavailable (${modelState.errorMessage ?? 'error'})',
                    };
                    final cap = modelState.capabilityReport;
                    final bench = modelState.lastBenchmark;
                    return Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: SegmentedControl<Gemma4Tier>(
                                  selected: modelState.tier,
                                  onChanged: (tier) {
                                    if (modelState.status !=
                                        OnDeviceModelStatus.downloading) {
                                      unawaited(gemmaService.selectTier(tier));
                                    }
                                  },
                                  segments: const [
                                    (
                                      value: Gemma4Tier.e2b,
                                      label: 'E2B (2.6GB)',
                                    ),
                                    (
                                      value: Gemma4Tier.e4b,
                                      label: 'E4B (4.9GB)',
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      modelState.tier.displayName,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: tokens.text,
                                      ),
                                    ),
                                    Text(
                                      statusLabel,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: tokens.secondaryText,
                                      ),
                                    ),
                                    if (cap != null) ...[
                                      const SizedBox(height: 4),
                                      Text(
                                        cap.advisoryReason,
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: tokens.secondaryText,
                                        ),
                                      ),
                                    ],
                                    if (bench != null) ...[
                                      const SizedBox(height: 4),
                                      Text(
                                        'Last benchmark: ${bench.latencyMs} ms (${bench.backendLabel})',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: tokens.accent,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              if (modelState.status ==
                                  OnDeviceModelStatus.downloading)
                                TextButton(
                                  onPressed: gemmaService.pauseDownload,
                                  child: const Text('Pause'),
                                )
                              else if (modelState.status ==
                                  OnDeviceModelStatus.paused)
                                FilledButton.tonal(
                                  onPressed: gemmaService.resumeDownload,
                                  child: const Text('Resume'),
                                )
                              else if (modelState.status ==
                                      OnDeviceModelStatus.ready ||
                                  modelState.status ==
                                      OnDeviceModelStatus.lowMemoryFallback)
                                Wrap(
                                  spacing: 4,
                                  children: [
                                    TextButton(
                                      onPressed:
                                          gemmaService.runLatencyBenchmark,
                                      child: const Text('Test'),
                                    ),
                                    TextButton(
                                      onPressed: gemmaService.deleteModel,
                                      child: const Text('Remove'),
                                    ),
                                  ],
                                )
                              else
                                FilledButton.tonal(
                                  onPressed: gemmaService.downloadModel,
                                  child: const Text('Download'),
                                ),
                            ],
                          ),
                          if (modelState.status ==
                                  OnDeviceModelStatus.downloading ||
                              modelState.status ==
                                  OnDeviceModelStatus.paused) ...[
                            const SizedBox(height: 8),
                            LinearProgressIndicator(
                              value: modelState.progress / 100.0,
                            ),
                          ],
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: tokens.space(16)),
          Text(
            'PRIVACY & ALERTS',
            style: TextStyle(
              fontSize: 12,
              letterSpacing: 0.6,
              color: tokens.secondaryText,
            ),
          ),
          const SizedBox(height: 6),
          LexCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                _ToggleRow(
                  label: 'Biometric app lock',
                  value: settings.biometricLockEnabled,
                  onChanged: (v) =>
                      controller.setBiometricLockEnabled(value: v),
                ),
                Divider(height: 1, color: tokens.hairline),
                _ToggleRow(
                  label: 'Encrypt local files',
                  value: settings.encryptLocalFiles,
                  onChanged: (v) => controller.setEncryptLocalFiles(value: v),
                ),
                Divider(height: 1, color: tokens.hairline),
                _ToggleRow(
                  label: 'Deadline reminders',
                  value: settings.deadlineRemindersEnabled,
                  onChanged: (v) =>
                      controller.setDeadlineRemindersEnabled(value: v),
                ),
                Divider(height: 1, color: tokens.hairline),
                _ToggleRow(
                  label: 'Hearing alerts',
                  value: settings.hearingAlertsEnabled,
                  onChanged: (v) =>
                      controller.setHearingAlertsEnabled(value: v),
                ),
                Divider(height: 1, color: tokens.hairline),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Auto-delete scans'),
                      DropdownButton<int>(
                        value: settings.autoDeleteScansDays,
                        underline: const SizedBox.shrink(),
                        items: const [
                          DropdownMenuItem(value: 7, child: Text('7 days')),
                          DropdownMenuItem(value: 30, child: Text('30 days')),
                          DropdownMenuItem(value: 90, child: Text('90 days')),
                          DropdownMenuItem(value: 0, child: Text('Never')),
                        ],
                        onChanged: (days) {
                          if (days != null) {
                            unawaited(controller.setAutoDeleteScansDays(days));
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: tokens.space(16)),
          LexCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.inventory_2_outlined),
                  title: const Text('Offline Knowledge Packs'),
                  subtitle: const Text(
                    'Constitution (May 2026) & Central Acts',
                  ),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => context.push('/customize/knowledge-packs'),
                ),
                Divider(height: 1, color: tokens.hairline),
                ListTile(
                  leading: const Icon(Icons.cloud_sync_outlined),
                  title: const Text('E2EE Cloud Sync & Workspaces'),
                  subtitle: const Text(
                    'Optional zero-knowledge backup & team RBAC',
                  ),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => context.push('/customize/workspace-sync'),
                ),
                Divider(height: 1, color: tokens.hairline),
                ListTile(
                  leading: const Icon(Icons.privacy_tip_outlined),
                  title: Text(l10n?.privacyNoticeTitle ?? 'Privacy notice'),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => _showPrivacyNotice(context),
                ),
                Divider(height: 1, color: tokens.hairline),
                ListTile(
                  leading: const Icon(Icons.download_outlined),
                  title: Text(l10n?.exportMyData ?? 'Export my data'),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => _exportUserData(context, ref),
                ),
                Divider(height: 1, color: tokens.hairline),
                ListTile(
                  leading: Icon(
                    Icons.delete_forever_outlined,
                    color: tokens.riskHigh,
                  ),
                  title: Text(
                    l10n?.deleteAllData ?? 'Delete all data',
                    style: TextStyle(color: tokens.riskHigh),
                  ),
                  onTap: () => _confirmDeleteAll(context, ref),
                ),
              ],
            ),
          ),
          SizedBox(height: tokens.space(14)),
          OutlinedButton(
            onPressed: controller.resetAll,
            child: const Text('Reset customization defaults'),
          ),
        ],
      ),
    );
  }
}

class _ToggleRow extends StatelessWidget {
  const new({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final tokens = context.lexTokens;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(fontSize: 15, color: tokens.text),
            ),
          ),
          LexToggle(value: value, semanticLabel: label, onChanged: onChanged),
        ],
      ),
    );
  }
}
