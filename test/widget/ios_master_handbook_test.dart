import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:handy_learn/features/ios_senior_prep/screens/ios_master_handbook_screen.dart';

void main() {
  group('IosMasterHandbookScreen Widget Tests', () {
    testWidgets('renders track switcher, search toolbar, difficulty filters, and topic cards', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: IosMasterHandbookScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Verify Track Switcher
      expect(find.text('⚡ Swift'), findsOneWidget);
      expect(find.text('💻 Coding'), findsOneWidget);
      expect(find.text('🔮 Claude'), findsOneWidget);
      expect(find.text('💙 Flutter'), findsOneWidget);

      // Verify Difficulty Filter Chips
      expect(find.text('All'), findsOneWidget);
      expect(find.text('Fundamental'), findsOneWidget);
      expect(find.text('Intermediate'), findsOneWidget);
      expect(find.text('Senior'), findsOneWidget);
      expect(find.text('Staff'), findsOneWidget);

      // Verify Search bar
      expect(find.byType(TextField), findsOneWidget);

      // Verify Topics rendered
      expect(find.text('Value vs Reference Semantics'), findsWidgets);

      // Tap on topic card to expand the 7 pillars
      await tester.tap(find.text('Value vs Reference Semantics').last);
      await tester.pumpAndSettle();

      // Verify 7-pillar sections appear
      expect(find.text('1. Mental Model (In Simple Words)'), findsOneWidget);
      expect(find.text('2. Formal Definition & Language Guarantees'), findsOneWidget);
      expect(find.text('3. Implementation & Production Architecture'), findsOneWidget);

      // Switch to Coding Track
      await tester.tap(find.text('💻 Coding'));
      await tester.pumpAndSettle();
      expect(find.text('DSA Framework'), findsOneWidget);

      // Switch to Claude Track
      await tester.tap(find.text('🔮 Claude'));
      await tester.pumpAndSettle();
      expect(find.text('AI & MCP'), findsOneWidget);

      // Switch to Flutter Track
      await tester.ensureVisible(find.text('💙 Flutter'));
      await tester.tap(find.text('💙 Flutter'));
      await tester.pumpAndSettle();
      expect(find.text('Architecture'), findsOneWidget);
    });

    testWidgets('renders breadcrumb bar, bookmark toggle, pagination bar, and curriculum drawer', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: IosMasterHandbookScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Verify breadcrumb bar
      expect(find.text('Swift & iOS Prep'), findsOneWidget);
      expect(find.text('Bookmark'), findsOneWidget);
      expect(find.text('Mark Complete'), findsOneWidget);

      // Tap Bookmark
      await tester.tap(find.text('Bookmark'));
      await tester.pumpAndSettle();
      expect(find.text('Bookmarked'), findsOneWidget);

      // Tap Mark Complete
      await tester.tap(find.text('Mark Complete'));
      await tester.pumpAndSettle();
      expect(find.text('Completed'), findsOneWidget);

      // Verify bottom pagination
      expect(find.text('Previous'), findsOneWidget);
      expect(find.text('Next Concept'), findsOneWidget);

      // Tap Next Concept
      await tester.tap(find.text('Next Concept'));
      await tester.pumpAndSettle();

      // Open curriculum drawer
      await tester.tap(find.byIcon(Icons.menu_rounded));
      await tester.pumpAndSettle();

      // Verify drawer header & actions
      expect(find.text('Interview Spec & Reference'), findsWidgets);
      expect(find.text('📚 Open handyLearn Flutter Hub'), findsOneWidget);
    });
  });
}
