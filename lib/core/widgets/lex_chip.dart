import 'package:flutter/material.dart';
import 'package:lex_copilot/app/theme/lex_tokens.dart';

/// Tappable filter or quick-action pill chip with 48dp accessible target.
class LexChip extends StatelessWidget {
  /// Creates a [LexChip].
  const new({
    required this.label,
    super.key,
    this.selected = false,
    this.leading,
    this.onTap,
  });

  /// Visible label text.
  final String label;

  /// Whether the chip is in an active selected state.
  final bool selected;

  /// Optional leading icon or dot widget.
  final Widget? leading;

  /// Optional tap handler.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.lexTokens;
    final radius = BorderRadius.circular(tokens.chipRadius + 4);
    final bg = selected ? tokens.accent : tokens.surface;
    final fg = selected ? tokens.onAccent : tokens.text;

    return Semantics(
      button: onTap != null,
      selected: selected,
      label: label,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 40),
        child: Material(
          color: bg,
          shape: RoundedRectangleBorder(
            borderRadius: radius,
            side: BorderSide(color: selected ? tokens.accent : tokens.hairline),
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            borderRadius: radius,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: tokens.space(14),
                vertical: tokens.space(9),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (leading != null) ...[
                    IconTheme(
                      data: IconThemeData(size: 16, color: fg),
                      child: leading!,
                    ),
                    const SizedBox(width: 6),
                  ],
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                      color: fg,
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
}
