import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Advanced Flutter Screen: Concurrency, Event Loop & Isolates.
/// Features a live interactive jank vs smooth frames experiment.
class IsolatesConcurrencyScreen extends StatefulWidget {
  const IsolatesConcurrencyScreen({super.key});

  @override
  State<IsolatesConcurrencyScreen> createState() => _IsolatesConcurrencyScreenState();
}

class _IsolatesConcurrencyScreenState extends State<IsolatesConcurrencyScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  bool _isRunning = false;
  String _status = 'Idle. Tap a button below to test thread impact.';
  int _lastResult = 0;
  int _elapsedMs = 0;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  // Heavy computation function that calculates primes up to limit
  static int _computePrimes(int limit) {
    int count = 0;
    for (int i = 2; i <= limit; i++) {
      bool isPrime = true;
      for (int j = 2; j * j <= i; j++) {
        if (i % j == 0) {
          isPrime = false;
          break;
        }
      }
      if (isPrime) count++;
    }
    return count;
  }

  // 1. Run on Main Thread (Blocks UI frame rendering -> Jank!)
  void _runOnMainThread() {
    setState(() {
      _isRunning = true;
      _status = 'Running on Main UI Thread (Watch spinner freeze!)...';
    });

    final stopwatch = Stopwatch()..start();
    // Heavy work blocks the UI isolate
    final primes = _computePrimes(150000);
    stopwatch.stop();

    setState(() {
      _lastResult = primes;
      _elapsedMs = stopwatch.elapsedMilliseconds;
      _isRunning = false;
      _status = 'Completed on Main Thread! UI froze completely for ${_elapsedMs}ms.';
    });
  }

  // 2. Run on Background Worker Isolate (Zero Jank!)
  Future<void> _runOnBackgroundIsolate() async {
    setState(() {
      _isRunning = true;
      _status = 'Running on Background Isolate (Spinner keeps rotating smoothly!)...';
    });

    final stopwatch = Stopwatch()..start();
    // compute() spawns a background isolate and returns result asynchronously
    final primes = await compute(_computePrimes, 150000);
    stopwatch.stop();

    if (!mounted) return;
    setState(() {
      _lastResult = primes;
      _elapsedMs = stopwatch.elapsedMilliseconds;
      _isRunning = false;
      _status = 'Completed on Worker Isolate in ${_elapsedMs}ms! Zero UI frame drops.';
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Isolates & Concurrency'),
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
                    ? [const Color(0xFF7C2D12), const Color(0xFF1E293B)]
                    : [const Color(0xFFEA580C), const Color(0xFFC2410C)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ADVANCED FLUTTER ARCHITECTURE',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Zero-Jank Multithreading & Isolates',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Dart is single-threaded by default with an Event Loop. To perform heavy JSON parsing or cryptographic math without dropping 60/120fps frames, you must offload to background Isolates.',
                  style: TextStyle(color: Colors.white, fontSize: 13, height: 1.35),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Interactive Jank Experiment Box
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: const Color(0xFFEA580C).withAlpha(120), width: 1.5),
            ),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                children: [
                  const Text(
                    'Live Frame Rate & Jank Test',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Observe the rotating wheel while executing 150,000 prime number calculations.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 18),

                  // Animated Rotating Indicator
                  RotationTransition(
                    turns: _animController,
                    child: Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        gradient: const SweepGradient(
                          colors: [Colors.orange, Colors.red, Colors.purple, Colors.orange],
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.orange.withAlpha(80),
                            blurRadius: 16,
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(Icons.speed_rounded, color: Colors.white, size: 36),
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  // Status and telemetry
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Status: $_status', style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600)),
                        if (_lastResult > 0) ...[
                          const SizedBox(height: 4),
                          Text('Result: $_lastResult primes found in ${_elapsedMs}ms',
                              style: const TextStyle(fontSize: 12, color: Colors.grey)),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.shade700,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: _isRunning ? null : _runOnMainThread,
                          icon: const Icon(Icons.block_rounded),
                          label: const Text('Main Thread (Jank)'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade700,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: _isRunning ? null : _runOnBackgroundIsolate,
                          icon: const Icon(Icons.bolt_rounded),
                          label: const Text('Isolate (Smooth)'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Theory Guide
          Text(
            'The Flutter Event Loop & Concurrency Rules',
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          _buildTheoryCard(
            '1. Event Loop Architecture',
            'Dart runs an infinite loop processing two FIFO queues:\n'
            '• Microtask Queue: Highest priority internal closures (scheduleMicrotask).\n'
            '• Event Queue: I/O events, timers, tap gestures, drawing frames.\n'
            'If a synchronous operation on the Event Queue exceeds 16.6ms (60fps) or 8.3ms (120fps), frames are dropped (jank).',
            Icons.sync_rounded,
          ),
          const SizedBox(height: 10),
          _buildTheoryCard(
            '2. compute() vs Raw Isolate.spawn()',
            '• compute<Q, R>(callback, message): Built-in high-level wrapper. Perfect for single-shot tasks (JSON parsing, image resizing).\n'
            '• Isolate.spawn(): Long-lived background workers with bidirectional message communication via ReceivePort and SendPort.',
            Icons.account_tree_rounded,
          ),
          const SizedBox(height: 10),
          _buildTheoryCard(
            '3. Zero Shared Memory',
            'Unlike threads in Java or C++, Dart Isolates share ZERO mutable memory. Communication occurs strictly via serialized message passing over ports. This eliminates mutexes, deadlocks, and race conditions by design.',
            Icons.security_rounded,
          ),
        ],
      ),
    );
  }

  Widget _buildTheoryCard(String title, String body, IconData icon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: const Color(0xFFEA580C), size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 4),
                  Text(body, style: const TextStyle(fontSize: 12.5, height: 1.4)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
