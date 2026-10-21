import 'dart:async';
import 'package:flutter/material.dart';
import '../data/ios_prep_master_hierarchy_data.dart';
import '../data/ios_prep_data.dart';
import 'ios_prep_domain_detail_screen.dart';
import 'ios_prep_system_design_screen.dart';
import 'ios_prep_topic_detail_screen.dart';

/// Global Search screen across all 24 Domains, Modules, Topics,
/// Under-the-hood internals, Interview Questions, and System Design cases.
class PrepGlobalSearchScreen extends StatefulWidget {
  final String? initialQuery;

  const PrepGlobalSearchScreen({super.key, this.initialQuery});

  @override
  State<PrepGlobalSearchScreen> createState() => _PrepGlobalSearchScreenState();
}

class _PrepGlobalSearchScreenState extends State<PrepGlobalSearchScreen> {
  late final TextEditingController _searchController;
  Timer? _debounceTimer;
  String _filterType = 'All'; // 'All', 'Topics', 'Questions', 'System Design', 'Domains'
  late String _query;
  List<_SearchResult> _cachedResults = [];

  @override
  void initState() {
    super.initState();
    _query = widget.initialQuery ?? '';
    _searchController = TextEditingController(text: _query);
    _cachedResults = _performSearch(_query.trim().toLowerCase());
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? const Color(0xFF0F172A) : const Color(0xFFF6F7FB);
    final surfaceColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textPrimary = isDark ? Colors.white : const Color(0xFF0F172A);
    final textSecondary = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    const primaryIndigo = Color(0xFF6366F1);

    final results = _cachedResults;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: backgroundColor,
        foregroundColor: textPrimary,
        title: Container(
          height: 42,
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
            ),
          ),
          child: TextField(
            controller: _searchController,
            autofocus: true,
            onChanged: (val) {
              _debounceTimer?.cancel();
              _debounceTimer = Timer(const Duration(milliseconds: 250), () {
                if (mounted) {
                  setState(() {
                    _query = val;
                    _cachedResults = _performSearch(_query.trim().toLowerCase());
                  });
                }
              });
            },
            style: TextStyle(fontSize: 14, color: textPrimary),
            decoration: InputDecoration(
              hintText: 'Search 24 domains, topics, Q&A, system design...',
              hintStyle: TextStyle(fontSize: 13, color: textSecondary),
              prefixIcon: Icon(Icons.search_rounded, size: 20, color: textSecondary),
              suffixIcon: _query.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, size: 16),
                      tooltip: 'Clear search query',
                      onPressed: () {
                        _debounceTimer?.cancel();
                        _searchController.clear();
                        setState(() {
                          _query = '';
                          _cachedResults = _performSearch('');
                        });
                      },
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Filter Pills
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: surfaceColor,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFilterPill('All'),
                    const SizedBox(width: 8),
                    _buildFilterPill('Topics'),
                    const SizedBox(width: 8),
                    _buildFilterPill('Questions'),
                    const SizedBox(width: 8),
                    _buildFilterPill('System Design'),
                    const SizedBox(width: 8),
                    _buildFilterPill('Coding'),
                    const SizedBox(width: 8),
                    _buildFilterPill('Scenarios'),
                    const SizedBox(width: 8),
                    _buildFilterPill('Domains'),
                  ],
                ),
              ),
            ),

            // Search Results Count
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              alignment: Alignment.centerLeft,
              child: Text(
                _query.isEmpty
                    ? 'Recommended topics and domains'
                    : '${results.length} result${results.length == 1 ? '' : 's'} for "$_query"',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: textSecondary,
                ),
              ),
            ),

            // Results List
            Expanded(
              child: results.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search_off_rounded, size: 48, color: textSecondary.withValues(alpha: 0.5)),
                          const SizedBox(height: 12),
                          Text(
                            'No matching concepts found',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Try searching for ARC, Concurrency, SwiftUI, or System Design',
                            style: TextStyle(fontSize: 13, color: textSecondary),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      itemCount: results.length,
                      itemBuilder: (context, index) {
                        final item = results[index];
                        return _buildResultCard(item, isDark, primaryIndigo);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterPill(String filter) {
    final isSelected = _filterType == filter;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        setState(() {
          _filterType = filter;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF6366F1)
              : (isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9)),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          filter,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? Colors.white : (isDark ? Colors.white70 : const Color(0xFF475569)),
          ),
        ),
      ),
    );
  }

  Widget _buildResultCard(_SearchResult item, bool isDark, Color primaryIndigo) {
    final surfaceColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textPrimary = isDark ? Colors.white : const Color(0xFF0F172A);
    final textSecondary = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: item.onTap,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: item.categoryColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(item.icon, size: 20, color: item.categoryColor),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: item.categoryColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              item.typeLabel.toUpperCase(),
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                color: item.categoryColor,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              item.tag,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item.title,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.snippet,
                        style: TextStyle(
                          fontSize: 12,
                          height: 1.4,
                          color: textSecondary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(Icons.chevron_right_rounded, size: 20, color: textSecondary),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<_SearchResult> _performSearch(String query) {
    final List<_SearchResult> list = [];

    // Search Domains
    if (_filterType == 'All' || _filterType == 'Domains') {
      for (final domain in masterPrepDomains) {
        if (query.isEmpty ||
            domain.title.toLowerCase().contains(query) ||
            domain.tag.toLowerCase().contains(query) ||
            domain.description.toLowerCase().contains(query)) {
          list.add(_SearchResult(
            typeLabel: 'Domain',
            tag: 'Domain 0${domain.domainNumber}',
            title: '${domain.emoji} ${domain.title}',
            snippet: domain.description,
            icon: Icons.folder_special_rounded,
            categoryColor: const Color(0xFF6366F1),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PrepDomainDetailScreen(domain: domain),
                ),
              );
            },
          ));
        }
      }
    }

    // Search Topics
    if (_filterType == 'All' || _filterType == 'Topics') {
      for (final domain in masterPrepDomains) {
        for (final module in domain.modules) {
          for (final topic in module.topics) {
            if (query.isEmpty ||
                topic.title.toLowerCase().contains(query) ||
                topic.quickAnswer.toLowerCase().contains(query) ||
                topic.whyItMatters.toLowerCase().contains(query) ||
                topic.underTheHood.toLowerCase().contains(query)) {
              list.add(_SearchResult(
                typeLabel: 'Topic',
                tag: domain.tag,
                title: topic.title,
                snippet: topic.quickAnswer,
                icon: Icons.article_rounded,
                categoryColor: const Color(0xFF0EA5E9),
                onTap: () {
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
              ));
            }
          }
        }
      }
    }

    // Search Interview Questions
    if (_filterType == 'All' || _filterType == 'Questions') {
      for (final domain in masterPrepDomains) {
        for (final module in domain.modules) {
          for (final topic in module.topics) {
            for (final q in topic.interviewQuestions) {
              if (query.isEmpty ||
                  q.question.toLowerCase().contains(query) ||
                  q.answer.toLowerCase().contains(query) ||
                  q.seniorInsight.toLowerCase().contains(query)) {
                list.add(_SearchResult(
                  typeLabel: 'Interview Q&A',
                  tag: '${domain.tag} • ${q.difficulty}',
                  title: q.question,
                  snippet: q.answer,
                  icon: Icons.help_outline_rounded,
                  categoryColor: const Color(0xFFF59E0B),
                  onTap: () {
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
                ));
              }
            }
          }
        }
      }
    }

    // Search System Design
    if (_filterType == 'All' || _filterType == 'System Design') {
      for (final s in masterSystemDesignCases) {
        if (query.isEmpty ||
            s.title.toLowerCase().contains(query) ||
            s.subtitle.toLowerCase().contains(query) ||
            s.components.any((c) => c.toLowerCase().contains(query))) {
          list.add(_SearchResult(
            typeLabel: 'System Design',
            tag: 'Case 0${s.id} • ${s.difficulty}',
            title: s.title,
            snippet: s.subtitle,
            icon: Icons.architecture_rounded,
            categoryColor: const Color(0xFF10B981),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PrepSystemDesignScreen(initialCaseStudyId: s.id),
                ),
              );
            },
          ));
        }
      }
    }

    // Search Coding Challenges
    if (_filterType == 'All' || _filterType == 'Coding') {
      for (final cc in codingChallenges) {
        if (query.isEmpty ||
            cc.title.toLowerCase().contains(query) ||
            cc.problemStatement.toLowerCase().contains(query) ||
            cc.optimizedApproach.toLowerCase().contains(query)) {
          list.add(_SearchResult(
            typeLabel: 'Coding Challenge',
            tag: '${cc.category} • ${cc.difficulty}',
            title: cc.title,
            snippet: cc.problemStatement,
            icon: Icons.code_rounded,
            categoryColor: const Color(0xFF8B5CF6),
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Theme.of(context).cardColor,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (ctx) => DraggableScrollableSheet(
                  initialChildSize: 0.7,
                  maxChildSize: 0.95,
                  minChildSize: 0.5,
                  expand: false,
                  builder: (_, scrollCtrl) => ListView(
                    controller: scrollCtrl,
                    padding: const EdgeInsets.all(20),
                    children: [
                      Text(cc.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      Text(cc.problemStatement, style: const TextStyle(fontSize: 14)),
                      const SizedBox(height: 16),
                      const Text('Optimized Approach:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent)),
                      Text(cc.optimizedApproach),
                      const SizedBox(height: 16),
                      const Text('Swift Solution:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                      Text(cc.swiftSolution),
                    ],
                  ),
                ),
              );
            },
          ));
        }
      }
    }

    // Search Production Scenarios
    if (_filterType == 'All' || _filterType == 'Scenarios') {
      for (final sc in enterpriseDefenseCases) {
        if (query.isEmpty ||
            sc.title.toLowerCase().contains(query) ||
            sc.interviewerTrap.toLowerCase().contains(query) ||
            sc.solution.toLowerCase().contains(query)) {
          list.add(_SearchResult(
            typeLabel: 'Production Scenario',
            tag: 'Crisis Playbook • Case ${sc.id}',
            title: sc.title,
            snippet: sc.solution,
            icon: Icons.security_rounded,
            categoryColor: const Color(0xFFEF4444),
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Theme.of(context).cardColor,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (ctx) => DraggableScrollableSheet(
                  initialChildSize: 0.7,
                  maxChildSize: 0.95,
                  minChildSize: 0.5,
                  expand: false,
                  builder: (_, scrollCtrl) => ListView(
                    controller: scrollCtrl,
                    padding: const EdgeInsets.all(20),
                    children: [
                      Text(sc.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      const Text('Interviewer Trap:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange)),
                      Text(sc.interviewerTrap),
                      const SizedBox(height: 16),
                      const Text('Production Solution:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                      Text(sc.solution),
                      const SizedBox(height: 16),
                      const Text('Webhook & Storage Invariant:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent)),
                      Text(sc.webhookTruth),
                    ],
                  ),
                ),
              );
            },
          ));
        }
      }
    }

    return list;
  }
}

class _SearchResult {
  final String typeLabel;
  final String tag;
  final String title;
  final String snippet;
  final IconData icon;
  final Color categoryColor;
  final VoidCallback onTap;

  const _SearchResult({
    required this.typeLabel,
    required this.tag,
    required this.title,
    required this.snippet,
    required this.icon,
    required this.categoryColor,
    required this.onTap,
  });
}
