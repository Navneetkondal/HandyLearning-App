import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/theme_cubit.dart';
import '../../../core/widgets/code_snippet_card.dart';
import '../../coding_dsa/screens/coding_dsa_hub_screen.dart';
import '../../home/screens/home_dashboard_screen.dart';
import '../data/ios_prep_master_hierarchy_data.dart';
import '../models/ios_prep_hierarchy_models.dart';
import '../services/prep_progress_service.dart';
import 'ios_prep_git_masterclass_screen.dart';
import 'ios_prep_interview_mode_screen.dart';
import 'ios_prep_staff_signals_screen.dart';
import 'ios_prep_system_design_screen.dart';
import 'ios_prep_topic_detail_screen.dart';

/// Redesigned Master Technical Handbook Screen.
/// Direct parity with the SwiftHandbook web application:
/// 1. 4-Track Switcher: ⚡ Swift (32 Domains) • 💻 Coding (DSA) • 🔮 Claude (AI/MCP) • 💙 Flutter (Cross-Platform)
/// 2. Canonical 7-Pillar Section & Details Cards:
///    - 💡 1. Easy-to-Learn Mental Model (In Simple Words + ASCII Diagram)
///    - 📖 2. Formal Definition & Language Guarantees (Quick Answer + Why It Matters)
///    - 💻 3. Implementation (Minimal Syntax vs Swift 6 Production Architecture)
///    - 🎯 4. Reason & Core Motivation (Step-by-step internal execution mechanics)
///    - 🏗️ 5. Real-World Architecture & Interactive Exercises (Production examples + Practice task)
///    - ⚙️ 6. Memory Layout, SIL & Pitfall Traps (Under the hood + Trade-offs + Traps)
///    - 🎓 7. Senior Revision Summary & Interview Drills (Checklist + Calibrated Q&A)
/// 3. Executive Study Toolbar (Search with count, Difficulty filters, Expand/Collapse All toggle)
/// 4. Quick Vaults Access (Senior 100, Exam 89, Git Masterclass, System Design)
/// 5. Dual theme support (WCAG AA Light & Dark mode tokens)
class IosMasterHandbookScreen extends StatefulWidget {
  final bool isEmbedded;
  final String initialTrack;

  const IosMasterHandbookScreen({
    super.key,
    this.isEmbedded = false,
    this.initialTrack = 'swift',
  });

  @override
  State<IosMasterHandbookScreen> createState() => _IosMasterHandbookScreenState();
}

class _IosMasterHandbookScreenState extends State<IosMasterHandbookScreen> {
  late String _activeTrack; // 'swift', 'coding', 'claude', 'flutter'
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _difficultyFilter = 'All'; // 'All', 'Fundamental', 'Intermediate', 'Senior', 'Staff'

  final Set<String> _expandedTopicIds = {};
  final Set<String> _revealedPracticeIds = {};
  final Map<String, int> _codeTabSelection = {}; // topicId -> 0 (minimal) or 1 (production)

  final PrepProgressService _progressService = PrepProgressService.instance;
  int _activeTopicIndex = 0;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _activeTrack = widget.initialTrack;
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // ─────────────────────────────────────────────
  // THEME COLOR TOKENS (Rule 6 Dual Theming)
  // ─────────────────────────────────────────────
  Color _bg(bool dark) => dark ? const Color(0xFF0D1117) : const Color(0xFFF7F8FA);
  Color _card(bool dark) => dark ? const Color(0xFF161B22) : Colors.white;
  Color _surface(bool dark) => dark ? const Color(0xFF21262D) : const Color(0xFFF1F4F8);
  Color _border(bool dark) => dark ? const Color(0xFF30363D) : const Color(0xFFE1E6ED);
  Color _text(bool dark) => dark ? const Color(0xFFF0F6FC) : const Color(0xFF17202A);
  Color _sub(bool dark) => dark ? const Color(0xFF8B949E) : const Color(0xFF647184);

  Color _accent(bool dark) => dark ? const Color(0xFF58A6FF) : const Color(0xFF2864DC);
  static const _claudePurple = Color(0xFF8B5CF6);
  static const _flutterCyan = Color(0xFF0284C7);
  static const _swiftOrange = Color(0xFFF05138);

  Color _trackColor([bool isDark = false]) {
    switch (_activeTrack) {
      case 'coding':
        return const Color(0xFF10B981);
      case 'claude':
        return _claudePurple;
      case 'flutter':
        return _flutterCyan;
      case 'swift':
      default:
        return _accent(isDark);
    }
  }

  Gradient _brandGradient(bool dark) => LinearGradient(
    colors: dark
        ? const [Color(0xFF1F6FEB), Color(0xFF58A6FF)]
        : const [Color(0xFF2864DC), Color(0xFF1E4FB8)],
  );

