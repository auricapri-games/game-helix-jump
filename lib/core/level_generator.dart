import 'package:auricapri_engine/auricapri_engine.dart';

import '../config/level_params.dart';
import 'game_state.dart';

class HelixGenerator extends LevelGenerator<HelixParams, HelixState> {
  const HelixGenerator();

  @override
  HelixState generate(HelixParams params) {
    final rng = SeededRandom(params.seed);
    final rings = <HelixRing>[];
    for (var i = 0; i < params.numRings; i++) {
      final segments = _buildRing(rng, params);
      rings.add(HelixRing(segments));
    }
    return HelixState(
      phase: params.phase,
      score: 0,
      movesUsed: 0,
      isOver: false,
      isWon: false,
      rings: rings,
      currentRing: 0,
      ballAngle: 0,
    );
  }

  List<SegmentType> _buildRing(SeededRandom rng, HelixParams params) {
    final n = params.segmentsPerRing;
    // Solubility-by-construction: angle 0 is always SAFE so the ball can
    // always drop without rotating. Other slots become a mix of dead /
    // safe / gap based on phase difficulty.
    final segments = List<SegmentType>.filled(n, SegmentType.safe);
    final deadCount = params.deadSegmentsPerRing.clamp(0, n - 1);
    final gapCount = params.gapSegmentsPerRing.clamp(0, n - 1 - deadCount);

    final candidates = List<int>.generate(n, (k) => k)..removeAt(0);
    rng.shuffleInPlace(candidates);
    var cursor = 0;
    for (var d = 0; d < deadCount; d++) {
      segments[candidates[cursor]] = SegmentType.dead;
      cursor++;
    }
    for (var g = 0; g < gapCount; g++) {
      segments[candidates[cursor]] = SegmentType.gap;
      cursor++;
    }
    return segments;
  }

  @override
  bool validateSolvable(HelixState state) {
    for (final ring in state.rings) {
      final hasSafePath = ring.segments.any(
        (s) => s == SegmentType.safe || s == SegmentType.gap,
      );
      if (!hasSafePath) return false;
    }
    return true;
  }
}
