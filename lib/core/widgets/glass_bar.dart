import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lex_copilot/app/theme/lex_tokens.dart';

/// Floating liquid-glass bar using [RepaintBoundary] + [BackdropFilter] with a
/// translucent gradient, 1px hairline border, and subtle inner highlight.
class GlassBar extends StatelessWidget {
  /// Creates a [GlassBar].
  const new({
    required this.child,
    super.key,
    this.height,
    this.padding = const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
    this.borderRadius,
  });

  /// Content inside the glass bar.
  final Widget child;

  /// Optional fixed height.
  final double? height;

  /// Inner padding around [child].
  final EdgeInsetsGeometry padding;

  /// Optional border radius override (defaults to `tokens.pillRadius`).
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    final tokens = context.lexTokens;
    final radius = BorderRadius.circular(borderRadius ?? tokens.pillRadius);
    final sigma = tokens.blurSigma;

    final decorated = DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: radius,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            tokens.glassHighlight.withValues(
              alpha: tokens.brightness == Brightness.dark ? 0.14 : 0.85,
            ),
            tokens.glassFill,
          ],
        ),
        border: Border.all(color: tokens.hairline),
        boxShadow: [
          BoxShadow(
            color: tokens.glassShadow,
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: SizedBox(
        height: height,
        child: Padding(
          padding: padding,
          child: height == null ? child : Center(widthFactor: 1, child: child),
        ),
      ),
    );

    return RepaintBoundary(
      child: ClipRRect(
        borderRadius: radius,
        child: sigma > 0.5
            ? BackdropFilter(
                filter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
                child: decorated,
              )
            : decorated,
      ),
    );
  }
}