  // ─────────────────────────────────────────────
  // DATA FILTERING & TRACK RESOLUTION
  // ─────────────────────────────────────────────
  List<({MasterTopic topic, PrepDomainHierarchy domain, DomainModule module})> _getFilteredTopics() {
    final query = _searchQuery.trim().toLowerCase();
    final List<({MasterTopic topic, PrepDomainHierarchy domain, DomainModule module})> result = [];

    // Filter domains by track
    Iterable<PrepDomainHierarchy> domainsToScan = masterPrepDomains;
    if (_activeTrack == 'swift') {
      domainsToScan = masterPrepDomains.where((d) => d.domainNumber <= 30);
    } else if (_activeTrack == 'coding') {
      domainsToScan = masterPrepDomains.where((d) => d.domainNumber == 27);
    } else if (_activeTrack == 'claude') {
      domainsToScan = masterPrepDomains.where((d) => d.domainNumber == 32);
    } else if (_activeTrack == 'flutter') {
      domainsToScan = masterPrepDomains.where((d) => d.domainNumber == 10 || d.domainNumber == 14);
    }

    for (final domain in domainsToScan) {
      for (final module in domain.modules) {
        for (final topic in module.topics) {
          // Check difficulty
          if (_difficultyFilter != 'All') {
            final diff = topic.difficulty.toLowerCase();
            final target = _difficultyFilter.toLowerCase();
            if (target == 'fundamental' && diff != 'junior' && diff != 'core') {
              continue;
            } else if (target == 'intermediate' && diff != 'mid' && diff != 'intermediate') {
              continue;
            } else if (target == 'senior' && diff != 'senior') {
              continue;
            } else if (target == 'staff' && diff != 'staff' && diff != 'expert') {
              continue;
            }
          }

          // Check query match
          if (query.isNotEmpty) {
            final match = topic.title.toLowerCase().contains(query) ||
                topic.quickAnswer.toLowerCase().contains(query) ||
                topic.whyItMatters.toLowerCase().contains(query) ||
                topic.minimalCode.toLowerCase().contains(query) ||
                topic.productionCode.toLowerCase().contains(query) ||
                topic.underTheHood.toLowerCase().contains(query) ||
                domain.title.toLowerCase().contains(query);
            if (!match) continue;
          }

          result.add((topic: topic, domain: domain, module: module));
        }
      }
    }

    return result;
  }

  void _toggleExpandAll(List<({MasterTopic topic, PrepDomainHierarchy domain, DomainModule module})> items) {
    HapticFeedback.lightImpact();
    setState(() {
      if (_expandedTopicIds.length >= items.length && items.isNotEmpty) {
        _expandedTopicIds.clear();
      } else {
        _expandedTopicIds.clear();
        for (final item in items) {
          _expandedTopicIds.add(item.topic.id);
        }
      }
    });
  }

  // ─────────────────────────────────────────────
  // BUILD METHOD
  // ─────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final filteredItems = _getFilteredTopics();
    final allExpanded = filteredItems.isNotEmpty && _expandedTopicIds.length >= filteredItems.length;
    final safeIndex = _activeTopicIndex.clamp(0, filteredItems.isEmpty ? 0 : filteredItems.length - 1);
    final activeItem = filteredItems.isNotEmpty ? filteredItems[safeIndex] : null;

