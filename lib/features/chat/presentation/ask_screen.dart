import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lex_copilot/ai/router/model_router.dart';
import 'package:lex_copilot/app/theme/lex_tokens.dart';
import 'package:lex_copilot/core/widgets/widgets.dart';
import 'package:lex_copilot/features/chat/domain/chat_models.dart';
import 'package:lex_copilot/features/chat/presentation/chat_controller.dart';
import 'package:lex_copilot/features/settings/presentation/settings_controller.dart';

/// Legal Q&A and document-grounded chat screen with streaming tokens,
/// verified citation chips, reasoning trail, counter-arguments, and retry.
class AskScreen extends ConsumerStatefulWidget {
  /// Creates an [AskScreen].
  const new({super.key});

  @override
  ConsumerState<AskScreen> createState() => _AskScreenState();
}

class _AskScreenState extends ConsumerState<AskScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool? _showReasoningOverride;
  bool _showCounters = false;
  bool _consentSheetOpen = false;

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _showCloudConsentSheet(CloudConsentRequest req) async {
    if (_consentSheetOpen || !mounted) return;
    _consentSheetOpen = true;
    final tokens = context.lexTokens;
    final approved = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Cloud escalation requires consent',
                style: Theme.of(ctx).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                req.reason,
                style: TextStyle(fontSize: 14, color: tokens.secondaryText),
              ),
              const SizedBox(height: 12),
              Text(
                'Redacted preview that will be sent:',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: tokens.text,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: tokens.neutralControlFill,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  req.redactedPreview.isEmpty
                      ? '(Redacted query preview)'
                      : req.redactedPreview,
                  style: TextStyle(fontSize: 12, color: tokens.secondaryText),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      child: const Text('Keep local'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: FilledButton(
                      onPressed: () => Navigator.pop(ctx, true),
                      child: const Text('Approve & send'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
    _consentSheetOpen = false;
    if (!mounted) return;
    if (approved == true) {
      unawaited(
        ref.read(chatControllerProvider.notifier).approveCloudEscalation(),
      );
    } else {
      ref.read(chatControllerProvider.notifier).declineCloudEscalation();
    }
  }

  Future<void> _submit() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    final ok = await ref
        .read(chatControllerProvider.notifier)
        .sendMessage(text);
    if (!mounted) return;
    if (ok) {
      _controller.clear();
    } else {
      // Preserve prompt so the user can edit or tap Retry.
      _controller.text = text;
    }
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.lexTokens;
    final chatState = ref.watch(chatControllerProvider);
    final settings = ref.watch(settingsControllerProvider);
    final showReasoning = _showReasoningOverride ?? settings.showReasoningTrail;

    ref.listen<CloudConsentRequest?>(
      chatControllerProvider.select((s) => s.pendingCloudConsent),
      (_, next) {
        if (next != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            unawaited(_showCloudConsentSheet(next));
          });
        }
      },
    );

    return Column(
      children: [
        Expanded(
          child: ListView(
            controller: _scrollController,
            padding: EdgeInsets.fromLTRB(
              tokens.space(20),
              tokens.space(20),
              tokens.space(20),
              24,
            ),
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Ask Lex',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                  ),
                  LexChip(
                    label: showReasoning ? 'Reasoning on' : 'Reasoning',
                    selected: showReasoning,
                    onTap: () =>
                        setState(() => _showReasoningOverride = !showReasoning),
                  ),
                  const SizedBox(width: 6),
                  LexChip(
                    label: _showCounters ? 'Counters on' : 'Counters',
                    selected: _showCounters,
                    onTap: () => setState(() => _showCounters = !_showCounters),
                  ),
                  if (chatState.messages.isNotEmpty) ...[
                    const SizedBox(width: 4),
                    IconButton(
                      tooltip: 'New conversation',
                      onPressed: chatState.isGenerating
                          ? null
                          : ref
                                .read(chatControllerProvider.notifier)
                                .clearThread,
                      icon: Icon(
                        Icons.add_comment_outlined,
                        size: 20,
                        color: tokens.secondaryText,
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 14),
              if (chatState.attachedScan != null) ...[
                LexCard(
                  padding: EdgeInsets.all(tokens.space(12)),
                  child: Row(
                    children: [
                      Expanded(
                        child: DocumentThumb(
                          fileName: chatState.attachedScan!.fileName,
                          subtitle:
                              '${chatState.attachedScan!.pageCount} page${chatState.attachedScan!.pageCount == 1 ? '' : 's'} · attached context',
                        ),
                      ),
                      IconButton(
                        tooltip: 'Remove attached document',
                        onPressed: ref
                            .read(chatControllerProvider.notifier)
                            .clearAttachment,
                        icon: Icon(
                          Icons.close_rounded,
                          color: tokens.secondaryText,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
              ],
              if (chatState.messages.isEmpty)
                EmptyState(
                  icon: Icons.gavel_rounded,
                  title: 'Grounded Indian legal research',
                  message: 'Ask about BNS, BNSS, BSA provisions, or attach a scanned notice/contract. Citations are checked against the local corpus.',
                  actionLabel: 'Scan a document',
                  onAction: () => context.go('/scan'),
                )
              else
                for (final msg in chatState.messages) ...[
                  if (msg.attachment != null && !msg.isUser)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: DocumentThumb(
                          fileName: msg.attachment!.fileName,
                          subtitle:
                              '${msg.attachment!.pageCount} page${msg.attachment!.pageCount == 1 ? '' : 's'} · OCR attached',
                        ),
                      ),
                    ),
                  _MessageCard(
                    message: msg,
                    showReasoning: showReasoning,
                    showCounters: _showCounters,
                    onCitationTap: (act, number) =>
                        context.push('/section/$act/$number'),
                    onRetry: ref
                        .read(chatControllerProvider.notifier)
                        .retryLast,
                  ),
                  const SizedBox(height: 12),
                ],
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
          child: GlassBar(
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              children: [
                IconButton(
                  tooltip: 'Attach scan',
                  onPressed: () => context.go('/scan'),
                  icon: Icon(
                    Icons.camera_alt_outlined,
                    color: tokens.secondaryText,
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => _submit(),
                    decoration: InputDecoration(
                      hintText: chatState.attachedScan != null
                          ? 'Ask about ${chatState.attachedScan!.fileName}…'
                          : 'Ask a legal question…',
                      hintStyle: TextStyle(color: tokens.secondaryText),
                      border: InputBorder.none,
                      isDense: true,
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
                    tooltip: 'Send message',
                    padding: EdgeInsets.zero,
                    onPressed: chatState.isGenerating ? null : _submit,
                    icon: chatState.isGenerating
                        ? SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: tokens.onAccent,
                            ),
                          )
                        : Icon(
                            Icons.arrow_upward_rounded,
                            size: 20,
                            color: tokens.onAccent,
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _MessageCard extends StatelessWidget {
  const new({
    required this.message,
    required this.showReasoning,
    required this.showCounters,
    required this.onCitationTap,
    required this.onRetry,
  });

  final ChatMessageModel message;
  final bool showReasoning;
  final bool showCounters;
  final void Function(String actCode, String sectionNumber) onCitationTap;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final tokens = context.lexTokens;

    if (message.isUser) {
      return ChatBubble(text: message.text, isUser: true);
    }

    if (message.errorMessage != null) {
      return ErrorState(
        title: 'Answer interrupted',
        message: message.errorMessage!,
        onRetry: onRetry,
      );
    }

    return ChatBubble(
      isUser: false,
      isStreaming: message.isStreaming,
      text: message.text.isEmpty && message.isStreaming
          ? 'Checking statutory corpus'
          : message.text,
      header: (message.confidence != null || message.engineLabel != null)
          ? Wrap(
              spacing: 8,
              runSpacing: 6,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                if (message.confidence != null)
                  ConfidenceBadge(
                    level: message.confidence!,
                    sourceCount: message.citations.length,
                  ),
                if (message.engineLabel != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: tokens.neutralControlFill,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      message.engineLabel!,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: tokens.secondaryText,
                      ),
                    ),
                  ),
              ],
            )
          : null,
      footer: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (message.citations.isNotEmpty)
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: [
                for (final c in message.citations)
                  CitationChip(
                    citation: c.label,
                    verified: c.verified,
                    onTap: c.verified
                        ? () => onCitationTap(c.actCode, c.sectionNumber)
                        : null,
                  ),
              ],
            ),
          if (message.provenance case final prov?) ...[
            if (prov.footnoteWarnings.isNotEmpty) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: tokens.riskMedium.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Amendment & Judicial Footnotes (${prov.intentLabel})',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: tokens.text,
                      ),
                    ),
                    const SizedBox(height: 4),
                    for (final warn in prov.footnoteWarnings)
                      Text(
                        '• $warn',
                        style: TextStyle(
                          fontSize: 11.5,
                          color: tokens.secondaryText,
                        ),
                      ),
                  ],
                ),
              ),
            ],
            if (prov.unavailableExternalNotices.isNotEmpty) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: tokens.riskHigh.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'External Acts Not Loaded Offline',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: tokens.riskHigh,
                      ),
                    ),
                    const SizedBox(height: 4),
                    for (final notice in prov.unavailableExternalNotices)
                      Text(
                        '• $notice',
                        style: TextStyle(
                          fontSize: 11.5,
                          color: tokens.secondaryText,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ],
          if (showReasoning &&
              message.reasoningTrail != null &&
              message.reasoningTrail!.isNotEmpty) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: tokens.neutralControlFill,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'Reasoning trail: ${message.reasoningTrail}',
                style: TextStyle(fontSize: 12, color: tokens.secondaryText),
              ),
            ),
          ],
          if (showCounters &&
              message.counterArguments != null &&
              message.counterArguments!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: tokens.riskMedium.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'Counter-arguments: ${message.counterArguments}',
                style: TextStyle(fontSize: 12, color: tokens.secondaryText),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
