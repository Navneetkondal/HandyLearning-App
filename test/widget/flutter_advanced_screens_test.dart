import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:handy_learn/features/flutter_advanced/screens/isolates_concurrency_screen.dart';
import 'package:handy_learn/features/flutter_advanced/screens/engine_internals_screen.dart';

void main() {
  group('Flutter Advanced & Master Screens Tests', () {
    testWidgets('IsolatesConcurrencyScreen renders and runs isolate computation',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: IsolatesConcurrencyScreen(),
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));

      // Check header and UI elements
      expect(find.text('Isolates & Concurrency'), findsOneWidget);
      expect(find.text('Zero-Jank Multithreading & Isolates'), findsOneWidget);

      final listFinder = find.byType(Scrollable).first;

      // Scroll to Isolate button
      final isolateBtnFinder = find.text('Isolate (Smooth)');
      await tester.scrollUntilVisible(isolateBtnFinder, 150, scrollable: listFinder);
      expect(isolateBtnFinder, findsOneWidget);

      // Tap isolate execution button inside runAsync to allow real isolate communication
      await tester.runAsync(() async {
        await tester.tap(isolateBtnFinder);
        await Future.delayed(const Duration(milliseconds: 600));
      });
      await tester.pump();
      expect(find.textContaining('Completed on Worker Isolate'), findsOneWidget);
    });

    testWidgets('EngineInternalsScreen renders Three Trees, Layout Protocol and Custom RenderBox',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: EngineInternalsScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Flutter Engine & RenderObjects'), findsOneWidget);
      expect(find.text('The Three Trees & Engine Internals'), findsOneWidget);

      final listFinder = find.byType(Scrollable).first;

      // Find Custom RenderBox card
      final renderBoxFinder = find.text('Live Custom RenderBox Demo');
      await tester.scrollUntilVisible(renderBoxFinder, 100, scrollable: listFinder);
      expect(renderBoxFinder, findsOneWidget);

      // Find Three Trees heading
      final threeTreesFinder = find.text('The Three Trees of Flutter');
      await tester.scrollUntilVisible(threeTreesFinder, 100, scrollable: listFinder);
      expect(threeTreesFinder, findsOneWidget);

      // Find Layout Protocol heading
      final layoutProtocolFinder = find.text('The Golden Law of Flutter Layout');
      await tester.scrollUntilVisible(layoutProtocolFinder, 100, scrollable: listFinder);
      expect(layoutProtocolFinder, findsOneWidget);
    });
  });
}
