import 'package:flutter/material.dart';
import 'package:lex_copilot/app/theme/lex_tokens.dart';

/// Grounding confidence level for an AI answer.
enum ConfidenceLevel {
  /// Verified directly against retrieved statutory text.
  high,

  /// Partially verified or context-dependent.
  medium,

  /// Limited grounding; verify with official text.
  low,
}

/// Pill badge displaying the AI answer's grounding confidence and optional
/// verified source count.
class ConfidenceBadge extends StatelessWidget {
  /// Creates a [ConfidenceBadge].
  const new({required this.level, super.key, this.sourceCount});

  /// Grounding confidence tier.
  final ConfidenceLevel level;

  /// Optional number of verified legal sources backing the response.
  final int? sourceCount;

  @override
  Widget build(BuildContext context) {
    final tokens = context.lexTokens;
    final (fg, bg, label) = switch (level) {
      ConfidenceLevel.high => (
        tokens.riskLow,
        tokens.riskLow.withValues(alpha: 0.14),
        'High confidence',
      ),
      ConfidenceLevel.medium => (
        tokens.accent,
        tokens.accentTint,
        'Medium confidence',
      ),
      ConfidenceLevel.low => (
        tokens.riskMedium,
        tokens.riskMedium.withValues(alpha: 0.14),
        'Low confidence',
      ),
    };

    return Wrap(
      spacing: 8,
      runSpacing: 6,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: fg,
            ),
          ),
        ),
        if (sourceCount != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: tokens.hairline),
            ),
            child: Text(
              sourceCount == 1 ? '1 source' : '$sourceCount sources',
              style: TextStyle(fontSize: 12, color: tokens.secondaryText),
            ),
          ),
      ],
    );
  }
}
