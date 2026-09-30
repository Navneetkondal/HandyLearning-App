import 'package:flutter/material.dart';

/// Interactive Prompt Caching ROI & Latency Calculator.
/// Calculates cost savings based on Anthropic's official pricing:
/// Claude 3.7 / 3.5 Sonnet:
///   - Base Input: $3.00 / MTok
///   - Cache Write: $3.75 / MTok (1.25x)
///   - Cache Read:  $0.30 / MTok (0.10x -> 90% discount)
/// Claude 3.5 Haiku:
///   - Base Input: $0.80 / MTok
///   - Cache Write: $1.00 / MTok (1.25x)
///   - Cache Read:  $0.08 / MTok (0.10x -> 90% discount)
/// Claude 3 Opus:
///   - Base Input: $15.00 / MTok
///   - Cache Write: $18.75 / MTok (1.25x)
///   - Cache Read:  $1.50 / MTok (0.10x -> 90% discount)
class ClaudeCachingCalculatorScreen extends StatefulWidget {
  const ClaudeCachingCalculatorScreen({super.key});

  @override
  State<ClaudeCachingCalculatorScreen> createState() => _ClaudeCachingCalculatorScreenState();
}

class _ClaudeCachingCalculatorScreenState extends State<ClaudeCachingCalculatorScreen> {
  String _selectedModel = 'Claude 3.7 Sonnet';
  double _cachedTokens = 40000; // 40k tokens
  double _requestsPerDay = 500;
  double _cacheHitRatio = 0.85; // 85% cache hit rate

