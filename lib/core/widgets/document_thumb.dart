import 'package:flutter/material.dart';
import 'package:lex_copilot/app/theme/lex_tokens.dart';
import 'package:lex_copilot/core/widgets/lex_card.dart';

/// Compact thumbnail card representing a scanned or attached legal document.
class DocumentThumb extends StatelessWidget {
  /// Creates a [DocumentThumb].
  const new({
    required this.fileName,
    required this.subtitle,
    super.key,
    this.onTap,
  });

  /// Document filename (e.g. `Rent_Notice.jpg`).
  final String fileName;

  /// Metadata line (e.g. `2 pages · text read`).
  final String subtitle;

  /// Optional tap callback.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.lexTokens;

    return LexCard(
      onTap: onTap,
      padding: EdgeInsets.all(tokens.space(10)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 70,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: tokens.neutralControlFill,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _SkeletonBar(
                  color: tokens.secondaryText.withValues(alpha: 0.35),
                  widthFactor: 1,
                ),
                _SkeletonBar(
                  color: tokens.secondaryText.withValues(alpha: 0.35),
                  widthFactor: 0.7,
                ),
                _SkeletonBar(
                  color: tokens.secondaryText.withValues(alpha: 0.35),
                  widthFactor: 1,
                ),
                _SkeletonBar(
                  color: tokens.secondaryText.withValues(alpha: 0.35),
                  widthFactor: 0.8,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  fileName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: tokens.text,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12, color: tokens.secondaryText),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SkeletonBar extends StatelessWidget {
  const new({required this.color, required this.widthFactor});

  final Color color;
  final double widthFactor;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: widthFactor,
      child: Container(
        height: 5,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(3),
        ),
      ),
    );
  }
}
