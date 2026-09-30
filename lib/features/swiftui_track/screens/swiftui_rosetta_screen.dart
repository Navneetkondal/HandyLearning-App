import 'package:flutter/material.dart';
import '../../../core/widgets/code_snippet_card.dart';
import '../../../core/widgets/section_header.dart';

/// Interactive Rosetta Stone mapping Flutter concepts directly to SwiftUI concepts.
class SwiftUiRosettaScreen extends StatelessWidget {
  const SwiftUiRosettaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final comparisonItems = [
      _RosettaItem(
        concept: 'View / Component',
        flutter: 'StatelessWidget / StatefulWidget',
        swiftUi: 'struct MyView: View',
        description: 'Both are immutable declarative structs composed into hierarchical trees.',
      ),
      _RosettaItem(
        concept: 'UI Entry Point',
        flutter: 'Widget build(BuildContext context)',
        swiftUi: 'var body: some View { ... }',
        description: 'Computed property or method returning the visual blueprint.',
      ),
      _RosettaItem(
        concept: 'Horizontal Layout',
        flutter: 'Row(children: [ ... ])',
        swiftUi: 'HStack(spacing: 8) { ... }',
        description: 'Linear horizontal flex layout.',
      ),
      _RosettaItem(
        concept: 'Vertical Layout',
        flutter: 'Column(children: [ ... ])',
        swiftUi: 'VStack(spacing: 8) { ... }',
        description: 'Linear vertical flex layout.',
      ),
      _RosettaItem(
        concept: 'Depth Layering',
        flutter: 'Stack(children: [ ... ])',
        swiftUi: 'ZStack { ... }',
        description: 'Overlays views on the Z-axis (back to front).',
      ),
      _RosettaItem(
        concept: 'Expanding Flex Spacer',
        flutter: 'Spacer() or Expanded(child: ...)',
        swiftUi: 'Spacer()',
        description: 'Expands along the main axis to consume available space.',
      ),
      _RosettaItem(
        concept: 'Lazy Recycled List',
        flutter: 'ListView.builder(...)',
        swiftUi: 'List(items) { ... } or LazyVStack',
        description: 'Only instantiates items visible on screen (viewport recycling).',
      ),
      _RosettaItem(
        concept: 'Local Ephemeral State',
        flutter: 'StatefulWidget + setState(() => count++)',
        swiftUi: '@State private var count = 0',
        description: 'Widget-local mutable memory triggering redraw on mutation.',
      ),
      _RosettaItem(
        concept: 'Two-Way Parent Binding',
        flutter: 'ValueNotifier / Callback (onChanged: (val) => ...)',
        swiftUi: '@Binding var isSelected: Bool',
        description: 'Two-way pointer reference into parent state without copying.',
      ),
      _RosettaItem(
        concept: 'Business Logic / State Manager',
        flutter: 'Cubit (flutter_bloc) / ValueNotifier',
        swiftUi: '@Observable class ViewModel (iOS 17+)',
        description: 'Decoupled presentation business logic managing asynchronous states.',
      ),
      _RosettaItem(
        concept: 'Data Contract',
        flutter: 'abstract class UserRepository',
        swiftUi: 'protocol UserRepository',
        description: 'Abstract interface decoupling networking/storage from presentation.',
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter ➔ SwiftUI Rosetta Stone'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Banner
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [const Color(0xFF1E3A8A), const Color(0xFF1E293B)]
                    : [const Color(0xFF0284C7), const Color(0xFF0369A1)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cross-Platform Rosetta Stone',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'If you know Flutter, you already understand 80% of SwiftUI! Use this side-by-side mapping to translate concepts seamlessly.',
                  style: TextStyle(color: Colors.white, fontSize: 13, height: 1.4),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          const SectionHeader(
            title: 'Side-by-Side Concept Dictionary',
            subtitle: 'Direct equivalents between Flutter & Apple SwiftUI.',
            icon: Icons.compare_arrows_rounded,
            badgeText: 'Translation',
          ),

          ...comparisonItems.map((item) {
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.concept,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFF0284C7).withAlpha(18),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: const Color(0xFF0284C7).withAlpha(40)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Row(
                                  children: [
                                    Icon(Icons.flutter_dash, size: 14, color: Color(0xFF0284C7)),
                                    SizedBox(width: 4),
                                    Text('Flutter / Dart',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 11,
                                          color: Color(0xFF0284C7),
                                        )),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(item.flutter,
                                    style: const TextStyle(
                                      fontFamily: 'Courier',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    )),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFF7C3AED).withAlpha(18),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: const Color(0xFF7C3AED).withAlpha(40)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Row(
                                  children: [
                                    Icon(Icons.apple_rounded, size: 16, color: Color(0xFF7C3AED)),
                                    SizedBox(width: 4),
                                    Text('SwiftUI / Swift',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 11,
                                          color: Color(0xFF7C3AED),
                                        )),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(item.swiftUi,
                                    style: const TextStyle(
                                      fontFamily: 'Courier',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    )),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item.description,
                      style: TextStyle(
                        fontSize: 12,
                        color: theme.brightness == Brightness.dark ? Colors.white60 : const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),

          const CodeSnippetCard(
            title: 'Side-by-Side Declarative Code Structure',
            code: '''// Flutter:
class CounterButton extends StatelessWidget {
  final int count;
  final VoidCallback onTap;
  const CounterButton({required this.count, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      child: Text('Count: \$count'),
    );
  }
}

// SwiftUI:
struct CounterButton: View {
    let count: Int
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text("Count: \\(count)")
        }
    }
}''',
            explanation:
                'Both frameworks rely on immutable structs with simple data passing and closure callbacks.',
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _RosettaItem {
  final String concept;
  final String flutter;
  final String swiftUi;
  final String description;

  const _RosettaItem({
    required this.concept,
    required this.flutter,
    required this.swiftUi,
    required this.description,
  });
}
