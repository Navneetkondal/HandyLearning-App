import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/theme_cubit.dart';
import '../../ai_engineering/screens/ai_engineer_roadmap_screen.dart';
import '../../certification/screens/certifications_hub_screen.dart';
import '../../challenges/screens/challenges_screen.dart';
import '../../claude_certification/screens/claude_curriculum_screen.dart';
import '../../claude_developer/screens/claude_caching_calculator_screen.dart';
import '../../claude_developer/screens/claude_developer_hub_screen.dart';
import '../../claude_developer/screens/claude_tool_simulator_screen.dart';
import '../../cubit_and_state/screens/cubit_intro_screen.dart';
import '../../cubit_and_state/screens/state_concept_screen.dart';
import '../../flutter_advanced/screens/engine_internals_screen.dart';
import '../../flutter_advanced/screens/isolates_concurrency_screen.dart';
import '../../labs/screens/bpe_tokenizer_sandbox_screen.dart';
import '../../labs/screens/interactive_labs_screen.dart';
import '../../lecture_slides/screens/lecture_slides_screen.dart';
import '../../repository_pattern/screens/user_directory_screen.dart';
import '../../stless_vs_stful/screens/stless_vs_stful_screen.dart';
import '../../swiftui_track/screens/swiftui_hub_screen.dart';
import '../../swiftui_track/screens/swiftui_rosetta_screen.dart';
import '../../swiftui_track/screens/swiftui_state_simulator_screen.dart';
import '../../ui_components/screens/ui_catalog_screen.dart';

/// Main Dashboard of FlutterLearningHub.
/// Hosts 4 core navigation experiences:
/// 1. Curriculum Tracks (Flutter, SwiftUI, Claude Developer & Architect)
/// 2. AI Engineering Roadmap (27-Lesson Child-to-Master Curriculum)
/// 3. Professional Certification & Timed Exams Hub
/// 4. Interactive Runtime Labs & Sandboxes
class HomeDashboardScreen extends StatefulWidget {
  const HomeDashboardScreen({super.key});

  @override
  State<HomeDashboardScreen> createState() => _HomeDashboardScreenState();
}

class _HomeDashboardScreenState extends State<HomeDashboardScreen> {
  int _selectedBottomNavIndex = 0; // 0: Curriculum, 1: AI Roadmap, 2: Certifications, 3: Labs
  int _selectedTrackIndex = 0; // 0: All, 1: Flutter, 2: SwiftUI, 3: Claude, 4: Rosetta Stone, 5: Certification

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

