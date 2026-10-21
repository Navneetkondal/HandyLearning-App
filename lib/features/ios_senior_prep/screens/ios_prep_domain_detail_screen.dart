import 'package:flutter/material.dart';
import '../data/ios_prep_master_hierarchy_data.dart';
import '../models/ios_prep_hierarchy_models.dart';
import '../models/ios_prep_models.dart';
import '../services/prep_progress_service.dart';
import 'ios_prep_interview_mode_screen.dart';
import 'ios_prep_topic_detail_screen.dart';

/// Redesigned Hierarchical Domain Detail Screen.
/// Follows the Apple-native engineering spec:
/// - Header: Domain Number, Name, Difficulty, Progress bar, Modules & Topics metrics
/// - Primary Action: [ Continue ]
/// - Secondary Actions: [ Practice ], [ Interview ]
/// - Module List: Each Module shows topics, Q&A count, and live mastery status (○, ◐, ✓, ★).
/// - Tapping a topic opens the 14-section `PrepTopicDetailScreen`.
class PrepDomainDetailScreen extends StatefulWidget {
  final dynamic domain; // Can be PrepDomainHierarchy or PrepDomain

  const PrepDomainDetailScreen({
    super.key,
    required this.domain,
  });

  @override
  State<PrepDomainDetailScreen> createState() => _PrepDomainDetailScreenState();
}

class _PrepDomainDetailScreenState extends State<PrepDomainDetailScreen> {
  final PrepProgressService _progressService = PrepProgressService.instance;
  late final PrepDomainHierarchy _hierarchyDomain;

