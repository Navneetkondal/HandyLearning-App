import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../ai_engineering/screens/ai_engineer_roadmap_screen.dart';
import '../../certification/models/certification_models.dart';
import '../../certification/screens/unified_exam_runner_screen.dart';
import '../../claude_certification/screens/claude_curriculum_screen.dart';
import '../models/claude_developer_topic.dart';
import 'claude_agent_loop_simulator_screen.dart';
import 'claude_caching_calculator_screen.dart';
import 'claude_developer_topic_detail_screen.dart';
import 'claude_tool_simulator_screen.dart';

/// Complete Claude Developer Mastery Hub.
/// Guides engineers from fundamental API calls to production-grade agentic architectures.
class ClaudeDeveloperHubScreen extends StatefulWidget {
  final bool hideAppBar;
  const ClaudeDeveloperHubScreen({super.key, this.hideAppBar = false});

  @override
  State<ClaudeDeveloperHubScreen> createState() => _ClaudeDeveloperHubScreenState();
}

class _ClaudeDeveloperHubScreenState extends State<ClaudeDeveloperHubScreen> {
  String _selectedTier = 'All'; // 'All', 'Basic', 'Intermediate', 'Advanced', 'Master'

  Color _tierColor(String tier) {
    switch (tier) {
      case 'Basic':
        return const Color(0xFF059669); // Emerald-600 (Accessible 4.5:1 with white)
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

  Widget _buildTierChip(String tier, String label) {
    final isSelected = _selectedTier == tier;
    final color = _tierColor(tier);

    return FilterChip(
      selected: isSelected,
      label: Text(label),
      labelStyle: TextStyle(
        fontSize: 12,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
        color: isSelected ? Colors.white : null,
      ),
      selectedColor: color,
      checkmarkColor: Colors.white,
      onSelected: (selected) {
        setState(() {
          _selectedTier = tier;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final filteredTopics = _selectedTier == 'All'
        ? claudeDeveloperTopics
        : claudeDeveloperTopics.where((t) => t.masteryLevel == _selectedTier).toList();

    final bodyContent = ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Hero Header Banner
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [const Color(0xFF78350F), const Color(0xFF1E293B)]
                    : [const Color(0xFFD97706), const Color(0xFFB45309)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFD97706).withAlpha(50),
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
                        'CLAUDE DEVELOPER TRACK',
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
                        '11 Modules • 4 Interactive Labs',
                        textAlign: TextAlign.end,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.white70, fontSize: 11.5),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  'Become a Complete Claude Developer',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'From SDK initialization to autonomous agentic loops, Model Context Protocol (MCP), and enterprise prompt caching.',
                  style: TextStyle(color: Colors.white, fontSize: 13, height: 1.35),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // Interactive Developer Sandboxes Row
          Text(
            'Interactive Developer Labs & Simulators',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 10),

          // Flagship Agent Loop Simulator Card
          _buildLabActionCard(
            context,
            title: 'Agentic Looping Simulator',
            subtitle: 'Evaluator-Optimizer, Tool Use Loop & Orchestrator Swarms',
            icon: Icons.all_inclusive_rounded,
            color: const Color(0xFF7C3AED),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ClaudeAgentLoopSimulatorScreen()),
              );
            },
          ),
          const SizedBox(height: 8),

          Row(
            children: [
              Expanded(
                child: _buildLabActionCard(
                  context,
                  title: 'Tool Simulator',
                  subtitle: 'tool_use ➔ tool_result loop',
                  icon: Icons.handyman_rounded,
                  color: const Color(0xFF0D9488),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ClaudeToolSimulatorScreen()),
                    );
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildLabActionCard(
                  context,
                  title: 'Caching ROI Calc',
                  subtitle: '90% savings & latency',
                  icon: Icons.savings_rounded,
                  color: const Color(0xFF0284C7),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ClaudeCachingCalculatorScreen()),
                    );
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Exam and Certification Banner
          InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const UnifiedExamRunnerScreen(
                    track: ExamTrack.claude,
                  ),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : const Color(0xFFFEF3C7),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFD97706).withAlpha(120)),
              ),
              child: Row(
                children: const [
                  CircleAvatar(
                    backgroundColor: Color(0xFFD97706),
                    child: Icon(Icons.quiz_rounded, color: Colors.white, size: 20),
                  ),
                  SizedBox(width: 12),
                ] + [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '10-Question Timed Mock Exam Simulator',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Pearson VUE 1000-point scoring • Domain performance diagnostics',
                          style: TextStyle(fontSize: 11.5, color: AppColors.textSub(isDark)),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Color(0xFFD97706)),
                ],
              ),
            ),
          ),

          const SizedBox(height: 10),

          // AI Engineering from Scratch ➔ Claude Master Banner
          InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AiEngineerRoadmapScreen()),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark
                      ? [const Color(0xFF1E1B4B), const Color(0xFF2E1065)]
                      : [const Color(0xFFEEF2FF), const Color(0xFFFAF5FF)],
                ),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: const Color(0xFF8B5CF6).withAlpha(120),
                  width: 1.2,
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.alt_route_rounded, color: Color(0xFF8B5CF6), size: 28),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'AI Engineering from Scratch Roadmap',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Child-to-Master progression: 523 lessons across 20 phases & Claude CCDV-F',
                          style: TextStyle(fontSize: 11.5, color: AppColors.textSub(isDark)),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Color(0xFF8B5CF6)),
                ],
              ),
            ),
          ),

          const SizedBox(height: 18),

          // Mastery Level Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildTierChip('All', 'All (${claudeDeveloperTopics.length})'),
                const SizedBox(width: 8),
                _buildTierChip('Basic', '🟢 Basic (2)'),
                const SizedBox(width: 8),
                _buildTierChip('Intermediate', '🟡 Intermediate (3)'),
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
                      ? 'Complete Curriculum (9 Core Modules)'
                      : '$_selectedTier Curriculum (${filteredTopics.length} Modules)',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.3,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Zero to Architect',
                style: TextStyle(fontSize: 12, color: AppColors.textSub(isDark), fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Topic Cards List
          ...filteredTopics.map((topic) {
            final originalIdx = claudeDeveloperTopics.indexOf(topic);

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ClaudeDeveloperTopicDetailScreen(topic: topic),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: topic.accentColor.withAlpha(25),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(topic.icon, color: topic.accentColor, size: 26),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'MODULE ${originalIdx + 1}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10.5,
                                    color: topic.accentColor,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                                  decoration: BoxDecoration(
                                    color: _tierColor(topic.masteryLevel).withAlpha(30),
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                      color: _tierColor(topic.masteryLevel).withAlpha(140),
                                      width: 0.8,
                                    ),
                                  ),
                                  child: Text(
                                    topic.masteryLevel.toUpperCase(),
                                    style: TextStyle(
                                      fontSize: 9.5,
                                      fontWeight: FontWeight.bold,
                                      color: _tierColor(topic.masteryLevel),
                                      letterSpacing: 0.4,
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                Flexible(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.surfaceContainerHighest,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      topic.category,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              topic.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              topic.summary,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark ? Colors.white70 : Colors.black87,
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      );

    if (widget.hideAppBar) {
      return bodyContent;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Claude Developer Mastery'),
        actions: [
          IconButton(
            icon: const Icon(Icons.alt_route_rounded, color: Color(0xFF818CF8)),
            tooltip: 'AI Engineer & Claude Roadmap',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AiEngineerRoadmapScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.school_rounded),
            tooltip: 'Certification Guide',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ClaudeCurriculumScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.workspace_premium_rounded, color: Color(0xFFF59E0B)),
            tooltip: 'Claude Certification Exam',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const UnifiedExamRunnerScreen(
                    track: ExamTrack.claude,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: bodyContent,
    );
  }

  Widget _buildLabActionCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withAlpha(80)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withAlpha(30),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11,
                color: AppColors.textSub(Theme.of(context).brightness == Brightness.dark),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
