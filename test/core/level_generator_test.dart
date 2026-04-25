import 'package:flutter_test/flutter_test.dart';
import 'package:game_helix_jump/config/level_params.dart';
import 'package:game_helix_jump/core/game_state.dart';
import 'package:game_helix_jump/core/level_generator.dart';

void main() {
  group('HelixGenerator', () {
    const generator = HelixGenerator();

    test('seed determinism: same params → same rings', () {
      final params = HelixParams.fromPhase(7);
      final a = generator.generate(params);
      final b = generator.generate(params);
      expect(a.rings, b.rings);
      expect(a.phase, b.phase);
    });

    test('angle 0 is always safe by construction', () {
      for (var phase = 1; phase <= 50; phase++) {
        final state = generator.generate(HelixParams.fromPhase(phase));
        for (final ring in state.rings) {
          expect(ring.segments.first, SegmentType.safe,
              reason: 'phase $phase ring start must be safe');
        }
      }
    });

    test('numRings grows with phase groups of 5', () {
      final p1 = generator.generate(HelixParams.fromPhase(1));
      final p10 = generator.generate(HelixParams.fromPhase(10));
      expect(p10.rings.length, greaterThan(p1.rings.length));
    });

    test('validateSolvable holds for 200 random phases', () {
      for (var phase = 1; phase <= 200; phase++) {
        final state = generator.generate(HelixParams.fromPhase(phase));
        expect(generator.validateSolvable(state), isTrue,
            reason: 'phase $phase must be solvable');
      }
    });

    test('initial state has zero score and is not over', () {
      final state = generator.generate(HelixParams.fromPhase(3));
      expect(state.score, 0);
      expect(state.movesUsed, 0);
      expect(state.isOver, isFalse);
      expect(state.currentRing, 0);
      expect(state.ballAngle, 0);
    });
  });
}
