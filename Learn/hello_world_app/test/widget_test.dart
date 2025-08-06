import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hello_world_app/main.dart';

void main() {
  testWidgets('TorchApp UI and toggle test', (WidgetTester tester) async {
    // Build the TorchApp widget
    await tester.pumpWidget(const TorchApp());

    // Verify the app bar title
    expect(find.text('Retro Torch'), findsOneWidget);

    // Find the flashlight icon (off state)
    expect(find.byIcon(Icons.flashlight_off), findsOneWidget);
    expect(find.byIcon(Icons.flashlight_on), findsNothing);

    // Tap the torch button
    await tester.tap(find.byType(GestureDetector));
    await tester.pumpAndSettle();

    // After tap, the icon should change (on state)
    expect(find.byIcon(Icons.flashlight_on), findsOneWidget);
    expect(find.byIcon(Icons.flashlight_off), findsNothing);
  });
}
