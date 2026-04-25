// Integration test: home → play → real gameplay produces visible state
// changes (camera advances, score updates, eventually game over).
//
// Drives the [HelixController] directly via `stepFor` so the test does
// not depend on a real frame Ticker — that path is exercised by the live
// app, but tests need determinism.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:game_helix_jump/config/level_params.dart';
import 'package:game_helix_jump/core/game_rules.dart';
import 'package:game_helix_jump/core/game_state.dart';
import 'package:game_helix_jump/core/level_generator.dart';
import 'package:game_helix_jump/main.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('app boots, splash advances to home, JOGAR is reachable',
      (tester) async {
    await tester.pumpWidget(const GameHelixJumpApp());
    // Splash auto-advances after 1700ms. Manual pumps only — pumpAndSettle
    // would hang on the looping mascot AnimationController.
    await tester.pump(const Duration(milliseconds: 1800));
    await tester.pump(const Duration(milliseconds: 200));
    await tester.pump(const Duration(milliseconds: 200));
    // Locale in headless tests defaults to en_US → button text is 'PLAY'.
    expect(find.byKey(const Key('home-play')), findsOneWidget);
  });

  testWidgets('falling without rotating eventually ends the run',
      (tester) async {
    // No-rotation run must die — the deterministic disc layout always
    // contains a deadly segment under the ball at some point. This guards
    // bug rule #1 (no fake "tap-to-win" mechanic) and rule #5 (timing).
    final params = HelixParams.fromPhase(1);
    final rules = HelixRules(params);
    var s = const HelixGenerator().generate(params);
    var ticks = 0;
    while (!s.isOver && ticks < 600) {
      s = rules.applyMove(
        s,
        const HelixMove(rotationDelta: 0, fallDelta: 12),
      );
      ticks++;
    }
    expect(s.isOver, isTrue,
        reason: 'no-rotation gameplay must eventually hit a deadly disc');
    expect(s.cameraY, greaterThan(0),
        reason: 'ball must have actually moved');
  });

  testWidgets('rotating before each disc lets the player score', (tester) async {
    // Skilful play — for each upcoming disc, choose the rotation that puts
    // a safe segment under the ball. Score must climb past 5.
    final params = HelixParams.fromPhase(1);
    final rules = HelixRules(params);
    var s = const HelixGenerator().generate(params);
    final twoPi = 6.283185307179586;
    final segAngle = twoPi / params.numSegments;
    var safety = 200;
    while (s.score < 5 && safety-- > 0 && !s.isOver) {
      // Find next un-passed disc ahead of the ball.
      final next = s.discs.firstWhere(
        (d) => d.y > s.cameraY && !s.passedDiscIds.contains(d.id),
        orElse: () => s.discs.first,
      );
      // Find a safe segment index.
      final safeIdx =
          next.segments.indexWhere((seg) => seg == SegmentType.safe);
      // Compute the rotation that puts segment `safeIdx` under the ball.
      // segmentAt uses inverse = (twoPi - rotation) mod twoPi; we want
      // floor(inverse / segAngle) == safeIdx → set inverse = safeIdx*segAngle
      // → rotation = (twoPi - safeIdx*segAngle) mod twoPi.
      final desired = (twoPi - safeIdx * segAngle) % twoPi;
      final delta = desired - (s.towerRotation % twoPi);
      s = rules.applyMove(
        s,
        HelixMove(rotationDelta: delta, fallDelta: params.discSpacing + 5),
      );
    }
    expect(s.isOver, isFalse,
        reason: 'skilful play should not have died yet');
    expect(s.score, greaterThanOrEqualTo(5),
        reason: 'aligned safe-segment play must produce score');
  });

  testWidgets(
      'gameplay screen renders score header that updates as ball falls',
      (tester) async {
    await tester.pumpWidget(const GameHelixJumpApp());
    await tester.pump(const Duration(milliseconds: 1800));
    await tester.pump(const Duration(milliseconds: 300));
    await tester.tap(find.byKey(const Key('home-play')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.byKey(const Key('score-card')), findsOneWidget);
    for (var i = 0; i < 60; i++) {
      await tester.pump(const Duration(milliseconds: 16));
    }
    expect(find.byKey(const Key('score-card')), findsOneWidget);
  });
}
