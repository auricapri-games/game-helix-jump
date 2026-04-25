import 'package:auricapri_engine/auricapri_engine.dart';

/// Per-phase parameters for Helix Jump. Difficulty scales with phase:
/// more rings, more dead segments, fewer free gaps.
class HelixParams extends LevelParams {
  const HelixParams({
    required super.phase,
    required super.seed,
    required this.numRings,
    required this.segmentsPerRing,
    required this.deadSegmentsPerRing,
    required this.gapSegmentsPerRing,
  });

  factory HelixParams.fromPhase(int phase) {
    final p = phase < 1 ? 1 : phase;
    final group = (p - 1) ~/ 5;
    return HelixParams(
      phase: p,
      seed: p * 9173 + 17,
      numRings: 8 + group * 2,
      segmentsPerRing: 6,
      deadSegmentsPerRing: (1 + group).clamp(1, 3),
      gapSegmentsPerRing: 2,
    );
  }

  final int numRings;
  final int segmentsPerRing;
  final int deadSegmentsPerRing;
  final int gapSegmentsPerRing;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is HelixParams &&
        other.phase == phase &&
        other.seed == seed &&
        other.numRings == numRings &&
        other.segmentsPerRing == segmentsPerRing &&
        other.deadSegmentsPerRing == deadSegmentsPerRing &&
        other.gapSegmentsPerRing == gapSegmentsPerRing;
  }

  @override
  int get hashCode => Object.hash(
        phase,
        seed,
        numRings,
        segmentsPerRing,
        deadSegmentsPerRing,
        gapSegmentsPerRing,
      );
}
