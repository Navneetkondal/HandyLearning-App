import 'package:flutter/material.dart';

/// Interactive Retain Cycle & ARC Memory Graph Simulator
class IosArcMemoryLabScreen extends StatefulWidget {
  const IosArcMemoryLabScreen({super.key});

  @override
  State<IosArcMemoryLabScreen> createState() => _IosArcMemoryLabScreenState();
}

class _IosArcMemoryLabScreenState extends State<IosArcMemoryLabScreen> {
  // Scenario state
  int _scenarioIndex = 0; // 0: Closure Capture, 1: Strong Delegate, 2: Target-Action Timer
  bool _applyFix = false;
  bool _isAllocated = false;
  String _debuggerLog = 'Ready. Select a scenario and allocate objects to inspect ARC mechanics.';

  // ARC Counts
  int _vcRefCount = 0;
  int _closureRefCount = 0;
  bool _hasSideTable = false;
  bool _isLeaked = false;

  void _allocate() {
    setState(() {
      _isAllocated = true;
      if (_scenarioIndex == 0) {
        // Closure capture
        _vcRefCount = _applyFix ? 1 : 2; // With fix, closure holds weak (side-table)
        _closureRefCount = 1;
        _hasSideTable = _applyFix;
        _isLeaked = !_applyFix;
        _debuggerLog = _applyFix
            ? 'ALLOCATED: ViewController [RC: 1] ➔ Closure [RC: 1]. Closure captures [weak self]. Side table created for weak pointer. Retain cycle PREVENTED.'
            : 'ALLOCATED: ViewController [RC: 2] ➔ Closure [RC: 1]. Closure captures strong self. Mutual retention created: ViewController ↔ Closure. Leaked on dismiss!';
      } else if (_scenarioIndex == 1) {
        // Strong delegate
        _vcRefCount = _applyFix ? 1 : 2;
        _closureRefCount = 1; // Used as DetailViewModel
        _hasSideTable = _applyFix;
        _isLeaked = !_applyFix;
        _debuggerLog = _applyFix
            ? 'ALLOCATED: ParentVC [RC: 1] ➔ DetailViewModel [RC: 1]. Delegate declared as `weak var delegate: Protocol?`. Zero cycle.'
            : 'ALLOCATED: ParentVC [RC: 2] ➔ DetailViewModel [RC: 1]. Delegate declared as `var delegate: Protocol?` (STRONG). Mutual retain cycle created!';
      } else {
        // Timer
        _vcRefCount = _applyFix ? 1 : 2;
        _closureRefCount = 1; // Timer
        _hasSideTable = _applyFix;
        _isLeaked = !_applyFix;
        _debuggerLog = _applyFix
            ? 'ALLOCATED: ViewController [RC: 1]. Timer instantiated with weak-proxy block. Invalidation hooked into viewWillDisappear. Clean deinit.'
            : 'ALLOCATED: ViewController [RC: 2]. RunLoop ➔ Timer ➔ ViewController (strong target). RunLoop retains Timer which retains ViewController!';
      }
    });
  }

  void _dismissScreen() {
    if (!_isAllocated) return;
    setState(() {
      if (_applyFix) {
        _isAllocated = false;
        _vcRefCount = 0;
        _closureRefCount = 0;
        _hasSideTable = false;
        _isLeaked = false;
        _debuggerLog = 'DISMISSED: All references dropped to 0. `deinit` invoked immediately! Heap memory reclaimed by OS.';
      } else {
        _isAllocated = false;
        _vcRefCount = 1; // Leaked!
        _closureRefCount = 1; // Leaked!
        _isLeaked = true;
        _debuggerLog = 'DISMISSED: Screen popped from UINavigationController, but ViewController RC remains 1! `deinit` was NEVER called! Leak confirmed in Instruments.';
      }
    });
  }

