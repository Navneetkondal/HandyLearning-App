import 'package:flutter/material.dart';
import '../../../core/widgets/code_snippet_card.dart';
import '../models/ios_prep_hierarchy_models.dart';
import '../services/prep_progress_service.dart';

class PrepTopicDetailScreen extends StatefulWidget {
  final MasterTopic topic;
  final String domainTitle;
  final int domainNumber;

  const PrepTopicDetailScreen({
    super.key,
    required this.topic,
    required this.domainTitle,
    required this.domainNumber,
  });

  @override
  State<PrepTopicDetailScreen> createState() => _PrepTopicDetailScreenState();
}

class _PrepTopicDetailScreenState extends State<PrepTopicDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final PrepProgressService _progressService = PrepProgressService.instance;

  bool _isBookmarked = false;
  TopicMasteryStatus _status = TopicMasteryStatus.notStarted;
  bool _minimalCode = true;
  bool _showPracticeSolution = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _loadStatus();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _progressService.setActiveTopic(
        course: 'iOS Senior',
        module: widget.domainTitle,
        topic: widget.topic.title,
        topicId: widget.topic.id,
        domainNumber: widget.domainNumber,
      );
      _progressService.recordTopicStudied(widget.topic.id);
    });
  }

  void _loadStatus() {
    setState(() {
      _isBookmarked = _progressService.isBookmarked(widget.topic.id);
      _status = _progressService.getTopicStatus(widget.topic.id);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _toggleBookmark() {
    _progressService.toggleBookmark(widget.topic.id);
    _loadStatus();
  }

  void _updateStatus(TopicMasteryStatus newStatus) {
    _progressService.setTopicStatus(widget.topic.id, newStatus);
    _loadStatus();
  }

  Color _getDifficultyColor(String diff, BuildContext context) {
    switch (diff.toLowerCase()) {
      case 'easy':
        return Colors.green;
      case 'medium':
        return Colors.orange;
      case 'hard':
        return Colors.red;
      case 'expert':
        return Colors.purple;
      default:
        return Theme.of(context).colorScheme.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Domain ${widget.domainNumber}',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: _getDifficultyColor(
                      widget.topic.difficulty,
                      context,
                    ).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    widget.topic.difficulty.toUpperCase(),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: _getDifficultyColor(
                        widget.topic.difficulty,
                        context,
                      ),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            Text(widget.topic.title, style: theme.textTheme.titleMedium),
          ],
        ),
        actions: [
          IconButton(
            tooltip: _isBookmarked ? 'Remove Bookmark' : 'Bookmark Topic',
            icon: Icon(
              _isBookmarked ? Icons.bookmark : Icons.bookmark_border,
              color: _isBookmarked ? colorScheme.primary : null,
            ),
            onPressed: _toggleBookmark,
          ),
          PopupMenuButton<TopicMasteryStatus>(
            tooltip: 'Update Mastery Status',
            icon: Icon(
              Icons.check_circle_outline,
              color:
                  _status == TopicMasteryStatus.completed ||
                      _status == TopicMasteryStatus.mastered
                  ? Colors.green
                  : null,
            ),
            onSelected: _updateStatus,
            itemBuilder: (context) => TopicMasteryStatus.values.map((s) {
              return PopupMenuItem(
                value: s,
                child: Text('${s.symbol} ${s.label}'),
              );
            }).toList(),
          ),
        ],
      ),
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            isScrollable: true,
            tabs: const [
              Tab(text: 'Learn'),
              Tab(text: 'Code'),
              Tab(text: 'Deep Dive'),
              Tab(text: 'Interview'),
              Tab(text: 'Practice'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildLearnTab(theme, colorScheme),
                _buildCodeTab(theme, colorScheme),
                _buildDeepDiveTab(theme, colorScheme),
                _buildInterviewTab(theme, colorScheme),
                _buildPracticeTab(theme, colorScheme),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- TAB 1: LEARN ---
  Widget _buildLearnTab(ThemeData theme, ColorScheme colorScheme) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Quick Answer
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer.withValues(alpha: 0.3),
            border: Border.all(color: colorScheme.primary.withValues(alpha: 0.5)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.bolt, color: colorScheme.primary),
                  const SizedBox(width: 8),
                  Text(
                    'Quick Answer',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(widget.topic.quickAnswer, style: theme.textTheme.bodyMedium),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Why It Matters
        Text(
          'Why It Matters',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(widget.topic.whyItMatters, style: theme.textTheme.bodyMedium),
        const SizedBox(height: 24),

        // Mental Model
        Text(
          'Mental Model',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.brightness == Brightness.dark
                ? Colors.grey.shade900
                : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            widget.topic.mentalModel,
            style: const TextStyle(fontFamily: 'monospace', fontSize: 13),
          ),
        ),
        const SizedBox(height: 24),

        // How It Works
        Text(
          'How It Works',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        ...widget.topic.howItWorksSteps.asMap().entries.map((e) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 24,
                  height: 24,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: colorScheme.secondaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '${e.key + 1}',
                    style: theme.textTheme.labelSmall,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(e.value, style: theme.textTheme.bodyMedium),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  // --- TAB 2: CODE ---
  Widget _buildCodeTab(ThemeData theme, ColorScheme colorScheme) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Implementation',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SegmentedButton<bool>(
              segments: const [
                ButtonSegment(value: true, label: Text('Minimal')),
                ButtonSegment(value: false, label: Text('Production')),
              ],
              selected: {_minimalCode},
              onSelectionChanged: (val) {
                setState(() => _minimalCode = val.first);
              },
            ),
          ],
        ),
        const SizedBox(height: 16),
        CodeSnippetCard(
          title: _minimalCode ? 'Minimal Implementation' : 'Production Swift 6',
          code: _minimalCode
              ? widget.topic.minimalCode
              : widget.topic.productionCode,
          language: 'swift',
        ),
      ],
    );
  }

  // --- TAB 3: DEEP DIVE ---
  Widget _buildDeepDiveTab(ThemeData theme, ColorScheme colorScheme) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ExpansionTile(
          title: Text(
            'Under The Hood',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          initiallyExpanded: true,
          childrenPadding: const EdgeInsets.all(16),
          children: [
            Text(widget.topic.underTheHood, style: theme.textTheme.bodyMedium),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          'Production Example',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(widget.topic.productionExample, style: theme.textTheme.bodyMedium),
        const SizedBox(height: 24),

        Text(
          'Trade-offs Matrix',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Table(
          border: TableBorder.all(color: colorScheme.outlineVariant),
          columnWidths: const {0: FlexColumnWidth(1), 1: FlexColumnWidth(2)},
          children: [
            _buildTableRow(
              'Performance',
              widget.topic.tradeoffs.performance,
              theme,
            ),
            _buildTableRow('Memory', widget.topic.tradeoffs.memory, theme),
            _buildTableRow(
              'Maintainability',
              widget.topic.tradeoffs.maintainability,
              theme,
            ),
            _buildTableRow(
              'Testability',
              widget.topic.tradeoffs.testability,
              theme,
            ),
            _buildTableRow(
              'Complexity',
              widget.topic.tradeoffs.complexity,
              theme,
            ),
          ],
        ),
      ],
    );
  }

  TableRow _buildTableRow(String label, String value, ThemeData theme) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(value, style: theme.textTheme.bodyMedium),
        ),
      ],
    );
  }

  // --- TAB 4: INTERVIEW ---
  Widget _buildInterviewTab(ThemeData theme, ColorScheme colorScheme) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Interview Traps',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.error,
          ),
        ),
        const SizedBox(height: 8),
        ...widget.topic.interviewTraps.map(
          (t) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorScheme.errorContainer.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: colorScheme.error.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                Icon(Icons.warning_amber_rounded, color: colorScheme.error),
                const SizedBox(width: 8),
                Expanded(child: Text(t, style: theme.textTheme.bodyMedium)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),

        Text(
          'Common Mistakes',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        ...widget.topic.commonMistakes.map(
          (m) => ExpansionTile(
            title: Text(m.title, style: theme.textTheme.bodyLarge),
            childrenPadding: const EdgeInsets.all(16),
            children: [
              Text(m.explanation, style: theme.textTheme.bodyMedium),
              const SizedBox(height: 8),
              Text(
                'Incorrect:',
                style: theme.textTheme.labelMedium?.copyWith(color: Colors.red),
              ),
              CodeSnippetCard(
                title: 'Anti-pattern / Incorrect Code',
                code: m.incorrectCode,
                language: 'swift',
              ),
              const SizedBox(height: 8),
              Text(
                'Corrected:',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: Colors.green,
                ),
              ),
              CodeSnippetCard(
                title: 'Recommended / Corrected Code',
                code: m.correctedCode,
                language: 'swift',
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        Text(
          'Interview Questions',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        ...widget.topic.interviewQuestions.map(
          (q) => ExpansionTile(
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(q.difficulty, style: theme.textTheme.labelSmall),
                ),
                Expanded(
                  child: Text(q.question, style: theme.textTheme.bodyMedium),
                ),
              ],
            ),
            childrenPadding: const EdgeInsets.all(16),
            children: [
              Text(
                'Answer:',
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(q.answer, style: theme.textTheme.bodyMedium),
              ...[
              const SizedBox(height: 8),
              Text(
                'Senior Insight:',
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
              ),
              Text(q.seniorInsight, style: theme.textTheme.bodyMedium),
            ],
            ],
          ),
        ),
      ],
    );
  }

  // --- TAB 5: PRACTICE ---
  Widget _buildPracticeTab(ThemeData theme, ColorScheme colorScheme) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Practice Prompt',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: colorScheme.outlineVariant),
          ),
          child: Text(
            widget.topic.practicePrompt,
            style: theme.textTheme.bodyMedium,
          ),
        ),
        ...[
        const SizedBox(height: 8),
        Text(
          'Hint: ${widget.topic.practiceHint}',
          style: theme.textTheme.bodySmall?.copyWith(
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
        const SizedBox(height: 16),

        ElevatedButton(
          onPressed: () =>
              setState(() => _showPracticeSolution = !_showPracticeSolution),
          child: Text(
            _showPracticeSolution ? 'Hide Solution' : 'Show Solution',
          ),
        ),
        if (_showPracticeSolution) ...[
          const SizedBox(height: 16),
          CodeSnippetCard(
            title: 'Practice Task Solution',
            code: widget.topic.practiceSolution,
            language: 'swift',
          ),
        ],
        const SizedBox(height: 24),

        Text(
          'Quick Revision',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        ...widget.topic.quickRevision.map(
          (r) => Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              children: [
                Icon(Icons.check, color: Colors.green, size: 20),
                const SizedBox(width: 8),
                Expanded(child: Text(r, style: theme.textTheme.bodyMedium)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),

        Text(
          'Mastery',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: TopicMasteryStatus.values.map((s) {
            final isSelected = _status == s;
            return ChoiceChip(
              label: Text('${s.symbol} ${s.label}'),
              selected: isSelected,
              onSelected: (val) {
                if (val) _updateStatus(s);
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}
