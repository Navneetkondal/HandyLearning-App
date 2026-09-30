import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_learning_hub/main.dart';

void main() {
  testWidgets('FlutterLearningHub multi-track dashboard renders properly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const FlutterLearningHubApp());
    await tester.pumpAndSettle();

    // Verify Dashboard Title is present
    expect(find.text('Flutter Learning Hub'), findsOneWidget);

    // Verify Welcome Card is present
    expect(find.text('Multi-Platform & AI Engineering Hub'), findsOneWidget);

    // Verify Multi-Track Header
    expect(find.text('MULTI-TRACK CURRICULUM'), findsOneWidget);

    // Verify initial Module Cards exist
    final listFinder = find.byType(Scrollable).first;
    final basicUiFinder = find.text('Basic UI Components');
    await tester.scrollUntilVisible(basicUiFinder, 100, scrollable: listFinder);
    expect(basicUiFinder, findsOneWidget);

    final stlessFinder = find.text('Stateless vs Stateful');
    await tester.scrollUntilVisible(stlessFinder, 100, scrollable: listFinder);
    expect(stlessFinder, findsOneWidget);
    final cubitCardFinder = find.text('Cubit & State Management');
    await tester.scrollUntilVisible(cubitCardFinder, 200, scrollable: listFinder);
    expect(cubitCardFinder, findsOneWidget);

    final swiftCardFinder = find.text('SwiftUI & Modern iOS Track');
    await tester.scrollUntilVisible(swiftCardFinder, 200, scrollable: listFinder);
    expect(swiftCardFinder, findsOneWidget);

    final claudeDevCardFinder = find.text('Become a Complete Claude Developer');
    await tester.scrollUntilVisible(claudeDevCardFinder, 200, scrollable: listFinder);
    expect(claudeDevCardFinder, findsOneWidget);

    final claudeCardFinder = find.text('Claude Certified Architect Guide');
    await tester.scrollUntilVisible(claudeCardFinder, 200, scrollable: listFinder);
    expect(claudeCardFinder, findsOneWidget);

    // Verify Theme toggle button works
    final themeToggleFinder = find.byType(IconButton).first;
    expect(themeToggleFinder, findsOneWidget);
    await tester.tap(themeToggleFinder);
    await tester.pumpAndSettle();

    // Test Claude Track Navigation
    await tester.tap(claudeCardFinder);
    await tester.pumpAndSettle();

    expect(find.text('Claude Architect Certification'), findsOneWidget);
    expect(find.text('60 Qs'), findsOneWidget);
    expect(find.text('10-Question Timed Mock Exam'), findsOneWidget);

    // Launch Mock Exam from banner
    final startExamBtn = find.byKey(const Key('launchMockExamButton'));
    expect(startExamBtn, findsOneWidget);
    await tester.tap(startExamBtn);
    await tester.pumpAndSettle();

    expect(find.text('Claude Certified Architect Exam'), findsOneWidget);
    expect(find.text('QUESTION 1 OF 10'), findsOneWidget);

    // Pop back from Mock Exam to Curriculum
    final examBackButton = find.byType(BackButton);
    await tester.tap(examBackButton);
    await tester.pumpAndSettle();

    expect(find.text('Domain 1: Agentic Architecture & Orchestration'), findsOneWidget);

    // Pop back to home
    final backButton = find.byType(BackButton);
    await tester.tap(backButton);
    await tester.pumpAndSettle();

    // Open Lecture Presentation Slides from AppBar
    final slidesButtonFinder = find.byTooltip('Lecture Presentation Slides');
    expect(slidesButtonFinder, findsOneWidget);
    await tester.tap(slidesButtonFinder);
    await tester.pumpAndSettle();

    // Verify Slide 1 loaded
    expect(find.text('The Flutter Mental Model'), findsOneWidget);
    expect(find.text('Next Slide'), findsOneWidget);

    // Tap Next Slide
    await tester.tap(find.text('Next Slide'));
    await tester.pumpAndSettle();
    expect(find.text('UI Components & Box Constraints'), findsOneWidget);
  });
}
