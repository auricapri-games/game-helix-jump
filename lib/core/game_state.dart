import 'package:auricapri_engine/auricapri_engine.dart';
import 'package:meta/meta.dart';

enum SegmentType { safe, dead, gap }

@immutable
class HelixRing {
  const HelixRing(this.segments);

  final List<SegmentType> segments;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! HelixRing) return false;
    if (other.segments.length != segments.length) return false;
    for (var i = 0; i < segments.length; i++) {
      if (segments[i] != other.segments[i]) return false;
    }
    return true;
  }

  @override
  int get hashCode => Object.hashAll(segments);
}

@immutable
class HelixState extends GameState {
  const HelixState({
    required super.phase,
    required super.score,
    required super.movesUsed,
    required super.isOver,
    required super.isWon,
    required this.rings,
    required this.currentRing,
    required this.ballAngle,
  });

  final List<HelixRing> rings;
  final int currentRing;
  final int ballAngle;

  HelixRing get activeRing => rings[currentRing];

  HelixState copyWith({
    int? score,
    int? movesUsed,
    bool? isOver,
    bool? isWon,
    int? currentRing,
    int? ballAngle,
  }) {
    return HelixState(
      phase: phase,
      score: score ?? this.score,
      movesUsed: movesUsed ?? this.movesUsed,
      isOver: isOver ?? this.isOver,
      isWon: isWon ?? this.isWon,
      rings: rings,
      currentRing: currentRing ?? this.currentRing,
      ballAngle: ballAngle ?? this.ballAngle,
    );
  }
}
