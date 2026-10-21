/// Hierarchical Data Models for the iOS Senior & Lead Preparation Platform.
/// Enforces the strict learning progression:
/// Domain → Modules → Topics → Subtopics → Mechanics → Code → Trade-offs → Production Use → Common Mistakes → Interview Traps → Q&A → Practice → Mastery.
library;

/// Progress Status enum matching the requested representation:
/// ○ Not Started, ◐ In Progress, ✓ Completed, ★ Mastered
enum TopicMasteryStatus {
  notStarted,
  inProgress,
  completed,
  mastered;

  String get symbol {
    switch (this) {
      case TopicMasteryStatus.notStarted:
        return '○';
      case TopicMasteryStatus.inProgress:
        return '◐';
      case TopicMasteryStatus.completed:
        return '✓';
      case TopicMasteryStatus.mastered:
        return '★';
    }
  }

  String get label {
    switch (this) {
      case TopicMasteryStatus.notStarted:
        return 'Not Started';
      case TopicMasteryStatus.inProgress:
        return 'In Progress';
      case TopicMasteryStatus.completed:
        return 'Completed';
      case TopicMasteryStatus.mastered:
        return 'Mastered';
    }
  }
}

/// A Master Architectural Domain (1 of 24)
class PrepDomainHierarchy {
  final int id;
  final int domainNumber;
  final String title;
  final String emoji;
  final String tag;
  final String difficulty; // 'Core', 'Intermediate', 'Advanced', 'Staff'
  final String description;
  final String architecturalTreatise;
  final List<DomainModule> modules;
  final List<String> staffSignals;

  const PrepDomainHierarchy({
    required this.id,
    required this.domainNumber,
    required this.title,
    required this.emoji,
    required this.tag,
    required this.difficulty,
    required this.description,
    required this.architecturalTreatise,
    required this.modules,
    this.staffSignals = const [],
  });

  int get totalTopics => modules.fold(0, (sum, m) => sum + m.topics.length);
  int get totalQuestions => modules.fold(0, (sum, m) => sum + m.topics.fold(0, (s2, t) => s2 + t.interviewQuestions.length));
}

/// A Module inside a Domain (groups 3-6 cohesive topics)
class DomainModule {
  final String id;
  final String title;
  final String description;
  final List<MasterTopic> topics;

  const DomainModule({
    required this.id,
    required this.title,
    required this.description,
    required this.topics,
  });

  int get totalQuestions => topics.fold(0, (s, t) => s + t.interviewQuestions.length);
}

/// Standardized 14-section Master Topic
class MasterTopic {
  final String id;
  final String domainId;
  final String title;
  final String difficulty; // 'Junior', 'Mid', 'Senior', 'Staff', 'Expert'
  final int estimatedMinutes;
  
  // 1. Quick Answer (2-4 sentences)
  final String quickAnswer;

  // 2. Why It Matters
  final String whyItMatters;

  // 3. Mental Model (ASCII diagram / visual)
  final String mentalModel;

  // 4. How It Works (Step-by-step internal mechanics)
  final List<String> howItWorksSteps;

  // 5. Swift Code (Minimal + Production Swift 6)
  final String minimalCode;
  final String productionCode;

  // 6. Under The Hood (Compiler/runtime, witness tables, memory, ABI, LLVM)
  final String underTheHood;

  // 7. Production Example (Real iOS architecture context)
  final String productionExample;

  // 8. Trade-offs (Performance, Memory, Maintainability, Testability, Flexibility, Complexity)
  final TopicTradeoffs tradeoffs;

  // 9. Common Mistakes (Bad code vs Good code + explanation)
  final List<TopicMistake> commonMistakes;

  // 10. Interview Traps (Common traps where candidates fail)
  final List<String> interviewTraps;

  // 11. Senior Interview Questions
  final List<TopicInterviewQuestion> interviewQuestions;

  // 12. Quick Revision (5-10 bullets)
  final List<String> quickRevision;

  // 13. Practice Task
  final String practicePrompt;
  final String practiceHint;
  final String practiceSolution;

  const MasterTopic({
    required this.id,
    required this.domainId,
    required this.title,
    required this.difficulty,
    this.estimatedMinutes = 15,
    required this.quickAnswer,
    required this.whyItMatters,
    required this.mentalModel,
    required this.howItWorksSteps,
    required this.minimalCode,
    required this.productionCode,
    required this.underTheHood,
    required this.productionExample,
    required this.tradeoffs,
    required this.commonMistakes,
    required this.interviewTraps,
    required this.interviewQuestions,
    required this.quickRevision,
    required this.practicePrompt,
    required this.practiceHint,
    required this.practiceSolution,
  });
}

/// Trade-offs matrix for a topic
class TopicTradeoffs {
  final String performance;
  final String memory;
  final String maintainability;
  final String testability;
  final String complexity;

  const TopicTradeoffs({
    required this.performance,
    required this.memory,
    required this.maintainability,
    required this.testability,
    required this.complexity,
  });
}

/// Mistake comparison (anti-pattern vs corrected implementation)
class TopicMistake {
  final String title;
  final String incorrectCode;
  final String correctedCode;
  final String explanation;

  const TopicMistake({
    required this.title,
    required this.incorrectCode,
    required this.correctedCode,
    required this.explanation,
  });
}

/// Interview question within a topic
class TopicInterviewQuestion {
  final String question;
  final String difficulty; // 'Easy', 'Medium', 'Hard', 'Expert'
  final String answer;
  final String seniorInsight;
  final String whyOtherAnswersFail;
  final String commonTrap;
  final String followUpQuestion;

  const TopicInterviewQuestion({
    required this.question,
    required this.difficulty,
    required this.answer,
    this.seniorInsight = '',
    this.whyOtherAnswersFail = '',
    this.commonTrap = '',
    this.followUpQuestion = '',
  });
}

/// System Design Case Study (for System Design Mode)
class SystemDesignCaseStudy {
  final int id;
  final String title;
  final String subtitle;
  final String difficulty;
  final String estimatedTime;
  final List<String> functionalRequirements;
  final List<String> nonFunctionalRequirements;
  final String architectureDiagram;
  final List<String> components;
  final String dataFlow;
  final String apiDesign;
  final String databaseDesign;
  final String cachingStrategy;
  final String offlineSyncStrategy;
  final String concurrencyModel;
  final String securityMeasures;
  final String scalabilityStrategy;
  final String failureHandling;
  final List<String> tradeOffs;
  final List<TopicInterviewQuestion> interviewQuestions;

  const SystemDesignCaseStudy({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.difficulty,
    required this.estimatedTime,
    required this.functionalRequirements,
    required this.nonFunctionalRequirements,
    required this.architectureDiagram,
    required this.components,
    required this.dataFlow,
    required this.apiDesign,
    required this.databaseDesign,
    required this.cachingStrategy,
    required this.offlineSyncStrategy,
    required this.concurrencyModel,
    required this.securityMeasures,
    required this.scalabilityStrategy,
    required this.failureHandling,
    required this.tradeOffs,
    required this.interviewQuestions,
  });
}
