import 'package:flutter/material.dart';
import '../../claude_developer/screens/claude_agent_loop_simulator_screen.dart';
import '../../claude_developer/screens/claude_caching_calculator_screen.dart';
import '../../claude_developer/screens/claude_tool_simulator_screen.dart';
import '../../flutter_advanced/screens/engine_internals_screen.dart';
import '../../flutter_advanced/screens/isolates_concurrency_screen.dart';
import '../../swiftui_track/screens/swiftui_state_simulator_screen.dart';
import 'bpe_tokenizer_sandbox_screen.dart';
import 'ios_arc_memory_lab_screen.dart';
import 'ios_concurrency_race_lab_screen.dart';
import 'ios_payment_storekit_lab_screen.dart';

/// Interactive Labs Screen: A central hub for runtime sandboxes,
/// execution simulators, cost calculators, and architecture inspectors.
class InteractiveLabsScreen extends StatelessWidget {
  const InteractiveLabsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final labs = [
      _LabItem(
        title: 'Claude Agentic Looping Simulator',
        subtitle: 'Evaluator-Optimizer, Tool Loop & Orchestrator Swarms',
        description:
            'Interactive runtime simulator for Anthropic agent loops: step through Generator ➔ Critic cycles, tool_use ➔ tool_result flows, and circuit breaker guardrails.',
        icon: Icons.all_inclusive_rounded,
        badge: 'Agent Architecture',
        color: const Color(0xFF7C3AED),
        screen: const ClaudeAgentLoopSimulatorScreen(),
      ),
      _LabItem(
        title: 'iOS Retain Cycle & ARC Simulator',
        subtitle: 'Reference Counting, Side Tables & Leak Detection',
        description:
            'Interactive visual memory graph. Test ViewController closure captures, strong delegates, and target-action timers with [weak self] fixes.',
        icon: Icons.memory_rounded,
        badge: 'iOS Memory',
        color: const Color(0xFF6366F1),
        screen: const IosArcMemoryLabScreen(),
      ),
      _LabItem(
        title: 'Actor Reentrancy & Race Simulator',
        subtitle: 'Suspension Points across await & State Integrity',
        description:
            'Simulate 10 concurrent async withdrawal requests. Observe how Actors eliminate data races but still corrupt state across await suspension points.',
        icon: Icons.bolt_rounded,
        badge: 'Swift Concurrency',
        color: const Color(0xFF8B5CF6),
        screen: const IosConcurrencyRaceLabScreen(),
      ),
      _LabItem(
        title: 'StoreKit 2 & Apple Pay Sandbox',
        subtitle: 'Async Purchases, JWS Validation & PassKit DPAN',
        description:
            'Interactive payment sandbox: simulate StoreKit 2 Product.purchase(), JWS signature validation against Apple Root CA, subscription grace periods, and PassKit Secure Element cryptograms.',
        icon: Icons.payments_rounded,
        badge: 'Payment Architecture',
        color: const Color(0xFF059669),
        screen: const IosPaymentStoreKitLabScreen(),
      ),
      _LabItem(
        title: 'Claude MCP Tool Use Simulator',
        subtitle: '4-Step Tool Execution Loop & JSON Schemas',
        description:
            'Step through the complete tool execution cycle: User Prompt ➔ Model tool_use block ➔ Client execution ➔ tool_result answer synthesis.',
        icon: Icons.handyman_rounded,
        badge: 'Claude & MCP',
        color: const Color(0xFF0D9488),
        screen: const ClaudeToolSimulatorScreen(),
      ),
      _LabItem(
        title: 'Prompt Caching 90% ROI Calculator',
        subtitle: 'Cost & Latency Savings across Claude 3.7 / 3.5',
        description:
            'Adjust prompt tokens, cache writes, cache reads, and queries per hour. Visualize 90% cost drop and 85% latency reduction.',
        icon: Icons.savings_rounded,
        badge: 'Token Economics',
        color: const Color(0xFF0284C7),
        screen: const ClaudeCachingCalculatorScreen(),
      ),
      _LabItem(
        title: 'BPE Tokenizer & Context Explorer',
        subtitle: 'Subword Segmentation & Context Window Capacity',
        description:
            'Visualize Byte-Pair Encoding subword tokenization, calculate characters per token, inspect context window limits, and calculate API pricing.',
        icon: Icons.token_rounded,
        badge: 'AI Algorithms',
        color: const Color(0xFF6366F1),
        screen: const BpeTokenizerSandboxScreen(),
      ),
      _LabItem(
        title: 'SwiftUI State & Data Flow Simulator',
        subtitle: '@State, @Binding, @Observable, @Environment',
        description:
            'Interactive runtime lab for Apple UI architecture. Test two-way bindings, iOS 17 Observation framework, and deep environment propagation.',
        icon: Icons.apple_rounded,
        badge: 'SwiftUI Runtime',
        color: const Color(0xFF4F46E5),
        screen: const SwiftUiStateSimulatorScreen(),
      ),
      _LabItem(
        title: 'Dart Isolates & Concurrency Engine',
        subtitle: 'Main Thread vs Background Isolate compute()',
        description:
            'Benchmark single-threaded event loop vs spawned background isolates. Test UI freezing under heavy CPU load vs zero-jank 60/120 FPS rendering.',
        icon: Icons.alt_route_rounded,
        badge: 'Concurrency',
        color: const Color(0xFFEA580C),
        screen: const IsolatesConcurrencyScreen(),
      ),
      _LabItem(
        title: 'Flutter Engine Internals Inspector',
        subtitle: 'Three Trees, Custom RenderBox & Dart FFI',
        description:
            'Explore Widget ➔ Element ➔ RenderObject lifecycle, the Layout protocol (constraints down, sizes up), and dynamic C/C++ native bindings.',
        icon: Icons.layers_rounded,
        badge: 'Engine Internals',
        color: const Color(0xFF9333EA),
        screen: const EngineInternalsScreen(),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Interactive Labs & Sandboxes'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Banner
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [const Color(0xFF134E4A), const Color(0xFF0F172A)]
                    : [const Color(0xFF0D9488), const Color(0xFF0F766E)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0D9488).withAlpha(50),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
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
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'HANDS-ON RUNTIME LABS',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const Spacer(),
                    const Text(
                      '9 Interactive Sandboxes',
                      style: TextStyle(color: Colors.white70, fontSize: 11.5),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  'Test, Simulate & Benchmark',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'True mastery comes from active experimentation. Run Claude tool-calling loops, compute prompt cache ROI, inspect subword tokens, and benchmark Dart isolates.',
                  style: TextStyle(color: Colors.white, fontSize: 13, height: 1.4),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // Section Title
          const Text(
            'AVAILABLE RUNTIME PLAYGROUNDS',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.8,
              color: Colors.grey,
            ),
          ),

          const SizedBox(height: 12),

          // List of Labs
          ...labs.map((lab) => _buildLabCard(context, lab, isDark)),
        ],
      ),
    );
  }

  Widget _buildLabCard(BuildContext context, _LabItem lab, bool isDark) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isDark ? Colors.white.withAlpha(20) : Colors.black.withAlpha(15),
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => lab.screen),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: lab.color.withAlpha(isDark ? 40 : 25),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: lab.color.withAlpha(100), width: 1.2),
                    ),
                    child: Icon(lab.icon, color: lab.color, size: 26),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: lab.color.withAlpha(isDark ? 40 : 20),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                lab.badge,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: lab.color,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          lab.title,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          lab.subtitle,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 14,
                    color: isDark ? Colors.white38 : Colors.black38,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                lab.description,
                style: TextStyle(
                  fontSize: 12.5,
                  height: 1.4,
                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Launch Sandbox',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: lab.color,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(Icons.play_arrow_rounded, size: 16, color: lab.color),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LabItem {
  final String title;
  final String subtitle;
  final String description;
  final IconData icon;
  final String badge;
  final Color color;
  final Widget screen;

  const _LabItem({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.icon,
    required this.badge,
    required this.color,
    required this.screen,
  });
}
