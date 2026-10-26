import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:handy_learn/core/widgets/pressable_scale.dart';

void main() {
  group('PressableScale Widget Tests', () {
    testWidgets('renders child widget properly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PressableScale(
              child: const Text('Tap Me'),
            ),
          ),
        ),
      );

      expect(find.text('Tap Me'), findsOneWidget);
    });

    testWidgets('triggers onTap and scales when pressed', (WidgetTester tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: PressableScale(
                scaleFactor: 0.95,
                onTap: () => tapped = true,
                child: const SizedBox(
                  width: 100,
                  height: 50,
                  child: Text('Clickable'),
                ),
              ),
            ),
          ),
        ),
      );

      // Verify initial scale is 1.0
      final scaleTransitionFinder = find.descendant(
        of: find.byType(PressableScale),
        matching: find.byType(ScaleTransition),
      );
      final ScaleTransition scaleTransition = tester.widget(scaleTransitionFinder);
      expect(scaleTransition.scale.value, 1.0);

      // Press down (gesture start)
      final gesture = await tester.startGesture(tester.getCenter(find.text('Clickable')));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Release gesture
      await gesture.up();
      await tester.pumpAndSettle();

      expect(tapped, isTrue);
    });
  });
}
