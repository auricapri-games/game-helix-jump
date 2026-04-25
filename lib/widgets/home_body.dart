import 'package:flutter/material.dart';

import '../l10n/strings.dart';
import '../state/best_score_store.dart';
import 'cta_button.dart';
import 'gradient_background.dart';
import 'help_card.dart';
import 'score_card.dart';
import 'screen_title.dart';
import 'secondary_button.dart';
import 'sprite_hero.dart';

@immutable
class HomeNavCallbacks {
  const HomeNavCallbacks({
    required this.onPlay,
    required this.onLevelSelect,
    required this.onSettings,
    required this.onRemoveAds,
    required this.onLegal,
  });

  final VoidCallback onPlay;
  final VoidCallback onLevelSelect;
  final VoidCallback onSettings;
  final VoidCallback onRemoveAds;
  final VoidCallback onLegal;
}

class HomeBody extends StatelessWidget {
  const HomeBody({
    required this.store,
    required this.callbacks,
    super.key,
  });

  final BestScoreStore store;
  final HomeNavCallbacks callbacks;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return GradientBackground(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(height: 8),
            ScreenTitle(text: s.appTitle),
            const SizedBox(height: 18),
            const SpriteHero(size: 170),
            const SizedBox(height: 22),
            AnimatedBuilder(
              animation: store,
              builder: (_, __) =>
                  ScoreCard(label: s.bestScore, value: '${store.value}'),
            ),
            const SizedBox(height: 18),
            CtaButton(
              key: const Key('home-play'),
              label: s.play,
              icon: Icons.play_arrow_rounded,
              onPressed: callbacks.onPlay,
            ),
            const SizedBox(height: 18),
            HelpCard(title: s.howToPlay, body: s.howToPlayBody),
            const SizedBox(height: 18),
            _SecondaryRow(callbacks: callbacks),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _SecondaryRow extends StatelessWidget {
  const _SecondaryRow({required this.callbacks});

  final HomeNavCallbacks callbacks;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 10,
      runSpacing: 10,
      children: [
        SecondaryButton(
          label: s.levelSelect,
          icon: Icons.grid_view_rounded,
          onPressed: callbacks.onLevelSelect,
        ),
        SecondaryButton(
          label: s.settings,
          icon: Icons.settings,
          onPressed: callbacks.onSettings,
        ),
        SecondaryButton(
          label: s.removeAds,
          icon: Icons.shield_outlined,
          onPressed: callbacks.onRemoveAds,
        ),
        SecondaryButton(
          label: s.legal,
          icon: Icons.gavel_outlined,
          onPressed: callbacks.onLegal,
        ),
      ],
    );
  }
}
