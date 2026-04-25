import 'package:flutter/material.dart';

import '../ds/app_colors.dart';
import 'cta_button.dart';
import 'gradient_background.dart';
import 'screen_title.dart';
import 'secondary_button.dart';
import 'sprite_hero.dart';

@immutable
class ResultAction {
  const ResultAction({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final VoidCallback onPressed;
}

class ResultBody extends StatelessWidget {
  const ResultBody({
    required this.title,
    required this.scoreLabel,
    required this.score,
    required this.primary,
    required this.secondary,
    super.key,
  });

  final String title;
  final String scoreLabel;
  final int score;
  final ResultAction primary;
  final ResultAction secondary;

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        children: [
          const Spacer(),
          const SpriteHero(size: 160),
          const SizedBox(height: 16),
          ScreenTitle(text: title),
          const SizedBox(height: 12),
          _BigScore(label: scoreLabel, value: score),
          const Spacer(),
          CtaButton(
            label: primary.label,
            icon: primary.icon,
            onPressed: primary.onPressed,
          ),
          const SizedBox(height: 14),
          SecondaryButton(
            label: secondary.label,
            icon: secondary.icon,
            onPressed: secondary.onPressed,
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

class _BigScore extends StatelessWidget {
  const _BigScore({required this.label, required this.value});

  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            color: AppColors.accent,
            fontSize: 14,
            letterSpacing: 1.6,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '$value',
          style: const TextStyle(
            color: AppColors.secondary,
            fontSize: 64,
            fontWeight: FontWeight.w900,
            shadows: [
              Shadow(
                color: Color(0x99000000),
                offset: Offset(0, 6),
                blurRadius: 14,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
