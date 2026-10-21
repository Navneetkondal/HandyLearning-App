import 'package:flutter/material.dart';
import '../../../core/widgets/code_snippet_card.dart';
import '../models/swiftui_lesson.dart';
import '../../certification/models/certification_models.dart';
import '../../certification/screens/unified_exam_runner_screen.dart';
import 'swiftui_rosetta_screen.dart';
import 'swiftui_state_simulator_screen.dart';

/// Hub screen for the SwiftUI & Modern iOS track.
/// Features full curriculum from Basic ➔ Intermediate ➔ Advanced ➔ Master.
class SwiftUiHubScreen extends StatefulWidget {
  final bool hideAppBar;
  const SwiftUiHubScreen({super.key, this.hideAppBar = false});

  @override
  State<SwiftUiHubScreen> createState() => _SwiftUiHubScreenState();
}

class _SwiftUiHubScreenState extends State<SwiftUiHubScreen> {
  String _selectedTier = 'All'; // 'All', 'Basic', 'Intermediate', 'Advanced', 'Master'

  Color _tierColor(String tier) {
    switch (tier) {
      case 'Basic':
        return const Color(0xFF10B981);
      case 'Intermediate':
        return const Color(0xFF0284C7);
      case 'Advanced':
        return const Color(0xFFEA580C);
      case 'Master':
        return const Color(0xFF9333EA);
      default:
        return const Color(0xFF64748B);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final filteredLessons = _selectedTier == 'All'
        ? swiftUiLessons
        : swiftUiLessons.where((l) => l.masteryLevel == _selectedTier).toList();

    return Scaffold(
      appBar: widget.hideAppBar
          ? null
          : AppBar(
              title: const Text('SwiftUI & Modern iOS Track'),
        actions: [
          IconButton(
            icon: const Icon(Icons.play_circle_outline_rounded),
            tooltip: 'State & Binding Simulator',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const SwiftUiStateSimulatorScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.compare_arrows_rounded),
            tooltip: 'Flutter vs SwiftUI Rosetta Stone',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const SwiftUiRosettaScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.workspace_premium_rounded, color: Color(0xFFF59E0B)),
            tooltip: 'SwiftUI Certification Exam',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const UnifiedExamRunnerScreen(
                    track: ExamTrack.swiftui,
                  ),
                ),
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
                        'BASIC TO MASTER CURRICULUM',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 10.5,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'iOS 17+ • Swift 5.9+ • Metal',
                        textAlign: TextAlign.end,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.white70, fontSize: 11.5),
                      ),
                    ),
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
                  'From basic View protocols and Layout Stacks to Swift Concurrency Actors, AttributeGraph internals, and Metal shaders.',
                  style: TextStyle(color: Colors.white, fontSize: 13, height: 1.35),
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 10,
                  runSpacing: 8,
                  children: [
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF4F46E5),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const SwiftUiStateSimulatorScreen()),
                        );
                      },
                      icon: const Icon(Icons.play_arrow_rounded),
                      label: const Text('State & Binding Simulator'),
                    ),
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white70),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const SwiftUiRosettaScreen()),
                        );
                      },
                      icon: const Icon(Icons.compare_arrows_rounded),
                      label: const Text('Rosetta Stone'),
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD4AF37),
                        foregroundColor: Colors.black87,
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const UnifiedExamRunnerScreen(
                              track: ExamTrack.swiftui,
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.workspace_premium_rounded),
                      label: const Text('Certification Exam'),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // Mastery Level Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildTierChip('All', 'All (${swiftUiLessons.length})'),
                const SizedBox(width: 8),
                _buildTierChip('Basic', '🟢 Basic (2)'),
                const SizedBox(width: 8),
                _buildTierChip('Intermediate', '🟡 Intermediate (2)'),
                const SizedBox(width: 8),
                _buildTierChip('Advanced', '🟠 Advanced (2)'),
                const SizedBox(width: 8),
                _buildTierChip('Master', '🟣 Master (2)'),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // Section Title
          Row(
            children: [
              Expanded(
                child: Text(
                  _selectedTier == 'All'
                      ? 'All Lessons (Basic to Master)'
                      : '$_selectedTier Tier Lessons',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.3,
                  ),
                ),
              ),
              Text(
                '${filteredLessons.length} Modules',
                style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Lesson List
          ...filteredLessons.map((lesson) {
            final tColor = _tierColor(lesson.masteryLevel);

            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                                      color: tColor.withAlpha(30),
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(color: tColor.withAlpha(80)),
                                    ),
                                    child: Text(
                                      lesson.masteryLevel.toUpperCase(),
                                      style: TextStyle(
                                        color: tColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10,
                                        letterSpacing: 0.5,
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
                                style: const TextStyle(fontSize: 13, height: 1.35),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),

                    const SizedBox(height: 14),

                    // Swift Snippet Card
                    CodeSnippetCard(
                      title: 'SwiftUI Implementation',
                      language: 'swift',
                      code: lesson.swiftCodeSnippet,
                    ),

                    const SizedBox(height: 10),

                    // Flutter Equivalent Card
                    CodeSnippetCard(
                      title: 'Flutter Equivalent',
                      language: 'dart',
                      code: lesson.flutterEquivalentSnippet,
                    ),

                    const SizedBox(height: 12),

                    // Architectural Comparison
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.lightbulb_outline_rounded, size: 18, color: Colors.amber.shade700),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              lesson.architecturalExplanation,
                              style: const TextStyle(fontSize: 12, height: 1.35),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTierChip(String tier, String label) {
    final isSelected = _selectedTier == tier;
    final color = _tierColor(tier);

    return FilterChip(
      selected: isSelected,
      label: Text(label),
      selectedColor: color.withAlpha(40),
      labelStyle: TextStyle(
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        fontSize: 12,
        color: isSelected ? color : null,
      ),
      onSelected: (_) {
        setState(() => _selectedTier = tier);
      },
    );
  }
}
