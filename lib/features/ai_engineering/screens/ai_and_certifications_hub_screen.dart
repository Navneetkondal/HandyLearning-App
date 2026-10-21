import 'package:flutter/material.dart';
import '../../certification/models/certification_models.dart';
import '../../certification/screens/certifications_hub_screen.dart';
import '../../certification/screens/unified_exam_runner_screen.dart';
import '../../claude_developer/screens/claude_developer_hub_screen.dart';
import 'ai_engineer_roadmap_screen.dart';

/// Unified Hub combining AI Engineering & Claude Mastery with Professional Certifications.
class AiAndCertificationsHubScreen extends StatefulWidget {
  final int initialSubTab; // 0: AI & Claude Roadmap, 1: Certifications & Exams

  const AiAndCertificationsHubScreen({
    super.key,
    this.initialSubTab = 0,
  });

  @override
  State<AiAndCertificationsHubScreen> createState() =>
      _AiAndCertificationsHubScreenState();
}

class _AiAndCertificationsHubScreenState
    extends State<AiAndCertificationsHubScreen> {
  late int _selectedSubTab;

  @override
  void initState() {
    super.initState();
    _selectedSubTab = widget.initialSubTab;
  }

  @override
  void didUpdateWidget(covariant AiAndCertificationsHubScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialSubTab != widget.initialSubTab) {
      _selectedSubTab = widget.initialSubTab;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFF6366F1).withAlpha(25),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.psychology_rounded,
                color: Color(0xFF6366F1),
                size: 22,
              ),
            ),
            const SizedBox(width: 10),
            const Expanded(
              child: Text(
                'AI & Certifications',
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: [
          if (_selectedSubTab == 0)
            IconButton(
              icon: const Icon(Icons.workspace_premium_rounded, color: Color(0xFFF59E0B)),
              tooltip: 'Launch Claude Mock Exam',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        const UnifiedExamRunnerScreen(track: ExamTrack.claude),
                  ),
                );
              },
            ),
        ],
      ),
      body: Column(
        children: [
          // Sub-Tab Switcher (Sleek Material 3 compact pills - standardized height)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
              border: Border(
                bottom: BorderSide(
                  color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                  width: 0.8,
                ),
              ),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ChoiceChip(
                    selected: _selectedSubTab == 0,
                    visualDensity: VisualDensity.compact,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    labelPadding: const EdgeInsets.symmetric(horizontal: 4),
                    avatar: Icon(
                      Icons.alt_route_rounded,
                      size: 14,
                      color: _selectedSubTab == 0
                          ? Colors.white
                          : const Color(0xFF6366F1),
                    ),
                    label: const Text('Beginner to AI Eng'),
                    selectedColor: const Color(0xFF4F46E5),
                    backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                    side: BorderSide(
                      color: _selectedSubTab == 0
                          ? const Color(0xFF4F46E5)
                          : (isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1)),
                      width: 0.8,
                    ),
                    labelStyle: TextStyle(
                      color: _selectedSubTab == 0
                          ? Colors.white
                          : (isDark ? Colors.white70 : const Color(0xFF334155)),
                      fontWeight:
                          _selectedSubTab == 0 ? FontWeight.bold : FontWeight.w500,
                      fontSize: 11.5,
                    ),
                    onSelected: (val) {
                      if (val) setState(() => _selectedSubTab = 0);
                    },
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    selected: _selectedSubTab == 1,
                    visualDensity: VisualDensity.compact,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    labelPadding: const EdgeInsets.symmetric(horizontal: 4),
                    avatar: Icon(
                      Icons.psychology_rounded,
                      size: 14,
                      color: _selectedSubTab == 1
                          ? Colors.white
                          : const Color(0xFF8B5CF6),
                    ),
                    label: const Text('Claude Master Hub'),
                    selectedColor: const Color(0xFF7C3AED),
                    backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                    side: BorderSide(
                      color: _selectedSubTab == 1
                          ? const Color(0xFF7C3AED)
                          : (isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1)),
                      width: 0.8,
                    ),
                    labelStyle: TextStyle(
                      color: _selectedSubTab == 1
                          ? Colors.white
                          : (isDark ? Colors.white70 : const Color(0xFF334155)),
                      fontWeight:
                          _selectedSubTab == 1 ? FontWeight.bold : FontWeight.w500,
                      fontSize: 11.5,
                    ),
                    onSelected: (val) {
                      if (val) setState(() => _selectedSubTab = 1);
                    },
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    selected: _selectedSubTab == 2,
                    visualDensity: VisualDensity.compact,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    labelPadding: const EdgeInsets.symmetric(horizontal: 4),
                    avatar: Icon(
                      Icons.workspace_premium_rounded,
                      size: 14,
                      color: _selectedSubTab == 2
                          ? Colors.white
                          : const Color(0xFFD97706),
                    ),
                    label: const Text('Certifications & Exams'),
                    selectedColor: const Color(0xFFD97706),
                    backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                    side: BorderSide(
                      color: _selectedSubTab == 2
                          ? const Color(0xFFD97706)
                          : (isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1)),
                      width: 0.8,
                    ),
                    labelStyle: TextStyle(
                      color: _selectedSubTab == 2
                          ? Colors.white
                          : (isDark ? Colors.white70 : const Color(0xFF334155)),
                      fontWeight:
                          _selectedSubTab == 2 ? FontWeight.bold : FontWeight.w500,
                      fontSize: 11.5,
                    ),
                    onSelected: (val) {
                      if (val) setState(() => _selectedSubTab = 2);
                    },
                  ),
                ],
              ),
            ),
          ),

          // IndexedStack preserves active scroll & completion progress
          Expanded(
            child: IndexedStack(
              index: _selectedSubTab,
              children: const [
                AiEngineerRoadmapScreen(hideAppBar: true),
                ClaudeDeveloperHubScreen(hideAppBar: true),
                CertificationsHubScreen(hideAppBar: true),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
