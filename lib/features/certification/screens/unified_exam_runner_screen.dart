import 'dart:async';
import 'package:flutter/material.dart';
import '../data/exam_question_bank.dart';
import '../models/certification_models.dart';
import '../services/certification_storage_service.dart';
import 'certificate_viewer_screen.dart';

/// Unified interactive timed certification exam engine supporting all tracks.
class UnifiedExamRunnerScreen extends StatefulWidget {
  final ExamTrack track;
  final CertificationStorageService? storageService;

  const UnifiedExamRunnerScreen({
    super.key,
    required this.track,
    this.storageService,
  });

  @override
  State<UnifiedExamRunnerScreen> createState() => _UnifiedExamRunnerScreenState();
}

class _UnifiedExamRunnerScreenState extends State<UnifiedExamRunnerScreen> {
  late final List<ExamQuestion> _questions;
  late int _secondsRemaining;
  Timer? _timer;

  int _currentIndex = 0;
  final Map<int, int> _userAnswers = {}; // questionId -> optionIndex
  final Set<int> _flaggedForReview = {}; // questionIds flagged
  bool _isSubmitted = false;
  ExamResult? _savedResult;

  CertificationStorageService? _storage;

  @override
  void initState() {
    super.initState();
    _questions = ExamQuestionBank.getQuestionsForTrack(widget.track);
    _secondsRemaining = widget.track.durationMinutes * 60;
    _initStorage();
    _startTimer();
  }

