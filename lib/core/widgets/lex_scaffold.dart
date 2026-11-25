import 'package:flutter/material.dart';
import 'package:lex_copilot/app/theme/lex_tokens.dart';

/// Root scaffold for Lex screens with the signature subtle top accent glow,
/// safe-area padding, optional pinned bottom overlay (such as LexNavBar or
/// a floating composer), and reduce-motion aware transitions.
class LexScaffold extends StatelessWidget {
  /// Creates a [LexScaffold].
  const new({
    required this.body,
    super.key,
    this.appBar,
    this.bottomOverlay,
    this.showTopGlow = true,
  });

  /// Main scrollable or static screen body.
  final Widget body;

  /// Optional top bar placed inside the safe area.
  final PreferredSizeWidget? appBar;

  /// Optional floating bottom bar or composer aligned above bottom safe area.
  final Widget? bottomOverlay;

  /// Whether to render the top radial accent wash from the prototype.
  final bool showTopGlow;

  @override
  Widget build(BuildContext context) {
    final tokens = context.lexTokens;

    return Scaffold(
      backgroundColor: tokens.background,
      appBar: appBar,
      body: Stack(
        fit: StackFit.expand,
        children: [
          if (showTopGlow)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 270,
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment.topCenter,
                      radius: 1.05,
                      colors: [
                        tokens.accentTint,
                        tokens.background.withValues(alpha: 0),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          SafeArea(bottom: bottomOverlay == null, child: body),
          if (bottomOverlay != null)
            Positioned(
              left: 16,
              right: 16,
              bottom: 16 + MediaQuery.paddingOf(context).bottom,
              child: bottomOverlay!,
            ),
        ],
      ),
    );
  }
}
