import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/widgets/code_snippet_card.dart';
import '../../../core/widgets/interactive_demo_box.dart';
import '../../../core/widgets/section_header.dart';
import '../cubit/counter_cubit.dart';
import '../cubit/counter_state.dart';

/// Screen teaching Cubit architecture with BlocProvider, BlocBuilder,
/// BlocListener, and BlocConsumer in an interactive laboratory.
class CubitIntroScreen extends StatelessWidget {
  const CubitIntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // We provide CounterCubit here so the subtree can access it
    return BlocProvider(
      create: (context) => CounterCubit(),
      child: const _CubitIntroView(),
    );
  }
}

class _CubitIntroView extends StatelessWidget {
  const _CubitIntroView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cubit State Management Lab'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          // Banner
          Card(
            color: const Color(0xFF0284C7).withAlpha(20),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.bolt_rounded, color: Color(0xFF0284C7), size: 36),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'What is a Cubit?',
                          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'A lightweight BLoC without event classes. UI calls methods directly; the Cubit emits immutable state snapshots.',
                          style: TextStyle(fontSize: 12.5),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // SECTION 1: Interactive Cubit Sandbox
          const SectionHeader(
            title: '1. Live Cubit Playground',
            subtitle: 'Uses BlocConsumer for UI rebuilds (builder) and SnackBar side-effects (listener).',
            icon: Icons.play_circle_outline_rounded,
            badgeText: 'BlocConsumer',
          ),

          InteractiveDemoBox(
            label: 'Counter Cubit State Monitor',
            child: BlocConsumer<CounterCubit, CounterState>(
              listener: (context, state) {
                // Side-effects: Only run when specific business conditions are met!
                if (state.count == 5) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('🎉 Milestone: Count reached 5! (Triggered by BlocListener)'),
                      backgroundColor: Colors.indigo,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                } else if (state.count < 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('⚠️ Warning: Count is negative! (Triggered by BlocListener)'),
                      backgroundColor: Colors.orange,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
              builder: (context, state) {
                // UI Rendering: Rebuilds whenever CounterState changes
                return Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withAlpha(15),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'Current Counter State',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '${state.count}',
                            style: TextStyle(
                              fontSize: 54,
                              fontWeight: FontWeight.w800,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            state.statusMessage,
                            style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Cubit Action Triggers
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      alignment: WrapAlignment.center,
                      children: [
                        FilledButton.icon(
                          onPressed: () => context.read<CounterCubit>().decrement(),
                          icon: const Icon(Icons.remove_rounded),
                          label: const Text('-1 Decrement'),
                          style: FilledButton.styleFrom(backgroundColor: Colors.red.shade600),
                        ),
                        FilledButton.icon(
                          onPressed: () => context.read<CounterCubit>().increment(),
                          icon: const Icon(Icons.add_rounded),
                          label: const Text('+1 Increment'),
                          style: FilledButton.styleFrom(backgroundColor: Colors.green.shade600),
                        ),
                        OutlinedButton.icon(
                          onPressed: () => context.read<CounterCubit>().addCustom(5),
                          icon: const Icon(Icons.exposure_plus_2_rounded),
                          label: const Text('+5 Step'),
                        ),
                        TextButton.icon(
                          onPressed: () => context.read<CounterCubit>().reset(),
                          icon: const Icon(Icons.restore_rounded),
                          label: const Text('Reset'),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),

          // SECTION 2: Transition History Log
          const SectionHeader(
            title: '2. State Transition History Log',
            subtitle: 'Real-time trace of states emitted by the Cubit.',
            icon: Icons.history_rounded,
          ),
          BlocBuilder<CounterCubit, CounterState>(
            builder: (context, state) {
              final logs = context.read<CounterCubit>().transitionLogs;

              return Container(
                height: 140,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
                  ),
                ),
                child: logs.isEmpty
                    ? const Center(child: Text('No transitions yet'))
                    : ListView.builder(
                        itemCount: logs.length,
                        itemBuilder: (ctx, i) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: Text(
                              logs[i],
                              style: TextStyle(
                                fontFamily: 'Courier',
                                fontSize: 11.5,
                                color: i == 0 ? Colors.green : (isDark ? Colors.white60 : Colors.black87),
                                fontWeight: i == 0 ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                          );
                        },
                      ),
              );
            },
          ),

          // SECTION 3: The 3 Core Bloc Consumers
          const SectionHeader(
            title: '3. BlocBuilder vs BlocListener vs BlocConsumer',
            subtitle: 'Choose the right tool based on whether you need UI rendering, side-effects, or both.',
            icon: Icons.widgets_outlined,
          ),
          const CodeSnippetCard(
            title: '1. BlocBuilder (Render UI only)',
            code: '''BlocBuilder<CounterCubit, CounterState>(
  buildWhen: (previous, current) => previous.count != current.count,
  builder: (context, state) {
    return Text('Count: \${state.count}');
  },
)''',
            explanation:
                'Use BlocBuilder whenever you only need to return and redraw UI widgets. buildWhen can conditionally skip rebuilds.',
          ),

          const CodeSnippetCard(
            title: '2. BlocListener (Side-effects only: SnackBar, Navigation, Dialog)',
            code: '''BlocListener<CounterCubit, CounterState>(
  listenWhen: (previous, current) => current.count == 10,
  listener: (context, state) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Target reached!')),
    );
  },
  child: const MyStaticChild(),
)''',
            explanation:
                'Never navigate or show SnackBars inside build(). Use BlocListener because listener executes exactly once per state transition.',
          ),

          const CodeSnippetCard(
            title: '3. BlocConsumer (Combines Builder + Listener)',
            code: '''BlocConsumer<CounterCubit, CounterState>(
  listener: (context, state) {
    if (state.count < 0) showWarning();
  },
  builder: (context, state) {
    return Text('Count: \${state.count}');
  },
)''',
            explanation:
                'BlocConsumer saves nesting by executing side-effects in listener while rebuilding the widget in builder.',
          ),

          // SECTION 4: context.read vs context.watch
          const SectionHeader(
            title: '4. context.read() vs context.watch()',
            subtitle: 'Crucial performance rule to avoid accidental full-screen rebuilds.',
            icon: Icons.psychology_alt_rounded,
            badgeText: 'Performance',
          ),
          const CodeSnippetCard(
            title: 'context.read vs context.watch rule',
            code: '''// ✅ CORRECT: Inside callbacks (onPressed, onTap) use read:
ElevatedButton(
  onPressed: () => context.read<CounterCubit>().increment(),
  child: const Text('Increment'),
);

// ⚠️ WARNING: Inside build(), context.watch subscribes the WHOLE widget:
Widget build(BuildContext context) {
  // If count changes, THIS ENTIRE BUILD METHOD RUNS AGAIN!
  final count = context.watch<CounterCubit>().state.count;
  return LargeComplexWidgetTree(count);
}

// 💡 BETTER: Scope the rebuild with BlocBuilder or context.select:
final count = context.select<CounterCubit, int>((cubit) => cubit.state.count);''',
            explanation:
                'Rule of thumb: context.read inside callbacks. BlocBuilder or context.select inside widget trees.',
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
