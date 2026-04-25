import 'package:flutter/material.dart';

import '../l10n/strings.dart';
import '../state/game_controller.dart';
import 'control_pad.dart';
import 'game_score_header.dart';
import 'gradient_background.dart';
import 'helix_view.dart';

class GameplayBody extends StatelessWidget {
  const GameplayBody({
    required this.controller,
    required this.onBack,
    super.key,
  });

  final HelixController controller;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return GradientBackground(
      child: AnimatedBuilder(
        animation: controller,
        builder: (_, __) => Column(
          children: [
            GameScoreHeader(
              phase: controller.state.phase,
              score: controller.state.score,
              onBack: onBack,
            ),
            const SizedBox(height: 12),
            const _ProgressLine(),
            const SizedBox(height: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: HelixView(state: controller.state),
              ),
            ),
            ControlPad(
              dropLabel: s.drop,
              onRotateLeft: () => controller.rotate(-1),
              onRotateRight: () => controller.rotate(1),
              onDrop: controller.drop,
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgressLine extends StatelessWidget {
  const _ProgressLine();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 4,
      child: ColoredBox(color: Color(0x33000000)),
    );
  }
}
