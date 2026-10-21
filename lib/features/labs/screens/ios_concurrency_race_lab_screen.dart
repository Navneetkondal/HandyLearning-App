import 'dart:async';
import 'package:flutter/material.dart';

/// Interactive Actor Reentrancy & Data Race Simulator Screen
class IosConcurrencyRaceLabScreen extends StatefulWidget {
  const IosConcurrencyRaceLabScreen({super.key});

  @override
  State<IosConcurrencyRaceLabScreen> createState() => _IosConcurrencyRaceLabScreenState();
}

class _IosConcurrencyRaceLabScreenState extends State<IosConcurrencyRaceLabScreen> {
  int _selectedArchitecture = 2; // 0: Unsafe Class, 1: GCD Serial Queue, 2: Actor (Reentrancy Bug), 3: Guarded Actor
  int _balance = 100;
  int _successfulWithdrawals = 0;
  int _rejectedWithdrawals = 0;
  bool _isRunning = false;
  final List<String> _logs = [];

  void _reset() {
    setState(() {
      _balance = 100;
      _successfulWithdrawals = 0;
      _rejectedWithdrawals = 0;
      _isRunning = false;
      _logs.clear();
      _logs.add('Simulator ready. Initial balance: \$100. Tap "Fire 10 Concurrent Requests".');
    });
  }

