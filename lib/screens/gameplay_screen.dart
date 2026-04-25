import 'package:flutter/material.dart';

import '../state/game_controller.dart';
import '../widgets/gameplay_body.dart';
import 'game_over_screen.dart';
import 'level_complete_screen.dart';

typedef ScoreSink = Future<bool> Function(int score);

class GameplayScreen extends StatefulWidget {
  const GameplayScreen({
    required this.phase,
    super.key,
    this.onGameEnd,
  });

  final int phase;
  final ScoreSink? onGameEnd;

  @override
  State<GameplayScreen> createState() => _GameplayScreenState();
}

class _GameplayScreenState extends State<GameplayScreen> {
  late final HelixController _ctrl;
  bool _resolving = false;

  @override
  void initState() {
    super.initState();
    _ctrl = HelixController(widget.phase);
    _ctrl.addListener(_onChanged);
  }

  @override
  void dispose() {
    _ctrl
      ..removeListener(_onChanged)
      ..dispose();
    super.dispose();
  }

  void _onChanged() {
    if (_ctrl.state.isOver && !_resolving) {
      _resolving = true;
      WidgetsBinding.instance.addPostFrameCallback((_) => _handleEnd());
    }
  }

  Future<void> _handleEnd() async {
    final score = _ctrl.state.score;
    await widget.onGameEnd?.call(score);
    if (!mounted) return;
    if (_ctrl.state.isWon) {
      await _showLevelComplete(score);
    } else {
      await _showGameOver(score);
    }
    _resolving = false;
  }

  Future<void> _showGameOver(int score) async {
    final action = await Navigator.of(context).push<GameOverAction>(
      MaterialPageRoute(builder: (_) => GameOverScreen(score: score)),
    );
    if (!mounted) return;
    if (action == GameOverAction.retry) {
      _ctrl.restart();
    } else {
      Navigator.of(context).pop();
    }
  }

  Future<void> _showLevelComplete(int score) async {
    final action = await Navigator.of(context).push<LevelCompleteAction>(
      MaterialPageRoute(builder: (_) => LevelCompleteScreen(score: score)),
    );
    if (!mounted) return;
    if (action == LevelCompleteAction.next) {
      _ctrl.advancePhase();
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GameplayBody(
        controller: _ctrl,
        onBack: () => Navigator.of(context).pop(),
      ),
    );
  }
}