    final allModules = [
      // ------------------------------------------
      // TRACK 1: FLUTTER & DART MODULES (Basic ➔ Master)
      // ------------------------------------------
      _LearningModule(
        trackId: 1,
        trackName: 'Flutter',
        title: 'Basic UI Components',
        description:
            'Interactive sandboxes for Row, Column, Stack, Buttons, Text, Inputs, Lists, Grids, and Dialogs.',
        icon: Icons.widgets_rounded,
        tag: 'Flutter UI',
        masteryLevel: 'Basic',
        color: const Color(0xFF2563EB),
        screen: const UiCatalogScreen(),
      ),
      _LearningModule(
        trackId: 1,
        trackName: 'Flutter',
        title: 'Stateless vs Stateful',
        description:
            'Deep dive into stless & stful, Widget Tree immutability, setState() mechanics, and the full State lifecycle.',
        icon: Icons.compare_arrows_rounded,
        tag: 'Fundamentals',
        masteryLevel: 'Basic',
        color: const Color(0xFF8B5CF6),
        screen: const StlessVsStfulScreen(),
      ),
      _LearningModule(
        trackId: 1,
        trackName: 'Flutter',
        title: 'Cubit & State Management',
        description:
            'Lightweight BLoC without boilerplate. Learn BlocProvider, BlocBuilder, BlocListener, and BlocConsumer.',
        icon: Icons.bolt_rounded,
        tag: 'State Mgmt',
        masteryLevel: 'Intermediate',
        color: const Color(0xFF0284C7),
        screen: const CubitIntroScreen(),
      ),
      _LearningModule(
        trackId: 1,
        trackName: 'Flutter',
        title: 'Repository Pattern & Data Flow',
        description:
            'Clean Architecture end-to-end: Model ➔ DataSource ➔ Repository Contract ➔ Cubit ➔ UI with failure simulation.',
        icon: Icons.account_tree_rounded,
        tag: 'Clean Arch',
        masteryLevel: 'Intermediate',
        color: const Color(0xFF0D9488),
        screen: const UserDirectoryScreen(),
      ),
      _LearningModule(
        trackId: 1,
        trackName: 'Flutter',
        title: 'State Architecture Principles',
        description:
            'Master UI = f(State), Ephemeral vs App State, Equatable value equality, and the 4 Canonical UI States.',
        icon: Icons.psychology_rounded,
        tag: 'Core Concepts',
        masteryLevel: 'Intermediate',
        color: const Color(0xFFEA580C),
        screen: const StateConceptScreen(),
      ),
      _LearningModule(
        trackId: 1,
        trackName: 'Flutter',
        title: 'Practice Coding Challenges',
        description:
            'Interactive challenges: Lightbulb setState(), SearchCubit with debouncing, and AuthRepository with retry.',
        icon: Icons.emoji_events_rounded,
        tag: 'Hands-On Lab',
        masteryLevel: 'Intermediate',
        color: const Color(0xFF10B981),
        screen: const ChallengesScreen(),
      ),
      _LearningModule(
        trackId: 1,
        trackName: 'Flutter',
        title: 'Isolates & Event Loop Concurrency',
        description:
            'Deep dive into the Dart single-threaded event loop, microtasks, background Isolate spawning, compute(), and zero-jank frame rendering.',
        icon: Icons.alt_route_rounded,
        tag: 'Concurrency Lab',
        masteryLevel: 'Advanced',
        color: const Color(0xFFEA580C),
        screen: const IsolatesConcurrencyScreen(),
      ),
      _LearningModule(
        trackId: 1,
        trackName: 'Flutter',
        title: 'Engine Internals & Custom RenderBox',
        description:
            'Explore the Three Trees (Widget ➔ Element ➔ RenderObject), the Layout protocol (constraints down, sizes up), and Dart FFI C/C++ dynamic bindings.',
        icon: Icons.layers_rounded,
        tag: 'Engine Architecture',
        masteryLevel: 'Master',
        color: const Color(0xFF9333EA),
        screen: const EngineInternalsScreen(),
      ),

      // ------------------------------------------
      // TRACK 2: SWIFTUI & MODERN IOS MODULES (Basic ➔ Master)
      // ------------------------------------------
      _LearningModule(
        trackId: 2,
        trackName: 'SwiftUI',
        title: 'SwiftUI & Modern iOS Track',
        description:
            'Declarative Apple UI: View protocols, Stacks (VStack/HStack/ZStack), @State, @Binding, @Observable, async/await, and Clean MVVM.',
        icon: Icons.apple_rounded,
        tag: 'iOS 17+ & Swift',
        masteryLevel: 'Master',
        color: const Color(0xFF4F46E5),
        screen: const SwiftUiHubScreen(),
      ),
      _LearningModule(
        trackId: 2,
        trackName: 'SwiftUI',
        title: 'SwiftUI State & Data Flow Simulator',
        description:
            'Interactive runtime lab: Test @State vs @Binding two-way data flow, iOS 17 @Observable tasks, and @Environment subtree propagation.',
        icon: Icons.play_circle_outline_rounded,
        tag: 'Interactive Lab',
        masteryLevel: 'Intermediate',
        color: const Color(0xFF6366F1),
        screen: const SwiftUiStateSimulatorScreen(),
      ),

      // ------------------------------------------
      // TRACK 3: CLAUDE DEVELOPER & ARCHITECT MODULES (Basic ➔ Master)
      // ------------------------------------------
      _LearningModule(
        trackId: 3,
        trackName: 'Claude',
        title: 'Become a Complete Claude Developer',
        description:
            'Comprehensive developer guide: Claude 3.7 Extended Thinking, Prompt Engineering, Tool Use, MCP, Claude Code, Caching, and 6 Agentic Workflows.',
        icon: Icons.psychology_rounded,
        tag: '9 Modules + Labs',
        masteryLevel: 'Master',
        color: const Color(0xFFD97706),
        screen: const ClaudeDeveloperHubScreen(),
      ),
      _LearningModule(
        trackId: 3,
        trackName: 'Claude',
        title: 'Claude Certified Architect Guide',
        description:
            'Based on https://claudecertificationguide.com/learn — Master the 5 official exam domains, 30 task modules, and Pearson VUE 10-Question Timed Mock Exam.',
        icon: Icons.school_rounded,
        tag: 'Timed Mock Exam',
        masteryLevel: 'Advanced',
        color: const Color(0xFFB45309),
        screen: const ClaudeCurriculumScreen(),
      ),
      _LearningModule(
        trackId: 3,
        trackName: 'Claude',
        title: 'Claude Tool Use & Function Calling Lab',
        description:
            'Step through the 4-step tool execution loop with JSON schemas, tool_use dispatch, self-correcting error handling, and answer synthesis.',
        icon: Icons.handyman_rounded,
        tag: 'Interactive Sandbox',
        masteryLevel: 'Intermediate',
        color: const Color(0xFF0D9488),
        screen: const ClaudeToolSimulatorScreen(),
      ),
      _LearningModule(
        trackId: 3,
        trackName: 'Claude',
        title: 'Prompt Caching 90% Cost Calculator',
        description:
            'Calculate dollar savings and latency drops across Sonnet 3.7, Haiku, and Opus workloads. Master 5-min TTL and cache breakpoints.',
        icon: Icons.savings_rounded,
        tag: 'ROI Calculator',
        masteryLevel: 'Advanced',
        color: const Color(0xFF0284C7),
        screen: const ClaudeCachingCalculatorScreen(),
      ),
      _LearningModule(
        trackId: 3,
        trackName: 'Claude',
        title: 'BPE Tokenizer & Context Window Lab',
        description:
            'Interactive Byte-Pair Encoding subword tokenization, character-to-token compression ratio, context capacity bar, and prompt cost estimation.',
        icon: Icons.token_rounded,
        tag: 'Subword & BPE',
        masteryLevel: 'Intermediate',
        color: const Color(0xFF6366F1),
        screen: const BpeTokenizerSandboxScreen(),
      ),
      _LearningModule(
        trackId: 3,
        trackName: 'Claude',
        title: 'Child-to-Master AI Engineer & Claude Roadmap',
        description:
            'From-scratch AI algorithms (Backprop, Attention, Tokenizers) to production Claude API, MCP, Subagents, and CCDV-F certification.',
        icon: Icons.alt_route_rounded,
        tag: 'Full Roadmap',
        masteryLevel: 'Master',
        color: const Color(0xFF6366F1),
        screen: const AiEngineerRoadmapScreen(),
      ),

      // ------------------------------------------
      // TRACK 4: FLUTTER VS SWIFTUI COMPARISON
      // ------------------------------------------
      _LearningModule(
        trackId: 4,
        trackName: 'Flutter vs SwiftUI',
        title: 'Flutter ➔ SwiftUI Rosetta Stone',
        description:
            'Direct side-by-side architectural mapping comparing Flutter widgets, Cubits, and layouts directly to their SwiftUI equivalents.',
        icon: Icons.compare_arrows_rounded,
        tag: 'Rosetta Stone',
        masteryLevel: 'Intermediate',
        color: const Color(0xFF6366F1),
        screen: const SwiftUiRosettaScreen(),
      ),

      // ------------------------------------------
      // TRACK 5: CERTIFICATIONS & TIMED MOCK EXAMS
      // ------------------------------------------
      _LearningModule(
        trackId: 5,
        trackName: 'Certification',
        title: 'Professional Certifications & Timed Exams',
        description:
            'Interactive timed mock exams for Flutter Master, Apple SwiftUI, and Claude Architect. Earn authenticated digital credentials.',
        icon: Icons.workspace_premium_rounded,
        tag: 'Credentials',
        masteryLevel: 'Master',
        color: const Color(0xFFD4AF37),
        screen: const CertificationsHubScreen(),
      ),
      _LearningModule(
        trackId: 5,
        trackName: 'Certification',
        title: 'AI Engineering from Scratch ➔ Claude Master',
        description:
            'Interactive 5-level curriculum linking aiengineeringfromscratch.com, Claude Academy, and official Pearson VUE CCDV-F exams.',
        icon: Icons.auto_awesome_rounded,
        tag: 'Curriculum',
        masteryLevel: 'Master',
        color: const Color(0xFF8B5CF6),
        screen: const AiEngineerRoadmapScreen(),
      ),
      _LearningModule(
        trackId: 5,
        trackName: 'Certification',
        title: 'Interactive Runtime Labs & Sandboxes',
        description:
            'Central playground with 6 live execution engines: MCP Tool Simulator, Caching ROI Calculator, BPE Tokenizer, SwiftUI State, and Concurrency Isolates.',
        icon: Icons.biotech_rounded,
        tag: '6 Playgrounds',
        masteryLevel: 'Master',
        color: const Color(0xFF0D9488),
        screen: const InteractiveLabsScreen(),
      ),
    ];

