import 'dart:async';
import 'package:flutter/material.dart';
import '../data/ios_prep_master_hierarchy_data.dart';
import '../data/ios_prep_senior100_data.dart';

/// Interview Mode screen providing:
/// - Quick 10
/// - Senior 25
/// - Lead 40
/// - Mock Interview (Timed 30s Think Mode + Staff Evaluation)
class PrepInterviewModeScreen extends StatefulWidget {
  final int initialQuestionCount;
  final String? initialCategory;
  final String? initialDomainFilter;

  const PrepInterviewModeScreen({
    super.key,
    this.initialQuestionCount = 10,
    this.initialCategory,
    this.initialDomainFilter,
  });

  @override
  State<PrepInterviewModeScreen> createState() => _PrepInterviewModeScreenState();
}

class _PrepInterviewModeScreenState extends State<PrepInterviewModeScreen> {
  late int _selectedQuestionCount;
  int _currentIndex = 0;
  bool _isAnswerRevealed = false;
  
  // Timer state for "Think Mode" (30 seconds)
  Timer? _thinkTimer;
  int _thinkSecondsRemaining = 30;
  bool _isTimerRunning = false;

  // Questions loaded for the session
  List<_InterviewSessionItem> _sessionQuestions = [];

  // User evaluation tracking: 'nailed', 'got_it', 'needs_review'
  final Map<int, String> _evaluations = {};

  @override
  void initState() {
    super.initState();
    _selectedQuestionCount = widget.initialQuestionCount;
    _buildQuestionSession();
  }

  @override
  void dispose() {
    _thinkTimer?.cancel();
    super.dispose();
  }

  void _buildQuestionSession() {
    _thinkTimer?.cancel();
    _isTimerRunning = false;
    _thinkSecondsRemaining = 30;
    _currentIndex = 0;
    _isAnswerRevealed = false;
    _evaluations.clear();

    final List<_InterviewSessionItem> pool = [];

    // Pull questions from master domains
    for (final domain in masterPrepDomains) {
      for (final module in domain.modules) {
        for (final topic in module.topics) {
          for (final q in topic.interviewQuestions) {
            pool.add(_InterviewSessionItem(
              domainTitle: domain.title,
              domainTag: domain.tag,
              topicTitle: topic.title,
              question: q.question,
              difficulty: q.difficulty,
              answer: q.answer,
              seniorInsight: q.seniorInsight.isNotEmpty
                  ? q.seniorInsight
                  : 'Demonstrates deep architectural trade-off awareness, memory behavior, and Swift 6 concurrency safety.',
              whyOtherAnswersFail: q.whyOtherAnswersFail.isNotEmpty
                  ? q.whyOtherAnswersFail
                  : 'Candidates fail by reciting textbook definitions without explaining compiler mechanics or production edge cases.',
              commonTrap: q.commonTrap.isNotEmpty
                  ? q.commonTrap
                  : 'Assuming compiler auto-optimizes without understanding ABI stability or dynamic dispatch cost.',
              followUpQuestion: q.followUpQuestion.isNotEmpty
                  ? q.followUpQuestion
                  : 'How would you measure the performance and memory footprint of this in Xcode Instruments?',
            ));
          }
        }
      }
    }

    // Pull from Senior 100 questions as well
    for (final s in senior100Questions) {
      pool.add(_InterviewSessionItem(
        domainTitle: s.category,
        domainTag: 'Senior 100',
        topicTitle: s.scenario ?? 'System Architecture',
        question: s.question,
        difficulty: 'Senior',
        answer: s.bulletPoints.join('\n\n• '),
        seniorInsight: 'Senior candidates emphasize maintainability, testing seams, and performance invariants over raw syntax.',
        whyOtherAnswersFail: 'Mid-level answers tend to miss error propagation, thread hops, and memory leak vectors.',
        commonTrap: 'Failing to mention backward compatibility or Apple framework release constraints.',
        followUpQuestion: 'What are the trade-offs of this approach compared to an alternative architectural pattern?',
      ));
    }

    // Shuffle pool for realistic interview variety
    pool.shuffle();

    // Take selected count
    _sessionQuestions = pool.take(_selectedQuestionCount).toList();
  }

