import 'package:auricapri_engine/auricapri_engine.dart';
import 'package:meta/meta.dart';

import '../config/level_params.dart';
import 'game_state.dart';

@immutable
sealed class HelixMove {
  const HelixMove();
}

class DropBall extends HelixMove {
  const DropBall();
}

class RotateBy extends HelixMove {
  const RotateBy(this.delta);
  final int delta;
}

class HelixRules extends GameRules<HelixParams, HelixState, HelixMove> {
  const HelixRules();

  @override
  HelixState applyMove(HelixState state, HelixMove move) {
    if (state.isOver) return state;
    if (move is RotateBy) {
      final n = state.activeRing.segments.length;
      final raw = state.ballAngle + move.delta;
      final wrapped = ((raw % n) + n) % n;
      return state.copyWith(
        ballAngle: wrapped,
        movesUsed: state.movesUsed + 1,
      );
    }
    if (move is DropBall) {
      final segs = state.activeRing.segments;
      final idx = state.ballAngle % segs.length;
      final seg = segs[idx];
      if (seg == SegmentType.dead) {
        return state.copyWith(
          isOver: true,
          movesUsed: state.movesUsed + 1,
        );
      }
      final nextRing = state.currentRing + 1;
      final scored = state.score + 1;
      if (nextRing >= state.rings.length) {
        return state.copyWith(
          score: scored,
          isOver: true,
          isWon: true,
          movesUsed: state.movesUsed + 1,
        );
      }
      return state.copyWith(
        score: scored,
        currentRing: nextRing,
        movesUsed: state.movesUsed + 1,
      );
    }
    return state;
  }

  @override
  bool isLegal(HelixState state, HelixMove move) => !state.isOver;
}
