import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_learning_hub/features/swiftui_track/screens/swiftui_state_simulator_screen.dart';

void main() {
  testWidgets('SwiftUiStateSimulatorScreen exercises @State, @Observable, and @Environment',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1200, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      const MaterialApp(
        home: SwiftUiStateSimulatorScreen(),
      ),
    );
    await tester.pumpAndSettle();

    // Verify title and banner
    expect(find.text('SwiftUI State & Data Flow Simulator'), findsOneWidget);
    expect(find.text('State, Binding & Observability Simulator'), findsOneWidget);

    // Lab 1: Test @State & @Binding interaction
    expect(find.text('counter = 10'), findsOneWidget);
    final incrementBtn = find.byIcon(Icons.add_rounded);
    await tester.tap(incrementBtn);
    await tester.pumpAndSettle();
    expect(find.text('counter = 11'), findsOneWidget);

    // Lab 2: Test @Observable ViewModel Task
    final fetchBtn = find.text('Task { await fetch() }');
    await tester.tap(fetchBtn);
    await tester.pump();
    expect(find.textContaining('Task { @MainActor'), findsOneWidget);

    // Wait for async task to complete
    await tester.pump(const Duration(milliseconds: 700));
    expect(find.text('Alex Rivera'), findsOneWidget);
    expect(find.text('iOS Staff Architect • Core Experience'), findsOneWidget);

    // Lab 3: Test @Environment Cascade
    final emeraldChip = find.text('Emerald');
    await tester.tap(emeraldChip);
    await tester.pumpAndSettle();
    expect(find.text('Emerald VIP'), findsOneWidget);
  });
}
