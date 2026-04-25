import 'package:flutter/material.dart';

import '../state/game_controller.dart';
import 'helix_painter.dart';

/// Side-view of the helix tower. Renders the painter beneath a fixed ball
/// sprite, and forwards horizontal drag gestures to the [HelixController]
/// to rotate the tower in real time.
class HelixView extends StatelessWidget {
  const HelixView({
    required this.controller,
    super.key,
  });

  final HelixController controller;

  static const double _ballScreenFraction = 0.28;
  static const double _pixelsToRadians = 0.012;

  @override
  Widget build(BuildContext context) {
    final state = controller.state;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onHorizontalDragUpdate: (details) {
        controller.addRotation(details.delta.dx * _pixelsToRadians);
      },
      onPanUpdate: (details) {
        // pan also accepts horizontal swipes — we mirror onHorizontalDragUpdate
        controller.addRotation(details.delta.dx * _pixelsToRadians);
      },
      child: LayoutBuilder(
        builder: (context, constraints) => Stack(
          alignment: Alignment.center,
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: HelixTowerPainter(
                  discs: state.discs,
                  cameraY: state.cameraY,
                  towerRotation: state.towerRotation,
                  ballScreenFraction: _ballScreenFraction,
                ),
              ),
            ),
            Positioned(
              top: constraints.maxHeight * _ballScreenFraction - 28,
              child: const _BallSprite(),
            ),
          ],
        ),
      ),
    );
  }
}

class _BallSprite extends StatelessWidget {
  const _BallSprite();

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.85, end: 1.0),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutBack,
      builder: (context, value, child) => Transform.scale(
        scale: value,
        child: child,
      ),
      child: SizedBox(
        width: 56,
        height: 56,
        child: DecoratedBox(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Color(0x66000000),
                blurRadius: 16,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: Image.asset(
            'assets/sprites/ball.png',
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
