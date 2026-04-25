import 'package:flutter/material.dart';

import '../l10n/strings.dart';
import '../state/game_controller.dart';
import 'game_score_header.dart';
import 'gradient_background.dart';
import 'helix_view.dart';
import 'help_card.dart';

/// Layout of the Gameplay screen: score header on top, the helix tower
/// occupying the rest of the screen, and a one-time "drag to rotate"
/// hint that fades after the player's first input.
class GameplayBody extends StatefulWidget {
  const GameplayBody({
    required this.controller,
    required this.onBack,
    super.key,
  });

  final HelixController controller;
  final VoidCallback onBack;

  @override
  State<GameplayBody> createState() => _GameplayBodyState();
}

class _GameplayBodyState extends State<GameplayBody> {
  bool _hintVisible = true;
  double _lastRotation = 0;

  @override
  void initState() {
    super.initState();
    _lastRotation = widget.controller.state.towerRotation;
    widget.controller.addListener(_maybeHideHint);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_maybeHideHint);
    super.dispose();
  }

  void _maybeHideHint() {
    if (!_hintVisible) return;
    final r = widget.controller.state.towerRotation;
    if ((r - _lastRotation).abs() > 0.05) {
      setState(() => _hintVisible = false);
    }
    _lastRotation = r;
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return GradientBackground(
      child: AnimatedBuilder(
        animation: widget.controller,
        builder: (_, __) => Column(
          children: [
            GameScoreHeader(
              phase: widget.controller.state.phase,
              score: widget.controller.state.score,
              onBack: widget.onBack,
            ),
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: HelixView(controller: widget.controller),
                  ),
                  Positioned(
                    bottom: 16,
                    left: 16,
                    right: 16,
                    child: IgnorePointer(
                      ignoring: !_hintVisible,
                      child: AnimatedOpacity(
                        opacity: _hintVisible ? 1 : 0,
                        duration: const Duration(milliseconds: 350),
                        child: HelpCard(
                          title: s.hint,
                          body: s.gameplayHint,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