    final body = Container(
      color: _bg(isDark),
      child: Column(
        children: [
          _buildTrackSwitcher(isDark),
          _buildExecutiveToolbar(isDark, filteredItems, allExpanded),
          _buildDifficultyChips(isDark),
          if (activeItem != null) _buildBreadcrumbBar(isDark, activeItem),
          Expanded(
            child: filteredItems.isEmpty
                ? _buildEmptyState(isDark)
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.fromLTRB(14, 8, 14, 20),
                    itemCount: filteredItems.length,
                    itemBuilder: (context, index) {
                      final item = filteredItems[index];
                      final isExpanded = _expandedTopicIds.contains(item.topic.id);
                      return _buildPillarTopicCard(
                        context: context,
                        topic: item.topic,
                        domain: item.domain,
                        module: item.module,
                        isExpanded: isExpanded,
                        isDark: isDark,
                      );
                    },
                  ),
          ),
          if (filteredItems.isNotEmpty)
            _buildBottomPaginationBar(isDark, safeIndex, filteredItems),
        ],
      ),
    );

    if (widget.isEmbedded) return body;

    return Scaffold(
      backgroundColor: _bg(isDark),
      drawer: _buildCurriculumDrawer(context, isDark, filteredItems),
      appBar: AppBar(
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.menu_rounded),
            tooltip: 'Open Curriculum Tree',
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3.5),
              decoration: BoxDecoration(
                gradient: _brandGradient(isDark),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                'iOS',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.5,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Swift & iOS Handbook',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                  ),
                  Text(
                    'Interview Spec & Reference',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 10, color: _sub(isDark)),
                  ),
                ],
              ),
            ),
          ],
        ),
        elevation: 0,
        actions: [
          IconButton(
            icon: Text(isDark ? '☀️' : '🌙', style: const TextStyle(fontSize: 16)),
            tooltip: isDark ? 'Switch to Light Mode' : 'Switch to Dark Mode',
            onPressed: () {
              HapticFeedback.lightImpact();
              context.read<ThemeCubit>().toggleTheme();
            },
          ),
          IconButton(
            icon: const Icon(Icons.flash_on_rounded, color: Color(0xFFF59E0B)),
            tooltip: 'Special Vaults & Drills',
            onPressed: () => _showSpecialVaultsSheet(context, isDark),
          ),
          IconButton(
            icon: const Icon(Icons.school_rounded, color: Color(0xFF6366F1)),
            tooltip: 'handyLearn Flutter Hub',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const HomeDashboardScreen()),
            ),
          ),
        ],
      ),
      body: body,
    );
  }

  // ─────────────────────────────────────────────
  // BREADCRUMB BAR (SwiftHandbook Web Parity)
  // ─────────────────────────────────────────────
  Widget _buildBreadcrumbBar(
    bool isDark,
    ({MasterTopic topic, PrepDomainHierarchy domain, DomainModule module}) item,
  ) {
    final isBookmarked = _progressService.isBookmarked(item.topic.id);
    final isCompleted = _progressService.getTopicStatus(item.topic.id) == TopicMasteryStatus.completed ||
        _progressService.getTopicStatus(item.topic.id) == TopicMasteryStatus.mastered;

    final trackLabel = _activeTrack == 'swift'
        ? 'Swift & iOS Prep'
        : (_activeTrack == 'coding'
            ? 'Coding & Logic Building'
            : (_activeTrack == 'claude' ? 'Claude & AI Architecture' : 'Flutter & Architecture'));

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: _card(isDark),
        border: Border(bottom: BorderSide(color: _border(isDark), width: 0.8)),
      ),
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Text(
                    trackLabel,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: _trackColor(),
                    ),
                  ),
                  Text(' → ', style: TextStyle(fontSize: 10.5, color: _sub(isDark))),
                  Text(
                    '${item.domain.domainNumber.toString().padLeft(2, '0')}. ${item.domain.tag.toUpperCase()}',
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w600,
                      color: _sub(isDark),
                    ),
                  ),
                  Text(' → ', style: TextStyle(fontSize: 10.5, color: _sub(isDark))),
                  Text(
                    item.topic.title,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: _text(isDark),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Bookmark Action
          InkWell(
            borderRadius: BorderRadius.circular(6),
            onTap: () {
              HapticFeedback.lightImpact();
              setState(() {
                _progressService.toggleBookmark(item.topic.id);
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3.5),
              decoration: BoxDecoration(
                color: isBookmarked ? const Color(0xFFF59E0B).withValues(alpha: 0.15) : _surface(isDark),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: isBookmarked ? const Color(0xFFF59E0B) : _border(isDark),
                  width: 0.8,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isBookmarked ? Icons.star_rounded : Icons.star_border_rounded,
                    size: 13,
                    color: isBookmarked ? const Color(0xFFF59E0B) : _sub(isDark),
                  ),
                  const SizedBox(width: 3),
                  Text(
                    isBookmarked ? 'Bookmarked' : 'Bookmark',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: isBookmarked ? const Color(0xFFF59E0B) : _sub(isDark),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 6),
          // Mark Completed Action
          InkWell(
            borderRadius: BorderRadius.circular(6),
            onTap: () {
              HapticFeedback.lightImpact();
              setState(() {
                if (isCompleted) {
                  _progressService.setTopicStatus(item.topic.id, TopicMasteryStatus.notStarted);
                } else {
                  _progressService.setTopicStatus(item.topic.id, TopicMasteryStatus.completed);
                }
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3.5),
              decoration: BoxDecoration(
                color: isCompleted ? const Color(0xFF10B981) : _surface(isDark),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: isCompleted ? const Color(0xFF10B981) : _border(isDark),
                  width: 0.8,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isCompleted ? Icons.check_circle_rounded : Icons.check_circle_outline_rounded,
                    size: 13,
                    color: isCompleted ? Colors.white : _sub(isDark),
                  ),
                  const SizedBox(width: 3),
                  Text(
                    isCompleted ? 'Completed' : 'Mark Complete',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: isCompleted ? Colors.white : _sub(isDark),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // BOTTOM LINEAR PAGINATION BAR (Web Parity)
  // ─────────────────────────────────────────────
  Widget _buildBottomPaginationBar(
    bool isDark,
    int currentIndex,
    List<({MasterTopic topic, PrepDomainHierarchy domain, DomainModule module})> items,
  ) {
    final safeIndex = currentIndex.clamp(0, items.length - 1);
    final hasPrev = safeIndex > 0;
    final hasNext = safeIndex < items.length - 1;
    final prevTopic = hasPrev ? items[safeIndex - 1].topic : null;
    final nextTopic = hasNext ? items[safeIndex + 1].topic : null;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: _card(isDark),
        border: Border(top: BorderSide(color: _border(isDark), width: 0.8)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.04),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // Previous Concept
            Expanded(
              child: InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: hasPrev
                    ? () {
                        HapticFeedback.selectionClick();
                        setState(() {
                          _activeTopicIndex = safeIndex - 1;
                          _expandedTopicIds.add(prevTopic!.id);
                        });
                        _scrollController.animateTo(
                          0,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    : null,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  decoration: BoxDecoration(
                    color: hasPrev ? _surface(isDark) : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: hasPrev ? _border(isDark) : Colors.transparent,
                      width: 0.8,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.chevron_left_rounded,
                        size: 16,
                        color: hasPrev ? _trackColor() : _sub(isDark).withValues(alpha: 0.3),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Previous',
                              style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: _sub(isDark)),
                            ),
                            Text(
                              hasPrev ? prevTopic!.title : 'Beginning',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w700,
                                color: hasPrev ? _text(isDark) : _sub(isDark).withValues(alpha: 0.4),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            // Next Concept
            Expanded(
              child: InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: hasNext
                    ? () {
                        HapticFeedback.selectionClick();
                        setState(() {
                          _activeTopicIndex = safeIndex + 1;
                          _expandedTopicIds.add(nextTopic!.id);
                        });
                        _scrollController.animateTo(
                          0,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    : null,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  decoration: BoxDecoration(
                    color: hasNext ? _trackColor().withValues(alpha: isDark ? 0.22 : 0.12) : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: hasNext ? _trackColor() : Colors.transparent,
                      width: 0.8,
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Next Concept',
                              style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: _trackColor()),
                            ),
                            Text(
                              hasNext ? nextTopic!.title : 'End of Track',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w700,
                                color: hasNext ? _text(isDark) : _sub(isDark).withValues(alpha: 0.4),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.chevron_right_rounded,
                        size: 16,
                        color: hasNext ? _trackColor() : _sub(isDark).withValues(alpha: 0.3),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // CURRICULUM DRAWER (SwiftHandbook #left-sidebar Parity)
  // ─────────────────────────────────────────────
  Widget _buildCurriculumDrawer(
    BuildContext context,
    bool isDark,
    List<({MasterTopic topic, PrepDomainHierarchy domain, DomainModule module})> filteredItems,
  ) {
    Iterable<PrepDomainHierarchy> domainsToScan = masterPrepDomains;
    if (_activeTrack == 'swift') {
      domainsToScan = masterPrepDomains.where((d) => d.domainNumber <= 30);
    } else if (_activeTrack == 'coding') {
      domainsToScan = masterPrepDomains.where((d) => d.domainNumber == 27);
    } else if (_activeTrack == 'claude') {
      domainsToScan = masterPrepDomains.where((d) => d.domainNumber == 32);
    } else if (_activeTrack == 'flutter') {
      domainsToScan = masterPrepDomains.where((d) => d.domainNumber == 10 || d.domainNumber == 14);
    }

    final totalDomains = domainsToScan.length;

    return Drawer(
      backgroundColor: _bg(isDark),
      width: MediaQuery.of(context).size.width * 0.85,
      child: SafeArea(
        child: Column(
          children: [
            // Brand header inside drawer
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: _card(isDark),
                border: Border(bottom: BorderSide(color: _border(isDark), width: 0.8)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3.5),
                    decoration: BoxDecoration(
                      gradient: _brandGradient(isDark),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'iOS',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.5,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 9),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Swift & iOS Handbook',
                          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14.5, color: _text(isDark)),
                        ),
                        Text(
                          'Interview Spec & Reference',
                          style: TextStyle(fontSize: 10, color: _sub(isDark)),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Text(isDark ? '☀️' : '🌙', style: const TextStyle(fontSize: 16)),
                    tooltip: 'Toggle Theme',
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      context.read<ThemeCubit>().toggleTheme();
                    },
                  ),
                ],
              ),
            ),
            // Track Switcher inside Drawer
            _buildTrackSwitcher(isDark),
            // Drawer Domain List
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: domainsToScan.map((domain) {
                  return Theme(
                    data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      leading: Text(domain.emoji, style: const TextStyle(fontSize: 18)),
                      title: Text(
                        '${domain.domainNumber.toString().padLeft(2, '0')}. ${domain.title}',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: _text(isDark),
                        ),
                      ),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: _trackColor().withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '${domain.totalTopics} topics',
                          style: TextStyle(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w700,
                            color: _trackColor(),
                          ),
                        ),
                      ),
                      children: domain.modules.expand((module) => module.topics).map((topic) {
                        final status = _progressService.getTopicStatus(topic.id);
                        final isSelected = filteredItems.isNotEmpty &&
                            filteredItems[_activeTopicIndex.clamp(0, filteredItems.length - 1)].topic.id == topic.id;

                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                          decoration: BoxDecoration(
                            color: isSelected ? _trackColor().withValues(alpha: isDark ? 0.2 : 0.1) : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isSelected ? _trackColor().withValues(alpha: 0.5) : Colors.transparent,
                              width: 0.8,
                            ),
                          ),
                          child: ListTile(
                            dense: true,
                            visualDensity: VisualDensity.compact,
                            leading: Text(
                              status.symbol,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: status == TopicMasteryStatus.completed || status == TopicMasteryStatus.mastered
                                    ? const Color(0xFF10B981)
                                    : (status == TopicMasteryStatus.inProgress ? _trackColor() : _sub(isDark)),
                              ),
                            ),
                            title: Text(
                              topic.title,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                                color: isSelected ? _trackColor() : _text(isDark),
                              ),
                            ),
                            trailing: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                              decoration: BoxDecoration(
                                color: _surface(isDark),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                topic.difficulty,
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w600,
                                  color: _sub(isDark),
                                ),
                              ),
                            ),
                            onTap: () {
                              HapticFeedback.selectionClick();
                              Navigator.pop(context); // close drawer
                              setState(() {
                                final idx = filteredItems.indexWhere((it) => it.topic.id == topic.id);
                                if (idx != -1) {
                                  _activeTopicIndex = idx;
                                }
                                _expandedTopicIds.add(topic.id);
                              });
                              _scrollController.animateTo(
                                0,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  );
                }).toList(),
              ),
            ),
            // Drawer Footer
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: _card(isDark),
                border: Border(top: BorderSide(color: _border(isDark), width: 0.8)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '$totalDomains Domains in Track',
                        style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600, color: _sub(isDark)),
                      ),
                      InkWell(
                        onTap: () {
                          HapticFeedback.lightImpact();
                          _progressService.resetAllProgress();
                          setState(() {});
                        },
                        child: Text(
                          'Reset Progress',
                          style: TextStyle(fontSize: 10.5, color: _sub(isDark), decoration: TextDecoration.underline),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.school_rounded, size: 16),
                      label: const Text('📚 Open handyLearn Flutter Hub', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF6366F1),
                        side: const BorderSide(color: Color(0xFF6366F1), width: 1.2),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const HomeDashboardScreen()));
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // 1. 4-TRACK SWITCHER (Swift • Coding • Claude • Flutter)
  // ─────────────────────────────────────────────
  Widget _buildTrackSwitcher(bool isDark) {
    final tracks = [
      ('swift', '⚡ Swift', '30 Domains', _trackColor(isDark)),
      ('coding', '💻 Coding', 'DSA Framework', const Color(0xFF10B981)),
      ('claude', '🔮 Claude', 'AI & MCP', _claudePurple),
      ('flutter', '💙 Flutter', 'Architecture', _flutterCyan),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: _card(isDark),
        border: Border(bottom: BorderSide(color: _border(isDark), width: 0.8)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: tracks.map((t) {
            final active = _activeTrack == t.$1;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {
                    HapticFeedback.selectionClick();
                    setState(() {
                      _activeTrack = t.$1;
                      _expandedTopicIds.clear();
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                    decoration: BoxDecoration(
                      color: active ? t.$4.withValues(alpha: isDark ? 0.22 : 0.12) : _surface(isDark),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: active ? t.$4 : _border(isDark),
                        width: active ? 1.4 : 0.8,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          t.$2,
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: active ? FontWeight.w800 : FontWeight.w600,
                            color: active ? (isDark ? Colors.white : t.$4) : _sub(isDark),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                          decoration: BoxDecoration(
                            color: active ? t.$4 : (isDark ? Colors.white12 : Colors.black12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            t.$3,
                            style: TextStyle(
                              fontSize: 9.5,
                              fontWeight: FontWeight.w700,
                              color: active ? Colors.white : _sub(isDark),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // 2. EXECUTIVE TOOLBAR (Search + Expand/Collapse All + Progress)
  // ─────────────────────────────────────────────
  Widget _buildExecutiveToolbar(
    bool isDark,
    List<({MasterTopic topic, PrepDomainHierarchy domain, DomainModule module})> items,
    bool allExpanded,
  ) {
    final ps = _progressService;
    final total = items.length;
    final completed = items.where((it) => ps.getTopicStatus(it.topic.id) == TopicMasteryStatus.completed || ps.getTopicStatus(it.topic.id) == TopicMasteryStatus.mastered).length;
    final pct = total > 0 ? ((completed / total) * 100).toInt() : 0;

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 6),
      color: _card(isDark),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 38,
                  decoration: BoxDecoration(
                    color: _surface(isDark),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: _border(isDark)),
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (val) => setState(() => _searchQuery = val),
                    style: TextStyle(fontSize: 13, color: _text(isDark)),
                    decoration: InputDecoration(
                      hintText: 'Search concepts, COW, ARC, Sendable, WitTable...',
                      hintStyle: TextStyle(fontSize: 12, color: _sub(isDark)),
                      prefixIcon: Icon(Icons.search_rounded, size: 18, color: _sub(isDark)),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear_rounded, size: 16),
                              onPressed: () {
                                _searchController.clear();
                                setState(() => _searchQuery = '');
                              },
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      isDense: true,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Smart Expand / Collapse All Toggle Button
              InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () => _toggleExpandAll(items),
                child: Container(
                  height: 38,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: _surface(isDark),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: _border(isDark)),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        allExpanded ? Icons.unfold_less_rounded : Icons.unfold_more_rounded,
                        size: 16,
                        color: _trackColor(),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        allExpanded ? 'Collapse' : 'Expand All',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: _text(isDark),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Stats row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Showing ${items.length} Concepts',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: _sub(isDark)),
              ),
              Row(
                children: [
                  Container(
                    width: 70,
                    height: 5,
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white12 : Colors.black12,
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: total > 0 ? (completed / total).clamp(0.0, 1.0) : 0.0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: _trackColor(),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '$pct% Completed ($completed/$total)',
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      color: _trackColor(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // 3. DIFFICULTY FILTER CHIPS
  // ─────────────────────────────────────────────
  Widget _buildDifficultyChips(bool isDark) {
    final filters = ['All', 'Fundamental', 'Intermediate', 'Senior', 'Staff'];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: _card(isDark),
        border: Border(bottom: BorderSide(color: _border(isDark), width: 0.8)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: filters.map((f) {
            final active = _difficultyFilter == f;
            return Padding(
              padding: const EdgeInsets.only(right: 6),
              child: ChoiceChip(
                label: Text(f),
                selected: active,
                onSelected: (val) {
                  if (val) setState(() => _difficultyFilter = f);
                },
                selectedColor: _trackColor().withValues(alpha: isDark ? 0.25 : 0.15),
                backgroundColor: _surface(isDark),
                labelStyle: TextStyle(
                  fontSize: 11,
                  fontWeight: active ? FontWeight.w800 : FontWeight.w500,
                  color: active ? _trackColor() : _sub(isDark),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
                side: BorderSide(
                  color: active ? _trackColor() : _border(isDark),
                  width: active ? 1.2 : 0.8,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // 4. CANONICAL 7-PILLAR SECTION & DETAILS CARD
  // ─────────────────────────────────────────────
  Widget _buildPillarTopicCard({
    required BuildContext context,
    required MasterTopic topic,
    required PrepDomainHierarchy domain,
    required DomainModule module,
    required bool isExpanded,
    required bool isDark,
  }) {
    final isBookmarked = _progressService.isBookmarked(topic.id);
    final status = _progressService.getTopicStatus(topic.id);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: _card(isDark),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isExpanded ? _trackColor() : _border(isDark),
          width: isExpanded ? 1.4 : 0.8,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ─── CARD SUMMARY HEADER (Always Visible) ───
          InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () {
              HapticFeedback.selectionClick();
              setState(() {
                if (isExpanded) {
                  _expandedTopicIds.remove(topic.id);
                } else {
                  _expandedTopicIds.add(topic.id);
                }
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Topic Identifier Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                      color: _trackColor().withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'D${domain.domainNumber.toString().padLeft(2, '0')}',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: _trackColor(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Title + Domain info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          topic.title,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.2,
                            color: _text(isDark),
                          ),
                        ),
                        const SizedBox(height: 3),
                        Row(
                          children: [
                            Text(
                              domain.tag,
                              style: TextStyle(fontSize: 11, color: _sub(isDark)),
                            ),
                            const SizedBox(width: 6),
                            Text('•', style: TextStyle(fontSize: 10, color: _border(isDark))),
                            const SizedBox(width: 6),
                            _difficultyBadge(topic.difficulty),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Actions: Bookmark + Status + Chevron
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        visualDensity: VisualDensity.compact,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                        icon: Icon(
                          isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                          size: 18,
                          color: isBookmarked ? const Color(0xFFF59E0B) : _sub(isDark),
                        ),
                        onPressed: () {
                          HapticFeedback.lightImpact();
                          setState(() {
                            _progressService.toggleBookmark(topic.id);
                          });
                        },
                      ),
                      const SizedBox(width: 4),
                      _masteryStatusPill(status, topic.id),
                      const SizedBox(width: 4),
                      Icon(
                        isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                        color: _sub(isDark),
                        size: 20,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // ─── 7-PILLAR ACCORDION BODY (Visible when Expanded) ───
          if (isExpanded) ...[
            Divider(height: 1, color: _border(isDark)),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 💡 1. MENTAL MODEL
                  _buildPillarSection(
                    icon: Icons.lightbulb_rounded,
                    iconColor: const Color(0xFFF59E0B),
                    title: '1. Mental Model (In Simple Words)',
                    isDark: isDark,
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          topic.whyItMatters,
                          style: TextStyle(fontSize: 12.5, height: 1.45, color: _text(isDark)),
                        ),
                        if (topic.mentalModel.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xFF090D13) : const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: _border(isDark)),
                            ),
                            child: SelectableText(
                              topic.mentalModel.replaceAll(r'\n', '\n'),
                              style: TextStyle(
                                fontFamily: 'Fira Code',
                                fontSize: 11,
                                height: 1.35,
                                color: isDark ? const Color(0xFF79C0FF) : const Color(0xFF1E40AF),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // 📖 2. FORMAL DEFINITION & LANGUAGE GUARANTEES
                  _buildPillarSection(
                    icon: Icons.auto_stories_rounded,
                    iconColor: _trackColor(),
                    title: '2. Formal Definition & Language Guarantees',
                    isDark: isDark,
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          topic.quickAnswer,
                          style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, height: 1.45, color: _text(isDark)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // 💻 3. IMPLEMENTATION (SYNTAX & CODE)
                  _buildPillarSection(
                    icon: Icons.code_rounded,
                    iconColor: const Color(0xFF10B981),
                    title: '3. Implementation & Production Architecture',
                    isDark: isDark,
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Toggle minimal vs production code
                        Row(
                          children: [
                            _codeTabButton('Minimal Syntax', (_codeTabSelection[topic.id] ?? 0) == 0, () {
                              setState(() => _codeTabSelection[topic.id] = 0);
                            }, isDark),
                            const SizedBox(width: 6),
                            _codeTabButton('Production Swift 6', (_codeTabSelection[topic.id] ?? 0) == 1, () {
                              setState(() => _codeTabSelection[topic.id] = 1);
                            }, isDark),
                          ],
                        ),
                        const SizedBox(height: 6),
                        CodeSnippetCard(
                          title: (_codeTabSelection[topic.id] ?? 0) == 0 ? 'Minimal Blueprint' : 'Production Swift 6 Architecture',
                          code: (_codeTabSelection[topic.id] ?? 0) == 0 ? topic.minimalCode : topic.productionCode,
                          language: 'swift',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // 🎯 4. REASON & CORE MOTIVATION (HOW IT WORKS)
                  if (topic.howItWorksSteps.isNotEmpty) ...[
                    _buildPillarSection(
                      icon: Icons.alt_route_rounded,
                      iconColor: const Color(0xFF8B5CF6),
                      title: '4. Reason & Core Motivation (Mechanics)',
                      isDark: isDark,
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: topic.howItWorksSteps.asMap().entries.map((entry) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 18,
                                  height: 18,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF8B5CF6).withValues(alpha: 0.15),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    '${entry.key + 1}',
                                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Color(0xFF8B5CF6)),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    entry.value,
                                    style: TextStyle(fontSize: 12, height: 1.4, color: _text(isDark)),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 14),
                  ],

                  // 🏗️ 5. REAL-WORLD ARCHITECTURE & PRACTICE TASK
                  if (topic.productionExample.isNotEmpty || topic.practicePrompt.isNotEmpty) ...[
                    _buildPillarSection(
                      icon: Icons.architecture_rounded,
                      iconColor: const Color(0xFF0EA5E9),
                      title: '5. Real-World Architecture & Interactive Exercise',
                      isDark: isDark,
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (topic.productionExample.isNotEmpty)
                            Text(
                              topic.productionExample,
                              style: TextStyle(fontSize: 12, height: 1.4, color: _text(isDark)),
                            ),
                          if (topic.practicePrompt.isNotEmpty) ...[
                            const SizedBox(height: 10),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: isDark ? const Color(0xFF0F172A) : const Color(0xFFEFF6FF),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: const Color(0xFF0EA5E9).withValues(alpha: 0.3)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.fitness_center_rounded, size: 14, color: Color(0xFF0EA5E9)),
                                      const SizedBox(width: 6),
                                      const Text(
                                        'Interactive Exercise',
                                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFF0EA5E9)),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    topic.practicePrompt,
                                    style: TextStyle(fontSize: 12, height: 1.35, color: _text(isDark)),
                                  ),
                                  const SizedBox(height: 8),
                                  InkWell(
                                    onTap: () {
                                      HapticFeedback.lightImpact();
                                      setState(() {
                                        if (_revealedPracticeIds.contains(topic.id)) {
                                          _revealedPracticeIds.remove(topic.id);
                                        } else {
                                          _revealedPracticeIds.add(topic.id);
                                        }
                                      });
                                    },
                                    child: Text(
                                      _revealedPracticeIds.contains(topic.id) ? '▲ Hide Solution' : '▼ Reveal Solution & Answer',
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF0EA5E9),
                                      ),
                                    ),
                                  ),
                                  if (_revealedPracticeIds.contains(topic.id) && topic.practiceSolution.isNotEmpty) ...[
                                    const SizedBox(height: 8),
                                    Text(
                                      topic.practiceSolution,
                                      style: TextStyle(
                                        fontSize: 11.5,
                                        height: 1.4,
                                        color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF334155),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                  ],

                  // ⚙️ 6. UNDER THE HOOD, SIL & PITFALL TRAPS
                  _buildPillarSection(
                    icon: Icons.memory_rounded,
                    iconColor: const Color(0xFFEC4899),
                    title: '6. Memory Layout, SIL & Pitfall Traps',
                    isDark: isDark,
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (topic.underTheHood.isNotEmpty) ...[
                          Text(
                            topic.underTheHood,
                            style: TextStyle(fontSize: 12, height: 1.45, color: _text(isDark)),
                          ),
                          const SizedBox(height: 8),
                        ],
                        if (topic.interviewTraps.isNotEmpty) ...[
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xFF2D1515) : const Color(0xFFFEF2F2),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: const Color(0xFFF87171).withValues(alpha: 0.3)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Row(
                                  children: [
                                    Icon(Icons.warning_amber_rounded, size: 14, color: Color(0xFFEF4444)),
                                    SizedBox(width: 6),
                                    Text(
                                      'Interview Pitfall Traps',
                                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFFEF4444)),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                ...topic.interviewTraps.map((trap) => Padding(
                                      padding: const EdgeInsets.only(bottom: 4),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text('⚠️ ', style: TextStyle(fontSize: 11)),
                                          Expanded(
                                            child: Text(
                                              trap,
                                              style: TextStyle(fontSize: 11.5, height: 1.35, color: _text(isDark)),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // 🎓 7. SENIOR REVISION SUMMARY & INTERVIEW DRILLS
                  _buildPillarSection(
                    icon: Icons.quiz_rounded,
                    iconColor: const Color(0xFF10B981),
                    title: '7. Senior Revision Summary & Interview Drills',
                    isDark: isDark,
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (topic.quickRevision.isNotEmpty) ...[
                          ...topic.quickRevision.map((rev) => Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('✓ ', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF10B981))),
                                    Expanded(
                                      child: Text(
                                        rev,
                                        style: TextStyle(fontSize: 11.5, height: 1.35, color: _text(isDark)),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                          const SizedBox(height: 10),
                        ],
                        // Detailed Interview Drill Button
                        OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: _trackColor()),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          icon: Icon(Icons.open_in_new_rounded, size: 14, color: _trackColor()),
                          label: Text(
                            'Open Full Deep-Dive Studio (${topic.interviewQuestions.length} Drills)',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: _trackColor()),
                          ),
                          onPressed: () {
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
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // HELPER WIDGETS FOR CARDS
  // ─────────────────────────────────────────────
  Widget _buildPillarSection({
    required IconData icon,
    required Color iconColor,
    required String title,
    required Widget content,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _surface(isDark),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _border(isDark)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 15, color: iconColor),
              const SizedBox(width: 6),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.1,
                  color: _text(isDark),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          content,
        ],
      ),
    );
  }

  Widget _codeTabButton(String label, bool active, VoidCallback onTap, bool isDark) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: active ? _trackColor() : (isDark ? Colors.white12 : Colors.black12),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 10.5,
            fontWeight: active ? FontWeight.w800 : FontWeight.w600,
            color: active ? Colors.white : _sub(isDark),
          ),
        ),
      ),
    );
  }

  Widget _difficultyBadge(String diff) {
    Color col;
    switch (diff.toLowerCase()) {
      case 'junior':
      case 'core':
      case 'fundamental':
        col = const Color(0xFF10B981);
        break;
      case 'mid':
      case 'intermediate':
        col = const Color(0xFF0EA5E9);
        break;
      case 'senior':
        col = _swiftOrange;
        break;
      case 'staff':
      case 'expert':
      default:
        col = const Color(0xFF8B5CF6);
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
      decoration: BoxDecoration(
        color: col.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        diff.toUpperCase(),
        style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w800, color: col),
      ),
    );
  }

  Widget _masteryStatusPill(TopicMasteryStatus status, String topicId) {
    Color col;
    switch (status) {
      case TopicMasteryStatus.notStarted:
        col = Colors.grey;
        break;
      case TopicMasteryStatus.inProgress:
        col = const Color(0xFFF59E0B);
        break;
      case TopicMasteryStatus.completed:
        col = const Color(0xFF10B981);
        break;
      case TopicMasteryStatus.mastered:
        col = const Color(0xFF8B5CF6);
        break;
    }

    return PopupMenuButton<TopicMasteryStatus>(
      tooltip: 'Update Mastery',
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
      icon: Container(
        width: 22,
        height: 22,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: col.withValues(alpha: 0.18),
          shape: BoxShape.circle,
        ),
        child: Text(
          status.symbol,
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: col),
        ),
      ),
      onSelected: (newStatus) {
        HapticFeedback.lightImpact();
        setState(() {
          _progressService.setTopicStatus(topicId, newStatus);
        });
      },
      itemBuilder: (context) => TopicMasteryStatus.values
          .map((s) => PopupMenuItem(
                value: s,
                child: Text('${s.symbol} ${s.label}'),
              ))
          .toList(),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off_rounded, size: 48, color: _sub(isDark)),
            const SizedBox(height: 12),
            Text(
              'No concepts match "$_searchQuery"',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: _text(isDark)),
            ),
            const SizedBox(height: 6),
            Text(
              'Try searching for COW, Sendable, Protocols, or reset the filters.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: _sub(isDark)),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _searchController.clear();
                setState(() {
                  _searchQuery = '';
                  _difficultyFilter = 'All';
                });
              },
              child: const Text('Reset Search & Filters'),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // 5. SPECIAL VAULTS BOTTOM SHEET
  // ─────────────────────────────────────────────
  void _showSpecialVaultsSheet(BuildContext context, bool isDark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: _card(isDark),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: _border(isDark),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: Row(
                    children: [
                      const Icon(Icons.flash_on_rounded, color: Color(0xFFF59E0B)),
                      const SizedBox(width: 8),
                      Text(
                        'Special Preparation Vaults',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: _text(isDark)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                ListTile(
                  leading: const Icon(Icons.quiz_rounded, color: Color(0xFFEC4899)),
                  title: const Text('Timed Interview Mode'),
                  subtitle: const Text('10-question timed technical interview with scoring'),
                  onTap: () {
                    Navigator.pop(ctx);
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const PrepInterviewModeScreen(initialQuestionCount: 10)));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.architecture_rounded, color: Color(0xFF8B5CF6)),
                  title: const Text('System Design Blueprints'),
                  subtitle: const Text('5 enterprise architecture specs (Offline, Media, Chat)'),
                  onTap: () {
                    Navigator.pop(ctx);
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const PrepSystemDesignScreen()));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.terminal_rounded, color: Color(0xFFF97316)),
                  title: const Text('Git Masterclass'),
                  subtitle: const Text('33 production conflict & recovery puzzles'),
                  onTap: () {
                    Navigator.pop(ctx);
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const PrepGitMasterclassScreen()));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.verified_user_rounded, color: Color(0xFF10B981)),
                  title: const Text('Staff Signals & Benchmarks'),
                  subtitle: const Text('10 landmark calibrations & 16 staff signals'),
                  onTap: () {
                    Navigator.pop(ctx);
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const PrepStaffSignalsScreen()));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.code_rounded, color: Color(0xFF0EA5E9)),
                  title: const Text('Coding & DSA Logic Hub'),
                  subtitle: const Text('14 modules, two-pointer, sliding window, DP'),
                  onTap: () {
                    Navigator.pop(ctx);
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const CodingDsaHubScreen()));
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
