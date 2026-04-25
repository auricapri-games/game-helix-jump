import 'package:flutter_test/flutter_test.dart';
import 'package:game_helix_jump/core/game_state.dart';

void main() {
  group('HelixRing equality', () {
    test('rings with same segments are equal', () {
      final a = HelixRing(const [
        SegmentType.safe,
        SegmentType.dead,
        SegmentType.gap,
      ]);
      final b = HelixRing(const [
        SegmentType.safe,
        SegmentType.dead,
        SegmentType.gap,
      ]);
      expect(a == b, isTrue);
      expect(a.hashCode, b.hashCode);
    });

    test('different lengths are not equal', () {
      final a = HelixRing(const [SegmentType.safe]);
      final b = HelixRing(const [SegmentType.safe, SegmentType.gap]);
      expect(a == b, isFalse);
    });

    test('different element values are not equal', () {
      final a = HelixRing(const [SegmentType.safe, SegmentType.dead]);
      final b = HelixRing(const [SegmentType.safe, SegmentType.gap]);
      expect(a == b, isFalse);
    });

    test('identical ring is equal to itself', () {
      final a = HelixRing(const [SegmentType.safe]);
      expect(a == a, isTrue);
    });
  });

  group('HelixState copyWith', () {
    final base = HelixState(
      phase: 2,
      score: 1,
      movesUsed: 3,
      isOver: false,
      isWon: false,
      rings: [HelixRing(const [SegmentType.safe, SegmentType.dead])],
      currentRing: 0,
      ballAngle: 0,
    );

    test('copyWith preserves rings reference', () {
      final next = base.copyWith(score: 5);
      expect(next.score, 5);
      expect(next.rings, same(base.rings));
      expect(next.phase, base.phase);
    });

    test('isLost mirrors isOver && !isWon', () {
      final lost = base.copyWith(isOver: true);
      expect(lost.isLost, isTrue);
      final won = base.copyWith(isOver: true, isWon: true);
      expect(won.isLost, isFalse);
    });
  });
}
