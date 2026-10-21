/// Data models for the iOS Senior & Lead Interview Preparation Hub.
/// Synthesized from `/Users/navneet/Documents/Prep`.
library;

/// Represents an Architectural Domain (from the 24 master domains).
class PrepDomain {
  final int id;
  final int domainNumber;
  final String title;
  final String emoji;
  final String description;
  final String tag;
  final List<DomainTopic> topics;
  final String? architecturalBlueprint;
  final List<String> keySignals;

  const PrepDomain({
    required this.id,
    required this.domainNumber,
    required this.title,
    required this.emoji,
    required this.description,
    required this.tag,
    required this.topics,
    this.architecturalBlueprint,
    this.keySignals = const [],
  });
}

/// Represents an in-depth topic inside an Architectural Domain.
class DomainTopic {
  final String title;
  final String definition;
  final String mechanics;
  final String? usesAndExamples;
  final String? codeSnippet;
  final String? wrongDoingsAndTraps;
  final List<DomainQuestion> questions;

  const DomainTopic({
    required this.title,
    required this.definition,
    required this.mechanics,
    this.usesAndExamples,
    this.codeSnippet,
    this.wrongDoingsAndTraps,
    this.questions = const [],
  });
}

/// A question/answer pair within a domain topic.
class DomainQuestion {
  final String question;
  final String answer;
  final String? seniorityLevel;

  const DomainQuestion({
    required this.question,
    required this.answer,
    this.seniorityLevel,
  });
}

/// Represents an interview question from the 89-Exam or Senior 100 Banks.
class ExamQuestion {
  final int id;
  final String question;
  final String answer;
  final String level; // 'Junior', 'Mid', 'Senior', 'Lead'
  final String category; // 'Swift Core', 'Concurrency', 'Architecture', 'Memory', 'System Design', 'Git', etc.
  final String? scenario;
  final String? codeSnippet;
  final String? keyTakeaway;

  const ExamQuestion({
    required this.id,
    required this.question,
    required this.answer,
    required this.level,
    required this.category,
    this.scenario,
    this.codeSnippet,
    this.keyTakeaway,
  });
}

/// Represents one of the 5 Mobile System Design Blueprints.
class SystemDesignBlueprint {
  final int id;
  final String title;
  final String subtitle;
  final String goal;
  final String asciiDiagram;
  final List<String> fivePhaseSteps;
  final List<String> keyDecisions;
  final String? codeSnippet;
  final String? failureModes;

  const SystemDesignBlueprint({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.goal,
    required this.asciiDiagram,
    required this.fivePhaseSteps,
    required this.keyDecisions,
    this.codeSnippet,
    this.failureModes,
  });
}

/// Enterprise production defense case studies.
class EnterpriseDefenseCase {
  final int id;
  final String title;
  final String interviewerTrap;
  final String solution;
  final String webhookTruth;
  final String codeSnippet;
  final List<String> technicalRules;

  const EnterpriseDefenseCase({
    required this.id,
    required this.title,
    required this.interviewerTrap,
    required this.solution,
    required this.webhookTruth,
    required this.codeSnippet,
    required this.technicalRules,
  });
}

/// Everyday Git scenario for engineering leads.
class GitScenario {
  final int id;
  final String title;
  final String category;
  final String command;
  final String explanation;
  final List<String> steps;

  const GitScenario({
    required this.id,
    required this.title,
    required this.category,
    required this.command,
    required this.explanation,
    required this.steps,
  });
}

/// Seniority level rubric entry (0–12+ Years).
class SeniorityBand {
  final String levelName;
  final String yoeBand;
  final String bandCode;
  final String coreFocus;
  final String roundExpectations;
  final String targetDepth;
  final String disqualifyingRedFlags;

  const SeniorityBand({
    required this.levelName,
    required this.yoeBand,
    required this.bandCode,
    required this.coreFocus,
    required this.roundExpectations,
    required this.targetDepth,
    required this.disqualifyingRedFlags,
  });
}

/// Represents one of the 16 Staff & Principal Architect Calibration Signals.
class StaffSignal {
  final int id;
  final String topic;
  final String category;
  final String strongSignal;
  final String weakSignal;
  final String? followUpQuestion;
  final String? followUpAnswer;

  const StaffSignal({
    required this.id,
    required this.topic,
    required this.category,
    required this.strongSignal,
    required this.weakSignal,
    this.followUpQuestion,
    this.followUpAnswer,
  });
}

/// Represents a defect in a code review scenario.
class CodeReviewDefect {
  final int index;
  final String title;
  final String priority; // 'P1 - Stability/Crash', 'P2 - Security/Privacy', 'P3 - Architecture'
  final String explanation;

  const CodeReviewDefect({
    required this.index,
    required this.title,
    required this.priority,
    required this.explanation,
  });
}

/// Senior/Staff Live Code Review & Refactoring simulation case.
class CodeReviewCase {
  final int id;
  final String title;
  final String submittedSnippet;
  final List<CodeReviewDefect> defects;
  final String structuredFeedback;
  final String productionRefactoredSnippet;

  const CodeReviewCase({
    required this.id,
    required this.title,
    required this.submittedSnippet,
    required this.defects,
    required this.structuredFeedback,
    required this.productionRefactoredSnippet,
  });
}

