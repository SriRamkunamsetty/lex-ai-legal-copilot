import 'package:flutter/material.dart';
import 'package:lex_copilot/app/theme/lex_tokens.dart';

/// Clause or contract risk severity level.
enum RiskLevel {
  /// High legal or financial exposure.
  high,

  /// Moderate exposure requiring attention.
  medium,

  /// Low or standard exposure.
  low,
}

/// Outlined pill badge showing High / Medium / Low risk matching the Contract
/// Review prototype.
class RiskPill extends StatelessWidget {
  /// Creates a [RiskPill].
  const new({required this.level, super.key, this.label});

  /// Risk severity level.
  final RiskLevel level;

  /// Optional custom text label (defaults to `High`, `Medium`, or `Low`).
  final String? label;

  @override
  Widget build(BuildContext context) {
    final tokens = context.lexTokens;
    final (color, defaultText) = switch (level) {
      RiskLevel.high => (tokens.riskHigh, 'High'),
      RiskLevel.medium => (tokens.riskMedium, 'Medium'),
      RiskLevel.low => (tokens.riskLow, 'Low'),
    };
    final text = label ?? defaultText;

    return Semantics(
      label: '$text risk',
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ),
    );
  }
}
