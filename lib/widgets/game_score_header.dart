import 'package:flutter/material.dart';

import '../ds/app_colors.dart';
import '../l10n/strings.dart';
import 'score_card.dart';

class GameScoreHeader extends StatelessWidget {
  const GameScoreHeader({
    required this.phase,
    required this.score,
    required this.onBack,
    super.key,
  });

  final int phase;
  final int score;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.close, color: AppColors.text, size: 28),
            onPressed: onBack,
          ),
          const Spacer(),
          ScoreCard(label: s.phase, value: '$phase'),
          const SizedBox(width: 12),
          ScoreCard(
            key: const Key('score-card'),
            label: s.score,
            value: '$score',
          ),
          const Spacer(),
          const SizedBox(width: 40),
        ],
      ),
    );
  }
}