/// Staff & Lead Behavioral Crisis Management scenario.
class BehavioralCrisisScenario {
  final int id;
  final String title;
  final String scenario;
  final String actionStep1Title;
  final String actionStep1Content;
  final String actionStep2Title;
  final String actionStep2Content;
  final String actionStep3Title;
  final String actionStep3Content;

  const BehavioralCrisisScenario({
    required this.id,
    required this.title,
    required this.scenario,
    required this.actionStep1Title,
    required this.actionStep1Content,
    required this.actionStep2Title,
    required this.actionStep2Content,
    required this.actionStep3Title,
    required this.actionStep3Content,
  });
}

/// Represents an individual algorithmic approach with dedicated complexities and code.
class CodingApproach {
  final String title; // e.g. 'Approach 1: Brute Force (Nested Loops)'
  final String timeComplexity; // e.g. 'O(N^2)'
  final String spaceComplexity; // e.g. 'O(1)'
  final String explanation; // Mechanism and intuition
  final String code; // Concrete implementation code
  final String verdict; // Interviewer recommendation / performance trade-off

  const CodingApproach({
    required this.title,
    required this.timeComplexity,
    required this.spaceComplexity,
    required this.explanation,
    required this.code,
    required this.verdict,
  });
}

/// Represents a production iOS live coding problem / algorithm challenge.
class CodingChallenge {
  final int id;
  final String title;
  final String category; // 'Data Structures', 'Concurrency & Tasks', 'Memory & CoW', 'Algorithms', 'Architecture'
  final String difficulty; // 'Medium', 'Hard', 'Staff'
  final String timeComplexity;
  final String spaceComplexity;
  final String problemStatement;
  final String bruteForceApproach;
  final String optimizedApproach;
  final String swiftSolution;
  final List<String> edgeCases;
  final String interviewFollowUp;
  final List<CodingApproach> approaches;

  const CodingChallenge({
    required this.id,
    required this.title,
    required this.category,
    required this.difficulty,
    required this.timeComplexity,
    required this.spaceComplexity,
    required this.problemStatement,
    required this.bruteForceApproach,
    required this.optimizedApproach,
    required this.swiftSolution,
    required this.edgeCases,
    required this.interviewFollowUp,
    this.approaches = const [],
  });
}

/// Represents an advanced cutting-edge topic from the 2025-2026 encyclopedia.
class CuttingEdgeTopic {
  final int id;
  final String title;
  final String category; // 'Privacy & Security', 'Swift 6 & Toolchain', 'Persistence & Data', 'Profiling & Telemetry'
  final String description;
  final List<String> keyMechanics;
  final String? codeSnippet;
  final String seniorTakeaway;

  const CuttingEdgeTopic({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.keyMechanics,
    this.codeSnippet,
    required this.seniorTakeaway,
  });
}

/// Represents one of the 100 Senior iOS Engineer Interview Questions from the Master Bank.
class Senior100Question {
  final int id;
  final String question;
  final String category; // 'Architecture', 'Concurrency', 'Persistence', 'Performance', 'Security', 'Testing & CI/CD', 'Leadership'
  final List<String> bulletPoints;
  final String? scenario;
  final String? codeSnippet;

  const Senior100Question({
    required this.id,
    required this.question,
    required this.category,
    required this.bulletPoints,
    this.scenario,
    this.codeSnippet,
  });
}

/// Represents a topic card from the Master 26-Document Preparation Encyclopedia.
class PrepEncyclopediaTopic {
  final int id;
  final String part; // 'Part A: Shobhakar Tiwari & Foundation', 'Part B: Ruchit 2025 Series', etc.
  final String title;
  final String overview;
  final List<String> keyPoints;
  final String? codeSnippet;
  final String? interviewInsight;

  const PrepEncyclopediaTopic({
    required this.id,
    required this.part,
    required this.title,
    required this.overview,
    required this.keyPoints,
    this.codeSnippet,
    this.interviewInsight,
  });
}

/// Lead Interview Code Output Puzzle with tricky execution behavior.
class LeadOutputPuzzle {
  final int id;
  final String title;
  final String concept; // 'Floating Point / NaN', 'Copy-on-Write Pointers', 'GCD Queue Execution Order', 'In-Place Linked List'
  final String codeSnippet;
  final String expectedOutput;
  final String explanation;
  final String trapWarning;

  const LeadOutputPuzzle({
    required this.id,
    required this.title,
    required this.concept,
    required this.codeSnippet,
    required this.expectedOutput,
    required this.explanation,
    required this.trapWarning,
  });
}

/// 10 Landmark Benchmark Questions with calibrated answers across 4 seniority tiers.
class BenchmarkCalibration {
  final int id;
  final String question;
  final String coreCompetency;
  final String juniorAnswer;
  final String midAnswer;
  final String seniorAnswer;
  final String staffAnswer;
  final String interviewEvaluationGuide;

  const BenchmarkCalibration({
    required this.id,
    required this.question,
    required this.coreCompetency,
    required this.juniorAnswer,
    required this.midAnswer,
    required this.seniorAnswer,
    required this.staffAnswer,
    required this.interviewEvaluationGuide,
  });
}
