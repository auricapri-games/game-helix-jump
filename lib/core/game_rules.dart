import 'package:auricapri_engine/auricapri_engine.dart';
import 'package:meta/meta.dart';

import '../config/level_params.dart';
import 'game_state.dart';

/// Player input for a single simulation tick.
///
/// [rotationDelta] — radians the tower should rotate this tick (drag).
/// [fallDelta]     — world units the ball falls this tick (= speed * dt).
@immutable
class HelixMove {
  const HelixMove({
    required this.rotationDelta,
    required this.fallDelta,
  });

  final double rotationDelta;
  final double fallDelta;

  static const HelixMove zero =
      HelixMove(rotationDelta: 0, fallDelta: 0);
}

/// Rules engine for Helix Jump. Pure functions — no IO, no mutation.
class HelixRules extends GameRules<HelixParams, HelixState, HelixMove> {
  const HelixRules(this.params);

  final HelixParams params;

  @override
  bool isLegal(HelixState state, HelixMove move) => !state.isOver;

  @override
  HelixState applyMove(HelixState state, HelixMove move) {
    if (state.isOver) return state;

    final newRotation = state.towerRotation + move.rotationDelta;
    final oldCameraY = state.cameraY;
    final newCameraY = oldCameraY + move.fallDelta;

    var score = state.score;
    var isOver = state.isOver;
    final passed = Set<int>.of(state.passedDiscIds);

    for (final disc in state.discs) {
      if (passed.contains(disc.id)) continue;
      if (oldCameraY < disc.y && newCameraY >= disc.y) {
        passed.add(disc.id);
        final segment = disc.segmentAt(newRotation);
        if (segment == SegmentType.deadly) {
          isOver = true;
          break;
        } else {
          score += 1;
        }
      }
    }

    final discs = List<HelixDisc>.of(state.discs);
    var nextId = state.nextDiscId;
    final farthestY = discs.isEmpty
        ? newCameraY
        : discs.map((d) => d.y).reduce(_max);
    final spawnHorizon = newCameraY + params.spawnAhead;
    var cursor = farthestY;
    while (cursor < spawnHorizon) {
      cursor += params.discSpacing;
      discs.add(_buildDisc(nextId, cursor));
      nextId += 1;
    }

    discs.removeWhere((d) => d.y < newCameraY - params.discSpacing * 2);

    final phase = 1 + (score ~/ 5);

    return state.copyWith(
      phase: phase,
      score: score,
      isOver: isOver,
      cameraY: newCameraY,
      towerRotation: newRotation,
      discs: discs,
      passedDiscIds: passed,
      nextDiscId: nextId,
    );
  }

  HelixDisc _buildDisc(int id, double y) {
    final n = params.numSegments;
    final h = _hash(id, params.seed);
    final deadlyMask = _segmentMaskForId(h, n, params.maxDeadly);
    final segments = <SegmentType>[];
    for (var i = 0; i < n; i++) {
      segments.add(deadlyMask.contains(i)
          ? SegmentType.deadly
          : SegmentType.safe);
    }
    return HelixDisc(id: id, y: y, segments: segments);
  }

  Set<int> _segmentMaskForId(int hash, int n, int maxDeadly) {
    final maxKill = maxDeadly.clamp(1, n - 1);
    final count = 1 + (hash.abs() % maxKill);
    final out = <int>{};
    var h = hash;
    var safety = 0;
    while (out.length < count && safety < 64) {
      h = _xorshift32(h);
      out.add(h.abs() % n);
      safety += 1;
    }
    return out;
  }

  /// JS-safe 32-bit hash (web build cannot use 64-bit literals).
  static int _hash(int a, int b) {
    var h = (a + 1) * 0x9E3779B1 ^ (b + 13) * 0x85EBCA6B;
    return _xorshift32(h);
  }

  static int _xorshift32(int x) {
    var v = x & 0xFFFFFFFF;
    if (v == 0) v = 1;
    v ^= (v << 13) & 0xFFFFFFFF;
    v ^= (v >> 17) & 0xFFFFFFFF;
    v ^= (v << 5) & 0xFFFFFFFF;
    return v & 0xFFFFFFFF;
  }

  static double _max(double a, double b) => a > b ? a : b;
}
