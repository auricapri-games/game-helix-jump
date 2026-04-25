import 'package:flutter/material.dart';

import '../l10n/strings.dart';
import '../widgets/result_modal.dart';

enum LevelCompleteAction { next, home }

class LevelCompleteScreen extends StatelessWidget {
  const LevelCompleteScreen({required this.score, super.key});

  final int score;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Scaffold(
      body: ResultBody(
        title: s.levelComplete,
        scoreLabel: s.score,
        score: score,
        primary: ResultAction(
          label: s.next,
          icon: Icons.skip_next_rounded,
          onPressed: () =>
              Navigator.of(context).pop(LevelCompleteAction.next),
        ),
        secondary: ResultAction(
          label: s.backHome,
          icon: Icons.home_rounded,
          onPressed: () => Navigator.of(context).pop(LevelCompleteAction.home),
        ),
      ),
    );
  }
}
