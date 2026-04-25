import 'package:flutter_test/flutter_test.dart';
import 'package:game_helix_jump/config/level_params.dart';

void main() {
  group('HelixParams.fromPhase', () {
    test('phase 1 baseline values', () {
      final p = HelixParams.fromPhase(1);
      expect(p.phase, 1);
      expect(p.numRings, 8);
      expect(p.segmentsPerRing, 6);
      expect(p.deadSegmentsPerRing, 1);
    });

    test('rings increase with phase', () {
      final p1 = HelixParams.fromPhase(1);
      final p11 = HelixParams.fromPhase(11);
      expect(p11.numRings, greaterThan(p1.numRings));
    });

    test('clamps phase 0 → 1', () {
      final p = HelixParams.fromPhase(0);
      expect(p.phase, 1);
    });

    test('equality and hashCode', () {
      final a = HelixParams.fromPhase(3);
      final b = HelixParams.fromPhase(3);
      expect(a == b, isTrue);
      expect(a.hashCode, b.hashCode);
      expect(a == HelixParams.fromPhase(4), isFalse);
    });
  });
}
