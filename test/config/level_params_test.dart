import 'package:flutter_test/flutter_test.dart';
import 'package:game_helix_jump/config/level_params.dart';

void main() {
  group('HelixParams.fromPhase', () {
    test('phase 1 baseline values', () {
      final p = HelixParams.fromPhase(1);
      expect(p.phase, 1);
      expect(p.numSegments, 8);
      expect(p.discSpacing, 130);
      expect(p.fallSpeed, 148);
      expect(p.maxDeadly, 1);
    });

    test('clamps phase 0 → 1', () {
      final p = HelixParams.fromPhase(0);
      expect(p.phase, 1);
    });

    test('fall speed grows with phase (capped at 320)', () {
      final p1 = HelixParams.fromPhase(1);
      final p10 = HelixParams.fromPhase(10);
      final p100 = HelixParams.fromPhase(100);
      expect(p10.fallSpeed, greaterThan(p1.fallSpeed));
      expect(p100.fallSpeed, lessThanOrEqualTo(320));
    });

    test('maxDeadly grows but is clamped at 5', () {
      final p1 = HelixParams.fromPhase(1);
      final p20 = HelixParams.fromPhase(20);
      final p999 = HelixParams.fromPhase(999);
      expect(p20.maxDeadly, greaterThanOrEqualTo(p1.maxDeadly));
      expect(p999.maxDeadly, lessThanOrEqualTo(5));
    });

    test('equality and hashCode', () {
      final a = HelixParams.fromPhase(3);
      final b = HelixParams.fromPhase(3);
      expect(a == b, isTrue);
      expect(a.hashCode, b.hashCode);
      expect(a == HelixParams.fromPhase(4), isFalse);
    });

    test('explicit seed overrides phase-derived seed', () {
      final p = HelixParams.fromPhase(5, seed: 1234);
      expect(p.seed, 1234);
    });
  });
}
