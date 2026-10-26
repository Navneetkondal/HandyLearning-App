import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_cubit.dart';
import '../../../core/utils/app_haptics.dart';
import '../../../core/widgets/pressable_scale.dart';
import '../../ai_engineering/screens/ai_and_certifications_hub_screen.dart';
import '../../coding_dsa/screens/coding_dsa_hub_screen.dart';
import '../../ios_senior_prep/data/ios_prep_master_hierarchy_data.dart';
import '../../ios_senior_prep/models/ios_prep_hierarchy_models.dart';
import '../../ios_senior_prep/screens/ios_master_handbook_screen.dart';
import '../../ios_senior_prep/screens/ios_prep_git_masterclass_screen.dart';
import '../../ios_senior_prep/screens/ios_prep_global_search_screen.dart';
import '../../ios_senior_prep/screens/ios_prep_interview_mode_screen.dart';
import '../../ios_senior_prep/screens/ios_prep_staff_signals_screen.dart';
import '../../ios_senior_prep/screens/ios_prep_system_design_screen.dart';
import '../../ios_senior_prep/screens/ios_prep_topic_detail_screen.dart';
import '../../ios_senior_prep/screens/ios_senior_prep_hub_screen.dart';
import '../../ios_senior_prep/services/prep_progress_service.dart';
import '../../labs/screens/interactive_labs_screen.dart';
import '../../mobile_dev/screens/mobile_dev_hub_screen.dart';

/// Redesigned Home Dashboard — Tactile, modern, engaging, and user-friendly.
/// Layout:
/// 1. Greeting + Search & Suggestion Chips
/// 2. Continue Learning Hero Card (interactive with stats)
/// 3. Quick Action Rail (thumb-friendly shortcuts)
/// 4. Daily Architectural Challenge (Question of the Day)
/// 5. Explore Tracks Grid (Primary curriculum navigation)
/// 6. Recently Studied List (status dots, direct resume)
class HomeDashboardScreen extends StatefulWidget {
  const HomeDashboardScreen({super.key});

  @override
  State<HomeDashboardScreen> createState() => _HomeDashboardScreenState();
}

class _HomeDashboardScreenState extends State<HomeDashboardScreen> {
  int _selectedTab = 0;
  final int _mobileDevInitialSubTab = 0;
  int _aiCertInitialSubTab = 0;
  bool _challengeRevealed = false;

  // Pre-indexed map for O(1) recent topic resolution
  static final Map<String, ({MasterTopic topic, PrepDomainHierarchy domain})> _topicIndex = {
    for (final d in masterPrepDomains)
      for (final m in d.modules)
        for (final t in m.topics)
          t.id: (topic: t, domain: d),
  };

  // Semantic color tokens
  static const _primary = Color(0xFF4F46E5);
  static const _primaryLight = Color(0xFF818CF8);
  static const _accent = Color(0xFF0EA5E9);
  static const _success = Color(0xFF10B981);
  static const _warning = Color(0xFFF59E0B);
  static const _violet = Color(0xFF8B5CF6);

