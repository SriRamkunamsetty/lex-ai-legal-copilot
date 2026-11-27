import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lex_copilot/ai/router/model_router.dart';
import 'package:lex_copilot/app/theme/lex_tokens.dart';
import 'package:lex_copilot/core/widgets/widgets.dart';
import 'package:lex_copilot/features/chat/domain/chat_models.dart';
import 'package:lex_copilot/features/chat/presentation/chat_controller.dart';
import 'package:lex_copilot/features/settings/domain/lex_settings.dart';
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
  void initState() {
    super.initState();
    _controller.addListener(_onInputChanged);
  }

  void _onInputChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _controller.removeListener(_onInputChanged);
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  String _timeGreeting(LexUserRole role) {
    final hour = DateTime.now().hour;
    final prefix = switch (hour) {
      < 12 => 'Good morning',
      < 17 => 'Good afternoon',
      _ => 'Good evening',
    };
    return switch (role) {
      LexUserRole.lawyer => '$prefix, Counsel',
      LexUserRole.business => '$prefix, Founder',
      LexUserRole.individual => prefix,
    };
  }

  String _planBadgePrefix(LexModelRouting routing) => switch (routing) {
    LexModelRouting.onDevice => 'Local Gemma 4',
    LexModelRouting.auto => 'Hybrid Auto',
    LexModelRouting.cloud => 'Cloud Gemini',
  };

  Future<void> _openComposerOptions(
    BuildContext context,
    bool showReasoning,
  ) async {
    unawaited(HapticFeedback.selectionClick());
    final tokens = context.lexTokens;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sheetBg = isDark ? const Color(0xFF1E1D1B) : const Color(0xFFFAF8F5);
    final cardBg = isDark ? const Color(0xFF282624) : const Color(0xFFFFFFFF);
    final border = isDark ? const Color(0xFF383531) : const Color(0xFFE8E4DC);
    final handleBg = isDark ? const Color(0xFF47443E) : const Color(0xFFD5D0C7);

    var localReasoning = showReasoning;
    var localCounters = _showCounters;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => Container(
          decoration: BoxDecoration(
            color: sheetBg,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            border: Border(top: BorderSide(color: border)),
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 10, 18, 18),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 38,
                      height: 4,
                      decoration: BoxDecoration(
                        color: handleBg,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: tokens.accent.withValues(alpha: 0.14),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.auto_awesome_rounded,
                          size: 18,
                          color: tokens.accent,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Ask Tools & Context',
                              style: Theme.of(ctx).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                            Text(
                              'Attach evidence or tune legal reasoning',
                              style: Theme.of(ctx).textTheme.bodySmall
                                  ?.copyWith(color: tokens.secondaryText),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _ComposerQuickCard(
                          icon: Icons.document_scanner_rounded,
                          title: 'Scan Notice',
                          subtitle: 'Camera or PDF OCR',
                          accent: tokens.accent,
                          cardBg: cardBg,
                          border: border,
                          textColor: tokens.text,
                          secondaryColor: tokens.secondaryText,
                          onTap: () {
                            unawaited(HapticFeedback.selectionClick());
                            Navigator.pop(ctx);
                            context.go('/scan');
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _ComposerQuickCard(
                          icon: Icons.mic_rounded,
                          title: 'Voice Incident',
                          subtitle: 'Speak in any language',
                          accent: tokens.accent,
                          cardBg: cardBg,
                          border: border,
                          textColor: tokens.text,
                          secondaryColor: tokens.secondaryText,
                          onTap: () {
                            unawaited(HapticFeedback.selectionClick());
                            Navigator.pop(ctx);
                            unawaited(context.push('/incident'));
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Container(
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: border),
                    ),
                    child: Column(
                      children: [
                        _ComposerToggleRow(
                          icon: Icons.psychology_alt_rounded,
                          title: 'Reasoning trail',
                          subtitle: 'Show IRAC step-by-step legal logic',
                          value: localReasoning,
                          accent: tokens.accent,
                          textColor: tokens.text,
                          secondaryColor: tokens.secondaryText,
                          onChanged: (next) {
                            unawaited(HapticFeedback.selectionClick());
                            setSheetState(() => localReasoning = next);
                            setState(() => _showReasoningOverride = next);
                          },
                        ),
                        Divider(height: 1, indent: 52, color: border),
                        _ComposerToggleRow(
                          icon: Icons.balance_rounded,
                          title: 'Counter-arguments',
                          subtitle: 'Include opposing counsel perspective',
                          value: localCounters,
                          accent: tokens.accent,
                          textColor: tokens.text,
                          secondaryColor: tokens.secondaryText,
                          onChanged: (next) {
                            unawaited(HapticFeedback.selectionClick());
                            setSheetState(() => localCounters = next);
                            setState(() => _showCounters = next);
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Material(
                    color: cardBg,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: border),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      onTap: () {
                        unawaited(HapticFeedback.selectionClick());
                        Navigator.pop(ctx);
                        ref.read(chatControllerProvider.notifier).clearThread();
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 13,
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 34,
                              height: 34,
                              decoration: BoxDecoration(
                                color: tokens.secondaryText.withValues(
                                  alpha: 0.12,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                Icons.add_comment_rounded,
                                size: 18,
                                color: tokens.text,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Start fresh conversation',
                                style: Theme.of(ctx).textTheme.titleSmall
                                    ?.copyWith(fontWeight: FontWeight.w600),
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 14,
                              color: tokens.secondaryText,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
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

    final hasConversation =
        chatState.messages.isNotEmpty || chatState.attachedScan != null;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final pillBg = isDark ? const Color(0xFF282724) : const Color(0xFFF0EEE9);
    final composerBg = isDark ? const Color(0xFF252422) : Colors.white;
    final composerBorder = isDark
        ? const Color(0xFF353330)
        : const Color(0xFFE6E3DD);
    final circleSoftBg = isDark
        ? const Color(0xFF32302D)
        : const Color(0xFFF2F0EC);
    final primaryBtnBg = isDark
        ? const Color(0xFFF4F2EE)
        : const Color(0xFF141413);
    final primaryBtnFg = isDark ? const Color(0xFF141413) : Colors.white;
    final hasTypedText = _controller.text.trim().isNotEmpty;

    return Column(
      children: [
        if (hasConversation) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 12, 12, 6),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Ask Lex',
                    style: Theme.of(context).textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.w600),
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
                  const SizedBox(width: 2),
                  IconButton(
                    tooltip: 'New conversation',
                    onPressed: chatState.isGenerating
                        ? null
                        : ref.read(chatControllerProvider.notifier).clearThread,
                    icon: Icon(
                      Icons.add_comment_outlined,
                      size: 20,
                      color: tokens.secondaryText,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
        Expanded(
          child: !hasConversation
              ? Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28,
                      vertical: 24,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CustomPaint(
                          size: Size(48, 48),
                          painter: _LexStarburstPainter(Color(0xFFD97757)),
                        ),
                        const SizedBox(height: 18),
                        Text(
                          _timeGreeting(settings.userRole),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'serif',
                            fontSize: 28,
                            fontWeight: FontWeight.w500,
                            letterSpacing: -0.3,
                            color: tokens.text,
                          ),
                        ),
                        const SizedBox(height: 18),
                        InkWell(
                          onTap: () => context.push('/customize/ai-privacy'),
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: pillBg,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text.rich(
                              TextSpan(
                                style: TextStyle(
                                  fontSize: 13,
                                  color: tokens.secondaryText,
                                ),
                                children: [
                                  TextSpan(
                                    text:
                                        '${_planBadgePrefix(settings.modelRouting)} · ',
                                  ),
                                  TextSpan(
                                    text: 'AI & Privacy',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: tokens.text,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : ListView(
                  controller: _scrollController,
                  padding: EdgeInsets.fromLTRB(
                    tokens.space(18),
                    tokens.space(8),
                    tokens.space(18),
                    16,
                  ),
                  children: [
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
          padding: EdgeInsets.fromLTRB(
            14,
            6,
            14,
            10 + ClaudeBottomBarInset.of(context),
          ),
          child: Container(
            padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
            decoration: BoxDecoration(
              color: composerBg,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: composerBorder),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.04),
                  blurRadius: 12,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                Tooltip(
                  message: 'Attach or options',
                  child: Material(
                    color: circleSoftBg,
                    shape: const CircleBorder(),
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      onTap: () => _openComposerOptions(context, showReasoning),
                      child: SizedBox(
                        width: 38,
                        height: 38,
                        child: Icon(
                          Icons.add_rounded,
                          size: 21,
                          color: tokens.text,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => _submit(),
                    decoration: InputDecoration(
                      hintText: chatState.attachedScan != null
                          ? 'Ask about ${chatState.attachedScan!.fileName}…'
                          : 'Type or hold to talk',
                      hintStyle: TextStyle(
                        fontSize: 15.5,
                        color: tokens.secondaryText,
                      ),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
                Tooltip(
                  message: 'Voice incident input',
                  child: Material(
                    color: circleSoftBg,
                    shape: const CircleBorder(),
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      onTap: () => context.push('/incident'),
                      child: SizedBox(
                        width: 38,
                        height: 38,
                        child: Icon(
                          Icons.mic_none_rounded,
                          size: 20,
                          color: tokens.text,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Tooltip(
                  message: 'Send message',
                  child: Material(
                    color: primaryBtnBg,
                    shape: const CircleBorder(),
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      onTap: chatState.isGenerating
                          ? null
                          : hasTypedText
                          ? _submit
                          : () => context.push('/incident'),
                      child: SizedBox(
                        width: 38,
                        height: 38,
                        child: Center(
                          child: chatState.isGenerating
                              ? SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: primaryBtnFg,
                                  ),
                                )
                              : Icon(
                                  hasTypedText
                                      ? Icons.arrow_upward_rounded
                                      : Icons.graphic_eq_rounded,
                                  size: 20,
                                  color: primaryBtnFg,
                                ),
                        ),
                      ),
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

class _LexStarburstPainter extends CustomPainter {
  const new(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final outer = size.width * 0.48;
    final inner = size.width * 0.14;
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3.1
      ..strokeCap = StrokeCap.round;

    const rayAngles = <double>[
      -1.57,
      -1.05,
      -0.42,
      0.12,
      0.68,
      1.26,
      1.92,
      2.46,
      3.04,
      -2.18,
    ];
    for (var i = 0; i < rayAngles.length; i++) {
      final angle = rayAngles[i];
      final radius = i.isEven ? outer : outer * 0.84;
      final start = Offset(
        center.dx + inner * 0.65 * _cos(angle),
        center.dy + inner * 0.65 * _sin(angle),
      );
      final end = Offset(
        center.dx + radius * _cos(angle),
        center.dy + radius * _sin(angle),
      );
      canvas.drawLine(start, end, paint);
    }
  }

  static double _cos(double rad) => _cosLookup(rad);
  static double _sin(double rad) => _sinLookup(rad);

  @override
  bool shouldRepaint(covariant _LexStarburstPainter oldDelegate) =>
      oldDelegate.color != color;
}

double _cosLookup(double x) {
  // Fast 6th-order Taylor approximation around 0 after modular wrap in [-pi, pi].
  const pi = 3.141592653589793;
  var a = x % (2 * pi);
  if (a > pi) a -= 2 * pi;
  if (a < -pi) a += 2 * pi;
  final a2 = a * a;
  return 1 - a2 / 2 + (a2 * a2) / 24 - (a2 * a2 * a2) / 720;
}

double _sinLookup(double x) => _cosLookup(x - 1.5707963267948966);

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

class _ComposerQuickCard extends StatelessWidget {
  const new({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.accent,
    required this.cardBg,
    required this.border,
    required this.textColor,
    required this.secondaryColor,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color accent;
  final Color cardBg;
  final Color border;
  final Color textColor;
  final Color secondaryColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: cardBg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: border),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.13),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 19, color: accent),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(fontSize: 12, color: secondaryColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ComposerToggleRow extends StatelessWidget {
  const new({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.accent,
    required this.textColor,
    required this.secondaryColor,
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final Color accent;
  final Color textColor;
  final Color secondaryColor;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(!value),
      borderRadius: BorderRadius.circular(18),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: value
                    ? accent.withValues(alpha: 0.15)
                    : secondaryColor.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                size: 18,
                color: value ? accent : secondaryColor,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 12, color: secondaryColor),
                  ),
                ],
              ),
            ),
            Switch.adaptive(
              value: value,
              activeTrackColor: accent,
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }
}
