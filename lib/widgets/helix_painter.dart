import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../core/game_state.dart';
import '../ds/app_theme.dart';

/// Renders the helix tower from a slightly tilted top-down perspective:
/// a stack of flat discs (oval shapes, divided into pie segments) with a
/// vertical pole behind. The ball sits at the centre at a fixed screen Y.
///
/// Pure painter — no widget state, no gameplay logic. Reads only [discs],
/// [cameraY] and [towerRotation] from the immutable [HelixState].
class HelixTowerPainter extends CustomPainter {
  HelixTowerPainter({
    required this.discs,
    required this.cameraY,
    required this.towerRotation,
    required this.ballScreenFraction,
  });

  /// All currently active discs (world coordinates).
  final List<HelixDisc> discs;

  /// How far the ball has fallen — discs are drawn at
  /// `screenY = ballY + (disc.y - cameraY)`.
  final double cameraY;

  /// Tower rotation in radians, applied to every disc.
  final double towerRotation;

  /// Where the ball is on screen, as fraction of canvas height.
  /// 0.4 = roughly upper-third.
  final double ballScreenFraction;

  static const double _discWidth = 220;
  static const double _discHeight = 44;
  static const double _poleWidth = 24;

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final ballY = size.height * ballScreenFraction;

    // Vertical pole — drawn first (background layer).
    final poleRect = Rect.fromCenter(
      center: Offset(cx, size.height / 2),
      width: _poleWidth,
      height: size.height,
    );
    final polePaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          const Color(0xFF1C0E07),
          AppTheme.colorScheme.surfaceContainerHigh.withOpacity(0.8),
          const Color(0xFF1C0E07),
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(poleRect);
    canvas.drawRRect(
      RRect.fromRectAndRadius(poleRect, const Radius.circular(8)),
      polePaint,
    );

    final sorted = List<HelixDisc>.of(discs)
      ..sort((a, b) => a.y.compareTo(b.y));
    for (final disc in sorted) {
      final discScreenY = ballY + (disc.y - cameraY);
      if (discScreenY < -_discHeight) continue;
      if (discScreenY > size.height + _discHeight) continue;
      _paintDisc(canvas, cx, discScreenY, disc);
    }
  }

  void _paintDisc(Canvas canvas, double cx, double cy, HelixDisc disc) {
    final rect = Rect.fromCenter(
      center: Offset(cx, cy),
      width: _discWidth,
      height: _discHeight,
    );
    final shadowRect = rect.shift(const Offset(0, 8));
    canvas.drawOval(
      shadowRect,
      Paint()
        ..color = const Color(0x66000000)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
    );

    final n = disc.segments.length;
    final sweep = (math.pi * 2) / n;
    for (var i = 0; i < n; i++) {
      final start = i * sweep + towerRotation;
      final paint = Paint()..color = _segmentColor(disc.segments[i]);
      canvas.drawArc(rect, start, sweep, true, paint);
    }

    final bevelRect = rect.deflate(2);
    canvas.drawOval(
      bevelRect,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.6
        ..color = AppTheme.colorScheme.tertiary.withOpacity(0.55),
    );
    canvas.drawOval(
      rect,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0
        ..color = AppTheme.colorScheme.surface,
    );

    // Segment dividers — thin radial lines so the player can read slices.
    for (var i = 0; i < n; i++) {
      final a = i * sweep + towerRotation;
      final p1 = Offset(cx, cy);
      final p2 = Offset(
        cx + math.cos(a) * (_discWidth / 2),
        cy + math.sin(a) * (_discHeight / 2),
      );
      canvas.drawLine(
        p1,
        p2,
        Paint()
          ..color = AppTheme.colorScheme.surface.withOpacity(0.35)
          ..strokeWidth = 1.0,
      );
    }
  }

  Color _segmentColor(SegmentType t) {
    switch (t) {
      case SegmentType.safe:
        return AppTheme.colorScheme.primary;
      case SegmentType.deadly:
        return AppTheme.deadSegment;
    }
  }

  @override
  bool shouldRepaint(covariant HelixTowerPainter old) =>
      old.cameraY != cameraY ||
      old.towerRotation != towerRotation ||
      old.discs != discs ||
      old.ballScreenFraction != ballScreenFraction;
}
