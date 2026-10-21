import 'package:flutter/material.dart';
import '../../challenges/screens/challenges_screen.dart';
import '../../cubit_and_state/screens/cubit_intro_screen.dart';
import '../../cubit_and_state/screens/state_concept_screen.dart';
import '../../lecture_slides/screens/lecture_slides_screen.dart';
import '../../repository_pattern/screens/user_directory_screen.dart';
import '../../stless_vs_stful/screens/stless_vs_stful_screen.dart';
import '../../ui_components/screens/ui_catalog_screen.dart';
import '../../certification/models/certification_models.dart';
import '../../certification/screens/unified_exam_runner_screen.dart';
import 'engine_internals_screen.dart';
import 'isolates_concurrency_screen.dart';

class _FlutterLessonItem {
  final String title;
  final String description;
  final String category;
  final String tag;
  final String masteryLevel;
  final IconData icon;
  final Color color;
  final Widget screen;

  const _FlutterLessonItem({
    required this.title,
    required this.description,
    required this.category,
    required this.tag,
    required this.masteryLevel,
    required this.icon,
    required this.color,
    required this.screen,
  });
}

/// Comprehensive Flutter & Dart Architecture Track Hub Screen.
class FlutterTrackHubScreen extends StatefulWidget {
  final bool hideAppBar;

  const FlutterTrackHubScreen({
    super.key,
    this.hideAppBar = false,
  });

  @override
  State<FlutterTrackHubScreen> createState() => _FlutterTrackHubScreenState();
}

class _FlutterTrackHubScreenState extends State<FlutterTrackHubScreen> {
  String _selectedCategory = 'All'; // 'All', 'UI & Layout', 'State & Arch', 'Engine & Performance'

  static const List<_FlutterLessonItem> _lessons = [
    _FlutterLessonItem(
      title: 'Basic UI Components',
      description: 'Foundational Flutter widgets: Text, Buttons, Layouts, Cards, Input fields, and Material 3 design tokens.',
      category: 'UI & Layout',
      tag: 'Foundation',
      masteryLevel: 'Basic',
      icon: Icons.widgets_rounded,
      color: Color(0xFF2563EB),
      screen: UiCatalogScreen(),
    ),
    _FlutterLessonItem(
      title: 'Stateless vs Stateful Lifecycle',
      description: 'Deep dive into widget lifecycle: build cycles, didUpdateWidget, dispose, and state hoisting patterns.',
      category: 'UI & Layout',
      tag: 'Lifecycle',
      masteryLevel: 'Basic',
      icon: Icons.refresh_rounded,
      color: Color(0xFF2563EB),
      screen: StlessVsStfulScreen(),
    ),
    _FlutterLessonItem(
      title: 'Cubit & State Management',
      description: 'Stream-based predictable state management with flutter_bloc, state immutability, and state-driven rebuilds.',
      category: 'State & Arch',
      tag: 'Bloc & Cubit',
      masteryLevel: 'Intermediate',
      icon: Icons.alt_route_rounded,
      color: Color(0xFF3B82F6),
      screen: CubitIntroScreen(),
    ),
    _FlutterLessonItem(
      title: 'Reactive Architecture: State Deep Dive',
      description: 'Comparison of setState vs InheritedWidget vs ValueNotifier vs BLoC architecture for complex enterprise state trees.',
      category: 'State & Arch',
      tag: 'Architecture',
      masteryLevel: 'Intermediate',
      icon: Icons.architecture_rounded,
      color: Color(0xFF3B82F6),
      screen: StateConceptScreen(),
    ),
    _FlutterLessonItem(
      title: 'Repository Pattern & Clean Architecture',
      description: 'Clean Architecture with separation of concerns: presentation cubit, domain contracts, and remote REST repository.',
      category: 'State & Arch',
      tag: 'Clean Arch',
      masteryLevel: 'Advanced',
      icon: Icons.folder_copy_rounded,
      color: Color(0xFF6366F1),
      screen: UserDirectoryScreen(),
    ),
    _FlutterLessonItem(
      title: 'Flutter Engine Internals & RenderBox',
      description: 'The 3 Trees (Widget, Element, RenderObject), one-pass BoxConstraints layout protocol, and custom paint shaders.',
      category: 'Engine & Performance',
      tag: '3-Trees Pipeline',
      masteryLevel: 'Master',
      icon: Icons.layers_rounded,
      color: Color(0xFF1D4ED8),
      screen: EngineInternalsScreen(),
    ),
    _FlutterLessonItem(
      title: 'Isolates & Heavy Concurrency Engine',
      description: 'Dart event loop, microtask queues, two-way ReceivePort/SendPort pipelines, compute(), and non-blocking background workers.',
      category: 'Engine & Performance',
      tag: 'Multi-Threading',
      masteryLevel: 'Master',
      icon: Icons.memory_rounded,
      color: Color(0xFF1D4ED8),
      screen: IsolatesConcurrencyScreen(),
    ),
    _FlutterLessonItem(
      title: 'Architecture Challenges & Sandboxes',
      description: 'Hands-on architectural debugging exercises: fix retain cycles, jank, memory leaks, and unbounded constraint errors.',
      category: 'Engine & Performance',
      tag: 'Coding Sandbox',
      masteryLevel: 'Advanced',
      icon: Icons.emoji_events_rounded,
      color: Color(0xFFF59E0B),
      screen: ChallengesScreen(),
    ),
  ];

