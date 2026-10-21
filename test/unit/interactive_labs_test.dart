import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:handy_learn/features/labs/screens/bpe_tokenizer_sandbox_screen.dart';
import 'package:handy_learn/features/labs/screens/interactive_labs_screen.dart';

void main() {
  group('Interactive Labs & Sandboxes Tests', () {
    testWidgets('InteractiveLabsScreen renders all 6 runtime playgrounds',
        (WidgetTester tester) async {
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
      expect(find.text('Test, Simulate & Benchmark'), findsOneWidget);
      expect(find.text('9 Interactive Sandboxes'), findsOneWidget);

      expect(find.text('Claude Agentic Looping Simulator'), findsOneWidget);
      expect(find.text('Claude MCP Tool Use Simulator'), findsOneWidget);
      expect(find.text('Prompt Caching 90% ROI Calculator'), findsOneWidget);
      expect(find.text('BPE Tokenizer & Context Explorer'), findsOneWidget);
      expect(find.text('SwiftUI State & Data Flow Simulator'), findsOneWidget);
      expect(find.text('Dart Isolates & Concurrency Engine'), findsOneWidget);
      expect(find.text('Flutter Engine Internals Inspector'), findsOneWidget);
    });

    testWidgets('BpeTokenizerSandboxScreen tokenizes text, calculates stats and updates presets',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        const MaterialApp(
          home: BpeTokenizerSandboxScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('BPE Tokenizer & Context Lab'), findsOneWidget);
      expect(find.text('Byte-Pair Encoding (BPE) & Context'), findsOneWidget);
      expect(find.text('Visualized Subword Token Stream'), findsOneWidget);

      // Verify token metric cards exist
      expect(find.text('Tokens'), findsOneWidget);
      expect(find.text('Characters'), findsOneWidget);
      expect(find.text('Chars/Token'), findsOneWidget);

      // Verify Presets are present and clickable
      final pythonPresetFinder = find.text('Python Code');
      expect(pythonPresetFinder, findsOneWidget);
      await tester.tap(pythonPresetFinder);
      await tester.pumpAndSettle();

      // Verify text changed and new tokens generated
      expect(find.textContaining('backprop'), findsWidgets);
    });
  });
}