    final filteredModules = _selectedTrackIndex == 0
        ? allModules
        : allModules.where((m) => m.trackId == _selectedTrackIndex).toList();

    return Scaffold(
      // The Primary AppBar is rendered for Tab 0 (Curriculum Tracks)
      // Other tabs manage their own top bars
      appBar: _selectedBottomNavIndex == 0
          ? AppBar(
              title: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withAlpha(25),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.school_rounded, color: theme.colorScheme.primary, size: 22),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'Flutter Learning Hub',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              actions: [
                // Instant Dual Theme Switcher (First IconButton in AppBar for test compatibility)
                BlocBuilder<ThemeCubit, ThemeMode>(
                  builder: (context, themeMode) {
                    return IconButton(
                      icon: Icon(
                        isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                        color: isDark ? Colors.amber : const Color(0xFF334155),
                      ),
                      tooltip: isDark ? 'Switch to Light Mode' : 'Switch to Dark Mode',
                      onPressed: () {
                        context.read<ThemeCubit>().toggleTheme();
                      },
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.alt_route_rounded, color: Color(0xFF818CF8)),
                  tooltip: 'AI Engineer & Claude Mastery Roadmap',
                  onPressed: () {
                    setState(() => _selectedBottomNavIndex = 1);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.co_present_rounded),
                  tooltip: 'Lecture Presentation Slides',
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const LectureSlidesScreen()),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.workspace_premium_rounded, color: Color(0xFFF59E0B)),
                  tooltip: 'Certification & Exam Center',
                  onPressed: () {
                    setState(() => _selectedBottomNavIndex = 2);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.help_outline_rounded),
                  tooltip: 'Architecture Cheatsheet',
                  onPressed: () => _showCheatsheet(context),
                ),
              ],
            )
          : null,

      // Navigation Bar (Material 3 Bottom Navigation)
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedBottomNavIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedBottomNavIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.school_outlined),
            selectedIcon: Icon(Icons.school_rounded),
            label: 'Curriculum',
          ),
          NavigationDestination(
            icon: Icon(Icons.alt_route_outlined),
            selectedIcon: Icon(Icons.alt_route_rounded),
            label: 'AI Roadmap',
          ),
          NavigationDestination(
            icon: Icon(Icons.workspace_premium_outlined),
            selectedIcon: Icon(Icons.workspace_premium_rounded),
            label: 'Certifications',
          ),
          NavigationDestination(
            icon: Icon(Icons.biotech_outlined),
            selectedIcon: Icon(Icons.biotech_rounded),
            label: 'Labs',
          ),
        ],
      ),

      body: _buildCurrentTab(context, theme, isDark, allModules, filteredModules),
    );
  }

  Widget _buildCurrentTab(
    BuildContext context,
    ThemeData theme,
    bool isDark,
    List<_LearningModule> allModules,
    List<_LearningModule> filteredModules,
  ) {
    switch (_selectedBottomNavIndex) {
      case 1:
        return const AiEngineerRoadmapScreen();
      case 2:
        return const CertificationsHubScreen();
      case 3:
        return const InteractiveLabsScreen();
      case 0:
      default:
        return _buildCurriculumTab(context, theme, isDark, allModules, filteredModules);
    }
  }

  Widget _buildCurriculumTab(
    BuildContext context,
    ThemeData theme,
    bool isDark,
    List<_LearningModule> allModules,
    List<_LearningModule> filteredModules,
  ) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Hero Welcome Card
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDark
                  ? [const Color(0xFF1E3A8A), const Color(0xFF1E293B)]
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
                      color: Colors.white.withAlpha(50),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'MULTI-TRACK CURRICULUM',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Flutter • SwiftUI • Claude • AI',
                      textAlign: TextAlign.end,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.white70, fontSize: 11.5),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Text(
                'Multi-Platform & AI Engineering Hub',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Master Flutter architecture, native SwiftUI for iOS, Claude Developer & Architect tracks, and from-scratch AI algorithms from Apprentice to Master.',
                style: TextStyle(color: Colors.white, fontSize: 13, height: 1.4),
              ),
            ],
          ),
        ),

        const SizedBox(height: 14),

        // Quick Navigation Carousel Cards (AI Roadmap, Certifications, Labs)
        Row(
          children: [
            Expanded(
              child: _quickAccessCard(
                title: 'AI Roadmap',
                subtitle: '27 Lessons',
                icon: Icons.alt_route_rounded,
                color: const Color(0xFF6366F1),
                isDark: isDark,
                onTap: () => setState(() => _selectedBottomNavIndex = 1),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _quickAccessCard(
                title: 'Cert Center',
                subtitle: '3 Mock Exams',
                icon: Icons.workspace_premium_rounded,
                color: const Color(0xFFD97706),
                isDark: isDark,
                onTap: () => setState(() => _selectedBottomNavIndex = 2),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _quickAccessCard(
                title: 'Live Labs',
                subtitle: '6 Playgrounds',
                icon: Icons.biotech_rounded,
                color: const Color(0xFF0D9488),
                isDark: isDark,
                onTap: () => setState(() => _selectedBottomNavIndex = 3),
              ),
            ),
          ],
        ),

        const SizedBox(height: 14),

        // Certification & Exam Center Banner
        InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            setState(() => _selectedBottomNavIndex = 2);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [const Color(0xFF2B2516), const Color(0xFF1E1A11)]
                    : [const Color(0xFFFFFBEB), const Color(0xFFFEF3C7)],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFFD4AF37).withAlpha(120),
                width: 1.2,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFD4AF37).withAlpha(40),
                  ),
                  child: const Icon(
                    Icons.workspace_premium_rounded,
                    color: Color(0xFFD97706),
                    size: 26,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Text(
                            'Certification & Exam Center',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFB45309),
                            ),
                          ),
                          SizedBox(width: 6),
                          Icon(Icons.verified, size: 14, color: Color(0xFFD97706)),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Timed mock exams for Flutter, SwiftUI & Claude. Earn digital certificates.',
                        style: TextStyle(
                          fontSize: 11.5,
                          color: isDark ? Colors.grey.shade400 : Colors.brown.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: Color(0xFFD97706),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 12),

        // AI Engineering from Scratch ➔ Claude Master Banner
        InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            setState(() => _selectedBottomNavIndex = 1);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [const Color(0xFF1E1B4B), const Color(0xFF18153A)]
                    : [const Color(0xFFEEF2FF), const Color(0xFFE0E7FF)],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFF6366F1).withAlpha(120),
                width: 1.2,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF6366F1).withAlpha(40),
                  ),
                  child: const Icon(
                    Icons.auto_awesome_rounded,
                    color: Color(0xFF6366F1),
                    size: 26,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Text(
                            'AI Engineer from Scratch ➔ Claude Master',
                            style: TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF4F46E5),
                            ),
                          ),
                          SizedBox(width: 6),
                          Icon(Icons.bolt_rounded, size: 14, color: Color(0xFF6366F1)),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Child-to-Master roadmap: 27 comprehensive lessons, backprop, Claude API & CCDV-F blueprint.',
                        style: TextStyle(
                          fontSize: 11.5,
                          color: isDark ? Colors.grey.shade400 : Colors.indigo.shade800,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: Color(0xFF6366F1),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 14),

        // Overview stats row
        Row(
          children: [
            _buildStatBadge(context, '5 Tracks', 'Curriculum', Icons.school_rounded),
            const SizedBox(width: 8),
            _buildStatBadge(context, '27 Lessons', 'From Scratch', Icons.auto_awesome_rounded),
            const SizedBox(width: 8),
            _buildStatBadge(context, '6 Playgrounds', 'Live Labs', Icons.biotech_rounded),
          ],
        ),

        const SizedBox(height: 18),

        // Track Filter Chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildTrackChip(0, 'All Tracks (${allModules.length})', Icons.dashboard_rounded),
              const SizedBox(width: 8),
              _buildTrackChip(1, 'Flutter (8)', Icons.flutter_dash),
              const SizedBox(width: 8),
              _buildTrackChip(2, 'SwiftUI (2)', Icons.apple_rounded),
              const SizedBox(width: 8),
              _buildTrackChip(3, 'Claude Developer (6)', Icons.psychology_alt_rounded),
              const SizedBox(width: 8),
              _buildTrackChip(4, 'Flutter vs SwiftUI (1)', Icons.compare_arrows_rounded),
              const SizedBox(width: 8),
              _buildTrackChip(5, 'Certifications & Labs (3)', Icons.workspace_premium_rounded),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Section Title
        Text(
          _selectedTrackIndex == 0
              ? 'All Learning Modules'
              : (_selectedTrackIndex == 1
                  ? 'Flutter & Dart Architecture Modules'
                  : (_selectedTrackIndex == 2
                      ? 'SwiftUI & Modern iOS Modules'
                      : (_selectedTrackIndex == 3
                          ? 'Claude Developer & Architect Modules'
                          : (_selectedTrackIndex == 4
                              ? 'Flutter vs SwiftUI Rosetta Stone'
                              : 'Professional Certification & Exams')))),
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 12),

        // Module Cards List
        ...filteredModules.map((module) {
          return Card(
            margin: const EdgeInsets.only(bottom: 14),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => module.screen),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: module.color.withAlpha(25),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(module.icon, color: module.color, size: 28),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: _tierColor(module.masteryLevel).withAlpha(25),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: _tierColor(module.masteryLevel).withAlpha(120),
                                    width: 0.8,
                                  ),
                                ),
                                child: Text(
                                  module.masteryLevel.toUpperCase(),
                                  style: TextStyle(
                                    color: _tierColor(module.masteryLevel),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 9.5,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                decoration: BoxDecoration(
                                  color: module.color.withAlpha(25),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  module.tag,
                                  style: TextStyle(
                                    color: module.color,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            module.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            module.description,
                            style: TextStyle(
                              fontSize: 13,
                              height: 1.35,
                              color: isDark ? Colors.white70 : const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Padding(
                      padding: EdgeInsets.only(top: 14),
                      child: Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _quickAccessCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: color.withAlpha(60),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withAlpha(isDark ? 20 : 15),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withAlpha(25),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12.5,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 10.5,
                color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrackChip(int index, String label, IconData icon) {
    final isSelected = _selectedTrackIndex == index;
    final theme = Theme.of(context);

    return ChoiceChip(
      selected: isSelected,
      avatar: Icon(
        icon,
        size: 16,
        color: isSelected ? Colors.white : theme.colorScheme.primary,
      ),
      label: Text(label),
      onSelected: (val) {
        if (val) setState(() => _selectedTrackIndex = index);
      },
    );
  }

  Widget _buildStatBadge(BuildContext context, String value, String label, IconData icon) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
          ),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 16, color: theme.colorScheme.primary),
                const SizedBox(width: 6),
                Text(
                  value,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: isDark ? Colors.white60 : const Color(0xFF64748B),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCheatsheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (ctx) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (_, scrollCtrl) => ListView(
          controller: scrollCtrl,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          children: const [
            Text(
              'Architecture & Multi-Track Cheatsheet',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            _CheatsheetItem(
              title: '1. Flutter: UI = f(State)',
              body:
                  'Flutter is declarative. Never mutate widgets in place. State changes trigger new builds.',
            ),
            _CheatsheetItem(
              title: '2. Flutter: Cubit (flutter_bloc)',
              body:
                  'Functions emit states. Use BlocBuilder to render UI, BlocListener for side-effects, and BlocConsumer for both.',
            ),
            _CheatsheetItem(
              title: '3. Claude Architect: 5 Exam Domains',
              body:
                  'Domain 1: Agentic Loops (27%), Domain 2: Tool Design & MCP (18%), Domain 3: Claude Code (20%), Domain 4: Prompt Eng & XML (20%), Domain 5: Context & Caching (15%). Pass score: 720/1000.',
            ),
            _CheatsheetItem(
              title: '4. SwiftUI: Declarative Stacks & @Observable',
              body:
                  'SwiftUI views conform to View protocol. Use VStack/HStack/ZStack for layouts, @State for local values, and @Observable classes for ViewModels.',
            ),
            _CheatsheetItem(
              title: '5. Clean Architecture Equivalence',
              body:
                  'Both Flutter and SwiftUI implement Clean Architecture identically: Abstract interface (Dart abstract class / Swift protocol) separates networking from presentation.',
            ),
            _CheatsheetItem(
              title: '6. AI Engineering from Scratch',
              body:
                  'Tokens are statistical fragments (BPE). Backpropagation propagates error deltas via chain rule. Attention computes query-key dot product weights to aggregate value vectors.',
            ),
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _LearningModule {
  final int trackId;
  final String trackName;
  final String title;
  final String description;
  final IconData icon;
  final String tag;
  final String masteryLevel; // 'Basic', 'Intermediate', 'Advanced', 'Master'
  final Color color;
  final Widget screen;

  const _LearningModule({
    required this.trackId,
    required this.trackName,
    required this.title,
    required this.description,
    required this.icon,
    required this.tag,
    required this.masteryLevel,
    required this.color,
    required this.screen,
  });
}

class _CheatsheetItem extends StatelessWidget {
  final String title;
  final String body;

  const _CheatsheetItem({required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 3),
          Text(body, style: const TextStyle(fontSize: 13, height: 1.3, color: Colors.grey)),
        ],
      ),
    );
  }
}
