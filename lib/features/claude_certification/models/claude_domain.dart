import 'package:flutter/material.dart';

/// Model representing an Exam Domain in the Claude Certified Architect (Foundations) curriculum.
/// Based on https://claudecertificationguide.com/learn
class ClaudeDomain {
  final int id;
  final String title;
  final int weightPercentage;
  final int moduleCount;
  final String description;
  final IconData icon;
  final Color color;
  final List<String> coreTopics;
  final List<String> examChecklist;
  final String codeExample;
  final List<ClaudeExamQuestion> sampleQuestions;

  const ClaudeDomain({
    required this.id,
    required this.title,
    required this.weightPercentage,
    required this.moduleCount,
    required this.description,
    required this.icon,
    required this.color,
    required this.coreTopics,
    required this.examChecklist,
    required this.codeExample,
    required this.sampleQuestions,
  });
}

class ClaudeExamQuestion {
  final String question;
  final List<String> options;
  final int correctIndex;
  final String rationale;

  const ClaudeExamQuestion({
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.rationale,
  });
}

/// Official 5 Domains of the Claude Certified Architect Exam
final List<ClaudeDomain> claudeExamDomains = [
  const ClaudeDomain(
    id: 1,
    title: 'Agentic Architecture & Orchestration',
    weightPercentage: 27,
    moduleCount: 7,
    description:
        'Design and implement autonomous agentic systems using Claude API, agent loops, routing patterns, multi-agent hierarchies, and the Claude Agent SDK.',
    icon: Icons.account_tree_rounded,
    color: Color(0xFFD97706),
    coreTopics: [
      'The Core Agent Loop: Think -> Act -> Observe -> Repeat',
      'Orchestration Workflows: Prompt Chaining, Routing, Parallelization, Evaluator-Optimizer',
      'Multi-Agent Hierarchies: Supervisor/Subagent delegation and handoffs',
      'Guardrails & Human-in-the-Loop (HITL) checkpoints',
      'State persistence & conversation memory across turns',
    ],
    examChecklist: [
      'Know when to use single-turn prompting vs agentic iterative loops',
      'Understand how to safely handle non-terminating loops with max iteration limits',
      'Know how to route user intents to specialized subagents',
      'Be able to implement validation loops using evaluator-optimizer pattern',
    ],
    codeExample: '''// Agent Loop Pattern (Pseudocode / Anthropic SDK)
while (iterations < MAX_ITERATIONS) {
  final response = await claude.messages.create({
    model: "claude-3-7-sonnet-20250219",
    messages: history,
    tools: availableTools,
  });

  if (response.stop_reason == "tool_use") {
    final toolResult = await executeTool(response.tool_calls);
    history.addToolResult(toolResult);
  } else {
    return response.content; // Final synthesized answer
  }
}''',
    sampleQuestions: [
      ClaudeExamQuestion(
        question:
            'When designing an autonomous agent system, what is the most robust safeguard against infinite execution loops caused by ambiguous tool outputs?',
        options: [
          'Set a low temperature parameter of 0.0',
          'Enforce a strict maximum iteration counter and budget timeout with a graceful fallback',
          'Disable multi-turn conversation history after 3 turns',
          'Always use Claude 3 Haiku instead of Claude 3.7 Sonnet',
        ],
        correctIndex: 1,
        rationale:
            'Enforcing hard iteration caps and execution timeouts ensures deterministic termination and prevents unbounded API costs or runaway agent loops.',
      ),
    ],
  ),
  const ClaudeDomain(
    id: 2,
    title: 'Tool Design & MCP Integration',
    weightPercentage: 18,
    moduleCount: 5,
    description:
        'Design effective tool schemas, implement Model Context Protocol (MCP) servers and clients, and integrate external services securely into Claude applications.',
    icon: Icons.integration_instructions_rounded,
    color: Color(0xFF2563EB),
    coreTopics: [
      'JSON Schema definition: Strict parameter types, descriptions, and required fields',
      'Model Context Protocol (MCP) architecture: Host, Client, and Server specifications',
      'MCP Primitives: Resources, Prompts, and Tools',
      'Tool Execution Security: Sandboxing, permission scoping, and confirmation prompts',
      'Error Handling in Tools: Providing clear actionable error strings back to Claude',
    ],
    examChecklist: [
      'Write clear, descriptive parameter descriptions so Claude knows when and how to call tools',
      'Differentiate between MCP Resources (read-only URI data) and MCP Tools (executable actions)',
      'Handle sensitive tool calls (e.g. database deletes, refunds) with explicit user approval',
    ],
    codeExample: '''// MCP Tool Schema Definition
{
  "name": "lookup_customer_order",
  "description": "Fetches order status and shipping tracking by order ID",
  "parameters": {
    "type": "object",
    "properties": {
      "order_id": {
        "type": "string",
        "description": "The 8-character alphanumeric order ID (e.g. ORD-9812)"
      }
    },
    "required": ["order_id"]
  }
}''',
    sampleQuestions: [
      ClaudeExamQuestion(
        question:
            'In the Model Context Protocol (MCP) specification, what is the architectural difference between a Resource and a Tool?',
        options: [
          'Resources are executable code; Tools are passive configuration files',
          'Resources provide read-only context/data identified by URI; Tools perform actions or computations with side effects',
          'Tools only run on local machines; Resources only run in cloud containers',
          'There is no difference; they are synonymous terms in the MCP spec',
        ],
        correctIndex: 1,
        rationale:
            'In MCP, Resources represent readable contextual data addressed by URI schemes (like files or database rows), whereas Tools are executable callable functions that can perform side-effects.',
      ),
    ],
  ),
  const ClaudeDomain(
    id: 3,
    title: 'Claude Code Configuration & Workflows',
    weightPercentage: 20,
    moduleCount: 6,
    description:
        'Configure Claude Code CLI for development workflows, manage project settings, CLAUDE.md memory guidelines, hooks, permissions, and CI/CD pipelines.',
    icon: Icons.terminal_rounded,
    color: Color(0xFF059669),
    coreTopics: [
      'CLAUDE.md Memory File: Architectural conventions, build commands, and rules',
      'Configuration Scopes: Global (~/.claude.json) vs Project-level configuration',
      'Hooks & Slash Commands: Custom script automation and workflow shortcuts',
      'Permission Model: Auto-approve rules, interactive prompts, and safe directory sandboxing',
      'Headless CI/CD: Automated PR reviews, linting, and smoke tests using Claude Code CLI',
    ],
    examChecklist: [
      'Organize CLAUDE.md with concise, high-signal instructions rather than repetitive noise',
      'Use headless flag (-p / --print) for scripted and automated pipeline executions',
      'Configure .claudeignore to exclude huge binaries, dist folders, and secrets',
    ],
    codeExample: '''# CLAUDE.md - Project Guidelines
## Build & Test Commands
- Build: `flutter build apk --release`
- Test: `flutter test`
- Analyze: `flutter analyze`

## Architectural Directives
- Always follow Clean Architecture: UI -> Cubit -> Repository -> DataSource
- Ensure zero warnings on `flutter analyze`
- Support both Light and Dark mode tokens''',
    sampleQuestions: [
      ClaudeExamQuestion(
        question:
            'What is the primary purpose of a project-level CLAUDE.md file when working with Claude Code?',
        options: [
          'To store secret API keys for automated authorization',
          'To provide persistent project context, build commands, coding standards, and architectural rules across sessions',
          'To compile Dart and TypeScript code directly into machine binaries',
          'To override the Anthropic foundation model weights locally',
        ],
        correctIndex: 1,
        rationale:
            'CLAUDE.md acts as persistent working memory for Claude Code, instructing the agent on project-specific commands, conventions, architectures, and testing requirements.',
      ),
    ],
  ),
  const ClaudeDomain(
    id: 4,
    title: 'Prompt Engineering & Structured Output',
    weightPercentage: 20,
    moduleCount: 6,
    description:
        'Craft effective prompts, implement structured JSON output patterns, leverage XML tags, and apply advanced prompting strategies for production systems.',
    icon: Icons.psychology_alt_rounded,
    color: Color(0xFF7C3AED),
    coreTopics: [
      'XML Tag Architecture: <instructions>, <context>, <examples>, <input>',
      'Role & Persona Prompting: Establishing domain expertise and operational tone',
      'Few-Shot Prompting: Providing high-signal input/output exemplar pairs',
      'Structured Outputs: Enforcing JSON schemas and prefilling assistant responses',
      'Chain-of-Thought (CoT): <thinking> tags for complex multi-step reasoning',
    ],
    examChecklist: [
      'Use XML tags to clearly separate instructions from untrusted user input (prevents prompt injection)',
      'Use response prefilling (e.g. starting assistant turn with "{" or "[" to force valid JSON)',
      'Provide negative constraints clearly: "Do NOT do X, instead do Y"',
    ],
    codeExample: '''// XML Tagged Production Prompt Structure
You are a senior code review architect.

<instructions>
Review the code for memory leaks, architectural coupling, and race conditions.
Format your final analysis inside valid JSON.
</instructions>

<context>
Project uses Flutter 3.x with flutter_bloc and Clean Architecture.
</context>

<code>
{{SOURCE_CODE}}
</code>''',
    sampleQuestions: [
      ClaudeExamQuestion(
        question:
            'Why does Anthropic recommend using XML tags (e.g. <context>, <instructions>) when prompting Claude?',
        options: [
          'Because Claude was exclusively trained on HTML documents',
          'XML tags clearly delineate instructions from untrusted user data, improving adherence and mitigating prompt injection',
          'XML tags reduce input token consumption by 50%',
          'XML tags are required by the JSON schema validator',
        ],
        correctIndex: 1,
        rationale:
            'Claude is fine-tuned to recognize XML tag boundaries, making it exceptionally reliable at distinguishing system instructions from user-provided content and preventing prompt injection.',
      ),
    ],
  ),
  const ClaudeDomain(
    id: 5,
    title: 'Context Management & Reliability',
    weightPercentage: 15,
    moduleCount: 6,
    description:
        'Manage context windows effectively, implement prompt caching strategies, handle long conversations, and build resilient, cost-effective production systems.',
    icon: Icons.memory_rounded,
    color: Color(0xFF0284C7),
    coreTopics: [
      'Prompt Caching: Breakpoints (cache_control: {"type": "ephemeral"}) for up to 90% cost & latency reduction',
      '200K Context Window Architecture: Token budgets and placement of critical instructions',
      'Context Compaction: Summarizing older conversational turns while preserving working memory',
      'Reliability & Fallbacks: Rate-limit backoffs, retries, and secondary model failover',
      'Evaluation & Benchmarks: Unit testing prompts against golden datasets',
    ],
    examChecklist: [
      'Place static context (system prompt, tool definitions, documentation) at the top before cache breakpoints',
      'Cache lifetime is 5 minutes from last request; refreshing it resets the TTL',
      'Keep dynamic, frequently-changing user input at the bottom of the prompt to maximize cache hits',
    ],
    codeExample: '''// Anthropic Prompt Caching Breakpoint
final systemPrompt = [
  {
    "type": "text",
    "text": largeCodebaseDocumentation,
    "cache_control": {"type": "ephemeral"} // Cache breakpoint!
  }
];''',
    sampleQuestions: [
      ClaudeExamQuestion(
        question:
            'To maximize prompt cache hit rates when using Anthropic Prompt Caching, how should you structure your API request?',
        options: [
          'Place frequently changing user messages at the very beginning of the prompt',
          'Place static content (system prompt, large reference docs, tool schemas) first with cache_control breakpoints, and dynamic user inputs at the end',
          'Disable streaming responses on all requests',
          'Set temperature to 1.0 on every cached call',
        ],
        correctIndex: 1,
        rationale:
            'Prompt caching matches prompt prefixes from the start. Placing static content first allows subsequent requests to reuse the cached prefix while appending dynamic user messages at the end.',
      ),
    ],
  ),
];
