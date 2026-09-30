import 'package:flutter/material.dart';
import '../../../core/widgets/code_snippet_card.dart';
import '../../../core/widgets/interactive_demo_box.dart';
import '../../../core/widgets/section_header.dart';

/// Screen teaching the core distinction between StatelessWidget and StatefulWidget.
/// Includes an interactive side-by-side comparison and lifecycle breakdown.
class StlessVsStfulScreen extends StatefulWidget {
  const StlessVsStfulScreen({super.key});

  @override
  State<StlessVsStfulScreen> createState() => _StlessVsStfulScreenState();
}

class _StlessVsStfulScreenState extends State<StlessVsStfulScreen> {
  // Stateful Counter State
  int _statefulCounter = 0;

  // Stless demo state tracker to show what happens behind the scenes
  int _statelessAttemptValue = 0;
  String _statelessMessage = 'Taps: 0 (Variable mutated, but UI did not rebuild!)';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Stateless vs Stateful Lab'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          // Banner
          Card(
            color: const Color(0xFF8B5CF6).withAlpha(20),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.compare_arrows_rounded, color: Color(0xFF8B5CF6), size: 36),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Stateless vs Stateful Explained',
                          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Understand when to keep a widget stateless and when local mutable state with setState is necessary.',
                          style: TextStyle(fontSize: 12.5),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // SECTION 1: Interactive Side-by-Side Comparison
          const SectionHeader(
            title: '1. Live Interactive Experiment',
            subtitle: 'Try tapping both buttons to observe Flutter rebuild mechanics.',
            icon: Icons.science_rounded,
            badgeText: 'Interactive Experiment',
          ),

          // Side-by-side Cards
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Stateless Card
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.red.withAlpha(100), width: 1.5),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.red.withAlpha(25),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'StatelessWidget',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.red),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text('Internal Count:', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      const Text(
                        '0', // Never changes on UI because build isn't recalled
                        style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.red),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Actual Dart variable: $_statelessAttemptValue',
                        style: const TextStyle(fontSize: 11, fontStyle: FontStyle.italic),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade600,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        ),
                        onPressed: () {
                          // Mutating a variable without setState does not schedule a frame!
                          _statelessAttemptValue++;
                          setState(() {
                            _statelessMessage =
                                'Variable became $_statelessAttemptValue, but without setState the widget tree was blind to it!';
                          });
                        },
                        child: const Text('Tap (No setState)', style: TextStyle(fontSize: 12)),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // Stateful Card
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.green.withAlpha(100), width: 1.5),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green.withAlpha(25),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'StatefulWidget',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.green),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text('Internal Count:', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      Text(
                        '$_statefulCounter',
                        style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.green),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'setState() marks dirty',
                        style: TextStyle(fontSize: 11, fontStyle: FontStyle.italic),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade600,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        ),
                        onPressed: () {
                          setState(() {
                            _statefulCounter++;
                          });
                        },
                        child: const Text('Tap (setState)', style: TextStyle(fontSize: 12)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
            ),
            child: Text(
              'Observation: $_statelessMessage',
              style: TextStyle(fontSize: 12, color: isDark ? Colors.amber : Colors.orange.shade800),
            ),
          ),

          // SECTION 2: Code Comparison
          const SectionHeader(
            title: '2. Code Structure Comparison',
            subtitle: 'See the architectural differences between stless and stful snippets.',
            icon: Icons.code_rounded,
          ),
          const CodeSnippetCard(
            title: 'StatelessWidget (stless shortcut)',
            code: '''class UserProfileHeader extends StatelessWidget {
  final String userName;
  final String avatarUrl;

  const UserProfileHeader({
    super.key,
    required this.userName,
    required this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    // Pure function: Inputs (props) -> UI
    return Row(
      children: [
        CircleAvatar(backgroundImage: NetworkImage(avatarUrl)),
        const SizedBox(width: 12),
        Text(userName, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}''',
            explanation:
                'All fields in a StatelessWidget must be final. It has NO persistent state. It receives data through constructor parameters and renders it.',
          ),

          const CodeSnippetCard(
            title: 'StatefulWidget (stful shortcut)',
            code: '''class SearchInput extends StatefulWidget {
  const SearchInput({super.key});

  @override
  State<SearchInput> createState() => _SearchInputState();
}

class _SearchInputState extends State<SearchInput> {
  late final TextEditingController _controller;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    // 1. Initialized once when widget enters tree
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    // 2. Cleaned up when widget permanently leaves tree
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      onChanged: (text) {
        setState(() {
          // 3. Marks Element as dirty and schedules next frame build()
          _hasText = text.isNotEmpty;
        });
      },
    );
  }
}''',
            explanation:
                'StatefulWidget pairs an immutable widget configuration with a mutable State object that survives rebuilds and manages controllers.',
          ),

          // SECTION 3: State Lifecycle Visualizer
          const SectionHeader(
            title: '3. State Lifecycle Methods',
            subtitle: 'The chronological order in which Flutter calls State lifecycle methods.',
            icon: Icons.timeline_rounded,
            badgeText: 'Lifecycle',
          ),
          InteractiveDemoBox(
            label: 'Lifecycle Timeline',
            child: Column(
              children: [
                _buildLifecycleStep(
                  step: '1',
                  name: 'createState()',
                  description: 'Creates the mutable State object when the widget is inserted.',
                  color: Colors.blue,
                ),
                _buildLifecycleStep(
                  step: '2',
                  name: 'initState()',
                  description: 'Called exactly ONCE. Ideal for subscribing to streams or setting up controllers.',
                  color: Colors.indigo,
                ),
                _buildLifecycleStep(
                  step: '3',
                  name: 'didChangeDependencies()',
                  description: 'Called when an InheritedWidget (like Theme or MediaQuery) changes.',
                  color: Colors.teal,
                ),
                _buildLifecycleStep(
                  step: '4',
                  name: 'build(context)',
                  description: 'Called frequently. Must remain pure and side-effect free.',
                  color: Colors.green,
                ),
                _buildLifecycleStep(
                  step: '5',
                  name: 'setState()',
                  description: 'Signals to Flutter framework that internal state has changed, marking element dirty.',
                  color: Colors.amber.shade700,
                ),
                _buildLifecycleStep(
                  step: '6',
                  name: 'dispose()',
                  description: 'Called when the State object is permanently removed. Cancel subscriptions & controllers!',
                  color: Colors.red,
                  isLast: true,
                ),
              ],
            ),
          ),

          // Summary Rule Card
          Card(
            color: theme.colorScheme.primary.withAlpha(20),
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Golden Rule for Developers:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  SizedBox(height: 6),
                  Text(
                    '• Default to StatelessWidget for 90% of your presentation widgets.\n'
                    '• Use StatefulWidget ONLY when managing ephemeral widget-local state (AnimationController, FocusNode, PageController, TextEditingController).\n'
                    '• For business logic and application data, use Cubit / BLoC instead of bloated setState()!',
                    style: TextStyle(fontSize: 12.5, height: 1.4),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildLifecycleStep({
    required String step,
    required String name,
    required String description,
    required Color color,
    bool isLast = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            CircleAvatar(
              radius: 14,
              backgroundColor: color,
              child: Text(step, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 34,
                color: color.withAlpha(100),
              ),
          ],
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: color)),
                const SizedBox(height: 2),
                Text(description, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
