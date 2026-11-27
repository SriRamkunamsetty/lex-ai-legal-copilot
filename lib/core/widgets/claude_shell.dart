import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lex_copilot/app/theme/lex_tokens.dart';

/// Destination metadata for [ClaudeBottomNavBar].
@immutable
class ClaudeNavItem {
  /// Creates a [ClaudeNavItem].
  const new({required this.kind, required this.label});

  /// Custom vector emblem style (`home`, `scan`, `ask`, `library`).
  final ClaudeNavIconKind kind;

  /// Accessibility & tooltip label.
  final String label;
}

/// Icon variants drawn cleanly via custom vector painters.
enum ClaudeNavIconKind {
  /// Clean architectural home/desk glyph.
  home,

  /// Modern rounded document-scanner viewfinder glyph.
  scan,

  /// Claude-style overlapping speech bubbles glyph.
  ask,

  /// Layered staggered statute cards glyph.
  library,
}

/// Provides bottom clearance height below content when hosted inside [ClaudeShellScaffold].
class ClaudeBottomBarInset extends InheritedWidget {
  /// Creates a [ClaudeBottomBarInset].
  const new({required this.inset, required super.child, super.key});

  /// Pixels reserved for the overlaid gradient-blur navigation bar.
  final double inset;

  /// Returns active inset or `0.0` outside [ClaudeShellScaffold].
  static double of(BuildContext context) =>
      context
          .dependOnInheritedWidgetOfExactType<ClaudeBottomBarInset>()
          ?.inset ??
      0.0;

  @override
  bool updateShouldNotify(ClaudeBottomBarInset oldWidget) =>
      inset != oldWidget.inset;
}

/// Claude-inspired warm-bone shell featuring:
/// - Liquid-smooth animated surface transitions when switching Light/Dark mode
/// - Warm outer top chrome with menu button & joined search/private toggle
/// - Continuous edge-to-edge rounded content sheet with seamless bottom nav bar
class ClaudeShellScaffold extends StatelessWidget {
  /// Creates a [ClaudeShellScaffold].
  const new({
    required this.currentIndex,
    required this.onSelectTab,
    required this.onOpenMenu,
    required this.onSearchTap,
    required this.onPrivateModeToggle,
    required this.isPrivateMode,
    required this.body,
    super.key,
  });

  /// Active branch index (`0: Home`, `1: Scan`, `2: Ask`, `3: Library`).
  final int currentIndex;

  /// Callback when a bottom nav destination is tapped.
  final ValueChanged<int> onSelectTab;

  /// Opens the slide-up Lex workspace menu drawer/sheet.
  final VoidCallback onOpenMenu;

  /// Navigates to search/library lookup.
  final VoidCallback onSearchTap;

  /// Toggles on-device local-only private mode.
  final VoidCallback onPrivateModeToggle;

  /// Whether local-only private mode is active.
  final bool isPrivateMode;

  /// Tab body rendered inside the rounded sheet.
  final Widget body;