  @override
  void initState() {
    super.initState();
    if (widget.domain is PrepDomainHierarchy) {
      _hierarchyDomain = widget.domain as PrepDomainHierarchy;
    } else {
      final prepDom = widget.domain as PrepDomain;
      _hierarchyDomain = masterPrepDomains.firstWhere(
        (d) => d.domainNumber == prepDom.domainNumber,
        orElse: () => masterPrepDomains.first,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListenableBuilder(
      listenable: _progressService,
      builder: (context, _) {
        final domainProgress = _progressService.getDomainProgress(_hierarchyDomain.domainNumber);
        final percentInt = (domainProgress * 100).toInt();

        return Scaffold(
          backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF6F7FB),
          appBar: AppBar(
            elevation: 0,
            backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
            foregroundColor: isDark ? Colors.white : const Color(0xFF0F172A),
            title: Row(
              children: [
                Text(_hierarchyDomain.emoji, style: const TextStyle(fontSize: 20)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Domain ${_hierarchyDomain.domainNumber.toString().padLeft(2, '0')}: ${_hierarchyDomain.tag}',
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.quiz_rounded, color: Color(0xFF6366F1)),
                tooltip: 'Domain Interview Mode',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PrepInterviewModeScreen(initialDomainFilter: _hierarchyDomain.title),
                    ),
                  );
                },
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildDomainHeroHeader(isDark, percentInt, domainProgress),
              const SizedBox(height: 16),
              _buildActionButtons(context, isDark),
              const SizedBox(height: 20),
              _buildSectionTitle('CURRICULUM MODULES & TOPICS', isDark),
              const SizedBox(height: 10),
              ..._hierarchyDomain.modules.map((module) => _buildModuleCard(context, module, isDark)),
              const SizedBox(height: 16),
              _buildArchitecturalTreatiseCard(isDark),
              const SizedBox(height: 16),
              _buildStaffSignalsCard(isDark),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  // -------------------------------------------------------------
  // HERO HEADER
  // -------------------------------------------------------------
  // -------------------------------------------------------------
  // HERO HEADER & PROGRESS CARD (Showcase Screen 3)
  // -------------------------------------------------------------
  Widget _buildDomainHeroHeader(bool isDark, int percentInt, double progress) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFEEF2FF),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFC7D2FE),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFEC4899).withValues(alpha: isDark ? 0.25 : 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Text(
                  _hierarchyDomain.emoji,
                  style: const TextStyle(fontSize: 20),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Domain ${_hierarchyDomain.domainNumber.toString().padLeft(2, '0')}: ${_hierarchyDomain.title}',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFF6366F1).withValues(alpha: isDark ? 0.3 : 0.15),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            _hierarchyDomain.difficulty,
                            style: const TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF6366F1),
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF59E0B).withValues(alpha: isDark ? 0.3 : 0.15),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: const Text(
                            'High Importance',
                            style: TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFFF59E0B),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'YOUR PROGRESS',
                style: TextStyle(
                  fontSize: 10.5,
                  letterSpacing: 0.8,
                  fontWeight: FontWeight.w700,
                  color: isDark ? const Color(0xFF818CF8) : const Color(0xFF4338CA),
                ),
              ),
              Text(
                '$percentInt% Complete',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF4F46E5),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: isDark ? const Color(0xFF334155) : const Color(0xFFC7D2FE),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF10B981)),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMetricStatItem('${_hierarchyDomain.totalTopics}', 'Topics', isDark),
              _buildMetricStatItem('${_hierarchyDomain.totalQuestions}', 'Q&A', isDark),
              _buildMetricStatItem('4', 'Coding', isDark),
              _buildMetricStatItem('3', 'Scenarios', isDark),
            ],
          ),
          const SizedBox(height: 12),
          // Action Buttons: Continue Learning > & Secondary
          Row(
            children: [
              Expanded(
                flex: 5,
                child: SizedBox(
                  height: 38,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4F46E5),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                    ),
                    onPressed: () {
                      final firstTopic = _hierarchyDomain.modules.first.topics.first;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PrepTopicDetailScreen(
                            topic: firstTopic,
                            domainTitle: _hierarchyDomain.title,
                            domainNumber: _hierarchyDomain.domainNumber,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.play_arrow_rounded, size: 16),
                    label: const Text(
                      'Continue',
                      style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 3,
                child: SizedBox(
                  height: 38,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: isDark ? Colors.white : const Color(0xFF4F46E5),
                      backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
                      side: BorderSide(color: isDark ? const Color(0xFF475569) : const Color(0xFFC7D2FE)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      padding: EdgeInsets.zero,
                    ),
                    onPressed: () {
                      final firstTopic = _hierarchyDomain.modules.first.topics.first;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PrepTopicDetailScreen(
                            topic: firstTopic,
                            domainTitle: _hierarchyDomain.title,
                            domainNumber: _hierarchyDomain.domainNumber,
                          ),
                        ),
                      );
                    },
                    child: const Text('Practice', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11.5)),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 3,
                child: SizedBox(
                  height: 38,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF10B981),
                      backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
                      side: const BorderSide(color: Color(0xFF10B981)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      padding: EdgeInsets.zero,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PrepInterviewModeScreen(initialDomainFilter: _hierarchyDomain.title),
                        ),
                      );
                    },
                    child: const Text('Interview', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11.5)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricStatItem(String value, String label, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w900,
            color: isDark ? Colors.white : const Color(0xFF1E1B4B),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
          ),
        ),
      ],
    );
  }

  // -------------------------------------------------------------
  // ACTION BUTTONS (Retained for legacy if called)
  // -------------------------------------------------------------
  Widget _buildActionButtons(BuildContext context, bool isDark) {
    return const SizedBox.shrink();
  }

  Widget _buildSectionTitle(String title, bool isDark) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.8,
        color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
      ),
    );
  }

  // -------------------------------------------------------------
  // MODULE CARD WITH TOPICS
  // -------------------------------------------------------------
  Widget _buildModuleCard(BuildContext context, DomainModule module, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      child: Material(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(
            color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
          initiallyExpanded: true,
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          leading: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: _hierarchyDomain.modules.indexOf(module) == 0
                  ? const Color(0xFF10B981).withValues(alpha: isDark ? 0.25 : 0.12)
                  : (_hierarchyDomain.modules.indexOf(module) == 1
                      ? const Color(0xFF6366F1).withValues(alpha: isDark ? 0.25 : 0.12)
                      : (isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9))),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: _hierarchyDomain.modules.indexOf(module) == 0
                ? const Icon(Icons.check_circle_rounded, color: Color(0xFF10B981), size: 20)
                : (_hierarchyDomain.modules.indexOf(module) == 1
                    ? const Icon(Icons.play_arrow_rounded, color: Color(0xFF6366F1), size: 20)
                    : Icon(Icons.lock_outline_rounded,
                        color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B), size: 16)),
          ),
          title: Text(
            module.title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14.5),
          ),
          subtitle: Text(
            '${module.topics.length} Topics • ${module.totalQuestions} Q&A',
            style: TextStyle(
              fontSize: 12,
              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    module.description,
                    style: TextStyle(
                      fontSize: 12.5,
                      color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ...module.topics.map((topic) => _buildTopicRow(context, topic, isDark)),
                ],
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }

  Widget _buildTopicRow(BuildContext context, MasterTopic topic, bool isDark) {
    final status = _progressService.getTopicStatus(topic.id);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
          leading: InkWell(
            onTap: () => _progressService.cycleTopicStatus(topic.id),
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: _statusColor(status).withAlpha(isDark ? 35 : 20),
                shape: BoxShape.circle,
              ),
              child: Text(
                status.symbol,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: _statusColor(status),
                ),
              ),
            ),
          ),
          title: Text(
            topic.title,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13.5),
          ),
          subtitle: Row(
            children: [
              Text(
                '${topic.estimatedMinutes} min',
                style: TextStyle(fontSize: 11, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
              ),
              const SizedBox(width: 8),
              Text(
                '• ${topic.difficulty}',
                style: TextStyle(fontSize: 11, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
              ),
            ],
          ),
          trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Color(0xFF6366F1)),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PrepTopicDetailScreen(
                  topic: topic,
                  domainTitle: _hierarchyDomain.title,
                  domainNumber: _hierarchyDomain.domainNumber,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // -------------------------------------------------------------
  // ARCHITECTURAL TREATISE CARD
  // -------------------------------------------------------------
  Widget _buildArchitecturalTreatiseCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.architecture_rounded, color: Color(0xFF6366F1), size: 20),
              const SizedBox(width: 8),
              Text(
                'Architectural Treatise & Invariants',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            _hierarchyDomain.architecturalTreatise,
            style: TextStyle(
              fontSize: 13,
              height: 1.5,
              color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
            ),
          ),
        ],
      ),
    );
  }

  // -------------------------------------------------------------
  // STAFF SIGNALS CARD
  // -------------------------------------------------------------
  Widget _buildStaffSignalsCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.verified_user_rounded, color: Color(0xFF10B981), size: 20),
              const SizedBox(width: 8),
              Text(
                'Staff & Principal Rubric Signals',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ..._hierarchyDomain.staffSignals.map((signal) {
            final isPositive = signal.toLowerCase().contains('strong hire');
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    isPositive ? Icons.check_circle_outline_rounded : Icons.highlight_off_rounded,
                    size: 16,
                    color: isPositive ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      signal,
                      style: TextStyle(
                        fontSize: 12.5,
                        height: 1.4,
                        color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Color _statusColor(TopicMasteryStatus status) {
    switch (status) {
      case TopicMasteryStatus.notStarted:
        return const Color(0xFF94A3B8);
      case TopicMasteryStatus.inProgress:
        return const Color(0xFF0EA5E9);
      case TopicMasteryStatus.completed:
        return const Color(0xFF10B981);
      case TopicMasteryStatus.mastered:
        return const Color(0xFFF59E0B);
    }
  }
}