  Future<void> _initStorage() async {
    if (widget.storageService != null) {
      _storage = widget.storageService;
    } else {
      _storage = await CertificationStorageService.getInstance();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
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

  Color get _trackColor {
    switch (widget.track) {
      case ExamTrack.flutter:
        return const Color(0xFF02569B);
      case ExamTrack.swiftui:
        return const Color(0xFF007AFF);
      case ExamTrack.claude:
        return const Color(0xFFD97706);
    }
  }

  void _submitExam({bool autoSubmit = false}) {
    if (_isSubmitted) return;

    if (!autoSubmit && _userAnswers.length < _questions.length) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Unanswered Questions'),
          content: Text(
            'You have answered ${_userAnswers.length} of ${_questions.length} questions. '
            'Are you sure you want to finish the exam?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Return to Exam'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: _trackColor),
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
    setState(() => _isSubmitted = true);

    int correct = 0;
    final domainTotals = <String, int>{};
    final domainCorrect = <String, int>{};

    for (final q in _questions) {
      domainTotals[q.domainName] = (domainTotals[q.domainName] ?? 0) + 1;
      if (_userAnswers[q.id] == q.correctIndex) {
        correct++;
        domainCorrect[q.domainName] = (domainCorrect[q.domainName] ?? 0) + 1;
      }
    }

    final scorePercentage = ((correct / _questions.length) * 100).round();
    final passed = scorePercentage >= widget.track.passingPercentage;

    final breakdown = <String, double>{};
    for (final domain in domainTotals.keys) {
      final total = domainTotals[domain] ?? 1;
      final corr = domainCorrect[domain] ?? 0;
      breakdown[domain] = corr / total;
    }

    final candidateName = _storage?.getCandidateName() ?? 'Senior Full-Stack Engineer';
    final certificateHash = CertificationStorageService.generateCertificateHash(
      widget.track,
      candidateName,
      scorePercentage,
    );

    final result = ExamResult(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      track: widget.track,
      candidateName: candidateName,
      scorePercentage: scorePercentage,
      correctCount: correct,
      totalQuestions: _questions.length,
      passed: passed,
      completedAt: DateTime.now(),
      domainBreakdown: breakdown,
      certificateHash: certificateHash,
    );

    _savedResult = result;
    _storage?.saveExamResult(result);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.track.shortName),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: LinearProgressIndicator(
            value: (_currentIndex + 1) / _questions.length,
            backgroundColor: Colors.transparent,
            valueColor: AlwaysStoppedAnimation<Color>(_trackColor),
          ),
        ),
        actions: [
          if (!_isSubmitted) ...[
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color: _secondsRemaining < 120
                      ? Colors.red.withAlpha(40)
                      : (_trackColor.withAlpha(30)),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _secondsRemaining < 120 ? Colors.red : _trackColor,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.timer_outlined,
                      size: 16,
                      color: _secondsRemaining < 120 ? Colors.red : _trackColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _formatTime(_secondsRemaining),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'monospace',
                        color: _secondsRemaining < 120 ? Colors.red : _trackColor,
                      ),
                    ),
                  ],
                ),
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
      body: _isSubmitted ? _buildScoreReport(isDark) : _buildExamTaker(isDark),
    );
  }

  Widget _buildExamTaker(bool isDark) {
    final q = _questions[_currentIndex];
    final selectedOption = _userAnswers[q.id];
    final isFlagged = _flaggedForReview.contains(q.id);

    return SafeArea(
      child: Column(
        children: [
          // Subheader Info Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: isDark ? Colors.grey.shade900 : Colors.grey.shade100,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: _trackColor.withAlpha(20),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'Domain ${q.domainId}',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: _trackColor,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    q.domainName,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    isFlagged ? Icons.bookmark_added_rounded : Icons.bookmark_border_rounded,
                    color: isFlagged ? Colors.amber : Colors.grey,
                  ),
                  tooltip: isFlagged ? 'Flagged for Review' : 'Flag Question',
                  onPressed: () {
                    setState(() {
                      if (isFlagged) {
                        _flaggedForReview.remove(q.id);
                      } else {
                        _flaggedForReview.add(q.id);
                      }
                    });
                  },
                ),
              ],
            ),
          ),
          // Question Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Q${_currentIndex + 1}. ',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: _trackColor,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          q.scenario,
                          style: const TextStyle(fontSize: 15, height: 1.4),
                        ),
                      ),
                    ],
                  ),
                  if (q.codeSnippet != null) ...[
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF181824) : const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.withAlpha(50)),
                      ),
                      child: Text(
                        q.codeSnippet!,
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 12,
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),
                  const Text(
                    'SELECT THE BEST ARCHITECTURAL CHOICE:',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Options
                  ...List.generate(q.options.length, (optIdx) {
                    final isSelected = selectedOption == optIdx;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: InkWell(
                        key: Key('option_${_currentIndex}_$optIdx'),
                        borderRadius: BorderRadius.circular(10),
                        onTap: () {
                          setState(() {
                            _userAnswers[q.id] = optIdx;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? _trackColor.withAlpha(25)
                                : (isDark ? const Color(0xFF22252D) : Colors.white),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: isSelected ? _trackColor : Colors.grey.withAlpha(60),
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 24,
                                height: 24,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isSelected ? _trackColor : Colors.transparent,
                                  border: Border.all(
                                    color: isSelected ? _trackColor : Colors.grey,
                                  ),
                                ),
                                child: Text(
                                  String.fromCharCode(65 + optIdx),
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: isSelected ? Colors.white : Colors.grey,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  q.options[optIdx],
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
          // Bottom Navigation Buttons
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(15),
                  blurRadius: 6,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                if (_currentIndex > 0)
                  OutlinedButton.icon(
                    onPressed: () => setState(() => _currentIndex--),
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Previous'),
                  )
                else
                  const SizedBox.shrink(),
                const Spacer(),
                if (_currentIndex < _questions.length - 1)
                  FilledButton.icon(
                    style: FilledButton.styleFrom(backgroundColor: _trackColor),
                    onPressed: () => setState(() => _currentIndex++),
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text('Next'),
                  )
                else
                  FilledButton.icon(
                    style: FilledButton.styleFrom(backgroundColor: Colors.green),
                    onPressed: () => _submitExam(),
                    icon: const Icon(Icons.check_circle_outline),
                    label: const Text('Submit Exam'),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreReport(bool isDark) {
    if (_savedResult == null) return const Center(child: CircularProgressIndicator());
    final result = _savedResult!;
    final passed = result.passed;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Banner
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: passed
                    ? [const Color(0xFF0F9D58), const Color(0xFF0B8043)]
                    : [const Color(0xFFD93025), const Color(0xFFB31412)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Icon(
                  passed ? Icons.emoji_events_rounded : Icons.cancel_outlined,
                  size: 56,
                  color: Colors.white,
                ),
                const SizedBox(height: 8),
                Text(
                  passed ? 'CONGRATULATIONS! YOU PASSED' : 'EXAM NOT CLEARED',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${result.scorePercentage}% Score • Passing Threshold ${widget.track.passingPercentage}%',
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // View Certificate Button if passed
          if (passed) ...[
            FilledButton.icon(
              icon: const Icon(Icons.verified_rounded, color: Colors.amber),
              label: const Text('View & Claim Digital Certificate'),
              style: FilledButton.styleFrom(
                backgroundColor: _trackColor,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => CertificateViewerScreen(
                      result: result,
                      storageService: _storage,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
          ],
          // Domain Breakdown Card
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey.withAlpha(50)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Domain Breakdown',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  ...result.domainBreakdown.entries.map((entry) {
                    final percent = (entry.value * 100).toInt();
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  entry.key,
                                  style: const TextStyle(fontSize: 12),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(
                                '$percent%',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: percent >= 75 ? Colors.green : Colors.orange,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          LinearProgressIndicator(
                            value: entry.value,
                            minHeight: 5,
                            backgroundColor: Colors.grey.withAlpha(40),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              percent >= 75 ? Colors.green : Colors.orange,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'DETAILED QUESTION REVIEW & RATIONALES',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 10),
          // Question Reviews
          ...List.generate(_questions.length, (idx) {
            final q = _questions[idx];
            final userChoice = _userAnswers[q.id];
            final isCorrect = userChoice == q.correctIndex;

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: isCorrect ? Colors.green.withAlpha(80) : Colors.red.withAlpha(80),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          isCorrect ? Icons.check_circle_rounded : Icons.cancel_rounded,
                          size: 18,
                          color: isCorrect ? Colors.green : Colors.red,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Question ${idx + 1}',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.grey.withAlpha(30),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            q.domainName,
                            style: const TextStyle(fontSize: 10),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(q.scenario, style: const TextStyle(fontSize: 13)),
                    const SizedBox(height: 10),
                    Text(
                      'Your Answer: ${userChoice != null ? q.options[userChoice] : "None (Unanswered)"}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isCorrect ? Colors.green : Colors.red,
                      ),
                    ),
                    if (!isCorrect) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Correct Answer: ${q.options[q.correctIndex]}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.green,
                        ),
                      ),
                    ],
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.grey.withAlpha(20),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Rationale: ${q.rationale}',
                        style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
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
                    Icon(Icons.grid_view_rounded, size: 20, color: _trackColor),
                    const SizedBox(width: 8),
                    const Text(
                      'Question Navigator',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const Spacer(),
                    Text(
                      '${_userAnswers.length} of ${_questions.length} answered',
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
                  itemCount: _questions.length,
                  itemBuilder: (context, idx) {
                    final q = _questions[idx];
                    final isAnswered = _userAnswers.containsKey(q.id);
                    final isFlagged = _flaggedForReview.contains(q.id);
                    final isCurrent = _currentIndex == idx;

                    Color bg = Colors.grey.withAlpha(40);
                    if (isAnswered) bg = _trackColor.withAlpha(160);
                    if (isCurrent) bg = _trackColor;

                    return InkWell(
                      key: Key('unifiedNavigatorBtn_${idx + 1}'),
                      borderRadius: BorderRadius.circular(8),
                      onTap: () {
                        Navigator.of(ctx).pop();
                        setState(() => _currentIndex = idx);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: bg,
                          borderRadius: BorderRadius.circular(8),
                          border: isFlagged
                              ? Border.all(color: Colors.amber, width: 2)
                              : null,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '${idx + 1}',
                          style: TextStyle(
                            color: (isAnswered || isCurrent) ? Colors.white : null,
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
