import 'package:flutter/material.dart';
import '../../../core/widgets/code_snippet_card.dart';
import '../../../core/widgets/section_header.dart';
import '../models/claude_domain.dart';

/// In-depth study guide for a specific Claude Architect Exam domain.
class ClaudeDomainDetailScreen extends StatefulWidget {
  final ClaudeDomain domain;

  const ClaudeDomainDetailScreen({super.key, required this.domain});

  @override
  State<ClaudeDomainDetailScreen> createState() => _ClaudeDomainDetailScreenState();
}

class _ClaudeDomainDetailScreenState extends State<ClaudeDomainDetailScreen> {
  int? _selectedAnswerIndex;
  bool _submitted = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final domain = widget.domain;
    final sampleQ = domain.sampleQuestions.first;

    return Scaffold(
      appBar: AppBar(
        title: Text('Domain ${domain.id}: ${domain.weightPercentage}% Weight'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Domain Hero Banner
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [domain.color.withAlpha(200), const Color(0xFF1E293B)]
                    : [domain.color, domain.color.withAlpha(210)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: domain.color.withAlpha(50),
                  blurRadius: 12,
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
                        color: Colors.white.withAlpha(40),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'DOMAIN ${domain.id} • ${domain.moduleCount} LESSON MODULES',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${domain.weightPercentage}% of Exam',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  domain.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  domain.description,
                  style: const TextStyle(color: Colors.white, fontSize: 13, height: 1.4),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // SECTION 1: Core Topics
          const SectionHeader(
            title: '1. Core Architectural Concepts',
            subtitle: 'Tested directly on the Claude Certified Architect exam.',
            icon: Icons.auto_stories_rounded,
            badgeText: 'Curriculum',
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: domain.coreTopics.map((topic) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.check_circle_rounded, color: domain.color, size: 18),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            topic,
                            style: const TextStyle(fontSize: 13.5, height: 1.35),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // SECTION 2: Code Architecture Pattern
          const SectionHeader(
            title: '2. Implementation Pattern',
            subtitle: 'Production syntax and SDK design patterns.',
            icon: Icons.code_rounded,
            badgeText: 'SDK Blueprint',
          ),
          CodeSnippetCard(
            title: '${domain.title} Pattern',
            code: domain.codeExample,
            explanation:
                'Official pattern recommended by Anthropic documentation for Domain ${domain.id}.',
          ),

          // SECTION 3: Exam Readiness Checklist
          const SectionHeader(
            title: '3. Exam Readiness Checklist',
            subtitle: 'Must-know criteria before scheduling your Pearson VUE exam.',
            icon: Icons.fact_check_rounded,
            badgeText: 'Pass Criteria',
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: domain.examChecklist.map((tip) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.star_rounded, color: Colors.amber, size: 18),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            tip,
                            style: const TextStyle(fontSize: 13, height: 1.3),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // SECTION 4: Live Sample Exam Question
          const SectionHeader(
            title: '4. Practice Exam Scenario',
            subtitle: 'Test your knowledge on a realistic exam-style question.',
            icon: Icons.quiz_rounded,
            badgeText: 'Practice',
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    sampleQ.question,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, height: 1.35),
                  ),
                  const SizedBox(height: 14),
                  RadioGroup<int>(
                    groupValue: _selectedAnswerIndex,
                    onChanged: (val) {
                      if (!_submitted && val != null) {
                        setState(() => _selectedAnswerIndex = val);
                      }
                    },
                    child: Column(
                      children: List.generate(sampleQ.options.length, (idx) {
                        final isSelected = _selectedAnswerIndex == idx;
                        final isCorrect = idx == sampleQ.correctIndex;

                        Color? tileColor;
                        if (_submitted) {
                          if (isCorrect) {
                            tileColor = Colors.green.withAlpha(30);
                          } else if (isSelected) {
                            tileColor = Colors.red.withAlpha(30);
                          }
                        }

                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          decoration: BoxDecoration(
                            color: tileColor,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: isSelected
                                  ? domain.color
                                  : (isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1)),
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(10),
                            onTap: _submitted
                                ? null
                                : () => setState(() => _selectedAnswerIndex = idx),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              child: Row(
                                children: [
                                  Radio<int>(value: idx),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      sampleQ.options[idx],
                                      style: const TextStyle(fontSize: 13),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (!_submitted)
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: domain.color),
                      onPressed: _selectedAnswerIndex == null
                          ? null
                          : () {
                              setState(() => _submitted = true);
                            },
                      child: const Text('Submit Answer', style: TextStyle(color: Colors.white)),
                    )
                  else ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: (_selectedAnswerIndex == sampleQ.correctIndex ? Colors.green : Colors.red)
                            .withAlpha(20),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: (_selectedAnswerIndex == sampleQ.correctIndex
                                  ? Colors.green
                                  : Colors.red)
                              .withAlpha(60),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                _selectedAnswerIndex == sampleQ.correctIndex
                                    ? Icons.check_circle_rounded
                                    : Icons.cancel_rounded,
                                color: _selectedAnswerIndex == sampleQ.correctIndex
                                    ? Colors.green
                                    : Colors.red,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                _selectedAnswerIndex == sampleQ.correctIndex
                                    ? 'Correct Answer!'
                                    : 'Incorrect',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: _selectedAnswerIndex == sampleQ.correctIndex
                                      ? Colors.green
                                      : Colors.red,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Rationale: ${sampleQ.rationale}',
                            style: const TextStyle(fontSize: 12.5, height: 1.35),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _submitted = false;
                          _selectedAnswerIndex = null;
                        });
                      },
                      child: const Text('Try Again'),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