  Color _text(bool d) => d ? const Color(0xFFF1F5F9) : const Color(0xFF0F172A);
  Color _sub(bool d) => d ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
  Color _card(bool d) => d ? const Color(0xFF1E293B) : Colors.white;
  Color _border(bool d) => d ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
  Color _bg(bool d) => d ? const Color(0xFF0B0F17) : const Color(0xFFF8FAFC);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: _bg(isDark),
      appBar: _selectedTab == 0
          ? AppBar(
              title: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF4F46E5), Color(0xFF8B5CF6)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.school_rounded, color: Colors.white, size: 18),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'handyLearn',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, letterSpacing: -0.4),
                  ),
                ],
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.search_rounded),
                  tooltip: 'Search Topics',
                  onPressed: () {
                    AppHaptics.light();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const PrepGlobalSearchScreen()),
                    );
                  },
                ),
                BlocBuilder<ThemeCubit, ThemeMode>(
                  builder: (context, themeMode) {
                    return IconButton(
                      icon: Icon(
                        isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                        color: isDark ? Colors.amber : const Color(0xFF334155),
                      ),
                      tooltip: isDark ? 'Switch to Light Mode' : 'Switch to Dark Mode',
                      onPressed: () {
                        AppHaptics.light();
                        context.read<ThemeCubit>().toggleTheme();
                      },
                    );
                  },
                ),
              ],
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedTab,
        animationDuration: const Duration(milliseconds: 280),
        onDestinationSelected: (i) {
          AppHaptics.selection();
          setState(() => _selectedTab = i);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.psychology_outlined),
            selectedIcon: Icon(Icons.psychology_rounded),
            label: 'Cloud & AI',
          ),
          NavigationDestination(
            icon: Icon(Icons.phone_iphone_outlined),
            selectedIcon: Icon(Icons.phone_iphone_rounded),
            label: 'Flutter & UI',
          ),
          NavigationDestination(
            icon: Icon(Icons.apple_outlined),
            selectedIcon: Icon(Icons.apple_rounded),
            label: 'iOS Prep',
          ),
          NavigationDestination(
            icon: Icon(Icons.code_rounded),
            selectedIcon: Icon(Icons.code_rounded),
            label: 'Coding & DSA',
          ),
        ],
      ),
      body: _buildBody(isDark),
    );
  }

  Widget _buildBody(bool isDark) {
    return IndexedStack(
      index: _selectedTab,
      children: [
        _buildHomeTab(isDark),
        AiAndCertificationsHubScreen(initialSubTab: _aiCertInitialSubTab),
        MobileDevHubScreen(initialSubTab: _mobileDevInitialSubTab),
        const IosSeniorPrepHubScreen(),
        const CodingDsaHubScreen(),
      ],
    );
  }

  Widget _buildHomeTab(bool isDark) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      children: [
        // 1. GREETING & STATS & SEARCH
        _buildGreeting(isDark),
        const SizedBox(height: 16),

        // 2. CONTINUE LEARNING (hero progress card)
        _buildContinueCard(isDark),
        const SizedBox(height: 16),

        // 3. QUICK ACTIONS RAIL (ergonomic thumb shortcuts)
        _buildQuickActionRail(isDark),
        const SizedBox(height: 20),

        // 4. DAILY ARCHITECTURAL CHALLENGE (interactive bite)
        _buildDailyChallenge(isDark),
        const SizedBox(height: 20),

        // 5. EXPLORE TRACKS GRID (primary navigation)
        _buildExploreSection(isDark),
        const SizedBox(height: 20),

        // 6. RECENTLY STUDIED
        _buildRecentSection(isDark),
        const SizedBox(height: 28),
      ],
    );
  }

  // ─────────────────────────────────────────────
  // 1. GREETING + STATS + SEARCH
  // ─────────────────────────────────────────────
  Widget _buildGreeting(bool isDark) {
    final hour = DateTime.now().hour;
    final greeting = hour < 12 ? 'Good morning' : (hour < 17 ? 'Good afternoon' : 'Good evening');
    final greetingIcon = hour < 12 ? Icons.wb_sunny_rounded : (hour < 17 ? Icons.wb_cloudy_rounded : Icons.nights_stay_rounded);
    final iconColor = hour < 12 ? Colors.amber : (hour < 17 ? Colors.orangeAccent : Colors.indigoAccent);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          '$greeting, Navneet',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                            color: _text(isDark),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Icon(greetingIcon, size: 20, color: iconColor),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'What would you like to master today?',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: _sub(isDark)),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Streak badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : const Color(0xFFFEF3C7),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDark ? const Color(0xFF334155) : const Color(0xFFFDE68A),
                ),
              ),
              child: Row(
                children: [
                  const Text('🔥', style: TextStyle(fontSize: 13)),
                  const SizedBox(width: 4),
                  Text(
                    '3 Days',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.amber : const Color(0xFFB45309),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        // Search bar
        Semantics(
          button: true,
          label: 'Search topics, domains, interview Q&A',
          hint: 'Double tap to open global search',
          child: PressableScale(
            scaleFactor: 0.98,
            onTap: () {
              AppHaptics.light();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PrepGlobalSearchScreen()),
              );
            },
            child: Container(
              constraints: const BoxConstraints(minHeight: 46),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: _card(isDark),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _border(isDark)),
                boxShadow: AppColors.cardShadow(isDark),
              ),
              child: Row(
                children: [
                  Icon(Icons.search_rounded, size: 20, color: _sub(isDark)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Search topics, domains, interview Q&A...',
                      style: TextStyle(fontSize: 13, color: _sub(isDark)),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: _primary.withValues(alpha: isDark ? 0.2 : 0.08),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '⌘K',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: isDark ? _primaryLight : _primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),

        // Quick topic pills
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _searchSuggestionChip('Swift Concurrency', isDark),
              _searchSuggestionChip('Flutter Rosetta', isDark),
              _searchSuggestionChip('Claude MCP', isDark),
              _searchSuggestionChip('System Design', isDark),
              _searchSuggestionChip('Git Puzzles', isDark),
            ],
          ),
        ),
      ],
    );
  }

  Widget _searchSuggestionChip(String query, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: Semantics(
        button: true,
        label: 'Search suggestion: $query',
        child: PressableScale(
          scaleFactor: 0.95,
          onTap: () {
            AppHaptics.selection();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PrepGlobalSearchScreen(initialQuery: query),
              ),
            );
          },
          child: Container(
            constraints: const BoxConstraints(minHeight: 48),
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _border(isDark)),
              boxShadow: AppColors.cardShadow(isDark),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.trending_up_rounded, size: 14, color: _sub(isDark)),
                const SizedBox(width: 4),
                Text(
                  query,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: _sub(isDark)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // 2. CONTINUE LEARNING HERO CARD
  // ─────────────────────────────────────────────
  Widget _buildContinueCard(bool isDark) {
    return AnimatedBuilder(
      animation: PrepProgressService.instance,
      builder: (context, _) {
        final ps = PrepProgressService.instance;
        final pct = (ps.overallProgressPercentage * 100).toInt();
        final module = ps.activeModule;
        final topic = ps.activeTopic;
        final hasStarted = ps.hasStarted;

        return PressableScale(
          scaleFactor: 0.98,
          onTap: () {
            AppHaptics.medium();
            _navigateToActivePrep();
          },
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF3730A3), Color(0xFF4F46E5)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: _primary.withValues(alpha: 0.35),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: MergeSemantics(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.apple_rounded, size: 12, color: Colors.white),
                                  const SizedBox(width: 4),
                                  Text(
                                    hasStarted ? 'In Progress' : 'Recommended Path',
                                    style: const TextStyle(
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '$pct% Completed',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      hasStarted ? module : 'iOS Senior & Lead Preparation',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      hasStarted ? topic : '32 Master Domains • 128 Topics • 100 Q&A Bank',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: ps.overallProgressPercentage,
                        minHeight: 5,
                        backgroundColor: Colors.white.withValues(alpha: 0.2),
                        valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF34D399)),
                        semanticsLabel: 'Curriculum completion progress',
                        semanticsValue: '$pct%',
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            '${ps.completedTopicsCount}/${ps.totalTopicsCount} topics mastered',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.white.withValues(alpha: 0.8),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                hasStarted ? 'Resume Topic' : 'Start Journey',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF4338CA),
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(Icons.arrow_forward_rounded, size: 14, color: Color(0xFF4338CA)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // ─────────────────────────────────────────────
  // 3. QUICK ACTION RAIL (thumb-friendly ergonomics)
  // ─────────────────────────────────────────────
  Widget _buildQuickActionRail(bool isDark) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _quickActionPill(
            icon: Icons.auto_stories_rounded,
            label: 'Swift Handbook',
            color: const Color(0xFFF05138),
            isDark: isDark,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const IosMasterHandbookScreen()),
            ),
          ),
          _quickActionPill(
            icon: Icons.mic_rounded,
            label: 'Interview Mode',
            color: const Color(0xFFEC4899),
            isDark: isDark,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PrepInterviewModeScreen(initialQuestionCount: 10)),
            ),
          ),
          _quickActionPill(
            icon: Icons.architecture_rounded,
            label: 'System Design',
            color: const Color(0xFF8B5CF6),
            isDark: isDark,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PrepSystemDesignScreen()),
            ),
          ),
          _quickActionPill(
            icon: Icons.terminal_rounded,
            label: 'Git Masterclass',
            color: const Color(0xFFF97316),
            isDark: isDark,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PrepGitMasterclassScreen()),
            ),
          ),
          _quickActionPill(
            icon: Icons.verified_user_rounded,
            label: 'Staff Signals',
            color: const Color(0xFF10B981),
            isDark: isDark,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PrepStaffSignalsScreen()),
            ),
          ),
          _quickActionPill(
            icon: Icons.biotech_rounded,
            label: 'Interactive Labs',
            color: const Color(0xFF0EA5E9),
            isDark: isDark,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const InteractiveLabsScreen()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _quickActionPill({
    required IconData icon,
    required String label,
    required Color color,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Semantics(
        button: true,
        label: label,
        child: PressableScale(
          scaleFactor: 0.95,
          onTap: () {
            AppHaptics.light();
            onTap();
          },
          child: Container(
            constraints: const BoxConstraints(minHeight: 48),
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: _card(isDark),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: _border(isDark)),
              boxShadow: AppColors.cardShadow(isDark),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 16, color: color),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: _text(isDark),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // 4. DAILY ARCHITECTURAL CHALLENGE (Interactive Snack)
  // ─────────────────────────────────────────────
  Widget _buildDailyChallenge(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _card(isDark),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _border(isDark)),
        boxShadow: AppColors.cardShadow(isDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFFF59E0B).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.lightbulb_rounded, size: 18, color: Color(0xFFF59E0B)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Question of the Day',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: _text(isDark),
                      ),
                    ),
                    Text(
                      'High-Frequency Senior iOS & Staff Interview Signal',
                      style: TextStyle(fontSize: 11, color: _sub(isDark)),
                    ),
                  ],
                ),
              ),
              Semantics(
                button: true,
                label: _challengeRevealed ? 'Hide daily challenge answer' : 'Reveal daily challenge answer',
                child: PressableScale(
                  scaleFactor: 0.92,
                  onTap: () {
                    AppHaptics.light();
                    setState(() => _challengeRevealed = !_challengeRevealed);
                  },
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        child: Text(
                          _challengeRevealed ? 'Hide' : 'Reveal',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: _primaryLight,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Why is [weak self] required over [unowned self] inside an escaping asynchronous Task that outlives the enclosing UIViewController?',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              height: 1.35,
              color: _text(isDark),
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 280),
            curve: Curves.easeInOutCubic,
            child: _challengeRevealed
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      Semantics(
                        container: true,
                        liveRegion: true,
                        label: 'Daily architectural challenge answer revealed',
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.verified_rounded, size: 14, color: Color(0xFF10B981)),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Staff Calibration Signal',
                                    style: TextStyle(
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.w700,
                                      color: isDark ? const Color(0xFF34D399) : const Color(0xFF059669),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                '`unowned` assumes memory is never nil. If the VC pops while network is in flight, referencing `unowned self` crashes instantly with EXC_BAD_ACCESS. `[weak self]` safely zeroes out into `nil`, allowing safe `guard let self else { return }` early exit.',
                                style: TextStyle(fontSize: 12, height: 1.4, color: _sub(isDark)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // 5. EXPLORE TRACKS GRID (2×3 category cards)
  // ─────────────────────────────────────────────
  Widget _buildExploreSection(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Explore Tracks',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: _text(isDark),
                letterSpacing: -0.3,
              ),
            ),
            Text(
              '6 Curriculums',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: _sub(isDark)),
            ),
          ],
        ),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 0.84,
          children: [
            _exploreCard(
              icon: Icons.psychology_rounded,
              title: 'Cloud & AI',
              subtitle: 'Agentic & MCP',
              color: _violet,
              isDark: isDark,
              onTap: () => setState(() => _selectedTab = 1),
            ),
            _exploreCard(
              icon: Icons.flutter_dash_rounded,
              title: 'Flutter & UI',
              subtitle: 'State & Rosetta',
              color: _accent,
              isDark: isDark,
              onTap: () => setState(() => _selectedTab = 2),
            ),
            _exploreCard(
              icon: Icons.apple_rounded,
              title: 'iOS Prep',
              subtitle: '32 Domains',
              color: _primary,
              isDark: isDark,
              onTap: () => setState(() => _selectedTab = 3),
            ),
            _exploreCard(
              icon: Icons.code_rounded,
              title: 'Coding & DSA',
              subtitle: 'Patterns & Algo',
              color: const Color(0xFFF97316),
              isDark: isDark,
              onTap: () => setState(() => _selectedTab = 4),
            ),
            _exploreCard(
              icon: Icons.biotech_rounded,
              title: 'Labs',
              subtitle: 'Sandboxes',
              color: _success,
              isDark: isDark,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const InteractiveLabsScreen()),
              ),
            ),
            _exploreCard(
              icon: Icons.workspace_premium_rounded,
              title: 'Certs',
              subtitle: 'Mock Exams',
              color: _warning,
              isDark: isDark,
              onTap: () => setState(() {
                _selectedTab = 1;
                _aiCertInitialSubTab = 1;
              }),
            ),
          ],
        ),
      ],
    );
  }

  Widget _exploreCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return PressableScale(
      scaleFactor: 0.94,
      onTap: () {
        AppHaptics.light();
        onTap();
      },
      child: Container(
        decoration: BoxDecoration(
          color: _card(isDark),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _border(isDark)),
          boxShadow: AppColors.cardShadow(isDark),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withValues(alpha: isDark ? 0.2 : 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: _text(isDark),
                ),
              ),
            ),
            const SizedBox(height: 2),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w500,
                  color: _sub(isDark),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // 6. RECENTLY STUDIED
  // ─────────────────────────────────────────────
  Widget _buildRecentSection(bool isDark) {
    return AnimatedBuilder(
      animation: PrepProgressService.instance,
      builder: (context, _) {
        final ps = PrepProgressService.instance;
        final recentIds = ps.recentlyStudiedTopicIds;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recently Studied',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: _text(isDark),
                    letterSpacing: -0.3,
                  ),
                ),
                if (recentIds.isNotEmpty)
                  Text(
                    '${recentIds.length} topics',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: _sub(isDark)),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            if (recentIds.isEmpty)
              _buildEmptyRecent(isDark)
            else
              ...recentIds.take(5).map((id) => _buildRecentItem(id, isDark, ps)),
          ],
        );
      },
    );
  }

  Widget _buildEmptyRecent(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _card(isDark),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _border(isDark)),
      ),
      child: Column(
        children: [
          Icon(Icons.school_outlined, size: 32, color: _sub(isDark)),
          const SizedBox(height: 8),
          Text(
            'No topics studied yet',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: _text(isDark)),
          ),
          const SizedBox(height: 4),
          Text(
            'Tap the Continue card above or explore any track to begin learning',
            style: TextStyle(fontSize: 12, color: _sub(isDark)),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildRecentItem(String topicId, bool isDark, PrepProgressService ps) {
    final match = _topicIndex[topicId];
    if (match == null) return const SizedBox.shrink();

    final topic = match.topic;
    final domain = match.domain;

    final status = ps.getTopicStatus(topicId);
    final statusColor = switch (status) {
      TopicMasteryStatus.mastered => _success,
      TopicMasteryStatus.completed => _primary,
      TopicMasteryStatus.inProgress => _warning,
      TopicMasteryStatus.notStarted => _sub(isDark),
    };

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: PressableScale(
        scaleFactor: 0.98,
        onTap: () {
          AppHaptics.light();
          ps.recordTopicStudied(topic.id);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PrepTopicDetailScreen(
                topic: topic,
                domainTitle: domain.title,
                domainNumber: domain.domainNumber,
              ),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: _card(isDark),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _border(isDark)),
            boxShadow: AppColors.cardShadow(isDark),
          ),
          child: Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(color: statusColor, shape: BoxShape.circle),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      topic.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: _text(isDark)),
                    ),
                    Text(
                      'D${domain.domainNumber.toString().padLeft(2, '0')} • ${domain.title}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 11, color: _sub(isDark)),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  status.label,
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: statusColor),
                ),
              ),
              const SizedBox(width: 6),
              Icon(Icons.chevron_right_rounded, size: 16, color: _sub(isDark)),
            ],
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // NAVIGATION HELPERS
  // ─────────────────────────────────────────────
  void _navigateToActivePrep() {
    final ps = PrepProgressService.instance;
    final domainNum = ps.activeDomainNumber;
    final targetDomain = masterPrepDomains.firstWhere(
      (d) => d.domainNumber == domainNum,
      orElse: () => masterPrepDomains.first,
    );
    final topic = targetDomain.modules.first.topics.first;
    ps.recordTopicStudied(topic.id);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PrepTopicDetailScreen(
          topic: topic,
          domainTitle: targetDomain.title,
          domainNumber: targetDomain.domainNumber,
        ),
      ),
    );
  }
}
