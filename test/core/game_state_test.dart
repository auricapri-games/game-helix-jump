import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';
import 'package:game_helix_jump/core/game_state.dart';

void main() {
  group('HelixDisc.segmentAt', () {
    final disc = HelixDisc(
      id: 0,
      y: 100,
      segments: const [
        SegmentType.safe,
        SegmentType.deadly,
        SegmentType.safe,
        SegmentType.deadly,
      ],
    );

    test('with rotation 0, the ball reads segment index 0', () {
      expect(disc.segmentAt(0), SegmentType.safe);
    });

    test('rotating tower by quarter turn shifts segment under ball', () {
      // n=4 → segAngle = pi/2. Tower rotation pi/2 puts the previous
      // segment 3 under the ball.
      expect(disc.segmentAt(math.pi / 2), SegmentType.deadly);
    });

    test('full rotation wraps back to original segment', () {
      expect(disc.segmentAt(math.pi * 2), SegmentType.safe);
    });

    test('negative rotation wraps correctly', () {
      expect(disc.segmentAt(-math.pi / 2), SegmentType.deadly);
    });
  });

  group('HelixDisc equality', () {
    test('same id/y/segments are equal', () {
      final a = HelixDisc(
        id: 1,
        y: 50,
        segments: const [SegmentType.safe, SegmentType.deadly],
      );
      final b = HelixDisc(
        id: 1,
        y: 50,
        segments: const [SegmentType.safe, SegmentType.deadly],
      );
      expect(a, equals(b));
      expect(a.hashCode, b.hashCode);
    });

    test('different segments → not equal', () {
      final a = HelixDisc(
        id: 1,
        y: 50,
        segments: const [SegmentType.safe],
      );
      final b = HelixDisc(
        id: 1,
        y: 50,
        segments: const [SegmentType.deadly],
      );
      expect(a, isNot(equals(b)));
    });

    test('segmentCount returns segments length', () {
      final d = HelixDisc(
        id: 0,
        y: 0,
        segments: const [
          SegmentType.safe,
          SegmentType.safe,
          SegmentType.deadly,
        ],
      );
      expect(d.segmentCount, 3);
    });
  });

  group('HelixState.copyWith', () {
    HelixState build() => const HelixState(
          phase: 1,
          score: 0,
          movesUsed: 0,
          isOver: false,
          isWon: false,
          cameraY: 0,
          towerRotation: 0,
          discs: <HelixDisc>[],
          passedDiscIds: <int>{},
          nextDiscId: 0,
        );

    test('keeps untouched fields', () {
      final s = build().copyWith(score: 5);
      expect(s.score, 5);
      expect(s.phase, 1);
      expect(s.isOver, false);
    });

    test('updates given fields', () {
      final s = build().copyWith(
        cameraY: 200,
        towerRotation: 1.0,
        isOver: true,
      );
      expect(s.cameraY, 200);
      expect(s.towerRotation, 1.0);
      expect(s.isOver, true);
      expect(s.isLost, true);
    });

    test('isLost mirrors isOver && !isWon', () {
      final won = build().copyWith(isOver: true, isWon: true);
      expect(won.isLost, isFalse);
    });
  });
}
