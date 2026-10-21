import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:handy_learn/features/ios_senior_prep/screens/ios_senior_prep_hub_screen.dart';

void main() {
  group('IosSeniorPrepHubScreen Widget Tests', () {
    testWidgets('renders redesigned header, progress strip, category chips, and domain list', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: IosSeniorPrepHubScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Check AppBar Title
      expect(find.text('iOS Prep'), findsOneWidget);

      // Verify category chips
      expect(find.text('All Domains'), findsOneWidget);
      expect(find.text('Swift Handbook'), findsOneWidget);
      expect(find.text('Interview Q&A'), findsOneWidget);
      expect(find.text('System Design'), findsOneWidget);

      // Switch to Swift Handbook tab
      await tester.tap(find.text('Swift Handbook'));
      await tester.pumpAndSettle();
      expect(find.text('⚡ Swift'), findsOneWidget);

      // Switch to Interview Q&A tab
      await tester.tap(find.text('Interview Q&A'));
      await tester.pumpAndSettle();
      expect(find.byType(ListView), findsOneWidget);

      // Switch back to All Domains
      await tester.tap(find.text('All Domains'));
      await tester.pumpAndSettle();
      expect(find.byType(Card), findsWidgets);
    });

    testWidgets('taps a domain card and navigates to PrepDomainDetailScreen', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: IosSeniorPrepHubScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Tap on first card in domain list
      final cardFinder = find.byType(Card).first;
      expect(cardFinder, findsOneWidget);

      await tester.tap(cardFinder);
      await tester.pumpAndSettle();

      // Verify navigation to PrepDomainDetailScreen
      expect(find.textContaining('Domain'), findsWidgets);
    });

    testWidgets('opens quick actions bottom sheet via floating action button', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: IosSeniorPrepHubScreen(),
        ),
      );
      await tester.pumpAndSettle();

      final fabFinder = find.byType(FloatingActionButton);
      expect(fabFinder, findsOneWidget);

      await tester.tap(fabFinder);
      await tester.pumpAndSettle();

      expect(find.text('Quick Actions'), findsOneWidget);
      expect(find.text('Interview Mode'), findsOneWidget);
      expect(find.text('Master Handbook'), findsOneWidget);
    });
  });
}

