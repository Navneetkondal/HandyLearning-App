import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:handy_learn/features/home/screens/home_dashboard_screen.dart';
import 'package:handy_learn/main.dart';

void main() {
  testWidgets('handyLearn premium engineering dashboard renders properly', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1200, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    // Build our app and trigger a frame.
    await tester.pumpWidget(const HandyLearnApp(initialHome: HomeDashboardScreen()));
    await tester.pump(const Duration(milliseconds: 200));

    // Verify Dashboard Title is present
    expect(find.text('handyLearn'), findsOneWidget);

    // Verify Welcome header
    expect(find.textContaining('Navneet'), findsOneWidget);
    expect(find.text('What would you like to master today?'), findsOneWidget);

    // Verify Search bar and quick pills
    expect(find.text('Search topics, domains, interview Q&A...'), findsOneWidget);
    expect(find.text('Swift Concurrency'), findsOneWidget);

    // Verify Continue Card
    expect(find.text('Recommended Path'), findsOneWidget);
    expect(find.text('iOS Senior & Lead Preparation'), findsOneWidget);

    // Verify Quick Action Rail
    expect(find.text('Interview Mode'), findsOneWidget);
    expect(find.text('System Design'), findsWidgets);

    // Verify Question of the Day
    expect(find.text('Question of the Day'), findsOneWidget);

    // Scroll to see Explore Tracks Grid
    final exploreFinder = find.text('Explore Tracks');
    final scrollableFinder = find.byType(Scrollable).first;
    await tester.scrollUntilVisible(exploreFinder, 200, scrollable: scrollableFinder);
    await tester.pump(const Duration(milliseconds: 100));

    expect(exploreFinder, findsOneWidget);
    expect(find.text('iOS Prep'), findsWidgets);
    expect(find.text('Flutter & UI'), findsWidgets);
    expect(find.text('Cloud & AI'), findsWidgets);
    expect(find.text('Coding & DSA'), findsWidgets);
    expect(find.text('Labs'), findsWidgets);
    expect(find.text('Certs'), findsWidgets);

    // Scroll further to see Recently Studied section
    final recentlyStudiedFinder = find.text('Recently Studied');
    await tester.scrollUntilVisible(recentlyStudiedFinder, 200, scrollable: scrollableFinder);
    await tester.pump(const Duration(milliseconds: 100));

    // Verify Recently Studied section
    expect(recentlyStudiedFinder, findsOneWidget);

    // Verify Theme toggle button works
    final themeToggleFinder = find.byIcon(Icons.dark_mode_rounded);
    expect(themeToggleFinder, findsOneWidget);
    await tester.tap(themeToggleFinder);
    await tester.pump(const Duration(milliseconds: 200));
  });

  testWidgets('handyLearn accessibility semantics and labels test', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1200, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    final SemanticsHandle handle = tester.ensureSemantics();
    await tester.pumpWidget(const HandyLearnApp(initialHome: HomeDashboardScreen()));
    await tester.pump(const Duration(milliseconds: 200));

    // Verify search suggestions have labeled semantics
    expect(
      find.byWidgetPredicate((w) => w is Semantics && (w.properties.label?.contains('Swift Concurrency') ?? false)),
      findsOneWidget,
    );

    // Verify daily challenge answer reveal toggle has proper accessible label
    expect(
      find.byWidgetPredicate((w) => w is Semantics && (w.properties.label?.contains('daily challenge answer') ?? false)),
      findsOneWidget,
    );

    handle.dispose();
  });
}
