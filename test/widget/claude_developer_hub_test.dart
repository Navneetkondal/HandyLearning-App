import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_learning_hub/features/claude_developer/screens/claude_developer_hub_screen.dart';
import 'package:flutter_learning_hub/features/claude_developer/screens/claude_tool_simulator_screen.dart';
import 'package:flutter_learning_hub/features/claude_developer/screens/claude_caching_calculator_screen.dart';
import 'package:flutter_learning_hub/features/claude_developer/screens/claude_developer_topic_detail_screen.dart';
import 'package:flutter_learning_hub/features/claude_developer/models/claude_developer_topic.dart';

void main() {
  testWidgets('ClaudeDeveloperHubScreen renders curriculum modules and launches labs', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: ClaudeDeveloperHubScreen(),
      ),
    );
    await tester.pumpAndSettle();

    // Verify title and header banner
    expect(find.text('Claude Developer Mastery'), findsOneWidget);
    expect(find.text('Become a Complete Claude Developer'), findsOneWidget);

    // Verify Labs
    expect(find.text('Tool Simulator'), findsOneWidget);
    expect(find.text('Caching ROI Calc'), findsOneWidget);
    expect(find.text('10-Question Timed Mock Exam Simulator'), findsOneWidget);

    // Verify Modules are visible via scrolling
    final listFinder = find.byType(Scrollable).first;
    final topic1Finder = find.text('Claude 3.7 Model Family & Extended Thinking');
    await tester.scrollUntilVisible(topic1Finder, 100, scrollable: listFinder);
    expect(topic1Finder, findsOneWidget);

    // Scroll to see remaining modules
    final agenticModuleFinder = find.text('Agentic Workflows & Multi-Agent Architecture');
    await tester.scrollUntilVisible(agenticModuleFinder, 200, scrollable: listFinder);
    expect(agenticModuleFinder, findsOneWidget);
  });

  testWidgets('ClaudeToolSimulatorScreen steps through full tool execution loop', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: ClaudeToolSimulatorScreen(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Interactive Tool Simulator'), findsOneWidget);
    expect(find.text('Step 1: User Request & Tool Definition'), findsOneWidget);

    final listFinder = find.byType(Scrollable).first;

    // Step 2
    final step2Btn = find.text('Step 2: Simulate Claude Call');
    await tester.scrollUntilVisible(step2Btn, 150, scrollable: listFinder);
    expect(step2Btn, findsOneWidget);
    await tester.tap(step2Btn);
    await tester.pumpAndSettle();

    expect(find.text('Step 2: Claude Returns `stop_reason: tool_use`'), findsOneWidget);

    // Step 3
    final step3Btn = find.text('Step 3: Execute Local Function');
    await tester.scrollUntilVisible(step3Btn, 150, scrollable: listFinder);
    expect(step3Btn, findsOneWidget);
    await tester.tap(step3Btn);
    await tester.pumpAndSettle();

    expect(find.text('Step 3: Client Tool Result Returned'), findsOneWidget);

    // Step 4
    final step4Btn = find.text('Step 4: Synthesize Final Answer');
    await tester.scrollUntilVisible(step4Btn, 150, scrollable: listFinder);
    expect(step4Btn, findsOneWidget);
    await tester.tap(step4Btn);
    await tester.pumpAndSettle();

    expect(find.text('Step 4: Claude Final Synthesized Output'), findsOneWidget);
    final restartBtn = find.text('Restart Interactive Simulation');
    await tester.scrollUntilVisible(restartBtn, 150, scrollable: listFinder);
    expect(restartBtn, findsOneWidget);
  });

  testWidgets('ClaudeCachingCalculatorScreen calculates 90% savings accurately', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: ClaudeCachingCalculatorScreen(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Prompt Caching ROI Calculator'), findsOneWidget);
    expect(find.text('Cut Enterprise API Bills by up to 90%'), findsOneWidget);
    expect(find.text('Estimated Monthly Savings'), findsOneWidget);
    expect(find.textContaining('% OFF'), findsOneWidget);
  });

  testWidgets('ClaudeDeveloperTopicDetailScreen switches between Guide, Code, and Best Practices', (WidgetTester tester) async {
    final sampleTopic = claudeDeveloperTopics.first;

    await tester.pumpWidget(
      MaterialApp(
        home: ClaudeDeveloperTopicDetailScreen(topic: sampleTopic),
      ),
    );
    await tester.pumpAndSettle();

    // Tab 1: Guide & Arch
    expect(find.text('Key Architectural Concepts'), findsOneWidget);
    await tester.drag(find.byKey(const Key('topicGuideListView')), const Offset(0, -300));
    await tester.pumpAndSettle();
    expect(find.text('In-Depth Reference Guide'), findsOneWidget);

    // Switch to Tab 2: SDK Code
    await tester.tap(find.text('SDK Code'));
    await tester.pumpAndSettle();

    expect(find.text('Python SDK (anthropic)'), findsOneWidget);
    expect(find.text('TypeScript (@anthropic-ai/sdk)'), findsOneWidget);
    expect(find.text('claude_example.py'), findsOneWidget);

    // Switch to TypeScript chip
    await tester.tap(find.text('TypeScript (@anthropic-ai/sdk)'));
    await tester.pumpAndSettle();
    expect(find.text('claude_example.ts'), findsOneWidget);

    // Switch to Tab 3: Best Practices
    await tester.tap(find.text('Best Practices'));
    await tester.pumpAndSettle();

    expect(find.text('Production Best Practices'), findsOneWidget);
    expect(find.text('Common Pitfalls to Avoid'), findsOneWidget);
  });
}
