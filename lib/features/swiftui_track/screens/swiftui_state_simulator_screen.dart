import 'package:flutter/material.dart';

/// Interactive SwiftUI State & Data Flow Simulator.
/// Simulates @State, @Binding, @Observable ViewModel, and @Environment propagation.
class SwiftUiStateSimulatorScreen extends StatefulWidget {
  const SwiftUiStateSimulatorScreen({super.key});

  @override
  State<SwiftUiStateSimulatorScreen> createState() => _SwiftUiStateSimulatorScreenState();
}

class _SwiftUiStateSimulatorScreenState extends State<SwiftUiStateSimulatorScreen> {
  // Lab 1: @State & @Binding
  int _parentCounter = 10;
  bool _isFeatureEnabled = true;

  // Lab 2: @Observable ViewModel Simulation
  bool _isLoadingUser = false;
  String _userStatus = 'Idle: Tap Fetch to run Swift Concurrency Task';
  Map<String, String>? _userData;

  // Lab 3: @Environment Key Injection
  Color _environmentAccent = const Color(0xFF4F46E5);
  String _environmentTier = 'Enterprise VIP';

  void _simulateSwiftTask({required bool shouldFail}) async {
    setState(() {
      _isLoadingUser = true;
      _userStatus = 'Task { @MainActor in await viewModel.fetchProfile() }...';
      _userData = null;
    });

    await Future.delayed(const Duration(milliseconds: 600));

    if (!mounted) return;

    setState(() {
      _isLoadingUser = false;
      if (shouldFail) {
        _userStatus = 'Error: URLError.timedOut. @Observable view invalidated with retry.';
        _userData = null;
      } else {
        _userStatus = 'Success: Task finished on @MainActor without thread hop.';
        _userData = {
          'name': 'Alex Rivera',
          'role': 'iOS Staff Architect',
          'team': 'Core Experience',
        };
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('SwiftUI State & Data Flow Simulator'),
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
                    ? [const Color(0xFF1E1B4B), const Color(0xFF1E293B)]
                    : [const Color(0xFF4F46E5), const Color(0xFF4338CA)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF4F46E5).withAlpha(50),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'INTERACTIVE SWIFTUI RUNTIME LAB',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'State, Binding & Observability Simulator',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Simulate real-time SwiftUI memory mechanics: @State single-source-of-truth, two-way @Binding mutations, iOS 17 @Observable macros, and @Environment cascades.',
                  style: TextStyle(color: Colors.white, fontSize: 13, height: 1.35),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ----------------------------------------------------
          // LAB 1: @State vs @Binding
          // ----------------------------------------------------
          _buildCard(
            context,
            title: '1. @State ➔ @Binding Two-Way Propagation',
            subtitle: 'ParentView owns @State; ChildStepperView receives \$counter as @Binding',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF4F46E5).withAlpha(80)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('ParentView @State memory:', style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(
                            'counter = $_parentCounter',
                            style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF4F46E5), fontSize: 16),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Feature Flag (@State Bool):'),
                          Switch(
                            value: _isFeatureEnabled,
                            activeThumbColor: const Color(0xFF4F46E5),
                            onChanged: (val) => setState(() => _isFeatureEnabled = val),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // Child View Simulation
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : const Color(0xFFEEF2FF),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.indigo.shade300),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.subdirectory_arrow_right_rounded, color: Color(0xFF4F46E5), size: 18),
                          SizedBox(width: 6),
                          Text('ChildView (bound via @Binding var count: Int)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Child view modifies parent state directly via projected binding \$counter:',
                              style: TextStyle(fontSize: 12, color: isDark ? Colors.white70 : Colors.black87),
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton.filledTonal(
                            icon: const Icon(Icons.remove_rounded),
                            onPressed: () => setState(() => _parentCounter--),
                          ),
                          const SizedBox(width: 4),
                          IconButton.filledTonal(
                            icon: const Icon(Icons.add_rounded),
                            onPressed: () => setState(() => _parentCounter++),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // ----------------------------------------------------
          // LAB 2: @Observable & Swift Concurrency Task
          // ----------------------------------------------------
          _buildCard(
            context,
            title: '2. iOS 17+ @Observable ViewModel & Task { }',
            subtitle: 'Replaces ObservableObject with macro-driven granular property tracking',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Runtime Status: $_userStatus', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12.5)),
                      if (_isLoadingUser) ...[
                        const SizedBox(height: 10),
                        const LinearProgressIndicator(),
                      ],
                      if (_userData != null) ...[
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.green.withAlpha(25),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.green.withAlpha(100)),
                          ),
                          child: Row(
                            children: [
                              const CircleAvatar(
                                backgroundColor: Color(0xFF10B981),
                                radius: 18,
                                child: Icon(Icons.person, color: Colors.white, size: 20),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(_userData!['name']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                    Text('${_userData!['role']} • ${_userData!['team']}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4F46E5),
                          foregroundColor: Colors.white,
                        ),
                        onPressed: _isLoadingUser ? null : () => _simulateSwiftTask(shouldFail: false),
                        icon: const Icon(Icons.bolt_rounded),
                        label: const Text('Task { await fetch() }'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red.shade700,
                          side: BorderSide(color: Colors.red.shade300),
                        ),
                        onPressed: _isLoadingUser ? null : () => _simulateSwiftTask(shouldFail: true),
                        icon: const Icon(Icons.error_outline_rounded),
                        label: const Text('Simulate Error'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // ----------------------------------------------------
          // LAB 3: @Environment Key Injection
          // ----------------------------------------------------
          _buildCard(
            context,
            title: '3. @Environment Subtree Cascade',
            subtitle: 'Ambient value injection down the hierarchy without prop drilling',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Select Root View Environment Value:'),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildThemeChip('Indigo', const Color(0xFF4F46E5)),
                    const SizedBox(width: 8),
                    _buildThemeChip('Emerald', const Color(0xFF059669)),
                    const SizedBox(width: 8),
                    _buildThemeChip('Rose', const Color(0xFFE11D48)),
                    const SizedBox(width: 8),
                    _buildThemeChip('Amber', const Color(0xFFD97706)),
                  ],
                ),
                const SizedBox(height: 14),

                // Subtree hierarchy
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: _environmentAccent.withAlpha(20),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: _environmentAccent.withAlpha(120)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'RootView.environment(\\.accentColor, selectedColor)',
                        style: TextStyle(fontFamily: 'monospace', fontSize: 11.5, fontWeight: FontWeight.bold, color: _environmentAccent),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: Text(
                          '↳ ChildView reads: @Environment(\\.accentColor)',
                          style: TextStyle(fontSize: 12, color: isDark ? Colors.white70 : Colors.black87),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Padding(
                        padding: const EdgeInsets.only(left: 32),
                        child: Row(
                          children: [
                            const Text('↳ GrandchildView Badge: ', style: TextStyle(fontSize: 12)),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: _environmentAccent,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                _environmentTier,
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required Widget child,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15.5)),
            const SizedBox(height: 2),
            Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 14),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildThemeChip(String label, Color color) {
    final isSelected = _environmentAccent == color;
    return ChoiceChip(
      selected: isSelected,
      label: Text(label),
      selectedColor: color.withAlpha(50),
      labelStyle: TextStyle(
        color: isSelected ? color : null,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        fontSize: 12,
      ),
      onSelected: (val) {
        if (val) {
          setState(() {
            _environmentAccent = color;
            _environmentTier = '$label VIP';
          });
        }
      },
    );
  }
}
