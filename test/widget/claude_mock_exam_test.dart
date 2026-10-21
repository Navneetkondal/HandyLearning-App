import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:handy_learn/features/claude_certification/screens/claude_mock_exam_screen.dart';

void main() {
  testWidgets('ClaudeMockExamScreen displays questions, accepts answers, and calculates score',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: ClaudeMockExamScreen(),
      ),
    );
    await tester.pumpAndSettle();

    // Verify Title and Timer
    expect(find.text('Claude Certified Architect Exam'), findsOneWidget);
    expect(find.byIcon(Icons.timer_outlined), findsOneWidget);

    // Verify Question 1 is shown
    expect(find.text('QUESTION 1 OF 10'), findsOneWidget);
    expect(find.text('Flag Question'), findsOneWidget);

    // Tap Flag
    await tester.tap(find.text('Flag Question'));
    await tester.pumpAndSettle();
    expect(find.text('Flagged for Review'), findsOneWidget);

    // Tap the first option
    final firstRadioFinder = find.byType(Radio<int>).first;
    expect(firstRadioFinder, findsWidgets);
    await tester.tap(firstRadioFinder);
    await tester.pumpAndSettle();

    // Tap Next Question
    final nextButtonFinder = find.text('Next Question');
    expect(nextButtonFinder, findsOneWidget);
    await tester.tap(nextButtonFinder);
    await tester.pumpAndSettle();

    // Verify Question 2 is shown
    expect(find.text('QUESTION 2 OF 10'), findsOneWidget);

    // Open Question Navigator
    final navigatorIconFinder = find.byIcon(Icons.grid_view_rounded);
    expect(navigatorIconFinder, findsOneWidget);
    await tester.tap(navigatorIconFinder);
    await tester.pumpAndSettle();

    expect(find.text('Question Navigator'), findsOneWidget);

    // Jump to Question 10 (index 9)
    final q10Finder = find.byKey(const Key('navigatorQuestionBtn_10'));
    expect(q10Finder, findsOneWidget);
    await tester.tap(q10Finder);
    await tester.pumpAndSettle();

    // Verify now at Question 10
    expect(find.text('QUESTION 10 OF 10'), findsOneWidget);
    expect(find.text('Submit Exam'), findsOneWidget);

    // Tap Submit Exam
    await tester.tap(find.text('Submit Exam'));
    await tester.pumpAndSettle();

    // Alert dialog pops up for unanswered questions
    expect(find.text('Unanswered Questions'), findsOneWidget);
    expect(find.text('Submit Anyway'), findsOneWidget);

    await tester.tap(find.text('Submit Anyway'));
    await tester.pumpAndSettle();

    // Now in Results & Diagnostic view
    expect(find.text('Exam Results & Diagnostic'), findsOneWidget);
    expect(find.text('Performance by Exam Domain'), findsOneWidget);

    final resultsListFinder = find.byType(Scrollable).first;
    final reviewSectionFinder = find.text('Detailed Question-by-Question Review');
    await tester.scrollUntilVisible(reviewSectionFinder, 200, scrollable: resultsListFinder);
    expect(reviewSectionFinder, findsOneWidget);
  });
}
