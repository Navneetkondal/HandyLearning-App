import 'dart:convert';
import 'package:flutter/material.dart';

/// Interactive Tool Calling Sandbox.
/// Demonstrates the full Anthropic tool lifecycle:
/// User Query -> Claude tool_use -> Client Execution -> tool_result -> Claude Synthesis.
class ClaudeToolSimulatorScreen extends StatefulWidget {
  const ClaudeToolSimulatorScreen({super.key});

  @override
  State<ClaudeToolSimulatorScreen> createState() => _ClaudeToolSimulatorScreenState();
}

class _ClaudeToolSimulatorScreenState extends State<ClaudeToolSimulatorScreen> {
  int _currentStep = 0;
  bool _simulateError = false;
  String _selectedTool = 'query_database';

  final Map<String, _ToolConfig> _tools = {
    'query_database': const _ToolConfig(
      name: 'query_database',
      description: 'Execute a read-only SQL query against the orders database.',
      userQuery: 'Find total revenue for customer ID 1042 in 2025.',
      inputSchema: {
        'type': 'object',
        'properties': {
          'sql': {
            'type': 'string',
            'description': 'The SELECT SQL statement to execute.'
          },
          'timeout_ms': {
            'type': 'integer',
            'description': 'Query execution timeout.'
          }
        },
        'required': ['sql']
      },
      toolUsePayload: {
        'id': 'toolu_01A9xK938fnk3',
        'name': 'query_database',
        'input': {
          'sql': 'SELECT SUM(total_amount) as revenue, COUNT(*) as orders_count FROM orders WHERE customer_id = 1042 AND strftime("%Y", created_at) = "2025";',
          'timeout_ms': 5000
        }
      },
      successOutput: {
        'rows': [
          {'revenue': 14850.50, 'orders_count': 18}
        ],
        'execution_ms': 14
      },
      errorOutput: {
        'error': 'OperationalError: column "created_at" does not exist. Available timestamp columns: ["order_timestamp", "fulfilled_at"].',
      },
      finalSuccessSynthesis: 'Customer 1042 generated a total revenue of **\$14,850.50** across **18 orders** during 2025.',
      finalErrorSynthesis: 'I encountered an error querying the orders table because column `created_at` does not exist. The schema indicates the timestamp column is `order_timestamp`. I will now re-execute with the corrected column name.',
    ),
    'fetch_weather': const _ToolConfig(
      name: 'fetch_weather',
      description: 'Retrieve real-time weather metrics for a geographic city.',
      userQuery: 'What is the current temperature and wind speed in Tokyo?',
      inputSchema: {
        'type': 'object',
        'properties': {
          'city': {'type': 'string', 'description': 'Target city name'},
          'units': {'type': 'string', 'enum': ['celsius', 'fahrenheit']}
        },
        'required': ['city']
      },
      toolUsePayload: {
        'id': 'toolu_01Wthr992kLa1',
        'name': 'fetch_weather',
        'input': {'city': 'Tokyo', 'units': 'celsius'}
      },
      successOutput: {
        'city': 'Tokyo',
        'temp_celsius': 18.5,
        'condition': 'Clear skies',
        'wind_kmh': 12.2,
        'humidity_percent': 48
      },
      errorOutput: {
        'error': 'API rate limit exceeded for weather station JP-TYO-01. Retry-After: 30s'
      },
      finalSuccessSynthesis: 'The current weather in Tokyo is **18.5°C** with **clear skies**, a humidity of 48%, and wind speeds of 12.2 km/h.',
      finalErrorSynthesis: 'The weather API returned a temporary rate limit error for the Tokyo station. Please retry in 30 seconds, or I can pull cached regional telemetry if preferred.',
    ),
  };

  void _reset() {
    setState(() {
      _currentStep = 0;
    });
  }