  Future<void> _simulateConcurrentWithdrawals() async {
    if (_isRunning) return;

    setState(() {
      _isRunning = true;
      _balance = 100;
      _successfulWithdrawals = 0;
      _rejectedWithdrawals = 0;
      _logs.clear();
      _logs.add('🚀 Dispatched 10 concurrent async withdrawal requests of \$20 each...');
    });

    const withdrawalAmount = 20;

    if (_selectedArchitecture == 0) {
      // 0: Unsynchronized Class (Data Race Simulation)
      _logs.add('⚠️ Running on raw unsynchronized memory without locks...');
      for (int i = 1; i <= 10; i++) {
        await Future.delayed(const Duration(milliseconds: 30));
        // Simulating data race: non-atomic read and write
        _balance -= withdrawalAmount; // Raw subtraction without proper atomic guard
        _successfulWithdrawals++;
        _logs.add('Task #$i: Wrote directly to memory. Balance now: \$$_balance');
      }
      _logs.add('💥 CRITICAL DATA RACE: Balance underflowed to \$$_balance! No thread synchronization!');
    } else if (_selectedArchitecture == 1) {
      // 1: GCD Serial Queue (Ordered execution)
      _logs.add('🔒 Synchronized using serial DispatchQueue. FIFO ordered execution...');
      for (int i = 1; i <= 10; i++) {
        await Future.delayed(const Duration(milliseconds: 40));
        if (_balance >= withdrawalAmount) {
          _balance -= withdrawalAmount;
          _successfulWithdrawals++;
          _logs.add('Task #$i [Serial]: Verified balance (\$$_balance + $withdrawalAmount) >= \$20. Success! Balance: \$$_balance');
        } else {
          _rejectedWithdrawals++;
          _logs.add('Task #$i [Serial]: Insufficient funds (Current: \$$_balance). Request REJECTED.');
        }
      }
      _logs.add('✅ GCD Serial Queue executed correctly. Final balance: \$$_balance.');
    } else if (_selectedArchitecture == 2) {
      // 2: Actor Reentrancy Vulnerability
      _logs.add('🎭 Actor isolated, BUT suspension point (await) causes Actor Reentrancy bug!');
      // Phase 1: All 10 tasks enter actor and check `balance >= 20` before await
      _logs.add('Phase 1: All 10 tasks pass `guard balance >= 20` check before suspension point.');
      for (int i = 1; i <= 10; i++) {
        _logs.add('Task #$i: Balance is \$100 >= \$20. Entering `await networkAuditDebit()`...');
      }

      // Suspension point delay
      await Future.delayed(const Duration(milliseconds: 400));

      // Phase 2: Tasks resume from await and blindly subtract without re-verifying
      _logs.add('Phase 2: Resuming across `await`. State was NOT re-verified!');
      for (int i = 1; i <= 10; i++) {
        await Future.delayed(const Duration(milliseconds: 40));
        _balance -= withdrawalAmount;
        _successfulWithdrawals++;
        _logs.add('Task #$i: Resumed from await! Subtracted \$20. Balance is now: \$$_balance');
      }
      _logs.add('❌ ACTOR REENTRANCY DISASTER: 10 withdrawals processed! Final balance: -\$100! Financial catastrophe.');
    } else {
      // 3: Guarded Actor (Re-verifying state or serializing transactional intents)
      _logs.add('🛡️ Guarded Actor: State is atomically re-checked AFTER suspension point before mutating.');
      for (int i = 1; i <= 10; i++) {
        await Future.delayed(const Duration(milliseconds: 50));
        // Suspension point
        await Future.delayed(const Duration(milliseconds: 20));
        if (_balance >= withdrawalAmount) {
          _balance -= withdrawalAmount;
          _successfulWithdrawals++;
          _logs.add('Task #$i [Guarded]: Verified after suspension point. Approved \$20. Balance: \$$_balance');
        } else {
          _rejectedWithdrawals++;
          _logs.add('Task #$i [Guarded]: State changed during suspension! Insufficient funds (\$$_balance). Rejected!');
        }
      }
      _logs.add('🏆 Transaction Safe! Only 5 withdrawals succeeded. Account balance protected at \$0.');
    }

    if (!mounted) return;
    setState(() {
      _isRunning = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _reset();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const primaryIndigo = Color(0xFF6366F1);
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textPrimary = isDark ? Colors.white : const Color(0xFF0F172A);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Actor Reentrancy & Race Lab'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Reset',
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
                    ? [const Color(0xFF3B0764), const Color(0xFF1E1B4B)]
                    : [const Color(0xFFFAF5FF), const Color(0xFFF3E8FF)],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF8B5CF6).withAlpha(80)),
            ),
            child: Row(
              children: [
                const Icon(Icons.bolt_rounded, color: Color(0xFF8B5CF6), size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Swift Concurrency Actor Reentrancy Lab',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.5, color: textPrimary),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Simulate high-frequency concurrent withdrawals. See why Actors prevent data races but still suffer from reentrancy bugs!',
                        style: TextStyle(fontSize: 12, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Architecture Selector
          Text('SELECT CONCURRENCY ARCHITECTURE', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, letterSpacing: 0.8, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B))),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildArchPill(0, 'Unsafe Class', Icons.warning_rounded),
                const SizedBox(width: 8),
                _buildArchPill(1, 'GCD Serial Queue', Icons.queue_rounded),
                const SizedBox(width: 8),
                _buildArchPill(2, 'Actor (Reentrancy Bug)', Icons.sync_problem_rounded),
                const SizedBox(width: 8),
                _buildArchPill(3, 'Guarded Actor', Icons.security_rounded),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Live Metrics Card
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _balance < 0
                    ? const Color(0xFFEF4444)
                    : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                width: _balance < 0 ? 2 : 1,
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('ACCOUNT BALANCE', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: textPrimary)),
                    Text(
                      '\$$_balance',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        color: _balance < 0
                            ? const Color(0xFFEF4444)
                            : (_balance == 0 ? const Color(0xFF10B981) : primaryIndigo),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981).withAlpha(15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Approved', style: TextStyle(fontSize: 11, color: Color(0xFF10B981), fontWeight: FontWeight.bold)),
                            Text('$_successfulWithdrawals / 10', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEF4444).withAlpha(15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Rejected', style: TextStyle(fontSize: 11, color: Color(0xFFEF4444), fontWeight: FontWeight.bold)),
                            Text('$_rejectedWithdrawals / 10', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Primary Action
          FilledButton.icon(
            icon: _isRunning
                ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : const Icon(Icons.flash_on_rounded, size: 20),
            label: Text(_isRunning ? 'Simulating Concurrent Threads...' : 'Fire 10 Concurrent Requests (\$20 each)'),
            style: FilledButton.styleFrom(
              backgroundColor: _selectedArchitecture == 2 ? const Color(0xFFDC2626) : primaryIndigo,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: _isRunning ? null : _simulateConcurrentWithdrawals,
          ),

          const SizedBox(height: 16),

          // Execution Trace Log
          Text('LIVE DISPATCH & REENTRANCY TRACE', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, letterSpacing: 0.8, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B))),
          const SizedBox(height: 8),
          Container(
            height: 220,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF334155)),
            ),
            child: ListView.builder(
              itemCount: _logs.length,
              itemBuilder: (context, idx) {
                final log = _logs[idx];
                Color logColor = const Color(0xFFCBD5E1);
                if (log.contains('❌') || log.contains('💥') || log.contains('CRITICAL')) {
                  logColor = const Color(0xFFF87171);
                } else if (log.contains('✅') || log.contains('🏆')) {
                  logColor = const Color(0xFF34D399);
                } else if (log.contains('⚠️') || log.contains('Phase')) {
                  logColor = const Color(0xFFFBBF24);
                }
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Text(
                    log,
                    style: TextStyle(fontFamily: 'Courier', fontSize: 11.5, color: logColor),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArchPill(int index, String title, IconData icon) {
    final isSelected = _selectedArchitecture == index;
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () {
        setState(() {
          _selectedArchitecture = index;
          _reset();
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF8B5CF6) : const Color(0xFF8B5CF6).withAlpha(20),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(icon, size: 15, color: isSelected ? Colors.white : const Color(0xFF8B5CF6)),
            const SizedBox(width: 6),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : const Color(0xFF8B5CF6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