  Color _levelColor(String level) {
    switch (level.toLowerCase()) {
      case 'basic':
        return const Color(0xFF10B981);
      case 'intermediate':
        return const Color(0xFF0284C7);
      case 'advanced':
        return const Color(0xFFEA580C);
      case 'master':
        return const Color(0xFF9333EA);
      default:
        return const Color(0xFF64748B);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final filtered = _lessons.where((lesson) {
      if (_selectedCategory == 'All') return true;
      return lesson.category == _selectedCategory;
    }).toList();

    return Scaffold(
      appBar: widget.hideAppBar
          ? null
          : AppBar(
              title: const Text('Flutter & Dart Architecture'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.co_present_rounded),
                  tooltip: 'Lecture Presentation Slides',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const LectureSlidesScreen()),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.workspace_premium_rounded, color: Color(0xFFF59E0B)),
                  tooltip: 'Take Flutter Master Exam',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const UnifiedExamRunnerScreen(track: ExamTrack.flutter),
                      ),
                    );
                  },
                ),
              ],
            ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Hero Banner
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [const Color(0xFF1E3A8A), const Color(0xFF172554)]
                    : [const Color(0xFF2563EB), const Color(0xFF1D4ED8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF2563EB).withAlpha(50),
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
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'FLUTTER ARCHITECTURE',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const Spacer(),
                    const Text(
                      '8 Core Modules',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  'Flutter & Dart Engine Mastery',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Master widget composition, reactive Cubit pipelines, 3-Trees rendering mechanics, and multi-isolate concurrency.',
                  style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.4),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Quick Sandbox Launchers
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildQuickChip(
                  icon: Icons.co_present_rounded,
                  label: 'Slides Deck',
                  color: const Color(0xFF2563EB),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const LectureSlidesScreen()),
                    );
                  },
                ),
                const SizedBox(width: 8),
                _buildQuickChip(
                  icon: Icons.layers_rounded,
                  label: 'RenderBox Inspector',
                  color: const Color(0xFF0284C7),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const EngineInternalsScreen()),
                    );
                  },
                ),
                const SizedBox(width: 8),
                _buildQuickChip(
                  icon: Icons.memory_rounded,
                  label: 'Isolates Lab',
                  color: const Color(0xFF7C3AED),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const IsolatesConcurrencyScreen()),
                    );
                  },
                ),
                const SizedBox(width: 8),
                _buildQuickChip(
                  icon: Icons.workspace_premium_rounded,
                  label: 'Flutter Master Exam',
                  color: const Color(0xFFD97706),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const UnifiedExamRunnerScreen(track: ExamTrack.flutter),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Category Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildCategoryFilter('All', Icons.apps_rounded),
                const SizedBox(width: 8),
                _buildCategoryFilter('UI & Layout', Icons.widgets_rounded),
                const SizedBox(width: 8),
                _buildCategoryFilter('State & Arch', Icons.alt_route_rounded),
                const SizedBox(width: 8),
                _buildCategoryFilter('Engine & Performance', Icons.layers_rounded),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Lesson Cards
          ...filtered.map((lesson) {
            return Card(
              elevation: 0,
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(
                  color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                ),
              ),
              color: isDark ? const Color(0xFF1E293B) : Colors.white,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => lesson.screen),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
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
                                    lesson.title,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: _levelColor(lesson.masteryLevel).withAlpha(25),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    lesson.masteryLevel,
                                    style: TextStyle(
                                      color: _levelColor(lesson.masteryLevel),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              lesson.description,
                              style: TextStyle(
                                fontSize: 12.5,
                                color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
                                height: 1.35,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary.withAlpha(15),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                lesson.tag,
                                style: TextStyle(
                                  color: theme.colorScheme.primary,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 14,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildQuickChip({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ActionChip(
      avatar: Icon(icon, size: 16, color: color),
      label: Text(label),
      labelStyle: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: color,
      ),
      onPressed: onTap,
    );
  }

  Widget _buildCategoryFilter(String category, IconData icon) {
    final isSelected = _selectedCategory == category;
    final theme = Theme.of(context);
    return ChoiceChip(
      selected: isSelected,
      avatar: Icon(
        icon,
        size: 16,
        color: isSelected ? Colors.white : theme.colorScheme.primary,
      ),
      label: Text(category),
      onSelected: (val) {
        if (val) setState(() => _selectedCategory = category);
      },
    );
  }
}
