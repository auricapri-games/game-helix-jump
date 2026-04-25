import 'package:flutter/material.dart';

import '../l10n/strings.dart';
import 'gradient_background.dart';
import 'screen_title.dart';
import 'sprite_hero.dart';
import 'tagline.dart';

class SplashBody extends StatelessWidget {
  const SplashBody({super.key});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return GradientBackground(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          const SpriteHero(size: 200),
          const SizedBox(height: 32),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeOut,
            builder: (_, value, child) =>
                Opacity(opacity: value, child: child),
            child: Column(
              children: [
                ScreenTitle(text: s.appTitle),
                const SizedBox(height: 12),
                Tagline(text: s.tagline),
              ],
            ),
          ),
          const Spacer(),
          const SizedBox(
            width: 28,
            height: 28,
            child: CircularProgressIndicator(strokeWidth: 2.6),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
