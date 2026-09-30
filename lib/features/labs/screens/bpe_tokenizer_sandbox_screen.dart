import 'package:flutter/material.dart';

/// Interactive Sandbox for exploring Byte-Pair Encoding (BPE), subword tokenization,
/// context window capacity, and token economics for Claude 3.7 and modern LLMs.
class BpeTokenizerSandboxScreen extends StatefulWidget {
  const BpeTokenizerSandboxScreen({super.key});

  @override
  State<BpeTokenizerSandboxScreen> createState() => _BpeTokenizerSandboxScreenState();
}

class _BpeTokenizerSandboxScreenState extends State<BpeTokenizerSandboxScreen> {
  final TextEditingController _textController = TextEditingController(
    text: 'Claude 3.7 Sonnet processes 200,000 tokens with extended thinking and subagent swarms!',
  );

  String _selectedModel = 'Claude 3.7 Sonnet (200k)';
  final List<String> _models = [
    'Claude 3.7 Sonnet (200k)',
    'Claude 3.5 Haiku (200k)',
    'Claude 3 Opus (200k)',
    'GPT-4o (128k)',
  ];

  // Token color palette for distinct token highlighting
  static const List<Color> _tokenColors = [
    Color(0xFF6366F1), // Indigo
    Color(0xFF0284C7), // Sky
    Color(0xFF10B981), // Emerald
    Color(0xFFD97706), // Amber
    Color(0xFFEC4899), // Pink
    Color(0xFF8B5CF6), // Purple
    Color(0xFF14B8A6), // Teal
    Color(0xFFF97316), // Orange
  ];

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  /// Simulates Byte-Pair Encoding subword tokenization rules
  List<String> _tokenize(String text) {
    if (text.isEmpty) return [];

    final tokens = <String>[];
    // Regex matches common subword boundaries: words, numbers, punctuation, spaces
    final regex = RegExp(r"([A-Za-z]+|\d+|[^\s\w]|\s+)");
    final matches = regex.allMatches(text);

    for (final match in matches) {
      final chunk = match.group(0)!;
      // If a word is long (> 6 chars), simulate BPE split into subwords
      if (chunk.trim().length > 6 && !chunk.contains(' ')) {
        final mid = (chunk.length / 2).ceil();
        tokens.add(chunk.substring(0, mid));
        tokens.add(chunk.substring(mid));
      } else {
        tokens.add(chunk);
      }
    }
    return tokens;
  }

  double _calculateInputCost(int tokenCount) {
    switch (_selectedModel) {
      case 'Claude 3.7 Sonnet (200k)':
        return (tokenCount / 1000000.0) * 3.00; // $3.00 per MTok
      case 'Claude 3.5 Haiku (200k)':
        return (tokenCount / 1000000.0) * 0.80; // $0.80 per MTok
      case 'Claude 3 Opus (200k)':
        return (tokenCount / 1000000.0) * 15.00; // $15.00 per MTok
      case 'GPT-4o (128k)':
        return (tokenCount / 1000000.0) * 2.50; // $2.50 per MTok
      default:
        return (tokenCount / 1000000.0) * 3.00;
    }
  }

  double _calculateCachedCost(int tokenCount) {
    switch (_selectedModel) {
      case 'Claude 3.7 Sonnet (200k)':
        return (tokenCount / 1000000.0) * 0.30; // $0.30 per MTok (90% discount)
      case 'Claude 3.5 Haiku (200k)':
        return (tokenCount / 1000000.0) * 0.08;
      case 'Claude 3 Opus (200k)':
        return (tokenCount / 1000000.0) * 1.50;
      default:
        return (tokenCount / 1000000.0) * 0.30;
    }
  }

