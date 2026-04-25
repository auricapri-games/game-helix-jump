import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../ds/app_colors.dart';

/// Big animated mascot — the ball sprite floating with a soft halo glow,
/// gentle bob animation, and shadow on a translucent platform underneath.
class SpriteHero extends StatefulWidget {
  const SpriteHero({super.key, this.size = 180});

  final double size;

  @override
  State<SpriteHero> createState() => _SpriteHeroState();
}

class _SpriteHeroState extends State<SpriteHero>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (context, _) => _HeroFrame(progress: _ctrl.value),
      ),
    );
  }
}

class _HeroFrame extends StatelessWidget {
  const _HeroFrame({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        const _Halo(),
        Transform.translate(
          offset: _Bob.offset(progress),
          child: const _BallImage(),
        ),
        const Positioned(
          bottom: 8,
          child: _GroundShadow(),
        ),
      ],
    );
  }
}

/// Helper to keep arithmetic out of any widget build() method.
class _Bob {
  static Offset offset(double t) {
    final v = math.sin(t * math.pi * 2) * 8;
    return Offset(0, v);
  }
}

class _Halo extends StatelessWidget {
  const _Halo();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      height: 220,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [Color(0x66FCBF49), Color(0x00000000)],
          stops: [0.0, 0.85],
        ),
      ),
    );
  }
}

class _BallImage extends StatelessWidget {
  const _BallImage();

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/sprites/ball.png',
      width: 130,
      height: 130,
      fit: BoxFit.contain,
    );
  }
}

class _GroundShadow extends StatelessWidget {
  const _GroundShadow();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      height: 18,
      decoration: const BoxDecoration(
        color: Color(0x55000000),
        borderRadius: BorderRadius.all(Radius.elliptical(60, 9)),
      ),
      child: const SizedBox.shrink(),
    );
  }
}

/// Simple wrapper used by error fallback if the asset bundle isn't ready.
class FallbackHero extends StatelessWidget {
  const FallbackHero({super.key});

  @override
  Widget build(BuildContext context) => const Icon(
        Icons.circle,
        size: 130,
        color: AppColors.secondary,
      );
}
