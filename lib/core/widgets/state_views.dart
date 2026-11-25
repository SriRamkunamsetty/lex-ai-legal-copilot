import 'package:flutter/material.dart';
import 'package:lex_copilot/app/theme/lex_tokens.dart';
import 'package:lex_copilot/core/widgets/lex_card.dart';

/// Clean empty state card with icon, title, subtitle, and optional CTA.
class EmptyState extends StatelessWidget {
  /// Creates an [EmptyState].
  const new({
    required this.icon,
    required this.title,
    required this.message,
    super.key,
    this.actionLabel,
    this.onAction,
  });

  /// Illustrative icon.
  final IconData icon;

  /// Primary heading.
  final String title;

  /// Supporting explanation.
  final String message;

  /// Optional action button label.
  final String? actionLabel;

  /// Optional action button callback.
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final tokens = context.lexTokens;

    return LexCard(
      padding: EdgeInsets.all(tokens.space(24)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: tokens.accentTint,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: tokens.accent, size: 24),
          ),
          SizedBox(height: tokens.space(14)),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: tokens.text,
            ),
          ),
          SizedBox(height: tokens.space(6)),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              height: 1.45,
              color: tokens.secondaryText,
            ),
          ),
          if (actionLabel != null && onAction != null) ...[
            SizedBox(height: tokens.space(16)),
            FilledButton(onPressed: onAction, child: Text(actionLabel!)),
          ],
        ],
      ),
    );
  }
}

/// Recoverable error state with clear message and optional retry button.
class ErrorState extends StatelessWidget {
  /// Creates an [ErrorState].
  const new({
    required this.message,
    super.key,
    this.title = 'Something went wrong',
    this.onRetry,
  });

  /// Short title.
  final String title;

  /// User-friendly error message.
  final String message;

  /// Optional retry callback.
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final tokens = context.lexTokens;

    return LexCard(
      padding: EdgeInsets.all(tokens.space(22)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: tokens.riskHigh.withValues(alpha: 0.14),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.error_outline_rounded,
              color: tokens.riskHigh,
              size: 24,
            ),
          ),
          SizedBox(height: tokens.space(12)),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: tokens.text,
            ),
          ),
          SizedBox(height: tokens.space(6)),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: tokens.secondaryText,
              height: 1.45,
            ),
          ),
          if (onRetry != null) ...[
            SizedBox(height: tokens.space(16)),
            FilledButton(onPressed: onRetry, child: const Text('Try again')),
          ],
        ],
      ),
    );
  }
}

/// Minimal rounded skeleton placeholder block for async loading states.
class LexSkeleton extends StatelessWidget {
  /// Creates a [LexSkeleton].
  const new({
    super.key,
    this.width = double.infinity,
    this.height = 14,
    this.borderRadius = 8,
  });

  /// Block width.
  final double width;

  /// Block height.
  final double height;

  /// Corner radius.
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final tokens = context.lexTokens;

    return Semantics(
      label: 'Loading',
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: tokens.neutralControlFill,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}
