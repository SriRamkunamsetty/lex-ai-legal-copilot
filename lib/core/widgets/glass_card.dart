import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lex_copilot/app/theme/lex_tokens.dart';

/// Translucent liquid-glass card reserved for floating overlays and badges.
///
/// Wrapped in [RepaintBoundary] for 60fps scrolling performance.
class GlassCard extends StatelessWidget {
  /// Creates a [GlassCard].
  const new({
    required this.child,
    super.key,
    this.padding,
    this.borderRadius,
    this.onTap,
  });

  /// Content inside the card.
  final Widget child;

  /// Optional inner padding (defaults to density-scaled 16).
  final EdgeInsetsGeometry? padding;

  /// Optional corner radius override (defaults to `tokens.cardRadius`).
  final double? borderRadius;

  /// Optional tap callback.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.lexTokens;
    final radius = BorderRadius.circular(borderRadius ?? tokens.cardRadius);
    final effectivePadding = padding ?? EdgeInsets.all(tokens.space(16));
    final sigma = tokens.blurSigma;

    final inner = Container(
      padding: effectivePadding,
      decoration: BoxDecoration(
        borderRadius: radius,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [tokens.glassFill, tokens.glassFill.withValues(alpha: 0.85)],
        ),
        border: Border.all(color: tokens.hairline),
        boxShadow: [
          BoxShadow(
            color: tokens.glassShadow,
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );

    final blurred = sigma > 0.5
        ? BackdropFilter(
            filter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
            child: inner,
          )
        : inner;

    return RepaintBoundary(
      child: ClipRRect(
        borderRadius: radius,
        child: onTap == null
            ? blurred
            : Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: radius,
                  onTap: onTap,
                  child: blurred,
                ),
              ),
      ),
    );
  }
}
