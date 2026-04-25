import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../core/game_state.dart';
import '../ds/app_theme.dart';

/// Renders a top-down view of the active helix ring as colored arc slices,
/// plus a needle showing where the ball will drop. Pure painting — no
/// arithmetic ever leaves this file (that's why it's a CustomPainter, not
/// a Widget build()).
class HelixRingPainter extends CustomPainter {
  HelixRingPainter({
    required this.ring,
    required this.ballAngle,
    required this.rotationProgress,
  });

  final HelixRing ring;
  final int ballAngle;
  final double rotationProgress;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final outerR = math.min(size.width, size.height) / 2 - 6;
    final innerR = outerR * 0.55;

    final n = ring.segments.length;
    final sweep = (math.pi * 2) / n;
    final ballSweepCenter = ballAngle * sweep + sweep / 2 + rotationProgress;

    // background ring shadow
    canvas.drawCircle(
      center.translate(0, 6),
      outerR,
      Paint()
        ..color = const Color(0x66000000)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
    );

    for (var i = 0; i < n; i++) {
      final start = i * sweep + rotationProgress - math.pi / 2;
      final color = _segmentColor(ring.segments[i]);
      final edgeColor = _segmentEdge(ring.segments[i]);
      final path = Path()
        ..moveTo(
          center.dx + innerR * math.cos(start),
          center.dy + innerR * math.sin(start),
        )
        ..lineTo(
          center.dx + outerR * math.cos(start),
          center.dy + outerR * math.sin(start),
        )
        ..arcTo(
          Rect.fromCircle(center: center, radius: outerR),
          start,
          sweep,
          false,
        )
        ..lineTo(
          center.dx + innerR * math.cos(start + sweep),
          center.dy + innerR * math.sin(start + sweep),
        )
        ..arcTo(
          Rect.fromCircle(center: center, radius: innerR),
          start + sweep,
          -sweep,
          false,
        )
        ..close();
      canvas.drawPath(path, Paint()..color = color);
      canvas.drawPath(
        path,
        Paint()
          ..color = edgeColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.0,
      );
    }

    // central well (where ball drops through)
    canvas.drawCircle(
      center,
      innerR - 4,
      Paint()..color = const Color(0xFF1F0E07),
    );
    canvas.drawCircle(
      center,
      innerR - 4,
      Paint()
        ..color = AppTheme.colorScheme.secondary
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );

    // pointer arrow showing the ball's drop slot
    final arrowR = innerR - 8;
    final arrowAngle = ballSweepCenter - math.pi / 2;
    final tip = Offset(
      center.dx + arrowR * math.cos(arrowAngle),
      center.dy + arrowR * math.sin(arrowAngle),
    );
    final left = Offset(
      center.dx + (arrowR - 12) * math.cos(arrowAngle - 0.3),
      center.dy + (arrowR - 12) * math.sin(arrowAngle - 0.3),
    );
    final right = Offset(
      center.dx + (arrowR - 12) * math.cos(arrowAngle + 0.3),
      center.dy + (arrowR - 12) * math.sin(arrowAngle + 0.3),
    );
    final arrowPath = Path()
      ..moveTo(tip.dx, tip.dy)
      ..lineTo(left.dx, left.dy)
      ..lineTo(right.dx, right.dy)
      ..close();
    canvas.drawPath(
      arrowPath,
      Paint()..color = AppTheme.colorScheme.secondary,
    );
  }

  Color _segmentColor(SegmentType t) {
    switch (t) {
      case SegmentType.safe:
        return AppTheme.safeSegment;
      case SegmentType.dead:
        return AppTheme.deadSegment;
      case SegmentType.gap:
        return AppTheme.gapSegment;
    }
  }

  Color _segmentEdge(SegmentType t) {
    switch (t) {
      case SegmentType.safe:
        return AppTheme.safeSegmentEdge;
      case SegmentType.dead:
        return AppTheme.deadSegmentEdge;
      case SegmentType.gap:
        return AppTheme.colorScheme.outline;
    }
  }

  @override
  bool shouldRepaint(covariant HelixRingPainter old) =>
      old.ring != ring ||
      old.ballAngle != ballAngle ||
      old.rotationProgress != rotationProgress;
}
