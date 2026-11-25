import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:lex_copilot/app/theme/lex_tokens.dart';

/// Circular arc progress ring displaying a 0-100 contract risk score.
class ScoreRing extends StatelessWidget {
  /// Creates a [ScoreRing].
  const new({
    required this.score,
    super.key,
    this.size = 92,
    this.strokeWidth = 9,
  });

  /// Score value clamped between `0` and `100`.
  final int score;

  /// Diameter of the ring.
  final double size;

  /// Thickness of the arc stroke.
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    final tokens = context.lexTokens;
    final clamped = score.clamp(0, 100);
    final color = clamped >= 75
        ? tokens.riskHigh
        : clamped >= 40
        ? tokens.riskMedium
        : tokens.riskLow;

    return Semantics(
      label: 'Risk score $clamped of 100',
      child: SizedBox(
        width: size,
        height: size,
        child: CustomPaint(
          painter: _ScoreRingPainter(
            progress: clamped / 100,
            trackColor: tokens.neutralControlFill,
            arcColor: color,
            strokeWidth: strokeWidth,
          ),
          child: Center(
            child: Text(
              '$clamped',
              style: TextStyle(
                fontSize: size * 0.28,
                fontWeight: FontWeight.w700,
                color: tokens.text,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ScoreRingPainter extends CustomPainter {
  const new({
    required this.progress,
    required this.trackColor,
    required this.arcColor,
    required this.strokeWidth,
  });

  final double progress;
  final Color trackColor;
  final Color arcColor;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = (size.shortestSide - strokeWidth) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final arcPaint = Paint()
      ..color = arcColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, trackPaint);
    if (progress > 0) {
      canvas.drawArc(
        rect,
        -math.pi / 2,
        2 * math.pi * progress,
        false,
        arcPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ScoreRingPainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.trackColor != trackColor ||
      oldDelegate.arcColor != arcColor ||
      oldDelegate.strokeWidth != strokeWidth;
}
