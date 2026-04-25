import 'package:flutter/material.dart';

import '../l10n/strings.dart';
import '../widgets/result_modal.dart';

enum GameOverAction { retry, home }

class GameOverScreen extends StatelessWidget {
  const GameOverScreen({required this.score, super.key});

  final int score;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Scaffold(
      body: ResultBody(
        title: s.gameOver,
        scoreLabel: s.score,
        score: score,
        primary: ResultAction(
          label: s.retry,
          icon: Icons.refresh,
          onPressed: () =>
              Navigator.of(context).pop(GameOverAction.retry),
        ),
        secondary: ResultAction(
          label: s.backHome,
          icon: Icons.home_rounded,
          onPressed: () => Navigator.of(context).pop(GameOverAction.home),
        ),
      ),
    );
  }
}
