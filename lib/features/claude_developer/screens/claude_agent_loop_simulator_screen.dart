import 'package:flutter/material.dart';

/// Interactive Agentic Looping Simulator.
/// Simulates Anthropic's landmark agent patterns:
/// 1. Evaluator-Optimizer (Generator-Critic loop)
/// 2. Autonomous Tool Use Loop (stop_reason == "tool_use" cycle)
/// 3. Orchestrator-Workers (Subtask decomposition and synthesis)
class ClaudeAgentLoopSimulatorScreen extends StatefulWidget {
  const ClaudeAgentLoopSimulatorScreen({super.key});

  @override
  State<ClaudeAgentLoopSimulatorScreen> createState() =>
      _ClaudeAgentLoopSimulatorScreenState();
}

enum AgentLoopPattern {
  evaluatorOptimizer,
  toolUseLoop,
  orchestratorWorkers,
}

class _ClaudeAgentLoopSimulatorScreenState
    extends State<ClaudeAgentLoopSimulatorScreen> {
  AgentLoopPattern _selectedPattern = AgentLoopPattern.evaluatorOptimizer;
  int _currentStepIndex = 0;
  bool _isRunningAuto = false;

  // Evaluator-Optimizer simulation steps
  final List<Map<String, dynamic>> _evaluatorSteps = [
    {
      'title': '1. Goal Specification',
      'phase': 'User Input',
      'stopReason': 'N/A',
      'tokens': 120,
      'actor': 'User ➔ Orchestrator',
      'detail':
          'Request: "Write a thread-safe Swift 6 in-memory cache with LRU eviction and zero actor-reentrancy bugs."',
      'payload':
          '{"role": "user", "content": "Write a thread-safe Swift 6 in-memory cache..."}',
      'output': 'Prompt queued for Generator model.',
    },
    {
      'title': '2. Generator Draft #1',
      'phase': 'Claude 3.7 Sonnet (Thinking)',
      'stopReason': 'end_turn',
      'tokens': 1850,
      'actor': 'Generator Model',
      'detail':
          'Model generates Candidate Draft 1 using an actor with basic dictionary storage and async eviction.',
      'payload':
          'thinking: "Let\'s use an actor to enforce data race safety. For LRU eviction, a doubly linked list is standard..."',
      'output':
          'actor MemoryCache<Key: Hashable, Value> {\n  private var storage: [Key: Value] = [:]\n  func get(_ key: Key) async -> Value? { ... }\n}',
    },
    {
      'title': '3. Evaluator Critic & Test Run',
      'phase': 'Critic Model (Audit & Evals)',
      'stopReason': 'end_turn',
      'tokens': 2600,
      'actor': 'Evaluator Model',
      'detail':
          'Evaluator model inspects code against concurrency rubrics: FAILS due to potential actor reentrancy during eviction await!',
      'payload':
          'critique: "FAILED. In function evictOldest(), an await call yields actor isolation, allowing concurrent writes to corrupt linked list pointers."',
      'output':
          'Rubric Score: 68/100 (FAIL)\nFeedback: Prevent suspension inside mutation lock; use synchronous in-memory eviction before yielding.',
    },
    {
      'title': '4. Generator Draft #2 (Optimization)',
      'phase': 'Claude 3.7 Sonnet (Refinement)',
      'stopReason': 'end_turn',
      'tokens': 3900,
      'actor': 'Generator Model',
      'detail':
          'Generator ingests rubric feedback and re-factors code to eliminate suspension points during cache mutation.',
      'payload':
          '{"role": "user", "content": "Previous code failed: actor reentrancy in eviction. Refactor with synchronous state machine."}',
      'output':
          'actor SecureLRUCache<Key: Hashable, Value: Sendable> {\n  // Eviction is now completely synchronous; no suspension points inside lock!\n}',
    },
    {
      'title': '5. Verification Gate PASSED',
      'phase': 'Critic Model (Re-Evaluation)',
      'stopReason': 'end_turn',
      'tokens': 4450,
      'actor': 'Evaluator Model',
      'detail':
          'Evaluator awards 100/100 score. All Swift 6 strict concurrency checks and LRU invariants pass. Loop terminates!',
      'payload':
          'critique: "PASSED. Zero suspension points inside state lock. Strict Sendable conformance verified."',
      'output':
          'FINAL VERIFIED CODE READY FOR PRODUCTION\nLoop terminated deterministically in 2 iterations.',
    },
  ];

  // Tool Use simulation steps
  final List<Map<String, dynamic>> _toolSteps = [
    {
      'title': '1. User Request',
      'phase': 'User Input',
      'stopReason': 'N/A',
      'tokens': 85,
      'actor': 'User',
      'detail':
          'Request: "What is Apple\'s current market cap, and what was its stock price change yesterday?"',
      'payload':
          '{"role": "user", "content": "What is Apple\'s current market cap..."}',
      'output': 'Initial user turn registered.',
    },
    {
      'title': '2. Model Invokes Tool',
      'phase': 'Claude 3.5 Sonnet',
      'stopReason': 'tool_use',
      'tokens': 720,
      'actor': 'Model ➔ Client',
      'detail':
          'Claude recognizes missing real-time data and returns a tool_use block targeting financial_api.',
      'payload':
          '{"type": "tool_use", "id": "toolu_01A", "name": "get_stock_quote", "input": {"ticker": "AAPL"}}',
      'output':
          'stop_reason: "tool_use"\nClient receives instruction to execute get_stock_quote(ticker: "AAPL").',
    },
    {
      'title': '3. Client Injects Tool Result',
      'phase': 'Client Execution',
      'stopReason': 'N/A',
      'tokens': 980,
      'actor': 'Client ➔ Model',
      'detail':
          'Client runs HTTP request, obtains JSON result, and appends a tool_result content block to conversation history.',
      'payload':
          '{"type": "tool_result", "tool_use_id": "toolu_01A", "content": "{\\"price\\": 234.80, \\"change\\": +1.45, \\"market_cap\\": \\"3.58T\\"}"}',
      'output': 'Tool result sent back to Claude Messages API.',
    },
    {
      'title': '4. Final Synthesis & Exit Gate',
      'phase': 'Claude 3.5 Sonnet',
      'stopReason': 'end_turn',
      'tokens': 1350,
      'actor': 'Model ➔ User',
      'detail':
          'Claude synthesizes the verified facts into an authoritative, user-ready answer. stop_reason is "end_turn".',
      'payload':
          '{"role": "assistant", "content": "Apple (AAPL) is currently valued at \$3.58 Trillion, up +1.45 yesterday to \$234.80."}',
      'output':
          'stop_reason: "end_turn"\nAutonomous tool-calling cycle successfully concluded.',
    },
  ];

  // Orchestrator-Workers simulation steps
  final List<Map<String, dynamic>> _orchestratorSteps = [
    {
      'title': '1. Complex Multi-Domain Goal',
      'phase': 'User Input',
      'stopReason': 'N/A',
      'tokens': 150,
      'actor': 'User ➔ Orchestrator',
      'detail':
          'Request: "Audit an iOS codebase for App Store release: Privacy Manifest, Swift 6 Concurrency, and Binary Size."',
      'payload': '{"role": "user", "content": "Audit iOS codebase for..."}',
      'output': 'High-complexity task received by Lead Orchestrator.',
    },
    {
      'title': '2. Dynamic Subtask Breakdown',
      'phase': 'Lead Orchestrator (Claude 3.7)',
      'stopReason': 'end_turn',
      'tokens': 1400,
      'actor': 'Lead Orchestrator',
      'detail':
          'Orchestrator breaks complex request into 3 independent, isolated subagent prompts.',
      'payload':
          'Plan: [Subtask 1: PrivacyInfo.xcprivacy check, Subtask 2: Sendable safety audit, Subtask 3: Asset catalog & dSYM stripping]',
      'output':
          'Spawning 3 isolated Worker Agents (Claude 3.5 Haiku) in parallel.',
    },
    {
      'title': '3. Parallel Worker Execution',
      'phase': 'Worker Subagents (Parallel)',
      'stopReason': 'end_turn',
      'tokens': 4200,
      'actor': 'Worker 1, 2, 3 (Concurrently)',
      'detail':
          'Worker 1 audits NSPrivacyAccessedAPITypes; Worker 2 analyzes actor isolation; Worker 3 runs link-map parser.',
      'payload':
          'Worker 1: PASSED (Required reasons declared)\nWorker 2: 2 Warnings (MainActor isolation missing)\nWorker 3: 42MB optimized down to 28MB',
      'output': 'All 3 workers return structured JSON reports.',
    },
    {
      'title': '4. Lead Orchestrator Synthesis',
      'phase': 'Lead Orchestrator (Synthesis)',
      'stopReason': 'end_turn',
      'tokens': 5600,
      'actor': 'Lead Orchestrator ➔ User',
      'detail':
          'Orchestrator synthesizes findings from all 3 workers into an executive App Store submission audit report.',
      'payload':
          'Summary: 100% Privacy compliant, 2 minor concurrency fixes required, 33% binary size reduction achieved.',
      'output':
          'Executive report compiled with zero context pollution between workers.',
    },
  ];

  List<Map<String, dynamic>> get _currentSteps {
    switch (_selectedPattern) {
      case AgentLoopPattern.evaluatorOptimizer:
        return _evaluatorSteps;
      case AgentLoopPattern.toolUseLoop:
        return _toolSteps;
      case AgentLoopPattern.orchestratorWorkers:
        return _orchestratorSteps;
    }
  }

  void _stepForward() {
    if (_currentStepIndex < _currentSteps.length - 1) {
      setState(() => _currentStepIndex++);
    }
  }

  void _stepBackward() {
    if (_currentStepIndex > 0) {
      setState(() => _currentStepIndex--);
    }
  }

  void _resetLoop() {
    setState(() {
      _currentStepIndex = 0;
      _isRunningAuto = false;
    });
  }

  void _runAutoLoop() async {
    if (_isRunningAuto) return;
    setState(() => _isRunningAuto = true);

    while (_currentStepIndex < _currentSteps.length - 1 && _isRunningAuto && mounted) {
      await Future.delayed(const Duration(milliseconds: 1400));
      if (!mounted || !_isRunningAuto) break;
      setState(() => _currentStepIndex++);
    }

    if (mounted) {
      setState(() => _isRunningAuto = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final steps = _currentSteps;
    final currentStep = steps[_currentStepIndex];
    final isLastStep = _currentStepIndex == steps.length - 1;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Claude Agentic Loop Simulator'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Reset Loop',
            onPressed: _resetLoop,
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Pattern Selector
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  _buildPatternTab(
                    title: 'Evaluator-Optimizer',
                    pattern: AgentLoopPattern.evaluatorOptimizer,
                    isDark: isDark,
                  ),
                  _buildPatternTab(
                    title: 'Tool Use Loop',
                    pattern: AgentLoopPattern.toolUseLoop,
                    isDark: isDark,
                  ),
                  _buildPatternTab(
                    title: 'Orchestrator-Workers',
                    pattern: AgentLoopPattern.orchestratorWorkers,
                    isDark: isDark,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Live Loop Execution Header
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark
                      ? [const Color(0xFF311042), const Color(0xFF1E293B)]
                      : [const Color(0xFF7C3AED), const Color(0xFF6D28D9)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF7C3AED).withAlpha(50),
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
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'STEP ${_currentStepIndex + 1} OF ${steps.length}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: isLastStep
                              ? const Color(0xFF10B981)
                              : Colors.white.withAlpha(30),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          isLastStep ? 'LOOP TERMINATED ✓' : 'ITERATING ◐',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10.5,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    currentStep['title'] as String,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.4,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    currentStep['detail'] as String,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Live Telemetry Row
            Row(
              children: [
                Expanded(
                  child: _buildMetricBadge(
                    label: 'STOP REASON',
                    value: currentStep['stopReason'] as String,
                    icon: Icons.pause_circle_outline_rounded,
                    color: currentStep['stopReason'] == 'tool_use'
                        ? const Color(0xFFF59E0B)
                        : (currentStep['stopReason'] == 'end_turn'
                            ? const Color(0xFF10B981)
                            : const Color(0xFF64748B)),
                    isDark: isDark,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildMetricBadge(
                    label: 'TOKENS CONSUMED',
                    value: '${currentStep['tokens']}',
                    icon: Icons.token_rounded,
                    color: const Color(0xFF6366F1),
                    isDark: isDark,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildMetricBadge(
                    label: 'ACTIVE ACTOR',
                    value: (currentStep['actor'] as String).split(' ').first,
                    icon: Icons.person_rounded,
                    color: const Color(0xFFEC4899),
                    isDark: isDark,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Visual Loop Stepper
            Text(
              'Loop State Pipeline',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(steps.length, (index) {
                  final isActive = index == _currentStepIndex;
                  final isDone = index < _currentStepIndex;
                  return Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        decoration: BoxDecoration(
                          color: isActive
                              ? const Color(0xFF7C3AED)
                              : (isDone
                                  ? (isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0))
                                  : (isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC))),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isActive
                                ? const Color(0xFF7C3AED)
                                : (isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1)),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              isDone
                                  ? Icons.check_circle_rounded
                                  : (isActive ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded),
                              size: 14,
                              color: isActive
                                  ? Colors.white
                                  : (isDone ? const Color(0xFF10B981) : Colors.grey),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Step ${index + 1}',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                                color: isActive
                                    ? Colors.white
                                    : (isDark ? Colors.white70 : const Color(0xFF334155)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (index < steps.length - 1)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Icon(
                            Icons.arrow_forward_rounded,
                            size: 14,
                            color: isDone ? const Color(0xFF10B981) : Colors.grey,
                          ),
                        ),
                    ],
                  );
                }),
              ),
            ),

            const SizedBox(height: 18),

            // Live Payload / Scratchpad Box
            Text(
              'Payload & Reasoning Scratchpad',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF0F172A) : const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFF334155)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.code_rounded, size: 16, color: Color(0xFF38BDF8)),
                      const SizedBox(width: 8),
                      Text(
                        currentStep['phase'] as String,
                        style: const TextStyle(
                          color: Color(0xFF38BDF8),
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const Divider(color: Color(0xFF334155), height: 18),
                  Text(
                    currentStep['payload'] as String,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                      color: Color(0xFFE2E8F0),
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      currentStep['output'] as String,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 11.5,
                        color: Color(0xFFFDE047),
                        height: 1.35,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Step Controls
            Row(
              children: [
                OutlinedButton.icon(
                  onPressed: _currentStepIndex > 0 ? _stepBackward : null,
                  icon: const Icon(Icons.arrow_back_rounded, size: 18),
                  label: const Text('Back'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: isLastStep ? _resetLoop : _stepForward,
                    icon: Icon(
                      isLastStep ? Icons.replay_rounded : Icons.arrow_forward_rounded,
                      size: 18,
                    ),
                    label: Text(isLastStep ? 'Restart Loop' : 'Next Step'),
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF7C3AED),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton.filledTonal(
                  onPressed: _runAutoLoop,
                  icon: Icon(_isRunningAuto ? Icons.pause_rounded : Icons.play_arrow_rounded),
                  tooltip: 'Auto Run',
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Architectural Best Practices & Circuit Breakers Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.shield_rounded, color: Color(0xFF10B981), size: 18),
                      SizedBox(width: 8),
                      Text(
                        'Loop Circuit Breakers & Safety Guardrails',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _buildGuidelineItem(
                    title: 'Deterministic Max Iterations',
                    description:
                        'Always enforce a hard cap (e.g. max_iterations = 5). Never allow unbounded while-loops in production.',
                  ),
                  _buildGuidelineItem(
                    title: 'Token Budget Circuit Breakers',
                    description:
                        'Enforce cumulative token limits to protect against recursive agent runaway costs.',
                  ),
                  _buildGuidelineItem(
                    title: 'State Hash Loop Detection',
                    description:
                        'Calculate SHA256 of tool outputs. If an agent repeats identical tool arguments twice, trigger graceful fallback.',
                  ),
                  _buildGuidelineItem(
                    title: 'Human-in-the-Loop (HITL) Checkpoints',
                    description:
                        'Destructive tool actions (e.g. file deletion, database writes, financial transfers) must prompt human confirmation.',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPatternTab({
    required String title,
    required AgentLoopPattern pattern,
    required bool isDark,
  }) {
    final isSelected = _selectedPattern == pattern;
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          setState(() {
            _selectedPattern = pattern;
            _currentStepIndex = 0;
            _isRunningAuto = false;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? (isDark ? const Color(0xFF334155) : Colors.white)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withAlpha(15),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected
                  ? (isDark ? Colors.white : const Color(0xFF7C3AED))
                  : (isDark ? Colors.white60 : const Color(0xFF64748B)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMetricBadge({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
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
              Icon(icon, size: 12, color: color),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuidelineItem({
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF10B981))),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 12, color: Color(0xFF64748B), height: 1.35),
                children: [
                  TextSpan(
                    text: '$title: ',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF334155)),
                  ),
                  TextSpan(text: description),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
