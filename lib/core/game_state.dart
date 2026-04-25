import 'package:auricapri_engine/auricapri_engine.dart';
import 'package:meta/meta.dart';

/// Kind of segment within a single disc in the helix tower.
enum SegmentType { safe, deadly }

/// Immutable disc — a horizontal ring of [segments] at vertical world
/// position [y]. Rotation is owned by the tower (game state), not the disc.
@immutable
class HelixDisc {
  const HelixDisc({
    required this.id,
    required this.y,
    required this.segments,
  });

  final int id;
  final double y;
  final List<SegmentType> segments;

  int get segmentCount => segments.length;

  /// Returns the segment under the ball given current tower rotation, in
  /// radians. The ball is fixed at world angle 0.
  SegmentType segmentAt(double towerRotationRad) {
    final n = segments.length;
    const twoPi = 6.283185307179586;
    var r = towerRotationRad % twoPi;
    if (r < 0) r += twoPi;
    final segAngle = twoPi / n;
    final inverse = (twoPi - r) % twoPi;
    final idx = (inverse / segAngle).floor() % n;
    return segments[idx];
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! HelixDisc) return false;
    if (other.id != id || other.y != y) return false;
    if (other.segments.length != segments.length) return false;
    for (var i = 0; i < segments.length; i++) {
      if (segments[i] != other.segments[i]) return false;
    }
    return true;
  }

  @override
  int get hashCode => Object.hash(id, y, Object.hashAll(segments));
}

/// Immutable game state for Helix Jump (infinite mode).
///
/// Coordinate system: world Y grows DOWNWARD. The ball is fixed at the
/// camera origin and the tower (with its discs) slides up in screen space
/// as [cameraY] increases — i.e. the ball is "falling" through the tower.
@immutable
class HelixState extends GameState {
  const HelixState({
    required super.phase,
    required super.score,
    required super.movesUsed,
    required super.isOver,
    required super.isWon,
    required this.cameraY,
    required this.towerRotation,
    required this.discs,
    required this.passedDiscIds,
    required this.nextDiscId,
  });

  /// How far the ball has fallen (world units, monotonically increasing).
  final double cameraY;

  /// Tower rotation in radians (player drag controls this).
  final double towerRotation;

  /// Active discs in the tower, sorted ascending by [HelixDisc.y].
  final List<HelixDisc> discs;

  /// Ids of discs the ball has already crossed (avoids double-scoring).
  final Set<int> passedDiscIds;

  /// Counter for assigning ids to newly spawned discs.
  final int nextDiscId;

  HelixState copyWith({
    int? phase,
    int? score,
    int? movesUsed,
    bool? isOver,
    bool? isWon,
    double? cameraY,
    double? towerRotation,
    List<HelixDisc>? discs,
    Set<int>? passedDiscIds,
    int? nextDiscId,
  }) {
    return HelixState(
      phase: phase ?? this.phase,
      score: score ?? this.score,
      movesUsed: movesUsed ?? this.movesUsed,
      isOver: isOver ?? this.isOver,
      isWon: isWon ?? this.isWon,
      cameraY: cameraY ?? this.cameraY,
      towerRotation: towerRotation ?? this.towerRotation,
      discs: discs ?? this.discs,
      passedDiscIds: passedDiscIds ?? this.passedDiscIds,
      nextDiscId: nextDiscId ?? this.nextDiscId,
    );
  }
}
