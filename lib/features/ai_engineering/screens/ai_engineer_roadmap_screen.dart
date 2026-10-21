import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/widgets/code_snippet_card.dart';
import '../../certification/models/certification_models.dart';
import '../../certification/screens/unified_exam_runner_screen.dart';
import '../../claude_developer/screens/claude_caching_calculator_screen.dart';
import '../../claude_developer/screens/claude_tool_simulator_screen.dart';
import '../models/ai_engineer_roadmap_models.dart';

/// Interactive AI Engineering from Scratch to Claude Certified Developer Roadmap Screen.
class AiEngineerRoadmapScreen extends StatefulWidget {
  final bool hideAppBar;
  const AiEngineerRoadmapScreen({super.key, this.hideAppBar = false});

  @override
  State<AiEngineerRoadmapScreen> createState() => _AiEngineerRoadmapScreenState();
}

class _AiEngineerRoadmapScreenState extends State<AiEngineerRoadmapScreen> {
  RoadmapTier? _selectedTier;
  String _searchQuery = '';
  final Set<String> _completedLessonIds = {};

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getStringList('ai_roadmap_completed_ids') ?? [];
      if (mounted) {
        setState(() {
          _completedLessonIds.addAll(saved);
        });
      }
    } catch (_) {}
  }

  Future<void> _toggleLessonCompletion(String id) async {
    setState(() {
      if (_completedLessonIds.contains(id)) {
        _completedLessonIds.remove(id);
      } else {
        _completedLessonIds.add(id);
      }
    });
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('ai_roadmap_completed_ids', _completedLessonIds.toList());
    } catch (_) {}
  }

  Color _tierColor(RoadmapTier tier) {
    switch (tier) {
      case RoadmapTier.apprentice:
        return const Color(0xFF10B981);
      case RoadmapTier.mechanist:
        return const Color(0xFF0284C7);
      case RoadmapTier.craftsman:
        return const Color(0xFF8B5CF6);
      case RoadmapTier.architect:
        return const Color(0xFFEA580C);
      case RoadmapTier.master:
        return const Color(0xFFD4AF37);
    }
  }

  String _tierName(RoadmapTier tier) {
    switch (tier) {
      case RoadmapTier.apprentice:
        return 'L1: Apprentice';
      case RoadmapTier.mechanist:
        return 'L2: Mechanist';
      case RoadmapTier.craftsman:
        return 'L3: Craftsman';
      case RoadmapTier.architect:
        return 'L4: Architect';
      case RoadmapTier.master:
        return 'L5: Master';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final filteredLessons = aiRoadmapLessons.where((lesson) {
      final matchesTier = _selectedTier == null || lesson.tier == _selectedTier;
      final q = _searchQuery.toLowerCase();
      final matchesQuery = q.isEmpty ||
          lesson.title.toLowerCase().contains(q) ||
          lesson.phaseOrCategory.toLowerCase().contains(q) ||
          lesson.ccdvDomainAlignment.toLowerCase().contains(q) ||
          lesson.childAnalogy.toLowerCase().contains(q);
      return matchesTier && matchesQuery;
    }).toList();

    final totalLessons = aiRoadmapLessons.length;
    final completedCount = _completedLessonIds.length;
    final progress = totalLessons > 0 ? (completedCount / totalLessons).clamp(0.0, 1.0) : 0.0;

    return Scaffold(
      appBar: widget.hideAppBar
          ? null
          : AppBar(
              title: const Text('AI Engineer & Claude Mastery'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.workspace_premium_rounded, color: Color(0xFFF59E0B)),
                  tooltip: 'Take Claude Mock Exam',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const UnifiedExamRunnerScreen(track: ExamTrack.claude),
                      ),
                    );
                  },
                ),
              ],
            ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Standardized Compact Progress & Roadmap Banner
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [const Color(0xFF1E1B4B), const Color(0xFF31104B)]
                    : [const Color(0xFFEEF2FF), const Color(0xFFFDF2F8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: const Color(0xFF6366F1).withAlpha(80),
                width: 1.0,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6366F1).withAlpha(30),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.psychology_rounded,
                        color: Color(0xFF6366F1),
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Child to Master AI Engineer Roadmap',
                            style: TextStyle(
                              fontSize: 14.5,
                              fontWeight: FontWeight.bold,
                              letterSpacing: -0.2,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '523 lessons • Claude Academy • Pearson VUE',
                            style: TextStyle(
                              fontSize: 11,
                              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withAlpha(25),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${(progress * 100).toInt()}% Done',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF10B981),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 4,
                          backgroundColor: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
                          color: const Color(0xFF10B981),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '$completedCount/$totalLessons',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                      ),
                    ),
                  ],
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
                _buildQuickActionChip(
                  icon: Icons.workspace_premium_rounded,
                  label: 'CCDV-F Mock Exam',
                  color: const Color(0xFFD4AF37),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const UnifiedExamRunnerScreen(track: ExamTrack.claude),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 8),
                _buildQuickActionChip(
                  icon: Icons.savings_rounded,
                  label: '90% Cache ROI Calc',
                  color: const Color(0xFF0284C7),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ClaudeCachingCalculatorScreen()),
                    );
                  },
                ),
                const SizedBox(width: 8),
                _buildQuickActionChip(
                  icon: Icons.handyman_rounded,
                  label: 'MCP Tool Simulator',
                  color: const Color(0xFF0D9488),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ClaudeToolSimulatorScreen()),
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Search Bar
          TextField(
            decoration: InputDecoration(
              hintText: 'Search algorithms, math, prompt tags, or tools...',
              prefixIcon: const Icon(Icons.search_rounded, size: 20),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, size: 18),
                      onPressed: () => setState(() => _searchQuery = ''),
                    )
                  : null,
              filled: true,
              fillColor: isDark ? const Color(0xFF1E293B) : Colors.grey.shade100,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
            onChanged: (val) => setState(() => _searchQuery = val),
          ),

          const SizedBox(height: 14),

          // Level Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                FilterChip(
                  selected: _selectedTier == null,
                  label: const Text('All 5 Levels'),
                  onSelected: (selected) {
                    setState(() => _selectedTier = null);
                  },
                ),
                const SizedBox(width: 8),
                ...RoadmapTier.values.map((tier) {
                  final isSelected = _selectedTier == tier;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      selected: isSelected,
                      label: Text(_tierName(tier)),
                      selectedColor: _tierColor(tier),
                      checkmarkColor: Colors.white,
                      labelStyle: TextStyle(
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected ? Colors.white : null,
                      ),
                      onSelected: (selected) {
                        setState(() {
                          _selectedTier = selected ? tier : null;
                        });
                      },
                    ),
                  );
                }),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Lesson Cards List
          if (filteredLessons.isEmpty)
            Container(
              padding: const EdgeInsets.all(32),
              alignment: Alignment.center,
              child: Column(
                children: [
                  Icon(Icons.search_off_rounded, size: 48, color: Colors.grey.shade400),
                  const SizedBox(height: 12),
                  const Text('No lessons match your search criteria.'),
                ],
              ),
            )
          else
            ...filteredLessons.map((lesson) {
              final isDone = _completedLessonIds.contains(lesson.id);
              return _buildLessonCard(context, lesson, isDone);
            }),
        ],
      ),
    );
  }

  Widget _buildQuickActionChip({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ActionChip(
      avatar: Icon(icon, color: color, size: 18),
      label: Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
      backgroundColor: color.withAlpha(25),
      side: BorderSide(color: color.withAlpha(100)),
      onPressed: onTap,
    );
  }

  Widget _buildLessonCard(BuildContext context, AiRoadmapLesson lesson, bool isDone) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isDone
              ? const Color(0xFF10B981).withAlpha(160)
              : (isDark ? Colors.grey.shade800 : Colors.grey.shade200),
          width: isDone ? 1.5 : 1.0,
        ),
      ),
      child: Theme(
        data: theme.copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: lesson.accentColor.withAlpha(isDark ? 50 : 30),
              shape: BoxShape.circle,
            ),
            child: Icon(lesson.icon, color: lesson.accentColor, size: 22),
          ),
          title: Row(
            children: [
              Expanded(
                child: Text(
                  lesson.title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    decoration: isDone ? TextDecoration.lineThrough : null,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  isDone ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                  color: isDone ? const Color(0xFF10B981) : Colors.grey.shade400,
                  size: 22,
                ),
                tooltip: isDone ? 'Mark as incomplete' : 'Mark as complete',
                onPressed: () => _toggleLessonCompletion(lesson.id),
              ),
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: _tierColor(lesson.tier).withAlpha(30),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      _tierName(lesson.tier),
                      style: TextStyle(
                        color: _tierColor(lesson.tier),
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      lesson.phaseOrCategory,
                      style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                '🎯 ${lesson.ccdvDomainAlignment}',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isDark ? const Color(0xFFFBBF24) : const Color(0xFFB45309),
                ),
              ),
            ],
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: DefaultTabController(
                length: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(),
                    const TabBar(
                      isScrollable: true,
                      tabAlignment: TabAlignment.start,
                      labelColor: Color(0xFF6366F1),
                      unselectedLabelColor: Colors.grey,
                      labelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                      tabs: [
                        Tab(icon: Icon(Icons.child_care_rounded, size: 16), text: "Child's Analogy"),
                        Tab(icon: Icon(Icons.science_rounded, size: 16), text: 'First Principles'),
                        Tab(icon: Icon(Icons.code_rounded, size: 16), text: 'Code Studio'),
                        Tab(icon: Icon(Icons.checklist_rounded, size: 16), text: 'Takeaways'),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 320,
                      child: TabBarView(
                        children: [
                          // Tab 1: Child Analogy
                          ListView(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF10B981).withAlpha(isDark ? 30 : 15),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: const Color(0xFF10B981).withAlpha(60),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Row(
                                      children: [
                                        Icon(Icons.child_care_rounded,
                                            size: 18, color: Color(0xFF10B981)),
                                        SizedBox(width: 8),
                                        Text(
                                          "Explain Like I'm 5 (ELIF5)",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                            color: Color(0xFF10B981),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      lesson.childAnalogy.trim(),
                                      style: TextStyle(
                                        fontSize: 13,
                                        height: 1.5,
                                        color: isDark ? Colors.grey.shade200 : Colors.grey.shade800,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          // Tab 2: First Principles Engineering
                          ListView(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF0284C7).withAlpha(isDark ? 30 : 15),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: const Color(0xFF0284C7).withAlpha(60),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Row(
                                      children: [
                                        Icon(Icons.precision_manufacturing_rounded,
                                            size: 18, color: Color(0xFF0284C7)),
                                        SizedBox(width: 8),
                                        Text(
                                          'First Principles & Rigorous Architecture',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                            color: Color(0xFF0284C7),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      lesson.engineeringExplanation.trim(),
                                      style: TextStyle(
                                        fontSize: 13,
                                        height: 1.5,
                                        color: isDark ? Colors.grey.shade200 : Colors.grey.shade800,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          // Tab 3: Code Studio
                          ListView(
                            children: [
                              Text(
                                'A. From-Scratch Algorithm (No Frameworks):',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
                                ),
                              ),
                              const SizedBox(height: 6),
                              CodeSnippetCard(
                                title: 'Pure Python Implementation',
                                language: 'python',
                                code: lesson.fromScratchSnippet.trim(),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'B. Production Claude API & MCP Implementation:',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
                                ),
                              ),
                              const SizedBox(height: 6),
                              CodeSnippetCard(
                                title: 'Anthropic SDK / TypeScript',
                                language: 'typescript',
                                code: lesson.claudeSnippet.trim(),
                              ),
                            ],
                          ),

                          // Tab 4: Takeaways & Certification Links
                          ListView(
                            children: [
                              ...lesson.keyTakeaways.map((point) => Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Icon(Icons.check_circle_outline_rounded,
                                            size: 16, color: Color(0xFF10B981)),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            point,
                                            style: const TextStyle(fontSize: 13, height: 1.4),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                              const SizedBox(height: 12),
                              OutlinedButton.icon(
                                icon: const Icon(Icons.open_in_new_rounded, size: 16),
                                label: Text('Read Curriculum: ${lesson.officialSourceName}'),
                                onPressed: () {
                                  Clipboard.setData(ClipboardData(text: lesson.officialSourceUrl));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('URL copied: ${lesson.officialSourceUrl}'),
                                      duration: const Duration(seconds: 3),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
