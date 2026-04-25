import 'package:auricapri_engine/auricapri_engine.dart';

/// Per-phase tunables for Helix Jump (physics, infinite mode).
///
/// Difficulty grows with phase but stays survivable — `maxDeadly` is capped
/// so every disc keeps at least one safe segment, and `fallSpeed` is capped
/// so reflexes can keep up.
class HelixParams extends LevelParams {
  const HelixParams({
    required super.phase,
    required super.seed,
    required this.numSegments,
    required this.discSpacing,
    required this.fallSpeed,
    required this.maxDeadly,
    required this.spawnAhead,
  });

  /// Number of pie segments per disc (8 → each = 45°).
  final int numSegments;

  /// World units between two consecutive discs.
  final double discSpacing;

  /// Ball fall speed in world units per second.
  final double fallSpeed;

  /// Upper bound on the number of deadly segments a disc may carry. Always
  /// leaves at least one safe segment so every disc is survivable.
  final int maxDeadly;

  /// How far below the camera new discs are pre-spawned, world units.
  final double spawnAhead;

  factory HelixParams.fromPhase(int phase, {int seed = 0}) {
    final p = phase < 1 ? 1 : phase;
    final actualSeed = seed == 0 ? p * 9173 + 17 : seed;
    final maxDeadly = (1 + (p ~/ 3)).clamp(1, 5); // 1..5 deadly per disc
    final fallSpeed = (140 + p * 8).clamp(140, 320).toDouble();
    return HelixParams(
      phase: p,
      seed: actualSeed,
      numSegments: 8,
      discSpacing: 130,
      fallSpeed: fallSpeed,
      maxDeadly: maxDeadly,
      spawnAhead: 1400,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is HelixParams &&
        other.phase == phase &&
        other.seed == seed &&
        other.numSegments == numSegments &&
        other.discSpacing == discSpacing &&
        other.fallSpeed == fallSpeed &&
        other.maxDeadly == maxDeadly &&
        other.spawnAhead == spawnAhead;
  }

  @override
  int get hashCode => Object.hash(
        phase,
        seed,
        numSegments,
        discSpacing,
        fallSpeed,
        maxDeadly,
        spawnAhead,
      );
}
