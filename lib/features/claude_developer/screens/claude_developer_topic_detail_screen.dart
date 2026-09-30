import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/claude_developer_topic.dart';

/// Detailed Lesson & Architecture Screen for a Claude Developer Topic.
class ClaudeDeveloperTopicDetailScreen extends StatefulWidget {
  final ClaudeDeveloperTopic topic;

  const ClaudeDeveloperTopicDetailScreen({
    super.key,
    required this.topic,
  });

  @override
  State<ClaudeDeveloperTopicDetailScreen> createState() => _ClaudeDeveloperTopicDetailScreenState();
}

class _ClaudeDeveloperTopicDetailScreenState extends State<ClaudeDeveloperTopicDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedCodeLang = 0; // 0: Python, 1: TypeScript

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _copyToClipboard(String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label copied to clipboard!'),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final topic = widget.topic;

    return Scaffold(
      appBar: AppBar(
        title: Text(topic.title),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: topic.accentColor,
          labelColor: topic.accentColor,
          tabs: const [
            Tab(icon: Icon(Icons.menu_book_rounded), text: 'Guide & Arch'),
            Tab(icon: Icon(Icons.code_rounded), text: 'SDK Code'),
            Tab(icon: Icon(Icons.checklist_rounded), text: 'Best Practices'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // TAB 1: GUIDE & ARCHITECTURE
          ListView(
            key: const Key('topicGuideListView'),
            padding: const EdgeInsets.all(16),
            children: [
              // Header Card
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: topic.accentColor.withAlpha(isDark ? 30 : 20),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: topic.accentColor.withAlpha(100)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: topic.accentColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(topic.icon, color: Colors.white, size: 28),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            topic.category.toUpperCase(),
                            style: TextStyle(
                              color: topic.accentColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            topic.title,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            topic.summary,
                            style: TextStyle(fontSize: 13, color: isDark ? Colors.white70 : Colors.black87),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Key Concepts List
              Text(
                'Key Architectural Concepts',
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ...topic.keyConcepts.map((concept) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Icon(Icons.check_circle_rounded, color: topic.accentColor, size: 16),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          concept,
                          style: const TextStyle(fontSize: 13.5, height: 1.35),
                        ),
                      ),
                    ],
                  ),
                );
              }),

              const SizedBox(height: 20),

              // Comprehensive Markdown Guide
              Text(
                'In-Depth Reference Guide',
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    topic.fullGuideMarkdown,
                    style: const TextStyle(fontSize: 14, height: 1.5),
                  ),
                ),
              ),
            ],
          ),

          // TAB 2: PRODUCTION SDK CODE BLUEPRINTS
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Language Switcher Chips
              Wrap(
                spacing: 10,
                runSpacing: 8,
                children: [
                  ChoiceChip(
                    label: const Text('Python SDK (anthropic)'),
                    selected: _selectedCodeLang == 0,
                    selectedColor: topic.accentColor.withAlpha(40),
                    onSelected: (val) => setState(() => _selectedCodeLang = 0),
                  ),
                  ChoiceChip(
                    label: const Text('TypeScript (@anthropic-ai/sdk)'),
                    selected: _selectedCodeLang == 1,
                    selectedColor: topic.accentColor.withAlpha(40),
                    onSelected: (val) => setState(() => _selectedCodeLang = 1),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // Code Display Card
              Card(
                color: isDark ? const Color(0xFF0F172A) : const Color(0xFF1E293B),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 10,
                                height: 10,
                                decoration: const BoxDecoration(color: Colors.redAccent, shape: BoxShape.circle),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                width: 10,
                                height: 10,
                                decoration: const BoxDecoration(color: Colors.amberAccent, shape: BoxShape.circle),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                width: 10,
                                height: 10,
                                decoration: const BoxDecoration(color: Colors.greenAccent, shape: BoxShape.circle),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                _selectedCodeLang == 0 ? 'claude_example.py' : 'claude_example.ts',
                                style: const TextStyle(color: Colors.white70, fontSize: 12, fontFamily: 'monospace'),
                              ),
                            ],
                          ),
                          IconButton(
                            icon: const Icon(Icons.copy_rounded, color: Colors.white70, size: 18),
                            tooltip: 'Copy Code',
                            onPressed: () {
                              final code = _selectedCodeLang == 0 ? topic.pythonCodeSnippet : topic.typeScriptCodeSnippet;
                              _copyToClipboard(code, _selectedCodeLang == 0 ? 'Python snippet' : 'TypeScript snippet');
                            },
                          ),
                        ],
                      ),
                      const Divider(color: Colors.white24, height: 16),
                      SelectableText(
                        _selectedCodeLang == 0 ? topic.pythonCodeSnippet : topic.typeScriptCodeSnippet,
                        style: const TextStyle(
                          color: Color(0xFFE2E8F0),
                          fontFamily: 'monospace',
                          fontSize: 12.5,
                          height: 1.45,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // TAB 3: BEST PRACTICES & PITFALLS
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Best Practices
              Row(
                children: [
                  const Icon(Icons.thumb_up_alt_rounded, color: Colors.green, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Production Best Practices',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ...topic.bestPractices.map((bp) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.green.withAlpha(60)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.check_rounded, color: Colors.green, size: 18),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(bp, style: const TextStyle(fontSize: 13.5, height: 1.35)),
                        ),
                      ],
                    ),
                  ),
                );
              }),

              const SizedBox(height: 20),

              // Common Pitfalls
              Row(
                children: [
                  const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Common Pitfalls to Avoid',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.red.shade700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ...topic.commonPitfalls.map((pitfall) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.red.withAlpha(60)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.close_rounded, color: Colors.red, size: 18),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(pitfall, style: const TextStyle(fontSize: 13.5, height: 1.35)),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }
}
