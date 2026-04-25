import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_helix_jump/main.dart';

void main() {
  testWidgets('app boots without crashing', (tester) async {
    await tester.pumpWidget(const GameHelixJumpApp());
    await tester.pump();
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