  int _getMaxContext() {
    if (_selectedModel.contains('128k')) return 128000;
    return 200000;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final text = _textController.text;
    final tokens = _tokenize(text);
    final charCount = text.length;
    final tokenCount = tokens.length;
    final maxContext = _getMaxContext();
    final contextPercent = maxContext > 0 ? (tokenCount / maxContext) : 0.0;
    final compressionRatio = tokenCount > 0 ? (charCount / tokenCount) : 0.0;
    final standardCost = _calculateInputCost(tokenCount);
    final cachedCost = _calculateCachedCost(tokenCount);

    return Scaffold(
      appBar: AppBar(
        title: const Text('BPE Tokenizer & Context Lab'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Reset sample text',
            onPressed: () {
              setState(() {
                _textController.text =
                    'Claude 3.7 Sonnet processes 200,000 tokens with extended thinking and subagent swarms!';
              });
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Header Card
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [const Color(0xFF1E1B4B), const Color(0xFF0F172A)]
                    : [const Color(0xFF6366F1), const Color(0xFF4338CA)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF6366F1).withAlpha(50),
                  blurRadius: 14,
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
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(40),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.token_rounded, color: Colors.white, size: 22),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Byte-Pair Encoding (BPE) & Context',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Visualizing subwords, tokens, context utilization & token costs',
                            style: TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  'LLMs do not read characters or full words — they process tokens created via greedy statistical merges (BPE). 1 token ≈ 4 English characters (0.75 words).',
                  style: TextStyle(color: Colors.white, fontSize: 12.5, height: 1.4),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Model Selector & Preset Buttons
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 0,
            color: isDark ? const Color(0xFF1E293B) : Colors.grey.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Row(
                  children: [
                    const Icon(Icons.tune_rounded, size: 20, color: Color(0xFF6366F1)),
                    const SizedBox(width: 8),
                    const Text('Target LLM Architecture', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    const Spacer(),
                    DropdownButton<String>(
                      value: _selectedModel,
                      underline: const SizedBox(),
                      borderRadius: BorderRadius.circular(12),
                      items: _models.map((m) {
                        return DropdownMenuItem(value: m, child: Text(m, style: const TextStyle(fontSize: 13)));
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedModel = val);
                      },
                    ),
                  ],
                ),
                const Divider(height: 20),
                const Text('Quick Presets:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    _presetChip('Python Code', 'def backprop(grads, lr=0.01):\n    for p, g in zip(params, grads):\n        p -= lr * g'),
                    _presetChip('JSON Schema', '{"name": "get_stock_price", "parameters": {"ticker": "AAPL", "currency": "USD"}}'),
                    _presetChip('Math Equation', 'Attention(Q, K, V) = softmax((Q * K^T) / sqrt(d_k)) * V'),
                    _presetChip('Multilingual', 'Bonjour le monde! こんにちは世界! नमस्ते दुनिया! 🚀'),
                  ],
                ),
              ],
            ),
          ),
        ),

          const SizedBox(height: 16),

