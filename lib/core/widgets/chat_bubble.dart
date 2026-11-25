import 'package:flutter/material.dart';
import 'package:lex_copilot/app/theme/lex_tokens.dart';
import 'package:lex_copilot/core/widgets/lex_card.dart';

/// Chat message bubble supporting user prompts and grounded assistant answers
/// with streaming indicator, citations, and notice footer.
class ChatBubble extends StatelessWidget {
  /// Creates a [ChatBubble].
  const new({
    required this.text,
    required this.isUser,
    super.key,
    this.isStreaming = false,
    this.header,
    this.footer,
  });

  /// Message body text.
  final String text;

  /// `true` for user messages, `false` for Lex assistant replies.
  final bool isUser;

  /// Displays a subtle streaming pulse when tokens are arriving.
  final bool isStreaming;

  /// Optional top metadata widget (e.g. ConfidenceBadge).
  final Widget? header;

  /// Optional bottom widget (e.g. citation chips or verify notice).
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final tokens = context.lexTokens;

    if (isUser) {
      return Align(
        alignment: Alignment.centerRight,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 300),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: tokens.space(16),
              vertical: tokens.space(12),
            ),
            decoration: BoxDecoration(
              color: tokens.accent,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(tokens.cardRadius),
                topRight: Radius.circular(tokens.cardRadius),
                bottomLeft: Radius.circular(tokens.cardRadius),
                bottomRight: const Radius.circular(6),
              ),
            ),
            child: Text(
              text,
              style: TextStyle(
                fontSize: 15,
                height: 1.45,
                color: tokens.onAccent,
              ),
            ),
          ),
        ),
      );
    }

    return LexCard(
      padding: EdgeInsets.all(tokens.space(18)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (header != null) ...[header!, SizedBox(height: tokens.space(10))],
          Text(
            isStreaming ? '$text ▌' : text,
            style: TextStyle(fontSize: 15, height: 1.5, color: tokens.text),
          ),
          if (footer != null) ...[SizedBox(height: tokens.space(12)), footer!],
        ],
      ),
    );
  }
}
