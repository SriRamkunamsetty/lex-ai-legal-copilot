import 'package:flutter/material.dart';
import 'package:lex_copilot/app/theme/lex_tokens.dart';
import 'package:lex_copilot/core/widgets/citation_chip.dart';
import 'package:lex_copilot/core/widgets/lex_card.dart';

/// List tile presenting a statutory section with a [CitationChip], title,
/// plain-language summary, and disclosure chevron.
class SectionTile extends StatelessWidget {
  /// Creates a [SectionTile].
  const new({
    required this.citation,
    required this.title,
    required this.summary,
    super.key,
    this.onTap,
  });

  /// Statutory identifier badge (e.g. `BNS 304`).
  final String citation;

  /// Section title (e.g. `Snatching`).
  final String title;

  /// Plain-language summary or punishment preview.
  final String summary;

  /// Callback when the tile is tapped.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.lexTokens;

    return LexCard(
      onTap: onTap,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CitationChip(citation: citation),
                SizedBox(height: tokens.space(8)),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: tokens.text,
                  ),
                ),
                SizedBox(height: tokens.space(3)),
                Text(
                  summary,
                  style: TextStyle(
                    fontSize: 13,
                    color: tokens.secondaryText,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Icon(
            Icons.chevron_right_rounded,
            color: tokens.secondaryText,
            semanticLabel: 'Open section',
          ),
        ],
      ),
    );
  }
}