  final Map<String, _ModelPricing> _pricing = {
    'Claude 3.7 Sonnet': const _ModelPricing(baseInput: 3.00, cacheWrite: 3.75, cacheRead: 0.30, minTokens: 1024),
    'Claude 3.5 Haiku': const _ModelPricing(baseInput: 0.80, cacheWrite: 1.00, cacheRead: 0.08, minTokens: 2048),
    'Claude 3 Opus': const _ModelPricing(baseInput: 15.00, cacheWrite: 18.75, cacheRead: 1.50, minTokens: 1024),
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final currentPricing = _pricing[_selectedModel]!;

    // Calculations
    final totalTokensPerDay = _cachedTokens * _requestsPerDay;
    final totalMTokPerDay = totalTokensPerDay / 1000000.0;

    // Standard Cost without caching
    final standardCostDaily = totalMTokPerDay * currentPricing.baseInput;
    final standardCostMonthly = standardCostDaily * 30;

    // Cost with Caching
    // Cache writes occur on cache misses / expired TTL
    final writesPerDay = _requestsPerDay * (1.0 - _cacheHitRatio);
    final readsPerDay = _requestsPerDay * _cacheHitRatio;

    final writeMTokPerDay = (_cachedTokens * writesPerDay) / 1000000.0;
    final readMTokPerDay = (_cachedTokens * readsPerDay) / 1000000.0;

    final cachedCostDaily = (writeMTokPerDay * currentPricing.cacheWrite) + (readMTokPerDay * currentPricing.cacheRead);
    final cachedCostMonthly = cachedCostDaily * 30;

    final monthlySavings = standardCostMonthly - cachedCostMonthly;
    final percentageSavings = standardCostMonthly > 0 ? (monthlySavings / standardCostMonthly) * 100 : 0.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Prompt Caching ROI Calculator'),
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
                    ? [const Color(0xFF0F172A), const Color(0xFF1E293B)]
                    : [const Color(0xFF0284C7), const Color(0xFF0369A1)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.savings_rounded, color: Colors.white, size: 24),
                    SizedBox(width: 8),
                    Text(
                      'ANTHROPIC PROMPT CACHING',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Text(
                  'Cut Enterprise API Bills by up to 90%',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Cache system prompts, tool schemas, and codebase contexts. Cached read tokens cost 90% less and slash First Token Latency by up to 80%.',
                  style: TextStyle(color: Colors.white, fontSize: 13, height: 1.3),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Savings Summary Card
          Card(
            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF0FDF4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: Colors.green.withAlpha(120), width: 1.5),
            ),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Estimated Monthly Savings', style: TextStyle(fontSize: 12, color: Colors.grey)),
                          const SizedBox(height: 4),
                          Text(
                            '\$${monthlySavings.toStringAsFixed(2)} / mo',
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.green.withAlpha(30),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.green),
                        ),
                        child: Text(
                          '${percentageSavings.toStringAsFixed(1)}% OFF',
                          style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: _buildMetricItem(
                          'Without Caching',
                          '\$${standardCostMonthly.toStringAsFixed(2)}',
                          Colors.redAccent,
                        ),
                      ),
                      Expanded(
                        child: _buildMetricItem(
                          'With Caching',
                          '\$${cachedCostMonthly.toStringAsFixed(2)}',
                          Colors.green,
                        ),
                      ),
                      Expanded(
                        child: _buildMetricItem(
                          'Latency Drop',
                          '~75%',
                          const Color(0xFF0284C7),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Interactive Sliders
          Text(
            'Configure Workload Parameters',
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          // Model Selector
          DropdownButtonFormField<String>(
            initialValue: _selectedModel,
            decoration: InputDecoration(
              labelText: 'Select Claude Model',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              prefixIcon: const Icon(Icons.psychology_rounded),
            ),
            items: _pricing.keys.map((name) {
              return DropdownMenuItem(value: name, child: Text(name));
            }).toList(),
            onChanged: (val) {
              if (val != null) setState(() => _selectedModel = val);
            },
          ),

          const SizedBox(height: 16),

          // Cached Context Tokens Slider
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Cached Context Size', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(
                        '${_cachedTokens.toInt()} tokens',
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0284C7)),
                      ),
                    ],
                  ),
                  Slider(
                    value: _cachedTokens,
                    min: currentPricing.minTokens.toDouble(),
                    max: 180000,
                    divisions: 180,
                    activeColor: const Color(0xFF0284C7),
                    onChanged: (val) => setState(() => _cachedTokens = val),
                  ),
                  Text(
                    'Min required threshold: ${currentPricing.minTokens} tokens (e.g. system instructions, tool schemas, docs).',
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Daily Request Volume Slider
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Daily API Requests', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(
                        '${_requestsPerDay.toInt()} reqs / day',
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0284C7)),
                      ),
                    ],
                  ),
                  Slider(
                    value: _requestsPerDay,
                    min: 10,
                    max: 10000,
                    divisions: 100,
                    activeColor: const Color(0xFF0284C7),
                    onChanged: (val) => setState(() => _requestsPerDay = val),
                  ),
                  Text(
                    'Monthly total: ${(_requestsPerDay * 30).toInt()} API invocations.',
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Cache Hit Rate Slider
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Cache Hit Rate (5-min TTL)', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(
                        '${(_cacheHitRatio * 100).toInt()}%',
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                      ),
                    ],
                  ),
                  Slider(
                    value: _cacheHitRatio,
                    min: 0.1,
                    max: 0.99,
                    divisions: 89,
                    activeColor: Colors.green,
                    onChanged: (val) => setState(() => _cacheHitRatio = val),
                  ),
                  const Text(
                    'Higher hit rates occur when requests arrive within the 5-minute rolling window.',
                    style: TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Caching Implementation Rules
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFFEF3C7),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.amber.shade700.withAlpha(100)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.lightbulb_outline_rounded, color: Colors.amber.shade800, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Anthropic Caching Architectural Rules',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13.5,
                        color: Colors.amber.shade900,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  '• 5-Minute Rolling TTL: Every cache hit automatically refreshes the 5-minute expiration clock.\n'
                  '• Max 4 Breakpoints: Place `cache_control: {"type": "ephemeral"}` on up to 4 message blocks.\n'
                  '• Strict Ordering: Static content must precede dynamic user content to avoid busting the cache prefix.\n'
                  '• Minimum Sizes: 1,024 tokens on Sonnet/Opus; 2,048 tokens on Haiku.',
                  style: TextStyle(fontSize: 12, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricItem(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: color),
        ),
      ],
    );
  }
}

class _ModelPricing {
  final double baseInput;
  final double cacheWrite;
  final double cacheRead;
  final int minTokens;

  const _ModelPricing({
    required this.baseInput,
    required this.cacheWrite,
    required this.cacheRead,
    required this.minTokens,
  });
}