  @override
  Widget build(BuildContext context) {
    final tokens = context.lexTokens;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final disableAnim = MediaQuery.disableAnimationsOf(context);
    final animDuration = disableAnim
        ? Duration.zero
        : const Duration(milliseconds: 320);
    final outerBg = isDark ? const Color(0xFF121211) : const Color(0xFFF3F1EC);
    final sheetBg = isDark ? const Color(0xFF1B1A19) : const Color(0xFFFAFAF8);
    final controlBg = isDark
        ? const Color(0xFF242321)
        : const Color(0xFFFFFFFF);
    final controlBorder = isDark
        ? const Color(0xFF33312E)
        : const Color(0xFFE7E4DE);
    final navInset = 64.0 + MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: outerBg,
      body: AnimatedContainer(
        duration: animDuration,
        curve: Curves.easeInOutCubicEmphasized,
        color: outerBg,
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 6, 16, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _CircleActionButton(
                      tooltip: 'Open Lex menu',
                      backgroundColor: controlBg,
                      borderColor: controlBorder,
                      animDuration: animDuration,
                      onTap: () {
                        unawaited(HapticFeedback.selectionClick());
                        onOpenMenu();
                      },
                      child: CustomPaint(
                        size: const Size(18, 12),
                        painter: _ClaudeMenuIconPainter(tokens.text),
                      ),
                    ),
                    AnimatedContainer(
                      duration: animDuration,
                      curve: Curves.easeInOutCubicEmphasized,
                      height: 44,
                      decoration: BoxDecoration(
                        color: controlBg,
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(color: controlBorder),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            tooltip: 'Search statutes & saved items',
                            onPressed: () {
                              unawaited(HapticFeedback.selectionClick());
                              onSearchTap();
                            },
                            icon: Icon(
                              Icons.search_rounded,
                              size: 21,
                              color: tokens.text,
                            ),
                          ),
                          Container(width: 1, height: 20, color: controlBorder),
                          IconButton(
                            tooltip: isPrivateMode
                                ? 'Local-only private mode on'
                                : 'Enable local-only private mode',
                            onPressed: () {
                              unawaited(HapticFeedback.selectionClick());
                              onPrivateModeToggle();
                            },
                            icon: CustomPaint(
                              size: const Size(19, 19),
                              painter: _IncognitoBadgePainter(
                                color: isPrivateMode
                                    ? const Color(0xFFD97757)
                                    : tokens.text,
                                filled: isPrivateMode,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: AnimatedContainer(
                  duration: animDuration,
                  curve: Curves.easeInOutCubicEmphasized,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: sheetBg,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(28),
                    ),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      ClaudeBottomBarInset(
                        inset: navInset,
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            if (constraints.maxWidth < 840) {
                              return body;
                            }
                            return Center(
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(
                                  maxWidth: 920,
                                ),
                                child: body,
                              ),
                            );
                          },
                        ),
                      ),
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: ClipRect(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  stops: const [0.0, 0.34, 1.0],
                                  colors: [
                                    sheetBg.withValues(alpha: 0),
                                    sheetBg.withValues(alpha: 0.80),
                                    sheetBg.withValues(alpha: 0.98),
                                  ],
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 18),
                                child: ClaudeBottomNavBar(
                                  currentIndex: currentIndex,
                                  onSelected: (index) {
                                    unawaited(HapticFeedback.selectionClick());
                                    onSelectTab(index);
                                  },
                                  outerBackground: Colors.transparent,
                                  surfaceCutout: sheetBg,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Edge-to-edge 4-icon navigation bar with sculpted custom vector icons.
class ClaudeBottomNavBar extends StatelessWidget {
  /// Creates a [ClaudeBottomNavBar].
  const new({
    required this.currentIndex,
    required this.onSelected,
    required this.outerBackground,
    this.surfaceCutout,
    super.key,
  });

  /// Active destination index.
  final int currentIndex;

  /// Callback triggered when an icon is tapped.
  final ValueChanged<int> onSelected;

  /// Continuous outer sheet background colour (zero seam).
  final Color outerBackground;

  /// Cutout background used for dual-layer active/inactive icons.
  final Color? surfaceCutout;

  /// Canonical 4 navigation tabs preserving GoRouter branch order.
  static const List<ClaudeNavItem> destinations = [
    ClaudeNavItem(kind: ClaudeNavIconKind.home, label: 'Home'),
    ClaudeNavItem(kind: ClaudeNavIconKind.scan, label: 'Scan'),
    ClaudeNavItem(kind: ClaudeNavIconKind.ask, label: 'Ask'),
    ClaudeNavItem(kind: ClaudeNavIconKind.library, label: 'Library'),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final disableAnim = MediaQuery.disableAnimationsOf(context);
    final activePill = isDark
        ? const Color(0xFF2B2A27)
        : const Color(0xFFEBE8E2);
    final activeIcon = isDark
        ? const Color(0xFFF5F3EE)
        : const Color(0xFF181715);
    final inactiveIcon = isDark
        ? const Color(0xFF8C8982)
        : const Color(0xFF72706A);

    return ColoredBox(
      color: outerBackground,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          16,
          6,
          16,
          10 + MediaQuery.paddingOf(context).bottom,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            for (var i = 0; i < destinations.length; i++)
              Semantics(
                button: true,
                selected: i == currentIndex,
                label: destinations[i].label,
                child: Tooltip(
                  message: destinations[i].label,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => onSelected(i),
                    child: AnimatedContainer(
                      duration: disableAnim
                          ? Duration.zero
                          : const Duration(milliseconds: 220),
                      curve: Curves.easeOutCubic,
                      width: 68,
                      height: 40,
                      decoration: BoxDecoration(
                        color: i == currentIndex
                            ? activePill
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: AnimatedScale(
                          duration: disableAnim
                              ? Duration.zero
                              : const Duration(milliseconds: 180),
                          curve: Curves.easeOutBack,
                          scale: i == currentIndex ? 1.06 : 1.0,
                          child: CustomPaint(
                            size: const Size(22, 22),
                            painter: _ClaudeNavVectorPainter(
                              kind: destinations[i].kind,
                              active: i == currentIndex,
                              color: i == currentIndex
                                  ? activeIcon
                                  : inactiveIcon,
                              surfaceCutout: i == currentIndex
                                  ? activePill
                                  : (surfaceCutout ?? outerBackground),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ClaudeNavVectorPainter extends CustomPainter {
  const new({
    required this.kind,
    required this.active,
    required this.color,
    required this.surfaceCutout,
  });

  final ClaudeNavIconKind kind;
  final bool active;
  final Color color;
  final Color surfaceCutout;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.7
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final fill = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    switch (kind) {
      case ClaudeNavIconKind.home:
        final roof = Path()
          ..moveTo(w * 0.14, h * 0.44)
          ..lineTo(w * 0.50, h * 0.14)
          ..lineTo(w * 0.86, h * 0.44)
          ..lineTo(w * 0.82, h * 0.48)
          ..lineTo(w * 0.82, h * 0.82)
          ..quadraticBezierTo(w * 0.82, h * 0.88, w * 0.74, h * 0.88)
          ..lineTo(w * 0.26, h * 0.88)
          ..quadraticBezierTo(w * 0.18, h * 0.88, w * 0.18, h * 0.82)
          ..lineTo(w * 0.18, h * 0.48)
          ..close();
        if (active) {
          canvas
            ..drawPath(roof, fill)
            ..drawRRect(
              RRect.fromRectAndRadius(
                Rect.fromLTWH(w * 0.40, h * 0.56, w * 0.20, h * 0.32),
                const Radius.circular(3),
              ),
              Paint()..color = surfaceCutout,
            );
        } else {
          canvas
            ..drawPath(roof, stroke)
            ..drawLine(
              Offset(w * 0.42, h * 0.68),
              Offset(w * 0.58, h * 0.68),
              stroke,
            );
        }
      case ClaudeNavIconKind.scan:
        final outerDoc = RRect.fromRectAndRadius(
          Rect.fromLTWH(w * 0.18, h * 0.14, w * 0.64, h * 0.74),
          const Radius.circular(4.5),
        );
        if (active) {
          final cut = Paint()
            ..color = surfaceCutout
            ..strokeWidth = 1.8
            ..strokeCap = StrokeCap.round;
          canvas
            ..drawRRect(outerDoc, fill)
            ..drawLine(
              Offset(w * 0.34, h * 0.38),
              Offset(w * 0.66, h * 0.38),
              cut,
            )
            ..drawLine(
              Offset(w * 0.34, h * 0.54),
              Offset(w * 0.66, h * 0.54),
              cut,
            )
            ..drawLine(
              Offset(w * 0.34, h * 0.70),
              Offset(w * 0.54, h * 0.70),
              cut,
            );
        } else {
          canvas
            ..drawRRect(outerDoc, stroke)
            ..drawLine(
              Offset(w * 0.34, h * 0.38),
              Offset(w * 0.66, h * 0.38),
              stroke,
            )
            ..drawLine(
              Offset(w * 0.34, h * 0.54),
              Offset(w * 0.66, h * 0.54),
              stroke,
            )
            ..drawLine(
              Offset(w * 0.34, h * 0.70),
              Offset(w * 0.52, h * 0.70),
              stroke,
            );
        }
      case ClaudeNavIconKind.ask:
        // Overlapping dual editorial speech bubbles matching the Claude screenshot
        final back = RRect.fromRectAndRadius(
          Rect.fromLTWH(w * 0.12, h * 0.16, w * 0.56, h * 0.42),
          const Radius.circular(8),
        );
        final front = RRect.fromRectAndRadius(
          Rect.fromLTWH(w * 0.34, h * 0.40, w * 0.54, h * 0.40),
          const Radius.circular(8),
        );
        final backTail = Path()
          ..moveTo(w * 0.22, h * 0.56)
          ..lineTo(w * 0.14, h * 0.68)
          ..lineTo(w * 0.34, h * 0.58)
          ..close();
        final frontTail = Path()
          ..moveTo(w * 0.70, h * 0.78)
          ..lineTo(w * 0.84, h * 0.88)
          ..lineTo(w * 0.78, h * 0.72)
          ..close();
        if (active) {
          canvas
            ..drawRRect(back, fill)
            ..drawPath(backTail, fill)
            ..drawRRect(front.inflate(1.5), Paint()..color = surfaceCutout)
            ..drawRRect(front, fill)
            ..drawPath(frontTail, fill);
        } else {
          canvas
            ..drawRRect(back, stroke)
            ..drawRRect(front, Paint()..color = surfaceCutout)
            ..drawRRect(front, stroke);
        }
      case ClaudeNavIconKind.library:
        // Sleek layered staggered statute cards
        final backCard = RRect.fromRectAndRadius(
          Rect.fromLTWH(w * 0.32, h * 0.14, w * 0.50, h * 0.62),
          const Radius.circular(4),
        );
        final frontCard = RRect.fromRectAndRadius(
          Rect.fromLTWH(w * 0.18, h * 0.24, w * 0.50, h * 0.62),
          const Radius.circular(4),
        );
        if (active) {
          canvas
            ..drawRRect(
              backCard,
              Paint()..color = color.withValues(alpha: 0.45),
            )
            ..drawRRect(frontCard.inflate(1.2), Paint()..color = surfaceCutout)
            ..drawRRect(frontCard, fill);
        } else {
          canvas
            ..drawRRect(backCard, stroke)
            ..drawRRect(frontCard, Paint()..color = surfaceCutout)
            ..drawRRect(frontCard, stroke);
        }
    }
  }

  @override
  bool shouldRepaint(covariant _ClaudeNavVectorPainter oldDelegate) =>
      oldDelegate.kind != kind ||
      oldDelegate.active != active ||
      oldDelegate.color != color ||
      oldDelegate.surfaceCutout != surfaceCutout;
}

class _CircleActionButton extends StatelessWidget {
  const new({
    required this.tooltip,
    required this.backgroundColor,
    required this.borderColor,
    required this.animDuration,
    required this.onTap,
    required this.child,
  });

  final String tooltip;
  final Color backgroundColor;
  final Color borderColor;
  final Duration animDuration;
  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: AnimatedContainer(
            duration: animDuration,
            curve: Curves.easeInOutCubicEmphasized,
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: backgroundColor,
              shape: BoxShape.circle,
              border: Border.all(color: borderColor),
            ),
            child: Center(child: child),
          ),
        ),
      ),
    );
  }
}

class _ClaudeMenuIconPainter extends CustomPainter {
  const new(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;
    canvas
      ..drawLine(
        Offset(0, size.height * 0.28),
        Offset(size.width, size.height * 0.28),
        paint,
      )
      ..drawLine(
        Offset(0, size.height * 0.78),
        Offset(size.width * 0.62, size.height * 0.78),
        paint,
      );
  }

  @override
  bool shouldRepaint(covariant _ClaudeMenuIconPainter oldDelegate) =>
      oldDelegate.color != color;
}

class _IncognitoBadgePainter extends CustomPainter {
  const new({required this.color, required this.filled});

  final Color color;
  final bool filled;

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = Paint()
      ..color = color
      ..style = filled ? PaintingStyle.fill : PaintingStyle.stroke
      ..strokeWidth = 1.7
      ..strokeJoin = StrokeJoin.round;

    final path = Path()
      ..moveTo(size.width * 0.2, size.height * 0.85)
      ..lineTo(size.width * 0.2, size.height * 0.42)
      ..arcToPoint(
        Offset(size.width * 0.8, size.height * 0.42),
        radius: Radius.circular(size.width * 0.3),
      )
      ..lineTo(size.width * 0.8, size.height * 0.85)
      ..lineTo(size.width * 0.65, size.height * 0.72)
      ..lineTo(size.width * 0.5, size.height * 0.85)
      ..lineTo(size.width * 0.35, size.height * 0.72)
      ..close();
    final eyePaint = Paint()
      ..color = filled ? Colors.white : color
      ..style = PaintingStyle.fill;
    canvas
      ..drawPath(path, stroke)
      ..drawCircle(
        Offset(size.width * 0.39, size.height * 0.46),
        size.width * 0.06,
        eyePaint,
      )
      ..drawCircle(
        Offset(size.width * 0.61, size.height * 0.46),
        size.width * 0.06,
        eyePaint,
      );
  }

  @override
  bool shouldRepaint(covariant _IncognitoBadgePainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.filled != filled;
}
