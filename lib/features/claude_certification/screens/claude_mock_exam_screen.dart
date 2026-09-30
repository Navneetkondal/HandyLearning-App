import 'dart:async';
import 'package:flutter/material.dart';
import '../models/claude_mock_exam_data.dart';

/// Full interactive timed mock exam engine for the Claude Certified Architect exam.
/// Simulates Pearson VUE grading (1000-point scale, 720 pass threshold).
class ClaudeMockExamScreen extends StatefulWidget {
  const ClaudeMockExamScreen({super.key});

  @override
  State<ClaudeMockExamScreen> createState() => _ClaudeMockExamScreenState();
}

class _ClaudeMockExamScreenState extends State<ClaudeMockExamScreen> {
  static const int _totalDurationSeconds = 15 * 60; // 15 minutes for 10 scenario questions
  int _secondsRemaining = _totalDurationSeconds;
  Timer? _timer;

  int _currentIndex = 0;
  final Map<int, int> _userAnswers = {}; // questionId -> optionIndex
  final Set<int> _flaggedForReview = {}; // questionIds flagged
  bool _isSubmitted = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        _timer?.cancel();
        _submitExam(autoSubmit: true);
      }
    });
  }

  String _formatTime(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void _submitExam({bool autoSubmit = false}) {
    if (_isSubmitted) return;

    if (!autoSubmit && _userAnswers.length < claudeMockExamPool.length) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Unanswered Questions'),
          content: Text(
            'You have answered ${_userAnswers.length} of ${claudeMockExamPool.length} questions. '
            'Are you sure you want to finish the exam?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Return to Exam'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD97706)),
              onPressed: () {
                Navigator.of(ctx).pop();
                _finalizeSubmission();
              },
              child: const Text('Submit Anyway', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
    } else {
      _finalizeSubmission();
    }
  }

  void _finalizeSubmission() {
    _timer?.cancel();
    setState(() {
      _isSubmitted = true;
    });
  }

  void _retakeExam() {
    setState(() {
      _userAnswers.clear();
      _flaggedForReview.clear();
      _currentIndex = 0;
      _secondsRemaining = _totalDurationSeconds;
      _isSubmitted = false;
    });
    _startTimer();
  }

  int _calculateScore() {
    int correctCount = 0;
    for (final q in claudeMockExamPool) {
      if (_userAnswers[q.id] == q.correctIndex) {
        correctCount++;
      }
    }
    // Scale to 1000 points
    return ((correctCount / claudeMockExamPool.length) * 1000).round();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isSubmitted ? 'Exam Results & Diagnostic' : 'Claude Certified Architect Exam'),
        actions: [
          if (!_isSubmitted) ...[
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: _secondsRemaining < 120 ? Colors.red.withAlpha(30) : const Color(0xFFD97706).withAlpha(25),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _secondsRemaining < 120 ? Colors.red : const Color(0xFFD97706),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.timer_outlined,
                    size: 16,
                    color: _secondsRemaining < 120 ? Colors.red : const Color(0xFFD97706),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _formatTime(_secondsRemaining),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: _secondsRemaining < 120 ? Colors.red : const Color(0xFFD97706),
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.grid_view_rounded),
              tooltip: 'Question Navigator',
              onPressed: _showQuestionNavigator,
            ),
          ],
        ],
      ),
      body: _isSubmitted ? _buildResultsView() : _buildExamQuestionView(),
    );
  }

  Widget _buildExamQuestionView() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final currentQ = claudeMockExamPool[_currentIndex];
    final selectedOption = _userAnswers[currentQ.id];
    final isFlagged = _flaggedForReview.contains(currentQ.id);

    return Column(
      children: [
        // Progress Indicator
        LinearProgressIndicator(
          value: (_currentIndex + 1) / claudeMockExamPool.length,
          backgroundColor: theme.colorScheme.surfaceContainerHighest,
          valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFD97706)),
          minHeight: 5,
        ),

        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Meta Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD97706).withAlpha(25),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'QUESTION ${_currentIndex + 1} OF ${claudeMockExamPool.length}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                        color: Color(0xFFD97706),
                      ),
                    ),
                  ),
                  const Spacer(),
                  // Flag Button
                  TextButton.icon(
                    onPressed: () {
                      setState(() {
                        if (isFlagged) {
                          _flaggedForReview.remove(currentQ.id);
                        } else {
                          _flaggedForReview.add(currentQ.id);
                        }
                      });
                    },
                    icon: Icon(
                      isFlagged ? Icons.bookmark_added_rounded : Icons.bookmark_border_rounded,
                      color: isFlagged ? Colors.amber : Colors.grey,
                      size: 18,
                    ),
                    label: Text(
                      isFlagged ? 'Flagged for Review' : 'Flag Question',
                      style: TextStyle(
                        fontSize: 12,
                        color: isFlagged ? Colors.amber : Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                'Domain ${currentQ.domainId}: ${currentQ.domainName}',
                style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 14),

              // Scenario Text
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    currentQ.scenario,
                    style: const TextStyle(fontSize: 14.5, height: 1.45, fontWeight: FontWeight.w600),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Options
              RadioGroup<int>(
                groupValue: selectedOption,
                onChanged: (val) {
                  if (val != null) {
                    setState(() => _userAnswers[currentQ.id] = val);
                  }
                },
                child: Column(
                  children: List.generate(currentQ.options.length, (idx) {
                    final isOptionSelected = selectedOption == idx;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: isOptionSelected ? const Color(0xFFD97706).withAlpha(20) : null,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isOptionSelected
                              ? const Color(0xFFD97706)
                              : (isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1)),
                          width: isOptionSelected ? 2 : 1,
                        ),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          setState(() => _userAnswers[currentQ.id] = idx);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          child: Row(
                            children: [
                              Radio<int>(
                                value: idx,
                                activeColor: const Color(0xFFD97706),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  currentQ.options[idx],
                                  style: TextStyle(
                                    fontSize: 13.5,
                                    height: 1.35,
                                    fontWeight: isOptionSelected ? FontWeight.w600 : FontWeight.normal,
                                  ),
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
            ],
          ),
        ),

        // Bottom Controls Bar
        SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : Colors.white,
              border: Border(top: BorderSide(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0))),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton(
                  onPressed: _currentIndex > 0
                      ? () => setState(() => _currentIndex--)
                      : null,
                  child: const Text('Previous'),
                ),
                if (_currentIndex < claudeMockExamPool.length - 1)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD97706)),
                    onPressed: () => setState(() => _currentIndex++),
                    child: const Text('Next Question', style: TextStyle(color: Colors.white)),
                  )
                else
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade700),
                    onPressed: _submitExam,
                    icon: const Icon(Icons.check_circle_outline, color: Colors.white),
                    label: const Text('Submit Exam', style: TextStyle(color: Colors.white)),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResultsView() {
    final score = _calculateScore();
    final isPassed = score >= 720;
    final totalCorrect = claudeMockExamPool.where((q) => _userAnswers[q.id] == q.correctIndex).length;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Score Header Card
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isPassed
                  ? [Colors.green.shade700, Colors.teal.shade800]
                  : [Colors.red.shade700, Colors.orange.shade800],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: (isPassed ? Colors.green : Colors.red).withAlpha(50),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            children: [
              Icon(
                isPassed ? Icons.verified_rounded : Icons.warning_amber_rounded,
                size: 54,
                color: Colors.white,
              ),
              const SizedBox(height: 10),
              Text(
                isPassed ? 'PASSED — CONGRATULATIONS!' : 'NEEDS FURTHER REVIEW',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '$score / 1000 Points',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 34,
                ),
              ),
              Text(
                '$totalCorrect of ${claudeMockExamPool.length} answered correctly • Pass Mark: 720 (72%)',
                style: const TextStyle(color: Colors.white70, fontSize: 13),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: isPassed ? Colors.green.shade800 : Colors.red.shade800,
                ),
                onPressed: _retakeExam,
                icon: const Icon(Icons.replay_rounded),
                label: const Text('Retake Mock Exam'),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // Domain Performance Breakdown
        const Text(
          'Performance by Exam Domain',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 10),
        _buildDomainStat(1, 'Agentic Architecture', 3),
        _buildDomainStat(2, 'Tool Design & MCP', 2),
        _buildDomainStat(3, 'Claude Code & Workflows', 2),
        _buildDomainStat(4, 'Prompt Engineering', 2),
        _buildDomainStat(5, 'Context Management', 1),

        const SizedBox(height: 20),

        // Review Mode Title
        const Text(
          'Detailed Question-by-Question Review',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 10),

        // Question Accordions
        ...claudeMockExamPool.map((q) {
          final chosen = _userAnswers[q.id];
          final isCorrect = chosen == q.correctIndex;

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ExpansionTile(
              leading: Icon(
                isCorrect ? Icons.check_circle_rounded : Icons.cancel_rounded,
                color: isCorrect ? Colors.green : Colors.red,
              ),
              title: Text(
                'Question ${q.id} (Domain ${q.domainId})',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              subtitle: Text(
                isCorrect ? 'Correct (+100 pts)' : (chosen == null ? 'Unanswered' : 'Incorrect'),
                style: TextStyle(fontSize: 12, color: isCorrect ? Colors.green : Colors.red),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(q.scenario, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13.5)),
                      const SizedBox(height: 12),
                      Text('Your Answer: ${chosen != null ? q.options[chosen] : "None"}',
                          style: TextStyle(color: isCorrect ? Colors.green : Colors.red, fontSize: 13)),
                      const SizedBox(height: 4),
                      if (!isCorrect)
                        Text('Correct Answer: ${q.options[q.correctIndex]}',
                            style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 13)),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFD97706).withAlpha(15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          'Anthropic Architectural Rationale:\n${q.rationale}',
                          style: const TextStyle(fontSize: 12.5, height: 1.35),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildDomainStat(int domainId, String domainName, int totalInDomain) {
    final correctInDomain = claudeMockExamPool
        .where((q) => q.domainId == domainId && _userAnswers[q.id] == q.correctIndex)
        .length;
    final ratio = correctInDomain / totalInDomain;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Domain $domainId: $domainName', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
              Text('$correctInDomain / $totalInDomain (${(ratio * 100).toInt()}%)',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: ratio,
              minHeight: 6,
              backgroundColor: Colors.grey.shade300,
              valueColor: AlwaysStoppedAnimation<Color>(
                ratio >= 0.7 ? Colors.green : (ratio >= 0.5 ? Colors.orange : Colors.red),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showQuestionNavigator() {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (ctx) {
        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.grid_view_rounded, size: 20, color: Color(0xFFD97706)),
                    const SizedBox(width: 8),
                    const Text('Question Navigator', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const Spacer(),
                    Text(
                      '${_userAnswers.length} of ${claudeMockExamPool.length} answered',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 1.3,
                  ),
                  itemCount: claudeMockExamPool.length,
                  itemBuilder: (context, idx) {
                    final q = claudeMockExamPool[idx];
                    final isAnswered = _userAnswers.containsKey(q.id);
                    final isFlagged = _flaggedForReview.contains(q.id);
                    final isCurrent = _currentIndex == idx;

                    Color bg = Colors.grey.shade200;
                    if (isAnswered) bg = const Color(0xFFD97706).withAlpha(180);
                    if (isCurrent) bg = const Color(0xFFD97706);

                    return InkWell(
                      key: Key('navigatorQuestionBtn_${idx + 1}'),
                      borderRadius: BorderRadius.circular(8),
                      onTap: () {
                        Navigator.of(ctx).pop();
                        setState(() => _currentIndex = idx);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: bg,
                          borderRadius: BorderRadius.circular(8),
                          border: isFlagged ? Border.all(color: Colors.amber, width: 2) : null,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '${idx + 1}',
                          style: TextStyle(
                            color: (isAnswered || isCurrent) ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
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
