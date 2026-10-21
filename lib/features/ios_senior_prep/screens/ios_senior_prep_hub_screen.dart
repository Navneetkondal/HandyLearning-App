import 'package:flutter/material.dart';
import '../data/ios_prep_data.dart';
import 'ios_prep_domain_detail_screen.dart';
import 'ios_prep_global_search_screen.dart';
import 'ios_prep_interview_mode_screen.dart';
import 'ios_prep_system_design_screen.dart';
import 'ios_master_handbook_screen.dart';
import 'ios_prep_git_masterclass_screen.dart';
import 'ios_prep_staff_signals_screen.dart';
import '../services/prep_progress_service.dart';
import '../../../core/theme/app_colors.dart';

class IosSeniorPrepHubScreen extends StatefulWidget {
  const IosSeniorPrepHubScreen({super.key});

  @override
  State<IosSeniorPrepHubScreen> createState() => _IosSeniorPrepHubScreenState();
}

class _IosSeniorPrepHubScreenState extends State<IosSeniorPrepHubScreen> {
  String _selectedCategory = 'All Domains';

  final List<String> _categories = [
    'All Domains',
    'Swift Handbook',
    'Interview Q&A',
    'System Design',
    'Git Masterclass',
    'Staff Signals',
  ];

  @override
  void initState() {
    super.initState();
  }

  void _showQuickActions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Quick Actions',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ListTile(
                leading: const Icon(Icons.mic, color: Color(0xFF6366F1)),
                title: const Text('Interview Mode'),
                subtitle: const Text('10-question timed technical interview'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const PrepInterviewModeScreen(initialQuestionCount: 10)));
                },
              ),
              ListTile(
                leading: const Icon(Icons.book, color: Color(0xFF3B82F6)),
                title: const Text('Master Handbook'),
                subtitle: const Text('Full 889-page organized curriculum'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const IosMasterHandbookScreen()));
                },
              ),
              ListTile(
                leading: const Icon(Icons.architecture, color: Color(0xFF8B5CF6)),
                title: const Text('System Design'),
                subtitle: const Text('5 enterprise architecture blueprints'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const PrepSystemDesignScreen()));
                },
              ),
              ListTile(
                leading: const Icon(Icons.terminal, color: Color(0xFFEC4899)),
                title: const Text('Git Masterclass'),
                subtitle: const Text('33 production & recovery puzzles'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const PrepGitMasterclassScreen()));
                },
              ),
              ListTile(
                leading: const Icon(Icons.verified_user, color: Color(0xFF10B981)),
                title: const Text('Staff Signals & Benchmarks'),
                subtitle: const Text('10 landmark calibrations & 16 staff signals'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const PrepStaffSignalsScreen()));
                },
              ),
            ],
          ),
        ),
      );
    },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('iOS Prep', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: 'Search All Topics',
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PrepGlobalSearchScreen())),
          ),
          IconButton(
            icon: const Icon(Icons.terminal, color: Color(0xFFEC4899)),
            tooltip: 'Git Masterclass',
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PrepGitMasterclassScreen())),
          ),
          IconButton(
            icon: const Icon(Icons.verified_user, color: Color(0xFF10B981)),
            tooltip: 'Staff Signals & Benchmarks',
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PrepStaffSignalsScreen())),
          ),
          IconButton(
            icon: const Icon(Icons.quiz),
            tooltip: 'Interview Mode',
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PrepInterviewModeScreen(initialQuestionCount: 10))),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Quick Actions & Study Modes',
        onPressed: _showQuickActions,
        child: const Icon(Icons.flash_on),
      ),
      body: Column(
        children: [
          _buildProgressStrip(),
          _buildCategoryPills(),
          Expanded(
            child: _buildMainContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressStrip() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final progressService = PrepProgressService.instance;
    final pct = progressService.overallProgressPercentage;
    final completed = progressService.completedTopicsCount;
    final total = progressService.totalTopicsCount;
    
    return Container(
      constraints: const BoxConstraints(minHeight: 48),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFEEF2FF),
        border: Border(
          bottom: BorderSide(
            color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
            width: 0.8,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: total > 0 ? (completed / total) : 0,
                backgroundColor: isDark ? Colors.white12 : Colors.black12,
                valueColor: AlwaysStoppedAnimation<Color>(
                  isDark ? AppColors.primaryLight : AppColors.primary,
                ),
                minHeight: 8,
                semanticsLabel: 'Curriculum completion progress',
                semanticsValue: '${(pct * 100).toInt()}%',
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '${(pct * 100).toInt()}%',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.primaryLight : AppColors.primary,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '$completed/$total topics',
            style: TextStyle(
              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryPills() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Wrap(
        spacing: 8,
        children: _categories.map((category) {
          final isSelected = _selectedCategory == category;
          return FilterChip(
            label: Text(category),
            selected: isSelected,
            onSelected: (bool selected) {
              if (selected) {
                setState(() => _selectedCategory = category);
              }
            },
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMainContent() {
    switch (_selectedCategory) {
      case 'All Domains':
        return _buildDomainList();
      case 'Swift Handbook':
        return const IosMasterHandbookScreen(isEmbedded: true);
      case 'Interview Q&A':
        return _buildQAList();
      case 'System Design':
        return const PrepSystemDesignScreen();
      case 'Git Masterclass':
        return const PrepGitMasterclassScreen();
      case 'Staff Signals':
        return const PrepStaffSignalsScreen();
      default:
        return _buildPlaceholder(_selectedCategory);
    }
  }

  Widget _buildDomainList() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: prepDomains.length,
      itemBuilder: (context, index) {
        final domain = prepDomains[index];
        final progress = PrepProgressService.instance.getDomainProgress(domain.domainNumber);
        
        return Card(
          elevation: 0,
          margin: const EdgeInsets.only(bottom: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Theme.of(context).dividerColor.withValues(alpha: 0.5)),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            leading: CircleAvatar(
              backgroundColor: isDark
                  ? AppColors.primary.withValues(alpha: 0.25)
                  : const Color(0xFFEEF2FF),
              child: Text(
                '${domain.domainNumber}',
                style: TextStyle(
                  color: AppColors.primaryText(isDark),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(
              domain.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              '${domain.topics.length} topics • ${(progress * 100).toInt()}% completed',
              style: TextStyle(fontSize: 12, color: Theme.of(context).textTheme.bodySmall?.color),
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => PrepDomainDetailScreen(domain: domain)),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildQAList() {
    final questions = seniorExamQuestions;
    if (questions.isEmpty) {
      return const Center(child: Text('No Q&A available'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: questions.length,
      itemBuilder: (context, index) {
        final q = questions[index];
        return Card(
          elevation: 0,
          margin: const EdgeInsets.only(bottom: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Theme.of(context).dividerColor.withValues(alpha: 0.5)),
          ),
          child: ExpansionTile(
            title: Text(q.question, style: const TextStyle(fontWeight: FontWeight.w500)),
            subtitle: Text('Level: ${q.level} • ${q.category}'),
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(q.answer),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPlaceholder(String title) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.construction, size: 48, color: Theme.of(context).disabledColor),
          const SizedBox(height: 16),
          Text('$title Coming Soon', style: Theme.of(context).textTheme.titleLarge),
        ],
      ),
    );
  }
}
