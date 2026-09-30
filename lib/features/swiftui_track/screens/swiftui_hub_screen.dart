import 'package:flutter/material.dart';
import '../../../core/widgets/code_snippet_card.dart';
import '../models/swiftui_lesson.dart';
import 'swiftui_rosetta_screen.dart';

/// Hub screen for the SwiftUI & Modern iOS track.
class SwiftUiHubScreen extends StatelessWidget {
  const SwiftUiHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('SwiftUI & Modern iOS Track'),
        actions: [
          IconButton(
            icon: const Icon(Icons.compare_arrows_rounded),
            tooltip: 'Flutter vs SwiftUI Rosetta Stone',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const SwiftUiRosettaScreen()),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Banner
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [const Color(0xFF1E1B4B), const Color(0xFF1E293B)]
                    : [const Color(0xFF4F46E5), const Color(0xFF4338CA)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF4F46E5).withAlpha(50),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(40),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'APPLE ECOSYSTEM TRACK',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const Spacer(),
                    const Text('iOS 17+ & Swift 5.9+',
                        style: TextStyle(color: Colors.white70, fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  'SwiftUI Architecture & Engineering',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Learn Apple declarative UI: View protocols, Stacks, Property Wrappers (@State, @Binding, @Observable), async/await, and Clean MVVM architecture.',
                  style: TextStyle(color: Colors.white, fontSize: 13, height: 1.35),
                ),
                const SizedBox(height: 14),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF4F46E5),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const SwiftUiRosettaScreen()),
                    );
                  },
                  icon: const Icon(Icons.compare_arrows_rounded),
                  label: const Text('Open Flutter ➔ SwiftUI Rosetta Stone'),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Section Title
          Text(
            'Core SwiftUI Lessons & Patterns',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 12),

          // Lesson List
          ...swiftUiLessons.map((lesson) {
            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: lesson.color.withAlpha(25),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(lesson.icon, color: lesson.color, size: 24),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      '${lesson.id}. ${lesson.title}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: lesson.color.withAlpha(25),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      lesson.tag,
                                      style: TextStyle(
                                        color: lesson.color,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 3),
                              Text(
                                lesson.subtitle,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isDark ? Colors.white60 : const Color(0xFF64748B),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Bullets
                    ...lesson.bulletPoints.map((point) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 6),
                              width: 5,
                              height: 5,
                              decoration: BoxDecoration(
                                color: lesson.color,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                point,
                                style: const TextStyle(fontSize: 12.5, height: 1.3),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),

                    const SizedBox(height: 12),

                    // Swift Code snippet
                    CodeSnippetCard(
                      title: 'SwiftUI Implementation',
                      code: lesson.swiftCodeSnippet,
                      language: 'swift',
                      explanation: lesson.architecturalExplanation,
                    ),

                    // Flutter Equivalent
                    CodeSnippetCard(
                      title: 'Flutter Equivalent Architecture',
                      code: lesson.flutterEquivalentSnippet,
                      language: 'dart',
                    ),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