          // Text Input Box
          TextField(
            controller: _textController,
            maxLines: 4,
            style: const TextStyle(fontSize: 14, fontFamily: 'monospace'),
            decoration: InputDecoration(
              labelText: 'Enter Text / Code / Prompt to Tokenize',
              hintText: 'Type or paste content here...',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
              prefixIcon: const Icon(Icons.edit_note_rounded),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear_rounded),
                onPressed: () => setState(() => _textController.clear()),
              ),
            ),
            onChanged: (_) => setState(() {}),
          ),

          const SizedBox(height: 16),

          // Live Stats Dashboard (Tokens, Chars, Ratio, Context)
          Row(
            children: [
              Expanded(
                child: _metricCard(
                  'Tokens',
                  '$tokenCount',
                  Icons.tag_rounded,
                  const Color(0xFF6366F1),
                  isDark,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _metricCard(
                  'Characters',
                  '$charCount',
                  Icons.text_fields_rounded,
                  const Color(0xFF0284C7),
                  isDark,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _metricCard(
                  'Chars/Token',
                  compressionRatio.toStringAsFixed(1),
                  Icons.compress_rounded,
                  const Color(0xFF10B981),
                  isDark,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Context Window Utilization Bar
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.grey.withAlpha(50)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Context Window Utilization (${_selectedModel.split(' ').first})',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '$tokenCount / $maxContext tokens (${(contextPercent * 100).toStringAsFixed(3)}%)',
                      style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: (contextPercent > 1.0 ? 1.0 : contextPercent).clamp(0.001, 1.0),
                    minHeight: 10,
                    backgroundColor: isDark ? Colors.black38 : Colors.grey.shade200,
                    valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF6366F1)),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Pricing & Prompt Caching Cost Breakdown
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [const Color(0xFF1B2E24), const Color(0xFF14241C)]
                    : [const Color(0xFFECFDF5), const Color(0xFFD1FAE5)],
              ),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFF10B981).withAlpha(100)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withAlpha(30),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.attach_money_rounded, color: Color(0xFF059669), size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Token Cost Estimation',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF047857)),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Standard Input: \$${standardCost.toStringAsFixed(6)} • With Prompt Caching (90% off): \$${cachedCost.toStringAsFixed(6)}',
                        style: TextStyle(
                          fontSize: 11.5,
                          color: isDark ? Colors.grey.shade300 : const Color(0xFF065F46),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Visualized Token Stream (Colored Chips)
          Row(
            children: [
              const Icon(Icons.view_array_rounded, size: 20, color: Color(0xFF6366F1)),
              const SizedBox(width: 8),
              const Text('Visualized Subword Token Stream', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              const Spacer(),
              Text('${tokens.length} chunks', style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 10),

          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0F172A) : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.grey.withAlpha(50)),
            ),
            child: tokens.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Text('Type text above to view token segmentation'),
                    ),
                  )
                : Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: List.generate(tokens.length, (index) {
                      final token = tokens[index];
                      final color = _tokenColors[index % _tokenColors.length];
                      final displayToken = token.replaceAll(' ', '·').replaceAll('\n', '↵\n');

                      return Tooltip(
                        message: 'Token #$index\nString: "$token"\nLength: ${token.length} chars\nByte length: ${token.codeUnits.length} bytes',
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: color.withAlpha(isDark ? 45 : 30),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: color.withAlpha(120), width: 1),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                displayToken,
                                style: TextStyle(
                                  fontFamily: 'monospace',
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? color.withAlpha(240) : color,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '$index',
                                style: TextStyle(
                                  fontSize: 9,
                                  color: isDark ? Colors.white38 : Colors.black38,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
          ),

          const SizedBox(height: 20),

          // Educational Concept Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.grey.withAlpha(60)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.lightbulb_outline_rounded, color: Color(0xFFF59E0B), size: 20),
                    SizedBox(width: 8),
                    Text('Core BPE Tokenizer Rules to Remember', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5)),
                  ],
                ),
                const SizedBox(height: 10),
                _bulletRule(
                  'Subword Decomposition',
                  'Rare words or names ("Backpropagation", "Navneet") are sliced into recurring fragments ("Back", "prop", "agation") to handle infinite vocabulary with finite ~100k token dictionaries.',
                ),
                _bulletRule(
                  'Spaces Belong to Tokens',
                  'In modern BPE tokenizers (like Claude\'s or tiktoken), leading spaces (rendered as "·" above) are attached to the subsequent token. " Apple" is token #1, while "Apple" (no space) is token #2!',
                ),
                _bulletRule(
                  'Arithmetic & Code Tokenization',
                  'Numbers ("12345") and code punctuation ("{}:,") are often chunked differently. Numbers may be split into 1-2 digits, which is why pure LLMs struggle with multi-digit math without extended thinking.',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _presetChip(String label, String sample) {
    return ActionChip(
      label: Text(label, style: const TextStyle(fontSize: 11)),
      onPressed: () {
        setState(() => _textController.text = sample);
      },
    );
  }

  Widget _metricCard(String title, String value, IconData icon, Color color, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withAlpha(60), width: 1.2),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: color),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: const TextStyle(fontSize: 11, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _bulletRule(String title, String explanation) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF6366F1))),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 12, height: 1.4, color: Colors.grey),
                children: [
                  TextSpan(
                    text: '$title: ',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey),
                  ),
                  TextSpan(text: explanation),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
