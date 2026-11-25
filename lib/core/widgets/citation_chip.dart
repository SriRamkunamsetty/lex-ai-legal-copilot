import 'package:flutter/material.dart';
import 'package:lex_copilot/app/theme/lex_tokens.dart';

/// Tappable statutory citation badge (e.g. `BNS 304`) that opens the Section
/// Reader when tapped.
class CitationChip extends StatelessWidget {
  /// Creates a [CitationChip].
  const new({
    required this.citation,
    super.key,
    this.onTap,
    this.verified = true,
  });

  /// Citation text such as `BNS 304` or `BNSS 173`.
  final String citation;

  /// Optional tap callback to open the corresponding section.
  final VoidCallback? onTap;

  /// Whether the citation passed corpus verification.
  final bool verified;

  @override
  Widget build(BuildContext context) {
    final tokens = context.lexTokens;
    final fg = verified ? tokens.accent : tokens.riskMedium;
    final bg = verified
        ? tokens.accentTint
        : tokens.riskMedium.withValues(alpha: 0.14);

    return Semantics(
      button: onTap != null,
      label: 'Open citation $citation',
      child: Material(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!verified) ...[
                  Icon(Icons.warning_amber_rounded, size: 13, color: fg),
                  const SizedBox(width: 4),
                ],
                Text(
                  citation,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: fg,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
