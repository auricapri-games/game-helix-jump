import 'package:flutter_test/flutter_test.dart';
import 'package:game_helix_jump/config/level_params.dart';
import 'package:game_helix_jump/core/game_rules.dart';
import 'package:game_helix_jump/core/game_state.dart';
import 'package:game_helix_jump/core/level_generator.dart';

void main() {
  group('HelixRules', () {
    const rules = HelixRules();
    const generator = HelixGenerator();

    HelixState fresh({int phase = 1}) =>
        generator.generate(HelixParams.fromPhase(phase));

    test('drop on safe slot increments score and advances ring', () {
      final s0 = fresh();
      final s1 = rules.applyMove(s0, const DropBall());
      expect(s1.score, 1);
      expect(s1.currentRing, 1);
      expect(s1.isOver, isFalse);
    });

    test('rotate wraps both directions', () {
      final s0 = fresh();
      final n = s0.activeRing.segments.length;
      final right = rules.applyMove(s0, const RotateBy(1));
      expect(right.ballAngle, 1 % n);
      final left = rules.applyMove(s0, const RotateBy(-1));
      expect(left.ballAngle, (n - 1) % n);
    });

    test('isLegal false after isOver', () {
      var state = fresh();
      while (!state.isOver) {
        state = rules.applyMove(state, const DropBall());
      }
      expect(rules.isLegal(state, const DropBall()), isFalse);
      // Further moves are no-ops.
      final after = rules.applyMove(state, const DropBall());
      expect(after.score, state.score);
    });

    test('drop on dead segment ends the game', () {
      var state = fresh();
      // Find the first dead segment in the active ring.
      final deadIdx = state.activeRing.segments
          .indexWhere((s) => s == SegmentType.dead);
      expect(deadIdx, isNonNegative);
      state = state.copyWith(ballAngle: deadIdx);
      final after = rules.applyMove(state, const DropBall());
      expect(after.isOver, isTrue);
      expect(after.isWon, isFalse);
      expect(after.isLost, isTrue);
    });

    test('clearing all rings sets isWon true', () {
      var state = fresh();
      while (!state.isOver) {
        // Always rotate to angle 0 (safe by construction) before dropping.
        state = state.copyWith(ballAngle: 0);
        state = rules.applyMove(state, const DropBall());
      }
      expect(state.isWon, isTrue);
      expect(state.isLost, isFalse);
    });
  });
}
