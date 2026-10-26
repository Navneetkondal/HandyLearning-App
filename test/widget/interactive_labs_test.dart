import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:handy_learn/features/labs/screens/interactive_labs_screen.dart';
import 'package:handy_learn/features/labs/screens/ios_arc_memory_lab_screen.dart';
import 'package:handy_learn/features/labs/screens/ios_concurrency_race_lab_screen.dart';

void main() {
  group('Interactive Labs & Simulators Tests', () {
    testWidgets('renders all lab cards in InteractiveLabsScreen', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        const MaterialApp(
          home: InteractiveLabsScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Interactive Labs & Sandboxes'), findsOneWidget);
      expect(find.text('Claude Agentic Looping Simulator'), findsOneWidget);
      expect(find.text('iOS Retain Cycle & ARC Simulator'), findsOneWidget);
      expect(find.text('Actor Reentrancy & Race Simulator'), findsOneWidget);
      expect(find.text('StoreKit 2 & Apple Pay Sandbox'), findsOneWidget);

      // Scroll down to see subsequent lab cards
      await tester.drag(find.byType(ListView).first, const Offset(0, -300));
      await tester.pumpAndSettle();

      expect(find.text('Claude MCP Tool Use Simulator'), findsOneWidget);
    });

    testWidgets('IosArcMemoryLabScreen allocates object and detects leak', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: IosArcMemoryLabScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('ARC & Retain Cycle Simulator'), findsOneWidget);
      expect(find.text('LIVE HEAP OBJECT TOPOLOGY'), findsOneWidget);

      // Allocate
      await tester.tap(find.text('Allocate Object'));
      await tester.pumpAndSettle();

      expect(find.text('RC: 2'), findsOneWidget); // Vulnerable has RC: 2

      // Dismiss
      await tester.tap(find.text('Pop / Dismiss Screen'));
      await tester.pumpAndSettle();

      expect(find.text('LEAK DETECTED ⚠'), findsOneWidget);
    });

    testWidgets('IosConcurrencyRaceLabScreen switches architecture and executes', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: IosConcurrencyRaceLabScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Actor Reentrancy & Race Lab'), findsOneWidget);
      expect(find.text('\$100'), findsOneWidget);

      // Select GCD Serial Queue
      await tester.tap(find.text('GCD Serial Queue'));
      await tester.pumpAndSettle();

      // Fire requests
      final fireBtn = find.byType(FilledButton);
      expect(fireBtn, findsOneWidget);
      await tester.tap(fireBtn);
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // After execution, GCD Serial Queue finishes with $0 balance and approved 5 / 10
      expect(find.text('\$0'), findsOneWidget);
      expect(find.text('5 / 10'), findsWidgets);
    });
  });
}
