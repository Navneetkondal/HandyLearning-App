import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/ios_prep_master_hierarchy_data.dart';
import '../services/prep_progress_service.dart';

/// Screen displaying the 10 real-world iOS System Design Case Studies
/// with complete 13-point senior/staff architectural breakdowns.
class PrepSystemDesignScreen extends StatefulWidget {
  final int? initialCaseStudyId;

  const PrepSystemDesignScreen({
    super.key,
    this.initialCaseStudyId,
  });

  @override
  State<PrepSystemDesignScreen> createState() => _PrepSystemDesignScreenState();
}

class _PrepSystemDesignScreenState extends State<PrepSystemDesignScreen> {
  int _selectedCaseId = 1;

  @override
  void initState() {
    super.initState();
    if (widget.initialCaseStudyId != null) {
      _selectedCaseId = widget.initialCaseStudyId!;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? const Color(0xFF0F172A) : const Color(0xFFF6F7FB);
    final surfaceColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textPrimary = isDark ? Colors.white : const Color(0xFF0F172A);
    final textSecondary = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    const primaryIndigo = Color(0xFF6366F1);

    final currentCase = masterSystemDesignCases.firstWhere(
      (c) => c.id == _selectedCaseId,
      orElse: () => masterSystemDesignCases.first,
    );

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: backgroundColor,
        foregroundColor: textPrimary,
        title: const Text(
          'iOS System Design',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18, letterSpacing: -0.3),
        ),
        actions: [
          // Case selector popup
          PopupMenuButton<int>(
            icon: const Icon(Icons.list_alt_rounded),
            tooltip: 'Select Case Study',
            onSelected: (id) {
              setState(() {
                _selectedCaseId = id;
              });
            },
            itemBuilder: (ctx) => masterSystemDesignCases.map((c) {
              return PopupMenuItem<int>(
                value: c.id,
                child: Text('0${c.id}. ${c.title}'),
              );
            }).toList(),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Horizontal Case Study Selector Bar
            Container(
              height: 54,
              color: surfaceColor,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                itemCount: masterSystemDesignCases.length,
                itemBuilder: (context, index) {
                  final caseItem = masterSystemDesignCases[index];
                  final isSelected = caseItem.id == _selectedCaseId;
                  final isCompleted = PrepProgressService.instance.isSystemDesignCompleted(caseItem.id);

                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      selected: isSelected,
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _selectedCaseId = caseItem.id;
                          });
                        }
                      },
                      selectedColor: primaryIndigo,
                      backgroundColor: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
                      label: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (isCompleted) ...[
                            const Icon(Icons.check_circle, size: 14, color: Color(0xFF10B981)),
                            const SizedBox(width: 4),
                          ],
                          Text(
                            'Case 0${caseItem.id}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                              color: isSelected
                                  ? Colors.white
                                  : (isDark ? Colors.white70 : const Color(0xFF475569)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Main Case Study Detail View
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: surfaceColor,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
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
                                  color: primaryIndigo.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'CASE STUDY 0${currentCase.id}',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                    color: primaryIndigo,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF59E0B).withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  currentCase.difficulty,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFFD97706),
                                  ),
                                ),
                              ),
                              const Spacer(),
                              Icon(Icons.schedule, size: 14, color: textSecondary),
                              const SizedBox(width: 4),
                              Text(
                                currentCase.estimatedTime,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: textSecondary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            currentCase.title,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: textPrimary,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            currentCase.subtitle,
                            style: TextStyle(
                              fontSize: 14,
                              color: textSecondary,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Completed status toggle
                          ListenableBuilder(
                            listenable: PrepProgressService.instance,
                            builder: (context, _) {
                              final isDone = PrepProgressService.instance.isSystemDesignCompleted(currentCase.id);
                              return InkWell(
                                onTap: () {
                                  PrepProgressService.instance.toggleSystemDesignCompleted(currentCase.id);
                                },
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: isDone
                                        ? const Color(0xFF10B981).withValues(alpha: 0.12)
                                        : (isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC)),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: isDone
                                          ? const Color(0xFF10B981)
                                          : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        isDone ? Icons.check_circle_rounded : Icons.radio_button_unchecked,
                                        color: isDone ? const Color(0xFF10B981) : textSecondary,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        isDone ? 'Marked as Completed & Mastered' : 'Mark as Mastered',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                          color: isDone ? const Color(0xFF10B981) : textPrimary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Section 1: Functional & Non-Functional Requirements
                    _buildExpandableCard(
                      title: '1. System Requirements & Invariants',
                      icon: Icons.checklist_rounded,
                      color: const Color(0xFF6366F1),
                      isDark: isDark,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Functional Requirements',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(height: 6),
                          ...currentCase.functionalRequirements.map((r) => _buildBullet(r, isDark)),
                          const SizedBox(height: 14),
                          const Text(
                            'Non-Functional Requirements & Performance Invariants',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(height: 6),
                          ...currentCase.nonFunctionalRequirements.map((r) => _buildBullet(r, isDark)),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Section 2: Architecture Diagram (ASCII)
                    _buildExpandableCard(
                      title: '2. High-Level Architecture Diagram',
                      icon: Icons.account_tree_outlined,
                      color: const Color(0xFF0EA5E9),
                      isDark: isDark,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'End-to-End Component Topology',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: textSecondary,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.copy_rounded, size: 18),
                                tooltip: 'Copy Diagram',
                                onPressed: () {
                                  Clipboard.setData(ClipboardData(text: currentCase.architectureDiagram));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Architecture diagram copied to clipboard')),
                                  );
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: const Color(0xFF0F172A),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Text(
                                currentCase.architectureDiagram,
                                style: const TextStyle(
                                  fontFamily: 'monospace',
                                  fontSize: 11,
                                  color: Color(0xFF38BDF8),
                                  height: 1.3,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Section 3: Core Client Components
                    _buildExpandableCard(
                      title: '3. Core Client Components',
                      icon: Icons.widgets_outlined,
                      color: const Color(0xFF8B5CF6),
                      isDark: isDark,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: currentCase.components.map((c) => _buildBullet(c, isDark)).toList(),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Section 4: End-to-End Data Flow
                    _buildExpandableCard(
                      title: '4. End-to-End Data Flow & Lifecycle',
                      icon: Icons.sync_alt_rounded,
                      color: const Color(0xFF10B981),
                      isDark: isDark,
                      child: Text(
                        currentCase.dataFlow,
                        style: TextStyle(
                          fontSize: 13,
                          height: 1.5,
                          color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Section 5: API Contracts & Networking
                    _buildExpandableCard(
                      title: '5. API Design & Protocol Contracts',
                      icon: Icons.api_rounded,
                      color: const Color(0xFFEC4899),
                      isDark: isDark,
                      child: Text(
                        currentCase.apiDesign,
                        style: TextStyle(
                          fontSize: 13,
                          height: 1.5,
                          color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Section 6: Local DB & Schema
                    _buildExpandableCard(
                      title: '6. Local Persistence & Database Schema',
                      icon: Icons.storage_rounded,
                      color: const Color(0xFFF59E0B),
                      isDark: isDark,
                      child: Text(
                        currentCase.databaseDesign,
                        style: TextStyle(
                          fontSize: 13,
                          height: 1.5,
                          color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Section 7: Caching Strategy
                    _buildExpandableCard(
                      title: '7. Multi-Tier Caching Architecture',
                      icon: Icons.memory_rounded,
                      color: const Color(0xFF06B6D4),
                      isDark: isDark,
                      child: Text(
                        currentCase.cachingStrategy,
                        style: TextStyle(
                          fontSize: 13,
                          height: 1.5,
                          color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Section 8: Offline-First Sync Strategy
                    _buildExpandableCard(
                      title: '8. Offline-First Sync & Conflict Resolution',
                      icon: Icons.cloud_off_rounded,
                      color: const Color(0xFF14B8A6),
                      isDark: isDark,
                      child: Text(
                        currentCase.offlineSyncStrategy,
                        style: TextStyle(
                          fontSize: 13,
                          height: 1.5,
                          color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Section 9: Concurrency Model (Swift 6)
                    _buildExpandableCard(
                      title: '9. Concurrency & Thread Isolation',
                      icon: Icons.electric_bolt_rounded,
                      color: const Color(0xFFEAB308),
                      isDark: isDark,
                      child: Text(
                        currentCase.concurrencyModel,
                        style: TextStyle(
                          fontSize: 13,
                          height: 1.5,
                          color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Section 10: Security & Data Protection
                    _buildExpandableCard(
                      title: '10. Security & Privacy Hardening',
                      icon: Icons.security_rounded,
                      color: const Color(0xFFEF4444),
                      isDark: isDark,
                      child: Text(
                        currentCase.securityMeasures,
                        style: TextStyle(
                          fontSize: 13,
                          height: 1.5,
                          color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Section 11: Scalability, Battery & Thermal Budget
                    _buildExpandableCard(
                      title: '11. Scalability, Battery & Thermal Budget',
                      icon: Icons.battery_charging_full_rounded,
                      color: const Color(0xFF84CC16),
                      isDark: isDark,
                      child: Text(
                        currentCase.scalabilityStrategy,
                        style: TextStyle(
                          fontSize: 13,
                          height: 1.5,
                          color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Section 12: Architectural Trade-offs
                    _buildExpandableCard(
                      title: '12. Key Architectural Trade-offs',
                      icon: Icons.balance_rounded,
                      color: const Color(0xFFA855F7),
                      isDark: isDark,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: currentCase.tradeOffs.map((t) => _buildBullet(t, isDark)).toList(),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Section 13: System Design Interview Q&A
                    _buildExpandableCard(
                      title: '13. Staff Interview Drilldown Q&A',
                      icon: Icons.question_answer_rounded,
                      color: const Color(0xFFF97316),
                      isDark: isDark,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: currentCase.interviewQuestions.map((q) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF97316).withValues(alpha: 0.15),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          q.difficulty,
                                          style: const TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w700,
                                            color: Color(0xFFEA580C),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    q.question,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    q.answer,
                                    style: TextStyle(
                                      fontSize: 13,
                                      height: 1.45,
                                      color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569),
                                    ),
                                  ),
                                  if (q.seniorInsight.isNotEmpty) ...[
                                    const SizedBox(height: 8),
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF6366F1).withValues(alpha: 0.08),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        'Senior Insight: ${q.seniorInsight}',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF6366F1),
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandableCard({
    required String title,
    required IconData icon,
    required Color color,
    required bool isDark,
    required Widget child,
  }) {
    final surfaceColor = isDark ? const Color(0xFF1E293B) : Colors.white;

    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: true,
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          title: Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
          ),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          children: [child],
        ),
      ),
    );
  }

  Widget _buildBullet(String text, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6, right: 10),
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: const Color(0xFF6366F1),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13,
                height: 1.45,
                color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
