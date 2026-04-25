import 'package:flutter/material.dart';

import '../ds/app_colors.dart';
import '../l10n/strings.dart';
import 'cta_button.dart';
import 'gradient_background.dart';
import 'screen_header.dart';
import 'sprite_hero.dart';

class RemoveAdsBody extends StatelessWidget {
  const RemoveAdsBody({required this.onBack, super.key});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return GradientBackground(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        children: [
          ScreenHeader(title: s.removeAds, onBack: onBack),
          const Spacer(),
          const SpriteHero(size: 140),
          const SizedBox(height: 24),
          Text(
            s.removeAdsBody,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.text,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              height: 1.4,
            ),
          ),
          const Spacer(),
          CtaButton(
            label: s.removeAdsCta,
            icon: Icons.shield_outlined,
            onPressed: null,
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
