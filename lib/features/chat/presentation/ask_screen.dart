import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
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
      header: message.confidence != null
          ? ConfidenceBadge(
              level: message.confidence!,
              sourceCount: message.citations.length,
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