  void _reset() {
    setState(() {
      _isAllocated = false;
      _vcRefCount = 0;
      _closureRefCount = 0;
      _hasSideTable = false;
      _isLeaked = false;
      _debuggerLog = 'Reset. Choose a scenario and test allocation & dismissal.';
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const primaryIndigo = Color(0xFF6366F1);
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textPrimary = isDark ? Colors.white : const Color(0xFF0F172A);

    return Scaffold(
      appBar: AppBar(
        title: const Text('ARC & Retain Cycle Simulator'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Reset Lab',
            onPressed: _reset,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Banner
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [const Color(0xFF312E81), const Color(0xFF1E1B4B)]
                    : [const Color(0xFFEEF2FF), const Color(0xFFE0E7FF)],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: primaryIndigo.withAlpha(80)),
            ),
            child: Row(
              children: [
                const Icon(Icons.memory_rounded, color: primaryIndigo, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Interactive Memory Graph Debugger',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.5, color: textPrimary),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Simulate heap reference counts, side tables, and closure/delegate leaks in real time.',
                        style: TextStyle(fontSize: 12, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Scenario Selector
          Text('SELECT LEAK SCENARIO', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, letterSpacing: 0.8, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B))),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildScenarioPill(0, 'Closure Capture', Icons.data_object_rounded),
                const SizedBox(width: 8),
                _buildScenarioPill(1, 'Strong Delegate', Icons.handshake_rounded),
                const SizedBox(width: 8),
                _buildScenarioPill(2, 'Target-Action Timer', Icons.timer_rounded),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Fix Switch
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: _applyFix ? const Color(0xFF10B981) : Colors.grey.withAlpha(60)),
            ),
            child: Row(
              children: [
                Icon(
                  _applyFix ? Icons.check_circle_rounded : Icons.warning_amber_rounded,
                  color: _applyFix ? const Color(0xFF10B981) : const Color(0xFFF59E0B),
                  size: 22,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _applyFix ? 'Safe Implementation Active' : 'Vulnerable Implementation Active',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: textPrimary),
                      ),
                      Text(
                        _applyFix ? _fixDescription() : 'No capture list or weak qualifiers applied.',
                        style: TextStyle(fontSize: 11, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: _applyFix,
                  activeThumbColor: const Color(0xFF10B981),
                  onChanged: (val) {
                    setState(() {
                      _applyFix = val;
                      _reset();
                    });
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Visual Node Graph
          _buildMemoryGraph(isDark, cardBg, textPrimary),

          const SizedBox(height: 16),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  icon: const Icon(Icons.add_box_rounded, size: 18),
                  label: const Text('Allocate Object'),
                  style: FilledButton.styleFrom(
                    backgroundColor: primaryIndigo,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: _isAllocated ? null : _allocate,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: FilledButton.icon(
                  icon: const Icon(Icons.arrow_back_rounded, size: 18),
                  label: const Text('Pop / Dismiss Screen'),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFDC2626),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: _isAllocated ? _dismissScreen : null,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Debugger Console Log
          Text('LLVM & INSTRUMENTS CONSOLE OUTPUT', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, letterSpacing: 0.8, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B))),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _isLeaked ? const Color(0xFFEF4444) : const Color(0xFF334155)),
            ),
            child: Text(
              _debuggerLog,
              style: TextStyle(
                fontFamily: 'Courier',
                fontSize: 12,
                color: _isLeaked ? const Color(0xFFFCA5A5) : const Color(0xFF34D399),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScenarioPill(int index, String title, IconData icon) {
    final isSelected = _scenarioIndex == index;
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () {
        setState(() {
          _scenarioIndex = index;
          _reset();
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF6366F1) : const Color(0xFF6366F1).withAlpha(20),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(icon, size: 15, color: isSelected ? Colors.white : const Color(0xFF6366F1)),
            const SizedBox(width: 6),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : const Color(0xFF6366F1),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _fixDescription() {
    switch (_scenarioIndex) {
      case 0:
        return 'Using `[weak self]` in capture list with optional unwrap.';
      case 1:
        return 'Using `weak var delegate: Protocol?` to break cycle.';
      case 2:
        return 'Using target-proxy pattern or weak-block timer.';
      default:
        return '';
    }
  }

  Widget _buildMemoryGraph(bool isDark, Color cardBg, Color textPrimary) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _isLeaked
              ? const Color(0xFFEF4444)
              : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
          width: _isLeaked ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'LIVE HEAP OBJECT TOPOLOGY',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: textPrimary),
              ),
              if (_isLeaked)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEF4444).withAlpha(25),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'LEAK DETECTED ⚠',
                    style: TextStyle(color: Color(0xFFEF4444), fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Node 1: ViewController
              _buildNode(
                title: 'ViewController',
                refCount: _vcRefCount,
                isAllocated: _isAllocated || _isLeaked,
                isLeaked: _isLeaked,
                sideTable: _hasSideTable,
              ),

              // Arrow
              Column(
                children: [
                  Icon(
                    _isAllocated || _isLeaked
                        ? (_isLeaked ? Icons.sync_problem_rounded : Icons.sync_alt_rounded)
                        : Icons.arrow_forward_rounded,
                    color: _isLeaked ? const Color(0xFFEF4444) : const Color(0xFF6366F1),
                    size: 26,
                  ),
                  Text(
                    _applyFix ? 'weak ref' : 'strong cycle',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: _applyFix ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                    ),
                  ),
                ],
              ),

              // Node 2: Closure / ViewModel / Timer
              _buildNode(
                title: _scenarioIndex == 0 ? 'Closure' : (_scenarioIndex == 1 ? 'Delegate/VM' : 'Timer'),
                refCount: _closureRefCount,
                isAllocated: _isAllocated || _isLeaked,
                isLeaked: _isLeaked,
                sideTable: false,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNode({
    required String title,
    required int refCount,
    required bool isAllocated,
    required bool isLeaked,
    required bool sideTable,
  }) {
    Color borderColor;
    if (!isAllocated && !isLeaked) {
      borderColor = Colors.grey.withAlpha(60);
    } else if (isLeaked) {
      borderColor = const Color(0xFFEF4444);
    } else {
      borderColor = const Color(0xFF10B981);
    }

    return Container(
      width: 120,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isLeaked ? const Color(0xFFEF4444).withAlpha(15) : (isAllocated ? const Color(0xFF10B981).withAlpha(15) : Colors.transparent),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor, width: 1.5),
      ),
      child: Column(
        children: [
          Icon(
            isAllocated ? Icons.layers_rounded : (isLeaked ? Icons.error_rounded : Icons.check_box_outline_blank_rounded),
            color: borderColor,
            size: 24,
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            'RC: $refCount',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: isLeaked ? const Color(0xFFEF4444) : const Color(0xFF6366F1),
            ),
          ),
          if (sideTable) ...[
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
              decoration: BoxDecoration(
                color: const Color(0xFF6366F1).withAlpha(20),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text('SideTable', style: TextStyle(fontSize: 9, color: Color(0xFF6366F1), fontWeight: FontWeight.bold)),
            ),
          ],
        ],
      ),
    );
  }
}
