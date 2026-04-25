import 'package:flutter/material.dart';

import '../state/game_controller.dart';
import '../widgets/gameplay_body.dart';
import 'game_over_screen.dart';

typedef ScoreSink = Future<bool> Function(int score);

/// Hosts the [HelixController] for the run, drives its [Ticker] off the
/// widget's vsync, and forwards Game Over to the result screen.
///
/// Infinite mode → there is no Level Complete flow; only Game Over.
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

class _GameplayScreenState extends State<GameplayScreen>
    with SingleTickerProviderStateMixin {
  late final HelixController _ctrl;
  bool _resolving = false;

  @override
  void initState() {
    super.initState();
    _ctrl = HelixController(widget.phase, vsync: this);
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
      _ctrl.pause();
      WidgetsBinding.instance.addPostFrameCallback((_) => _handleEnd());
    }
  }

  Future<void> _handleEnd() async {
    final score = _ctrl.state.score;
    await widget.onGameEnd?.call(score);
    if (!mounted) return;
    final action = await Navigator.of(context).push<GameOverAction>(
      MaterialPageRoute(builder: (_) => GameOverScreen(score: score)),
    );
    if (!mounted) return;
    if (action == GameOverAction.retry) {
      _ctrl.restart();
      _resolving = false;
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
