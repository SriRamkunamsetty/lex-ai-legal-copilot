import 'package:flutter/material.dart';
import 'package:lex_copilot/app/theme/lex_tokens.dart';

/// Flat, clean content card with 1px hairline border matching the prototype.
class LexCard extends StatelessWidget {
  /// Creates a [LexCard].
  const new({
    required this.child,
    super.key,
    this.padding,
    this.borderRadius,
    this.backgroundColor,
    this.onTap,
  });

  /// Card child widget.
  final Widget child;

  /// Optional padding override (defaults to density-scaled 16).
  final EdgeInsetsGeometry? padding;

  /// Optional corner radius override (defaults to `tokens.cardRadius`).
  final double? borderRadius;

  /// Optional background colour override (defaults to `tokens.surface`).
  final Color? backgroundColor;

  /// Optional tap callback.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.lexTokens;
    final radius = BorderRadius.circular(borderRadius ?? tokens.cardRadius);
    final effectivePadding =
        padding ??
        EdgeInsets.symmetric(
          horizontal: tokens.space(16),
          vertical: tokens.space(14),
        );

    return Material(
      color: backgroundColor ?? tokens.surface,
      shape: RoundedRectangleBorder(
        borderRadius: radius,
        side: BorderSide(color: tokens.hairline),
      ),
      clipBehavior: Clip.antiAlias,
      child: onTap == null
          ? Padding(padding: effectivePadding, child: child)
          : InkWell(
              onTap: onTap,
              borderRadius: radius,
              child: Padding(padding: effectivePadding, child: child),
            ),
    );
  }
}
