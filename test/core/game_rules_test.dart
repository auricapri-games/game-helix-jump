import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';
import 'package:game_helix_jump/config/level_params.dart';
import 'package:game_helix_jump/core/game_rules.dart';
import 'package:game_helix_jump/core/game_state.dart';
import 'package:game_helix_jump/core/level_generator.dart';

void main() {
  group('HelixRules', () {
    HelixState fresh({int phase = 1}) =>
        const HelixGenerator().generate(HelixParams.fromPhase(phase));

    test('falling past the all-safe first disc increments score', () {
      final s0 = fresh();
      final rules = HelixRules(HelixParams.fromPhase(1));
      // First disc is at y == discSpacing (130). Fall just past it.
      final s1 = rules.applyMove(
        s0,
        const HelixMove(rotationDelta: 0, fallDelta: 200),
      );
      expect(s1.score, 1);
      expect(s1.isOver, isFalse);
      expect(s1.cameraY, 200);
      expect(s1.passedDiscIds.contains(0), isTrue);
    });

    test('rotating without falling does not change score', () {
      final s0 = fresh();
      final rules = HelixRules(HelixParams.fromPhase(1));
      final s1 = rules.applyMove(
        s0,
        const HelixMove(rotationDelta: math.pi / 4, fallDelta: 0),
      );
      expect(s1.score, 0);
      expect(s1.towerRotation, math.pi / 4);
      expect(s1.isOver, isFalse);
    });

    test('isLegal returns false once isOver is true', () {
      final s0 = fresh();
      final rules = HelixRules(HelixParams.fromPhase(1));
      final dead = s0.copyWith(isOver: true);
      expect(rules.isLegal(dead, HelixMove.zero), isFalse);
      // Further moves are no-ops.
      final after = rules.applyMove(
        dead,
        const HelixMove(rotationDelta: 0, fallDelta: 100),
      );
      expect(after.cameraY, dead.cameraY);
    });

    test('crossing a disc with a deadly slot under the ball ends the game',
        () {
      final params = HelixParams.fromPhase(1);
      final rules = HelixRules(params);
      // Construct a state with a single disc just below the ball whose
      // segment 0 is deadly. With rotation 0 the ball is over segment 0.
      final disc = HelixDisc(
        id: 99,
        y: 50,
        segments: const [
          SegmentType.deadly,
          SegmentType.safe,
          SegmentType.safe,
          SegmentType.safe,
          SegmentType.safe,
          SegmentType.safe,
          SegmentType.safe,
          SegmentType.safe,
        ],
      );
      final s = HelixState(
        phase: 1,
        score: 0,
        movesUsed: 0,
        isOver: false,
        isWon: false,
        cameraY: 0,
        towerRotation: 0,
        discs: <HelixDisc>[disc],
        passedDiscIds: const <int>{},
        nextDiscId: 100,
      );
      final after = rules.applyMove(
        s,
        const HelixMove(rotationDelta: 0, fallDelta: 80),
      );
      expect(after.isOver, isTrue);
      expect(after.isLost, isTrue);
      expect(after.score, 0);
    });

    test('rotating BEFORE crossing a deadly disc avoids it', () {
      final params = HelixParams.fromPhase(1);
      final rules = HelixRules(params);
      final disc = HelixDisc(
        id: 7,
        y: 50,
        segments: const [
          SegmentType.deadly,
          SegmentType.safe,
          SegmentType.safe,
          SegmentType.safe,
        ],
      );
      final s = HelixState(
        phase: 1,
        score: 0,
        movesUsed: 0,
        isOver: false,
        isWon: false,
        cameraY: 0,
        towerRotation: 0,
        discs: <HelixDisc>[disc],
        passedDiscIds: const <int>{},
        nextDiscId: 8,
      );
      // Rotate by quarter turn so segment 1 (safe) sits under the ball,
      // then cross the disc.
      final after = rules.applyMove(
        s,
        const HelixMove(rotationDelta: math.pi / 2, fallDelta: 80),
      );
      expect(after.isOver, isFalse);
      expect(after.score, 1);
    });

    test('disc spawning keeps the buffer ahead of the ball', () {
      final params = HelixParams.fromPhase(1);
      final rules = HelixRules(params);
      var s = const HelixGenerator().generate(params);
      // Drive the ball forward; disc count should stay > 5 because the
      // generator/ rules keep spawning ahead.
      for (var i = 0; i < 30; i++) {
        s = rules.applyMove(
          s,
          HelixMove(rotationDelta: 0, fallDelta: params.discSpacing),
        );
        if (s.isOver) break;
        expect(s.discs.length, greaterThanOrEqualTo(5));
      }
    });

    test('phase increases as score grows (one phase per 5 discs)', () {
      final params = HelixParams.fromPhase(1);
      final rules = HelixRules(params);
      var s = const HelixGenerator().generate(params);
      // Force-pass 6 discs by zeroing out cameraY/passed each tick is
      // overkill — just keep falling against the deterministic layout
      // until we either die or score 5+, then check phase math.
      s = s.copyWith(score: 5);
      final after = rules.applyMove(s, HelixMove.zero);
      expect(after.phase, 2);
    });
  });
}