  void _startThinkTimer() {
    _thinkTimer?.cancel();
    setState(() {
      _thinkSecondsRemaining = 30;
      _isTimerRunning = true;
    });

    _thinkTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_thinkSecondsRemaining > 0) {
        setState(() {
          _thinkSecondsRemaining--;
        });
      } else {
        timer.cancel();
        setState(() {
          _isTimerRunning = false;
        });
      }
    });
  }

  void _pauseThinkTimer() {
    _thinkTimer?.cancel();
    setState(() {
      _isTimerRunning = false;
    });
  }

  void _resetThinkTimer() {
    _thinkTimer?.cancel();
    setState(() {
      _thinkSecondsRemaining = 30;
      _isTimerRunning = false;
    });
  }

  void _recordEvaluation(String rating) {
    setState(() {
      _evaluations[_currentIndex] = rating;
    });
  }

  void _goToNextQuestion() {
    if (_currentIndex < _sessionQuestions.length - 1) {
      _resetThinkTimer();
      setState(() {
        _currentIndex++;
        _isAnswerRevealed = false;
      });
    } else {
      _showCompletionDialog();
    }
  }

  void _goToPreviousQuestion() {
    if (_currentIndex > 0) {
      _resetThinkTimer();
      setState(() {
        _currentIndex--;
        _isAnswerRevealed = false;
      });
    }
  }

  void _showCompletionDialog() {
    final nailedCount = _evaluations.values.where((v) => v == 'nailed').length;
    final gotItCount = _evaluations.values.where((v) => v == 'got_it').length;
    final reviewCount = _evaluations.values.where((v) => v == 'needs_review').length;

    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.stars_rounded, color: Color(0xFFF59E0B), size: 28),
            const SizedBox(width: 10),
            Text(
              'Session Complete!',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: isDark ? Colors.white : const Color(0xFF1E293B),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'You completed all ${_sessionQuestions.length} interview questions in this session.',
              style: TextStyle(
                fontSize: 14,
                color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
              ),
            ),
            const SizedBox(height: 16),
            _buildStatRow('Nailed It (★)', nailedCount, const Color(0xFF10B981)),
            const SizedBox(height: 8),
            _buildStatRow('Got It (✓)', gotItCount, const Color(0xFF6366F1)),
            const SizedBox(height: 8),
            _buildStatRow('Needs Review (◐)', reviewCount, const Color(0xFFEF4444)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            child: const Text('Exit to Hub'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF6366F1),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              setState(() {
                _buildQuestionSession();
              });
            },
            child: const Text('Start New Session'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, int count, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
          ],
        ),
        Text(
          '$count',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: color),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? const Color(0xFF0F172A) : const Color(0xFFF6F7FB);
    final surfaceColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textPrimary = isDark ? Colors.white : const Color(0xFF0F172A);
    final textSecondary = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    const primaryIndigo = Color(0xFF6366F1);

    if (_sessionQuestions.isEmpty) {
      return Scaffold(
        backgroundColor: backgroundColor,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final item = _sessionQuestions[_currentIndex];
    final progress = (_currentIndex + 1) / _sessionQuestions.length;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: backgroundColor,
        foregroundColor: textPrimary,
        centerTitle: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Senior Interview Mode',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, letterSpacing: -0.3),
            ),
            Text(
              'Question ${_currentIndex + 1} of ${_sessionQuestions.length}',
              style: TextStyle(fontSize: 12, color: textSecondary, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        actions: [
          // Mode Selector Menu
          PopupMenuButton<int>(
            icon: const Icon(Icons.tune_rounded),
            tooltip: 'Select Session Length',
            onSelected: (count) {
              setState(() {
                _selectedQuestionCount = count;
                _buildQuestionSession();
              });
            },
            itemBuilder: (ctx) => [
              const PopupMenuItem(value: 10, child: Text('Quick 10 Questions')),
              const PopupMenuItem(value: 25, child: Text('Senior 25 Questions')),
              const PopupMenuItem(value: 40, child: Text('Lead 40 Deep Dive')),
              const PopupMenuItem(value: 15, child: Text('Mock Interview (15 Questions)')),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Shuffle & Restart',
            onPressed: () {
              setState(() {
                _buildQuestionSession();
              });
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Linear Progress Bar
            LinearProgressIndicator(
              value: progress,
              backgroundColor: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
              valueColor: const AlwaysStoppedAnimation<Color>(primaryIndigo),
              minHeight: 4,
            ),

            // Mode Selector Pills
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              color: surfaceColor,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildModePill(10, 'Quick 10'),
                    const SizedBox(width: 8),
                    _buildModePill(25, 'Senior 25'),
                    const SizedBox(width: 8),
                    _buildModePill(40, 'Lead 40'),
                    const SizedBox(width: 8),
                    _buildModePill(15, 'Mock Interview'),
                  ],
                ),
              ),
            ),

            // Scrollable Question & Answer Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Context Pill & Difficulty
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: primaryIndigo.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            item.domainTag,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: primaryIndigo,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF59E0B).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            item.difficulty,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFFD97706),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            item.topicTitle,
                            textAlign: TextAlign.end,
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 11,
                              color: textSecondary,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Question Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: surfaceColor,
                        borderRadius: BorderRadius.circular(18),
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: primaryIndigo.withValues(alpha: 0.12),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.help_outline_rounded,
                                  color: primaryIndigo,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  item.question,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    color: textPrimary,
                                    height: 1.35,
                                    letterSpacing: -0.3,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 18),

                          // Think Timer Row
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: _isTimerRunning
                                    ? primaryIndigo.withValues(alpha: 0.4)
                                    : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.timer_outlined,
                                  size: 18,
                                  color: _isTimerRunning ? primaryIndigo : textSecondary,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Think Timer: ${_thinkSecondsRemaining}s',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: _isTimerRunning ? primaryIndigo : textPrimary,
                                  ),
                                ),
                                const Spacer(),
                                if (!_isTimerRunning && _thinkSecondsRemaining == 30)
                                  GestureDetector(
                                    onTap: _startThinkTimer,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: primaryIndigo,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Text(
                                        'Start 30s',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  )
                                else if (_isTimerRunning)
                                  GestureDetector(
                                    onTap: _pauseThinkTimer,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF59E0B),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Text(
                                        'Pause',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  )
                                else
                                  GestureDetector(
                                    onTap: _resetThinkTimer,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        'Reset',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                          color: textPrimary,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Reveal Answer Button OR Expanded Senior Answer Breakdown
                    if (!_isAnswerRevealed) ...[
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: FilledButton.icon(
                          style: FilledButton.styleFrom(
                            backgroundColor: primaryIndigo,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            elevation: 0,
                          ),
                          onPressed: () {
                            setState(() {
                              _isAnswerRevealed = true;
                              _thinkTimer?.cancel();
                              _isTimerRunning = false;
                            });
                          },
                          icon: const Icon(Icons.visibility_rounded),
                          label: const Text(
                            'Reveal Senior Answer & Analysis',
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ] else ...[
                      // Comprehensive Answer Section
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: surfaceColor,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: const Color(0xFF10B981).withValues(alpha: 0.3),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF10B981).withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(Icons.check_circle_outline, color: Color(0xFF10B981), size: 18),
                                ),
                                const SizedBox(width: 10),
                                const Text(
                                  'Senior / Lead Reference Answer',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF10B981),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              item.answer,
                              style: TextStyle(
                                fontSize: 14,
                                height: 1.5,
                                color: textPrimary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Senior Insight Card
                      _buildInsightCard(
                        title: 'Senior & Staff Insight',
                        icon: Icons.lightbulb_outline_rounded,
                        color: const Color(0xFF6366F1),
                        content: item.seniorInsight,
                        isDark: isDark,
                      ),

                      const SizedBox(height: 12),

                      // Why Other Answers Fail
                      _buildInsightCard(
                        title: 'Why Mid-Level Answers Fail',
                        icon: Icons.cancel_outlined,
                        color: const Color(0xFFEF4444),
                        content: item.whyOtherAnswersFail,
                        isDark: isDark,
                      ),

                      const SizedBox(height: 12),

                      // Common Interview Trap
                      _buildInsightCard(
                        title: 'Common Interview Trap',
                        icon: Icons.warning_amber_rounded,
                        color: const Color(0xFFF59E0B),
                        content: item.commonTrap,
                        isDark: isDark,
                      ),

                      const SizedBox(height: 12),

                      // Follow-up Question
                      _buildInsightCard(
                        title: 'Expected Follow-up Question',
                        icon: Icons.alt_route_rounded,
                        color: const Color(0xFF0D9488),
                        content: item.followUpQuestion,
                        isDark: isDark,
                      ),

                      const SizedBox(height: 20),

                      // Self-Assessment Rubric
                      Text(
                        'Self-Assessment & Mastery',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: _buildEvaluationButton(
                              'Needs Review',
                              'needs_review',
                              const Color(0xFFEF4444),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildEvaluationButton(
                              'Got It',
                              'got_it',
                              const Color(0xFF6366F1),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildEvaluationButton(
                              'Nailed It ★',
                              'nailed',
                              const Color(0xFF10B981),
                            ),
                          ),
                        ],
                      ),
                    ],

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),

            // Bottom Navigation Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: surfaceColor,
                border: Border(
                  top: BorderSide(
                    color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                  ),
                ),
              ),
              child: Row(
                children: [
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: textPrimary,
                      side: BorderSide(
                        color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
                      ),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    onPressed: _currentIndex > 0 ? _goToPreviousQuestion : null,
                    icon: const Icon(Icons.arrow_back_rounded, size: 18),
                    label: const Text('Previous'),
                  ),
                  const Spacer(),
                  FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: primaryIndigo,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    onPressed: _goToNextQuestion,
                    icon: Icon(
                      _currentIndex == _sessionQuestions.length - 1
                          ? Icons.done_all_rounded
                          : Icons.arrow_forward_rounded,
                      size: 18,
                    ),
                    label: Text(
                      _currentIndex == _sessionQuestions.length - 1 ? 'Finish Session' : 'Next Question',
                      style: const TextStyle(fontWeight: FontWeight.w700),
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

  Widget _buildModePill(int count, String label) {
    final isSelected = _selectedQuestionCount == count;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        if (!isSelected) {
          setState(() {
            _selectedQuestionCount = count;
            _buildQuestionSession();
          });
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF6366F1)
              : (isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9)),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? Colors.white : (isDark ? Colors.white70 : const Color(0xFF475569)),
          ),
        ),
      ),
    );
  }

  Widget _buildInsightCard({
    required String title,
    required IconData icon,
    required Color color,
    required String content,
    required bool isDark,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isDark ? 0.08 : 0.05),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(
              fontSize: 13,
              height: 1.45,
              color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEvaluationButton(String label, String value, Color color) {
    final isSelected = _evaluations[_currentIndex] == value;

    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        backgroundColor: isSelected ? color.withValues(alpha: 0.15) : Colors.transparent,
        side: BorderSide(
          color: isSelected ? color : color.withValues(alpha: 0.3),
          width: isSelected ? 2 : 1,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(vertical: 10),
      ),
      onPressed: () => _recordEvaluation(value),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
          color: color,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _InterviewSessionItem {
  final String domainTitle;
  final String domainTag;
  final String topicTitle;
  final String question;
  final String difficulty;
  final String answer;
  final String seniorInsight;
  final String whyOtherAnswersFail;
  final String commonTrap;
  final String followUpQuestion;

  const _InterviewSessionItem({
    required this.domainTitle,
    required this.domainTag,
    required this.topicTitle,
    required this.question,
    required this.difficulty,
    required this.answer,
    required this.seniorInsight,
    required this.whyOtherAnswersFail,
    required this.commonTrap,
    required this.followUpQuestion,
  });
}
