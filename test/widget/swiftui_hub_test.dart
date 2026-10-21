import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:handy_learn/features/swiftui_track/screens/swiftui_hub_screen.dart';

void main() {
  testWidgets('SwiftUiHubScreen renders curriculum and filters by mastery level',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1200, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      const MaterialApp(
        home: SwiftUiHubScreen(),
      ),
    );
    await tester.pumpAndSettle();

    // Verify title and banner
    expect(find.text('SwiftUI & Modern iOS Track'), findsOneWidget);
    expect(find.text('SwiftUI Architecture & Engineering'), findsOneWidget);

    // Verify filter chips exist
    expect(find.textContaining('All ('), findsOneWidget);
    expect(find.textContaining('🟢 Basic'), findsOneWidget);
    expect(find.textContaining('🟡 Intermediate'), findsOneWidget);
    expect(find.textContaining('🟠 Advanced'), findsOneWidget);
    expect(find.textContaining('🟣 Master'), findsOneWidget);

    // Filter by Basic
    final basicChip = find.textContaining('🟢 Basic');
    await tester.tap(basicChip);
    await tester.pumpAndSettle();

    expect(find.textContaining('Basic Tier Lessons'), findsOneWidget);
    expect(find.textContaining('Declarative Views & Modifiers'), findsOneWidget);

    // Filter by Master
    final masterChip = find.textContaining('🟣 Master');
    await tester.tap(masterChip);
    await tester.pumpAndSettle();

    expect(find.textContaining('Master Tier Lessons'), findsOneWidget);
    expect(find.textContaining('AttributeGraph Internals & Re-Render Auditing'), findsOneWidget);

    final listFinder = find.byType(Scrollable).first;
    final metalFinder = find.textContaining('Metal Shaders & Low-Level Render Pipeline');
    await tester.scrollUntilVisible(metalFinder, 150, scrollable: listFinder);
    expect(metalFinder, findsOneWidget);
  });
}
