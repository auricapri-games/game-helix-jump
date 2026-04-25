import 'package:flutter/material.dart';

import '../core/game_state.dart';
import 'helix_painter.dart';

/// Visual representation of the active ring with the bouncing ball sprite
/// hovering above it. The painter does the work — this widget only sizes
/// and stacks.
class HelixView extends StatelessWidget {
  const HelixView({
    required this.state,
    super.key,
  });

  final HelixState state;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: HelixRingPainter(
                ring: state.activeRing,
                ballAngle: state.ballAngle,
                rotationProgress: 0,
              ),
            ),
          ),
          // Ball sprite stays at the centre — visually it represents the
          // ball about to drop into the well.
          const _BallSprite(),
        ],
      ),
    );
  }
}

class _BallSprite extends StatelessWidget {
  const _BallSprite();

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.92, end: 1.0),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOutBack,
      builder: (context, value, child) => Transform.scale(
        scale: value,
        child: child,
      ),
      child: Container(
        width: 56,
        height: 56,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Color(0x88000000),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Image.asset(
          'assets/sprites/ball.png',
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