  void _nextStep() {
    if (_currentStep < 3) {
      setState(() => _currentStep++);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final tool = _tools[_selectedTool]!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Interactive Tool Simulator'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Reset Simulation',
            onPressed: _reset,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Tool Selector & Error Toggle Row
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: _selectedTool,
                  decoration: InputDecoration(
                    labelText: 'Select Demo Tool',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  items: _tools.keys.map((k) {
                    return DropdownMenuItem(value: k, child: Text(k));
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        _selectedTool = val;
                        _currentStep = 0;
                      });
                    }
                  },
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text('Simulate Error', style: TextStyle(fontSize: 11, color: Colors.grey)),
                  Switch(
                    value: _simulateError,
                    activeThumbColor: Colors.red,
                    onChanged: (val) {
                      setState(() => _simulateError = val);
                    },
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Stepper Header
          Row(
            children: [
              _buildStepIndicator(0, '1. Prompt'),
              _buildStepLine(0),
              _buildStepIndicator(1, '2. tool_use'),
              _buildStepLine(1),
              _buildStepIndicator(2, '3. Execute'),
              _buildStepLine(2),
              _buildStepIndicator(3, '4. Result'),
            ],
          ),

          const SizedBox(height: 20),

          // STEP 0: USER PROMPT & SCHEMA
          if (_currentStep >= 0) ...[
            _buildCardHeader('Step 1: User Request & Tool Definition', Icons.chat_bubble_outline_rounded, const Color(0xFF2563EB)),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('User Prompt:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey)),
                    const SizedBox(height: 4),
                    Text(tool.userQuery, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    const SizedBox(height: 12),
                    const Text('Registered Tool Schema (input_schema):', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey)),
                    const SizedBox(height: 4),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        const JsonEncoder.withIndent('  ').convert(tool.inputSchema),
                        style: const TextStyle(fontFamily: 'monospace', fontSize: 11.5),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],

          // STEP 1: CLAUDE TOOL_USE DECISION
          if (_currentStep >= 1) ...[
            const SizedBox(height: 16),
            _buildCardHeader('Step 2: Claude Returns `stop_reason: tool_use`', Icons.smart_toy_rounded, const Color(0xFFD97706)),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Claude Decided to Call Tool:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey)),
                    const SizedBox(height: 6),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        const JsonEncoder.withIndent('  ').convert({
                          'type': 'tool_use',
                          'id': tool.toolUsePayload['id'],
                          'name': tool.toolUsePayload['name'],
                          'input': tool.toolUsePayload['input']
                        }),
                        style: const TextStyle(fontFamily: 'monospace', fontSize: 11.5, color: Color(0xFFD97706)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],

          // STEP 2: CLIENT EXECUTION & TOOL RESULT
          if (_currentStep >= 2) ...[
            const SizedBox(height: 16),
            _buildCardHeader(
              _simulateError ? 'Step 3: Client Tool Error (`is_error: true`)' : 'Step 3: Client Tool Result Returned',
              _simulateError ? Icons.error_outline_rounded : Icons.check_circle_outline_rounded,
              _simulateError ? Colors.red : Colors.green,
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _simulateError ? 'Client Handled Error Payload:' : 'Client Tool Execution Output:',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        const JsonEncoder.withIndent('  ').convert({
                          'type': 'tool_result',
                          'tool_use_id': tool.toolUsePayload['id'],
                          'content': jsonEncode(_simulateError ? tool.errorOutput : tool.successOutput),
                          if (_simulateError) 'is_error': true,
                        }),
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 11.5,
                          color: _simulateError ? Colors.red : Colors.green,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],

          // STEP 3: FINAL SYNTHESIS
          if (_currentStep >= 3) ...[
            const SizedBox(height: 16),
            _buildCardHeader('Step 4: Claude Final Synthesized Output', Icons.auto_awesome_rounded, const Color(0xFF8B5CF6)),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('End-User Response:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey)),
                    const SizedBox(height: 6),
                    Text(
                      _simulateError ? tool.finalErrorSynthesis : tool.finalSuccessSynthesis,
                      style: const TextStyle(fontSize: 14.5, height: 1.4),
                    ),
                  ],
                ),
              ),
            ),
          ],

          const SizedBox(height: 24),

          // Next Step Button
          if (_currentStep < 3)
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD97706),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: _nextStep,
              icon: const Icon(Icons.play_arrow_rounded),
              label: Text(
                _currentStep == 0
                    ? 'Step 2: Simulate Claude Call'
                    : (_currentStep == 1 ? 'Step 3: Execute Local Function' : 'Step 4: Synthesize Final Answer'),
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            )
          else
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.all(14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: _reset,
              icon: const Icon(Icons.replay_rounded),
              label: const Text('Restart Interactive Simulation', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
        ],
      ),
    );
  }

  Widget _buildStepIndicator(int stepIndex, String title) {
    final isDone = _currentStep > stepIndex;
    final isCurrent = _currentStep == stepIndex;

    Color color = Colors.grey.shade400;
    if (isDone) color = Colors.green;
    if (isCurrent) color = const Color(0xFFD97706);

    return Column(
      children: [
        CircleAvatar(
          radius: 12,
          backgroundColor: color,
          child: Text(
            '${stepIndex + 1}',
            style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 4),
        Text(title, style: TextStyle(fontSize: 10, color: color, fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal)),
      ],
    );
  }

  Widget _buildStepLine(int afterStepIndex) {
    final isPassed = _currentStep > afterStepIndex;
    return Expanded(
      child: Container(
        height: 2,
        color: isPassed ? Colors.green : Colors.grey.shade300,
        margin: const EdgeInsets.only(bottom: 14),
      ),
    );
  }

  Widget _buildCardHeader(String title, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5, color: color),
            ),
          ),
        ],
      ),
    );
  }
}

class _ToolConfig {
  final String name;
  final String description;
  final String userQuery;
  final Map<String, dynamic> inputSchema;
  final Map<String, dynamic> toolUsePayload;
  final Map<String, dynamic> successOutput;
  final Map<String, dynamic> errorOutput;
  final String finalSuccessSynthesis;
  final String finalErrorSynthesis;

  const _ToolConfig({
    required this.name,
    required this.description,
    required this.userQuery,
    required this.inputSchema,
    required this.toolUsePayload,
    required this.successOutput,
    required this.errorOutput,
    required this.finalSuccessSynthesis,
    required this.finalErrorSynthesis,
  });
}
