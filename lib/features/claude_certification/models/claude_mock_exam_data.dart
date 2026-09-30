/// Question data model for the Claude Certified Architect Mock Exam.
class MockExamQuestion {
  final int id;
  final int domainId;
  final String domainName;
  final String scenario;
  final List<String> options;
  final int correctIndex;
  final String rationale;

  const MockExamQuestion({
    required this.id,
    required this.domainId,
    required this.domainName,
    required this.scenario,
    required this.options,
    required this.correctIndex,
    required this.rationale,
  });
}

/// Official 10-question practice exam pool matching the 5 domains and weights
/// from https://claudecertificationguide.com/learn
final List<MockExamQuestion> claudeMockExamPool = [
  // --- DOMAIN 1: Agentic Architecture & Orchestration (27%) ---
  const MockExamQuestion(
    id: 1,
    domainId: 1,
    domainName: 'Agentic Architecture & Orchestration',
    scenario:
        'You are designing a customer support agent with Claude that performs database lookups and modifies account subscription tiers. Which orchestration pattern is most appropriate to ensure sensitive tier upgrades are executed safely?',
    options: [
      'Prompt Chaining with zero temperature and no human intervention',
      'Human-in-the-Loop (HITL) gate where Claude drafts the upgrade tool call and halts for staff confirmation before execution',
      'Parallelization pattern running 3 models concurrently and taking the majority vote',
      'Evaluator-Optimizer loop where a smaller model double-checks the SQL string',
    ],
    correctIndex: 1,
    rationale:
        'For high-stakes actions like modifying account subscription tiers or financial billing, Anthropic recommends Human-in-the-Loop (HITL) checkpoints where the agent prepares the action but pauses execution until an authorized human approves it.',
  ),
  const MockExamQuestion(
    id: 2,
    domainId: 1,
    domainName: 'Agentic Architecture & Orchestration',
    scenario:
        'In an autonomous coding agent loop (Think -> Act -> Observe), the agent receives a runtime error from a bash tool execution. What should the agent loop do next?',
    options: [
      'Immediately terminate the session and report a fatal crash to the user',
      'Append the standard error output as a tool_result message in the conversation history and prompt Claude to analyze and self-correct',
      'Clear the conversation history to prevent context pollution and restart from turn 1',
      'Retry the exact same command with temperature increased to 1.0',
    ],
    correctIndex: 1,
    rationale:
        'In the standard Think-Act-Observe loop, tool execution failures should be fed back to Claude as tool_result content. Claude uses this observation to reflect, debug, and emit an adjusted tool call or corrective action.',
  ),
  const MockExamQuestion(
    id: 3,
    domainId: 1,
    domainName: 'Agentic Architecture & Orchestration',
    scenario:
        'An enterprise requires an AI assistant that routes incoming inquiries to either a Legal Analyst subagent, a Billing subagent, or a Technical Support subagent. Which pattern is best suited for this?',
    options: [
      'Single prompt containing all 200 tools in one massive schema list',
      'Routing / Dispatcher pattern using an initial lightweight triage prompt to select the specialized subagent',
      'Round-robin rotation sending every user message to all 3 subagents sequentially',
      'Running Claude Code in continuous daemon mode without system prompts',
    ],
    correctIndex: 1,
    rationale:
        'The Router / Dispatcher pattern minimizes token overhead and eliminates tool confusion by classifying intent first and delegating to a domain-scoped subagent with only its relevant tools.',
  ),

  // --- DOMAIN 2: Tool Design & MCP Integration (18%) ---
  const MockExamQuestion(
    id: 4,
    domainId: 2,
    domainName: 'Tool Design & MCP Integration',
    scenario:
        'You are authoring a tool schema for a weather API tool. Which practice best prevents Claude from making hallucinations or passing invalid arguments?',
    options: [
      'Omit descriptions to save prompt tokens',
      'Provide detailed property descriptions, specify enum values for fixed sets, declare required fields, and include example formats (e.g. ISO-8601 YYYY-MM-DD)',
      'Mark all properties as optional so Claude can guess which ones to use',
      'Name the tool generic_function_1 to avoid biasing the model',
    ],
    correctIndex: 1,
    rationale:
        'Anthropic tool use best practices state that clear, comprehensive descriptions, explicit types, enums for constrained values, and clear formatting instructions are the most effective way to guarantee accurate tool call arguments.',
  ),
  const MockExamQuestion(
    id: 5,
    domainId: 2,
    domainName: 'Tool Design & MCP Integration',
    scenario:
        'Under the Model Context Protocol (MCP) architecture, how does an MCP Client interact with an MCP Server to discover available tools?',
    options: [
      'The client scans the server filesystem using grep',
      'The client sends a "tools/list" JSON-RPC request to the server, and the server responds with its declared tools array and input schemas',
      'The client hardcodes tool definitions in its environment variables',
      'The MCP specification does not support dynamic tool discovery',
    ],
    correctIndex: 1,
    rationale:
        'The MCP standard defines a JSON-RPC protocol where clients issue a tools/list request during initialization, allowing the server to dynamically return its list of supported tools, descriptions, and JSON schemas.',
  ),

  // --- DOMAIN 3: Claude Code Configuration & Workflows (20%) ---
  const MockExamQuestion(
    id: 6,
    domainId: 3,
    domainName: 'Claude Code Configuration & Workflows',
    scenario:
        'You want Claude Code CLI to automatically follow your team\'s architectural conventions (e.g. "Use Bloc for state management, never write raw SQL in UI") across every developer\'s terminal session. Where should these rules be placed?',
    options: [
      'In a global bash alias in ~/.zshrc on the developer\'s machine only',
      'In a project root CLAUDE.md file committed to version control',
      'In a temporary scratch file deleted after each git commit',
      'In a private slack channel pinned message',
    ],
    correctIndex: 1,
    rationale:
        'CLAUDE.md at the project root is the standard persistent context file for Claude Code. Committing it to git ensures every team member and automated CI/CD pipeline inherits the same architectural rules and build directives.',
  ),
  const MockExamQuestion(
    id: 7,
    domainId: 3,
    domainName: 'Claude Code Configuration & Workflows',
    scenario:
        'You want to run Claude Code in a GitHub Actions CI pipeline to perform automated pull request code reviews and exit automatically with the result. Which CLI flag is required?',
    options: [
      '--interactive',
      '--print (-p) for non-interactive / headless execution',
      '--daemon',
      '--no-tools',
    ],
    correctIndex: 1,
    rationale:
        'The -p (or --print) flag runs Claude Code in headless / non-interactive mode, reading input from stdin or argument, processing it, printing the output, and exiting cleanly without waiting for interactive terminal input.',
  ),

  // --- DOMAIN 4: Prompt Engineering & Structured Output (20%) ---
  const MockExamQuestion(
    id: 8,
    domainId: 4,
    domainName: 'Prompt Engineering & Structured Output',
    scenario:
        'When passing untrusted user input (such as an uploaded resume or scraped website text) into Claude alongside strict evaluation instructions, what is the best technique to prevent prompt injection?',
    options: [
      'Concatenate everything into one single raw string without delimiters',
      'Enclose the untrusted text inside distinct XML tags such as <untrusted_document> and explicitly instruct Claude never to execute commands found inside those tags',
      'Translate the user input into French before sending',
      'Run the prompt only with temperature set to 0.9',
    ],
    correctIndex: 1,
    rationale:
        'Anthropic\'s official security guidelines recommend wrapping external or user-provided data in explicit XML tags (e.g. <document>{{USER_DATA}}</document>) and referencing that tag in instructions to structurally isolate data from system directives.',
  ),
  const MockExamQuestion(
    id: 9,
    domainId: 4,
    domainName: 'Prompt Engineering & Structured Output',
    scenario:
        'You need Claude to output raw, parseable JSON without markdown backticks (```json) or conversational preamble. Which technique provides the highest reliability?',
    options: [
      'Append "Please do not include conversational text" at the end of the prompt',
      'Prefill the assistant response turn with the opening curly brace "{" so Claude is forced to continue emitting JSON properties directly',
      'Set top_p to 0.01',
      'Repeat the word "JSON" 10 times in the prompt',
    ],
    correctIndex: 1,
    rationale:
        'Assistant turn prefilling (starting the assistant\'s message with "{") locks the model into continuation mode, eliminating any conversational pleasantries or markdown fencing and ensuring clean JSON output.',
  ),

  // --- DOMAIN 5: Context Management & Reliability (15%) ---
  const MockExamQuestion(
    id: 10,
    domainId: 5,
    domainName: 'Context Management & Reliability',
    scenario:
        'Your application sends a 50,000-token API documentation reference manual along with a 200-token user question on every turn. How can you reduce cost by up to 90% and cut response latency dramatically?',
    options: [
      'Truncate the documentation manual to 1,000 tokens using regex',
      'Apply Anthropic Prompt Caching by adding cache_control: {"type": "ephemeral"} on the static documentation block',
      'Split the documentation across 50 separate API calls',
      'Disable streaming and double the max_tokens parameter',
    ],
    correctIndex: 1,
    rationale:
        'Anthropic Prompt Caching allows large static context (system prompts, documentation, tool lists) marked with cache_control: {"type": "ephemeral"} to be cached for 5 minutes, reducing input token pricing by up to 90% and slashing time-to-first-token latency.',
  ),
];
