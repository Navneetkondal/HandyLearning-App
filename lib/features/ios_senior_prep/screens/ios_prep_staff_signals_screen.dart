import 'package:flutter/material.dart';
import '../data/ios_prep_data.dart';
import '../models/ios_prep_models.dart';

class PrepStaffSignalsScreen extends StatefulWidget {
  const PrepStaffSignalsScreen({super.key});

  @override
  State<PrepStaffSignalsScreen> createState() => _PrepStaffSignalsScreenState();
}

class _PrepStaffSignalsScreenState extends State<PrepStaffSignalsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final Map<int, int> _selectedTierPerQuestion = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Staff Signals & Benchmarks', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: const Color(0xFF6366F1),
          tabs: const [
            Tab(text: '4-Tier Calibrations'),
            Tab(text: '16 Staff Signals'),
            Tab(text: 'Crisis & PR Review'),
            Tab(text: 'Seniority Matrix'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildCalibrationsTab(isDark),
          _buildStaffSignalsTab(isDark),
          _buildCrisisAndReviewTab(isDark),
          _buildSeniorityMatrixTab(isDark),
        ],
      ),
    );
  }

  // =============================================================
  // TAB 1: 4-TIER BENCHMARK CALIBRATIONS
  // =============================================================
  Widget _buildCalibrationsTab(bool isDark) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: benchmarkCalibrations.length,
      itemBuilder: (context, index) {
        final b = benchmarkCalibrations[index];
        final selectedTier = _selectedTierPerQuestion[b.id] ?? 2; // Default to Senior (2)

        return Card(
          elevation: 0,
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
            ),
          ),
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header badge
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6366F1).withValues(alpha: isDark ? 0.3 : 0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'Benchmark #${b.id}: ${b.coreCompetency}',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6366F1),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  b.question,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                const SizedBox(height: 14),
                // 4-tier selector buttons
                Container(
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.all(3),
                  child: Row(
                    children: [
                      _buildTierSegment(b.id, 0, 'Junior', selectedTier, isDark),
                      _buildTierSegment(b.id, 1, 'Mid', selectedTier, isDark),
                      _buildTierSegment(b.id, 2, 'Senior', selectedTier, isDark),
                      _buildTierSegment(b.id, 3, 'Staff', selectedTier, isDark),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                // Calibrated Answer Display
                _buildAnswerContent(b, selectedTier, isDark),
                const SizedBox(height: 12),
                // Interview evaluation guide
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E1B4B).withValues(alpha: 0.4) : const Color(0xFFEEF2FF),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isDark ? const Color(0xFF4338CA).withValues(alpha: 0.4) : const Color(0xFFC7D2FE),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.psychology, size: 18, color: Color(0xFF6366F1)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          b.interviewEvaluationGuide,
                          style: TextStyle(
                            fontSize: 11.5,
                            height: 1.35,
                            color: isDark ? const Color(0xFFC7D2FE) : const Color(0xFF3730A3),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTierSegment(int questionId, int tierIndex, String label, int currentTier, bool isDark) {
    final isSelected = currentTier == tierIndex;
    Color activeColor;
    switch (tierIndex) {
      case 0:
        activeColor = const Color(0xFF10B981);
        break;
      case 1:
        activeColor = const Color(0xFF3B82F6);
        break;
      case 2:
        activeColor = const Color(0xFF8B5CF6);
        break;
      default:
        activeColor = const Color(0xFFEC4899);
    }

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTierPerQuestion[questionId] = tierIndex),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            color: isSelected ? (isDark ? activeColor.withValues(alpha: 0.25) : Colors.white) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            boxShadow: isSelected && !isDark
                ? [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4, offset: const Offset(0, 1))]
                : null,
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected ? activeColor : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnswerContent(BenchmarkCalibration b, int tierIndex, bool isDark) {
    String answer;
    String badgeText;
    Color accentColor;

    switch (tierIndex) {
      case 0:
        answer = b.juniorAnswer;
        badgeText = 'Junior Expectation (0–2 YOE)';
        accentColor = const Color(0xFF10B981);
        break;
      case 1:
        answer = b.midAnswer;
        badgeText = 'Mid-Level Expectation (2–5 YOE)';
        accentColor = const Color(0xFF3B82F6);
        break;
      case 2:
        answer = b.seniorAnswer;
        badgeText = 'Senior Engineer Expectation (5–8 YOE)';
        accentColor = const Color(0xFF8B5CF6);
        break;
      default:
        answer = b.staffAnswer;
        badgeText = 'Staff / Principal Expectation (8+ YOE)';
        accentColor = const Color(0xFFEC4899);
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: accentColor.withValues(alpha: isDark ? 0.12 : 0.06),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: accentColor.withValues(alpha: isDark ? 0.3 : 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.workspace_premium, size: 14, color: accentColor),
              const SizedBox(width: 6),
              Text(
                badgeText,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: accentColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            answer,
            style: TextStyle(
              fontSize: 13,
              height: 1.45,
              color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF1E293B),
            ),
          ),
        ],
      ),
    );
  }

  // =============================================================
  // TAB 2: THE 16 STAFF SIGNALS
  // =============================================================
  Widget _buildStaffSignalsTab(bool isDark) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: staffSignals.length,
      itemBuilder: (context, index) {
        final s = staffSignals[index];
        return Card(
          elevation: 0,
          margin: const EdgeInsets.only(bottom: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: BorderSide(
              color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
            ),
          ),
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Signal #${s.id}: ${s.topic}',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        s.category,
                        style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Strong Signal
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withValues(alpha: isDark ? 0.15 : 0.08),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.check_circle_rounded, size: 16, color: Color(0xFF10B981)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(
                              fontSize: 12.5,
                              height: 1.4,
                              color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF0F172A),
                            ),
                            children: [
                              const TextSpan(
                                text: 'Strong Hire Signal: ',
                                style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF10B981)),
                              ),
                              TextSpan(text: s.strongSignal),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                // Weak Signal
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEF4444).withValues(alpha: isDark ? 0.15 : 0.08),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFEF4444).withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.cancel_rounded, size: 16, color: Color(0xFFEF4444)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(
                              fontSize: 12.5,
                              height: 1.4,
                              color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF0F172A),
                            ),
                            children: [
                              const TextSpan(
                                text: 'Red Flag Signal: ',
                                style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFEF4444)),
                              ),
                              TextSpan(text: s.weakSignal),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (s.followUpQuestion != null) ...[
                  const SizedBox(height: 10),
                  Theme(
                    data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      tilePadding: EdgeInsets.zero,
                      title: Text(
                        'Staff Follow-Up: ${s.followUpQuestion!}',
                        style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: Color(0xFF6366F1)),
                      ),
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            s.followUpAnswer ?? '',
                            style: TextStyle(
                              fontSize: 12,
                              height: 1.4,
                              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  // =============================================================
  // TAB 3: CRISIS MITIGATION & PR CODE REVIEW
  // =============================================================
  Widget _buildCrisisAndReviewTab(bool isDark) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'PRODUCTION P0 INCIDENT MITIGATION PLAYBOOKS',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.8,
            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
          ),
        ),
        const SizedBox(height: 8),
        ...behavioralCrisisScenarios.map((c) => _buildCrisisCard(c, isDark)),
        const SizedBox(height: 20),
        Text(
          'LIVE SENIOR / STAFF PR CODE REVIEW SIMULATOR',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.8,
            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
          ),
        ),
        const SizedBox(height: 8),
        ...codeReviewCases.map((cr) => _buildCodeReviewCard(cr, isDark)),
      ],
    );
  }

  Widget _buildCrisisCard(BehavioralCrisisScenario c, bool isDark) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
      ),
      color: isDark ? const Color(0xFF1E293B) : Colors.white,
      child: ExpansionTile(
        initiallyExpanded: c.id == 1,
        title: Text(c.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        subtitle: Text(
          c.scenario,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 11.5),
        ),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: [
          const Divider(height: 1),
          const SizedBox(height: 12),
          _buildActionStep('Phase 1: ${c.actionStep1Title}', c.actionStep1Content, const Color(0xFFEF4444), isDark),
          const SizedBox(height: 8),
          _buildActionStep('Phase 2: ${c.actionStep2Title}', c.actionStep2Content, const Color(0xFFF59E0B), isDark),
          const SizedBox(height: 8),
          _buildActionStep('Phase 3: ${c.actionStep3Title}', c.actionStep3Content, const Color(0xFF10B981), isDark),
        ],
      ),
    );
  }

  Widget _buildActionStep(String title, String content, Color color, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isDark ? 0.12 : 0.06),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: color)),
          const SizedBox(height: 4),
          Text(content, style: const TextStyle(fontSize: 12, height: 1.35)),
        ],
      ),
    );
  }

  Widget _buildCodeReviewCard(CodeReviewCase cr, bool isDark) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
      ),
      color: isDark ? const Color(0xFF1E293B) : Colors.white,
      child: ExpansionTile(
        initiallyExpanded: true,
        title: Text(cr.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: [
          const Divider(height: 1),
          const SizedBox(height: 12),
          const Text('Submitted Code (with subtle anti-patterns):', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0F172A) : const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(8),
            ),
            child: SelectableText(
              cr.submittedSnippet,
              style: const TextStyle(fontFamily: 'monospace', fontSize: 11.5, color: Color(0xFFF87171)),
            ),
          ),
          const SizedBox(height: 12),
          const Text('Defects Identified by Staff Interviewer:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          const SizedBox(height: 6),
          ...cr.defects.map((d) => Padding(
                padding: const EdgeInsets.only(bottom: 6.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                      decoration: BoxDecoration(
                        color: d.priority.contains('P1') ? Colors.red.withValues(alpha: 0.2) : Colors.orange.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        d.priority,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: d.priority.contains('P1') ? Colors.red : Colors.orange,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${d.title}: ${d.explanation}',
                        style: const TextStyle(fontSize: 12, height: 1.3),
                      ),
                    ),
                  ],
                ),
              )),
          const SizedBox(height: 10),
          const Text('Production-Grade Refactored Code:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0F172A) : const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(8),
            ),
            child: SelectableText(
              cr.productionRefactoredSnippet,
              style: const TextStyle(fontFamily: 'monospace', fontSize: 11.5, color: Color(0xFF34D399)),
            ),
          ),
        ],
      ),
    );
  }

  // =============================================================
  // TAB 4: SENIORITY PROGRESSION MATRIX
  // =============================================================
  Widget _buildSeniorityMatrixTab(bool isDark) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: seniorityRubricBands.length,
      itemBuilder: (context, index) {
        final band = seniorityRubricBands[index];
        return Card(
          elevation: 0,
          margin: const EdgeInsets.only(bottom: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: BorderSide(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
          ),
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        '${band.levelName} (${band.bandCode})',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6366F1).withValues(alpha: isDark ? 0.3 : 0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        band.yoeBand,
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF6366F1)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                _buildMatrixRow('Core Focus', band.coreFocus, Icons.track_changes, isDark),
                const SizedBox(height: 6),
                _buildMatrixRow('Round Expectations', band.roundExpectations, Icons.assignment, isDark),
                const SizedBox(height: 6),
                _buildMatrixRow('Target Depth', band.targetDepth, Icons.layers, isDark),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: isDark ? 0.15 : 0.08),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.warning, size: 14, color: Colors.red),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          'Disqualifying Red Flags: ${band.disqualifyingRedFlags}',
                          style: TextStyle(fontSize: 11.5, color: isDark ? const Color(0xFFFCA5A5) : Colors.red[800]),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMatrixRow(String label, String value, IconData icon, bool isDark) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 14, color: const Color(0xFF6366F1)),
        const SizedBox(width: 6),
        Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
        Expanded(child: Text(value, style: const TextStyle(fontSize: 12))),
      ],
    );
  }
}
