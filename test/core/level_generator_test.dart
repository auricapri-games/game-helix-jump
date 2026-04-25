import 'package:flutter_test/flutter_test.dart';
import 'package:game_helix_jump/config/level_params.dart';
import 'package:game_helix_jump/core/game_state.dart';
import 'package:game_helix_jump/core/level_generator.dart';

void main() {
  group('HelixGenerator', () {
    const generator = HelixGenerator();

    test('initial state baseline', () {
      final state = generator.generate(HelixParams.fromPhase(3));
      expect(state.score, 0);
      expect(state.movesUsed, 0);
      expect(state.isOver, isFalse);
      expect(state.isWon, isFalse);
      expect(state.cameraY, 0);
      expect(state.towerRotation, 0);
      expect(state.passedDiscIds, isEmpty);
    });

    test('first disc is all-safe (tutorial guarantee)', () {
      for (var phase = 1; phase <= 50; phase++) {
        final state = generator.generate(HelixParams.fromPhase(phase));
        final firstDisc = state.discs.firstWhere((d) => d.id == 0);
        for (final s in firstDisc.segments) {
          expect(s, SegmentType.safe,
              reason: 'phase $phase first disc must be all-safe');
        }
      }
    });

    test('determinism: same phase → identical disc layout', () {
      final p = HelixParams.fromPhase(5);
      final a = generator.generate(p);
      final b = generator.generate(p);
      expect(a.discs.length, b.discs.length);
      for (var i = 0; i < a.discs.length; i++) {
        expect(a.discs[i], b.discs[i]);
      }
    });

    test('initial state has multiple discs already spawned', () {
      final state = generator.generate(HelixParams.fromPhase(1));
      expect(state.discs.length, greaterThan(2));
    });

    test('validateSolvable holds for 200 phases', () {
      for (var phase = 1; phase <= 200; phase++) {
        final state = generator.generate(HelixParams.fromPhase(phase));
        expect(generator.validateSolvable(state), isTrue,
            reason: 'phase $phase must be solvable');
      }
    });

    test('every disc has at least one safe segment', () {
      for (var phase = 1; phase <= 50; phase++) {
        final state = generator.generate(HelixParams.fromPhase(phase));
        for (final disc in state.discs) {
          expect(disc.segments.contains(SegmentType.safe), isTrue,
              reason: 'phase $phase disc ${disc.id} has no safe segment');
        }
      }
    });
  });
}
