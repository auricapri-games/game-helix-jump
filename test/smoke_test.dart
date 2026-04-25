import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:game_helix_jump/main.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  testWidgets('app boots without crashing', (tester) async {
    await tester.pumpWidget(const GameHelixJumpApp());
    await tester.pump();
    expect(find.byType(MaterialApp), findsOneWidget);
    // Flush splash timer + repeating sprite-hero animation so the test
    // doesn't trip the "pending timer" invariant on tear-down.
    await tester.pump(const Duration(milliseconds: 2000));
    await tester.pump(const Duration(milliseconds: 200));
  });
}
