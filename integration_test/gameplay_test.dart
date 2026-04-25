import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:game_helix_jump/main.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  testWidgets('home → play → drop increments score', (tester) async {
    await tester.pumpWidget(const GameHelixJumpApp());

    // Wait for the splash auto-navigation timer to fire and Home to settle.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 2200));
    await tester.pump(const Duration(milliseconds: 200));

    // Home: tap the JOGAR CTA.
    final playBtn = find.byKey(const Key('home-play'));
    expect(playBtn, findsOneWidget);
    await tester.tap(playBtn);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    // Gameplay: score card visible, currently 0.
    final scoreCard = find.byKey(const Key('score-card'));
    expect(scoreCard, findsOneWidget);
    expect(
      find.descendant(of: scoreCard, matching: find.text('0')),
      findsOneWidget,
    );

    // Tap drop button — angle 0 is guaranteed safe by construction.
    final dropBtn = find.byKey(const Key('drop'));
    expect(dropBtn, findsOneWidget);
    await tester.tap(dropBtn);
    await tester.pump();

    // Score must have advanced to 1 (proves the rules engine actually ran).
    expect(
      find.descendant(of: scoreCard, matching: find.text('1')),
      findsOneWidget,
    );

    // Tap drop again — should be 2.
    await tester.tap(dropBtn);
    await tester.pump();
    expect(
      find.descendant(of: scoreCard, matching: find.text('2')),
      findsOneWidget,
    );
  });
}
