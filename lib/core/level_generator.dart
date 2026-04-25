import 'package:auricapri_engine/auricapri_engine.dart';

import '../config/level_params.dart';
import 'game_rules.dart';
import 'game_state.dart';

/// Builds the initial state for a Helix Jump run.
///
/// Solvability by construction: the FIRST disc directly under the ball is
/// guaranteed to be all-safe so the player can never lose on frame 0.
class HelixGenerator extends LevelGenerator<HelixParams, HelixState> {
  const HelixGenerator();

  @override
  HelixState generate(HelixParams params) {
    final firstDisc = HelixDisc(
      id: 0,
      y: params.discSpacing,
      segments: List<SegmentType>.filled(
        params.numSegments,
        SegmentType.safe,
      ),
    );
    final initial = HelixState(
      phase: 1,
      score: 0,
      movesUsed: 0,
      isOver: false,
      isWon: false,
      cameraY: 0,
      towerRotation: 0,
      discs: <HelixDisc>[firstDisc],
      passedDiscIds: const <int>{},
      nextDiscId: 1,
    );
    // Drive a zero-delta move so the rules engine populates the spawn buffer.
    return HelixRules(params).applyMove(initial, HelixMove.zero);
  }

  @override
  bool validateSolvable(HelixState state) {
    for (final disc in state.discs) {
      if (disc.y <= state.cameraY) continue;
      return disc.segments.any((s) => s == SegmentType.safe);
    }
    return false;
  }
}
