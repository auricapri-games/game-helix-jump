import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_helix_jump/main.dart';

void main() {
  testWidgets('app boots without crashing', (tester) async {
    await tester.pumpWidget(const GameHelixJumpApp());
    expect(find.byType(MaterialApp), findsOneWidget);
    // Drain the splash screen's pending Future.delayed (1700 ms) so the test
    // does not fail on the "Timer is still pending" framework invariant.
    await tester.pump(const Duration(milliseconds: 1800));
    await tester.pump(const Duration(milliseconds: 200));
  });
}
