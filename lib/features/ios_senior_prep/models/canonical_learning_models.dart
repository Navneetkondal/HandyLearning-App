/// Canonical Learning Content Models for handyLearn.
/// Implements the comprehensive, scalable 15-level hierarchy:
/// DOMAIN → CATEGORY → MODULE → TOPIC → SUBTOPIC → CONCEPT → LESSON →
/// CODE EXAMPLE → PRODUCTION EXAMPLE → TRADEOFFS → COMMON MISTAKES →
/// INTERVIEW TRAPS → QUESTIONS → PRACTICE → MASTERY.
library;

/// Content Provenance / Source tracking (Phase 15)
enum ContentSourceType {
  extracted,
  generated,
  userProvided,
  officialDocumentation,
  curated;

  String get label {
    switch (this) {
      case ContentSourceType.extracted:
        return 'Extracted from Source';
      case ContentSourceType.generated:
        return 'System Generated';
      case ContentSourceType.userProvided:
        return 'User Provided';
      case ContentSourceType.officialDocumentation:
        return 'Official Documentation';
      case ContentSourceType.curated:
        return 'Curated Architecture';
    }
  }
}

class ContentSource {
  final ContentSourceType type;
  final String? reference;
  final String? url;
  final String status; // 'verified', 'needs_review', 'canonical'

  const ContentSource({
    required this.type,
    this.reference,
    this.url,
    this.status = 'canonical',
  });

  Map<String, dynamic> toJson() => {
    'type': type.name,
    'reference': reference,
    'url': url,
    'status': status,
  };

  factory ContentSource.fromJson(Map<String, dynamic> json) => ContentSource(
    type: ContentSourceType.values.firstWhere(
      (e) => e.name == json['type'],
      orElse: () => ContentSourceType.curated,
    ),
    reference: json['reference'] as String?,
    url: json['url'] as String?,
    status: json['status'] as String? ?? 'canonical',
  );
}

/// Learning Difficulty & Seniority Level (Phase 3 & 8)
enum SeniorityLevel {
  junior(1, 'Junior (0-2 YoE)'),
  mid(2, 'Mid-Level (2-4 YoE)'),
  senior(3, 'Senior (5-8 YoE)'),
  staff(4, 'Staff / Principal (8-12 YoE)'),
  lead(5, 'Lead / Director (12+ YoE)');

  final int rank;
  final String label;
  const SeniorityLevel(this.rank, this.label);
}

enum ContentImportance {
  low,
  medium,
  high,
  critical;
}

enum ContentMasteryStatus {
  notStarted('○', 'Not Started'),
  inProgress('◐', 'In Progress'),
  completed('✓', 'Completed'),
  mastered('★', 'Mastered');

  final String symbol;
  final String label;
  const ContentMasteryStatus(this.symbol, this.label);
}

/// 1. DOMAIN (1 of 24)
class CanonicalDomain {
  final String id; // e.g. "dom-01-swift-core"
  final int domainNumber; // 1 to 24
  final String title;
  final String shortDescription;
  final String description;
  final int order;
  final SeniorityLevel level;
  final List<String> tags;
  final List<String> prerequisites;
  final List<String> relatedContent;
  final int estimatedTimeMinutes;
  final ContentImportance importance;
  final String interviewRelevance;
  final String productionRelevance;
  final ContentMasteryStatus status;
  final ContentSource source;
  final String version;
  final String emoji;
  final String tag;
  final List<CanonicalCategory> categories;

  const CanonicalDomain({
    required this.id,
    required this.domainNumber,
    required this.title,
    required this.shortDescription,
    required this.description,
    required this.order,
    this.level = SeniorityLevel.senior,
    this.tags = const [],
    this.prerequisites = const [],
    this.relatedContent = const [],
    this.estimatedTimeMinutes = 180,
    this.importance = ContentImportance.critical,
    this.interviewRelevance = 'High',
    this.productionRelevance = 'Critical',
    this.status = ContentMasteryStatus.notStarted,
    required this.source,
    this.version = '2.2.0',
    required this.emoji,
    required this.tag,
    required this.categories,
  });

  int get totalCategories => categories.length;
  int get totalModules => categories.fold(0, (sum, c) => sum + c.modules.length);
  int get totalTopics => categories.fold(0, (sum, c) => sum + c.modules.fold(0, (s2, m) => s2 + m.topics.length));
  int get totalConcepts => categories.fold(0, (sum, c) => sum + c.modules.fold(0, (s2, m) => s2 + m.topics.fold(0, (s3, t) => s3 + t.concepts.length)));
}

/// 2. CATEGORY
class CanonicalCategory {
  final String id; // e.g. "cat-arc-ownership"
  final String domainId;
  final String title;
  final String shortDescription;
  final String description;
  final int order;
  final SeniorityLevel level;
  final List<String> tags;
  final List<String> prerequisites;
  final List<String> relatedContent;
  final int estimatedTimeMinutes;
  final ContentImportance importance;
  final String interviewRelevance;
  final String productionRelevance;
  final ContentMasteryStatus status;
  final ContentSource source;
  final String version;
  final List<CanonicalModule> modules;

  const CanonicalCategory({
    required this.id,
    required this.domainId,
    required this.title,
    required this.shortDescription,
    required this.description,
    required this.order,
    this.level = SeniorityLevel.senior,
    this.tags = const [],
    this.prerequisites = const [],
    this.relatedContent = const [],
    this.estimatedTimeMinutes = 60,
    this.importance = ContentImportance.high,
    this.interviewRelevance = 'High',
    this.productionRelevance = 'High',
    this.status = ContentMasteryStatus.notStarted,
    required this.source,
    this.version = '2.2.0',
    required this.modules,
  });
}

/// 3. MODULE
class CanonicalModule {
  final String id; // e.g. "mod-reference-counting"
  final String categoryId;
  final String domainId;
  final String title;
  final String shortDescription;
  final String description;
  final int order;
  final SeniorityLevel level;
  final List<String> tags;
  final List<String> prerequisites;
  final List<String> relatedContent;
  final int estimatedTimeMinutes;
  final ContentImportance importance;
  final String interviewRelevance;
  final String productionRelevance;
  final ContentMasteryStatus status;
  final ContentSource source;
  final String version;
  final List<CanonicalTopic> topics;

  const CanonicalModule({
    required this.id,
    required this.categoryId,
    required this.domainId,
    required this.title,
    required this.shortDescription,
    required this.description,
    required this.order,
    this.level = SeniorityLevel.senior,
    this.tags = const [],
    this.prerequisites = const [],
    this.relatedContent = const [],
    this.estimatedTimeMinutes = 45,
    this.importance = ContentImportance.high,
    this.interviewRelevance = 'High',
    this.productionRelevance = 'High',
    this.status = ContentMasteryStatus.notStarted,
    required this.source,
    this.version = '2.2.0',
    required this.topics,
  });
}

/// 4. TOPIC
class CanonicalTopic {
  final String id; // e.g. "top-retain-cycles"
  final String moduleId;
  final String categoryId;
  final String domainId;
  final String title;
  final String shortDescription;
  final String description;
  final int order;
  final SeniorityLevel level;
  final List<String> tags;
  final List<String> prerequisites;
  final List<String> relatedContent;
  final int estimatedTimeMinutes;
  final ContentImportance importance;
  final String interviewRelevance;
  final String productionRelevance;
  final ContentMasteryStatus status;
  final ContentSource source;
  final String version;
  final List<CanonicalSubTopic> subtopics;
  final List<CanonicalConcept> concepts;

  const CanonicalTopic({
    required this.id,
    required this.moduleId,
    required this.categoryId,
    required this.domainId,
    required this.title,
    required this.shortDescription,
    required this.description,
    required this.order,
    this.level = SeniorityLevel.senior,
    this.tags = const [],
    this.prerequisites = const [],
    this.relatedContent = const [],
    this.estimatedTimeMinutes = 20,
    this.importance = ContentImportance.critical,
    this.interviewRelevance = 'Critical',
    this.productionRelevance = 'Critical',
    this.status = ContentMasteryStatus.notStarted,
    required this.source,
    this.version = '2.2.0',
    this.subtopics = const [],
    required this.concepts,
  });
}

/// 5. SUBTOPIC
class CanonicalSubTopic {
  final String id; // e.g. "subtop-closure-retain-cycles"
  final String topicId;
  final String moduleId;
  final String categoryId;
  final String domainId;
  final String title;
  final String shortDescription;
  final String description;
  final int order;
  final SeniorityLevel level;
  final List<String> tags;
  final List<String> prerequisites;
  final List<String> relatedContent;
  final int estimatedTimeMinutes;
  final ContentImportance importance;
  final String interviewRelevance;
  final String productionRelevance;
  final ContentMasteryStatus status;
  final ContentSource source;
  final String version;
  final List<String> conceptIds;

  const CanonicalSubTopic({
    required this.id,
    required this.topicId,
    required this.moduleId,
    required this.categoryId,
    required this.domainId,
    required this.title,
    required this.shortDescription,
    required this.description,
    required this.order,
    this.level = SeniorityLevel.senior,
    this.tags = const [],
    this.prerequisites = const [],
    this.relatedContent = const [],
    this.estimatedTimeMinutes = 15,
    this.importance = ContentImportance.high,
    this.interviewRelevance = 'High',
    this.productionRelevance = 'High',
    this.status = ContentMasteryStatus.notStarted,
    required this.source,
    this.version = '2.2.0',
    this.conceptIds = const [],
  });
}

/// 6. CONCEPT (Phase 4 — 30 detailed dimensions)
class CanonicalConcept {
  final String id; // e.g. "cpt-closure-capture-semantics"
  final String topicId;
  final String subtopicId;
  final String moduleId;
  final String categoryId;
  final String domainId;
  final String title;
  final String shortDescription;
  final String description;
  final int order;
  final SeniorityLevel level;
  final List<String> tags;
  final List<String> prerequisites;
  final List<String> relatedContent;
  final int estimatedTimeMinutes;
  final ContentImportance importance;
  final String interviewRelevance;
  final String productionRelevance;
  final ContentMasteryStatus status;
  final ContentSource source;
  final String version;

  // 30 Deep Dimensions (Phase 4)
  final String whatIsIt;
  final String whyDoesItExist;
  final String whyIsItImportant;
  final String whereIsItUsed;
  final String howDoesItWork;
  final String internalMechanics;
  final String mentalModel;
  final String syntax;
  final CanonicalCodeExample basicExample;
  final CanonicalCodeExample advancedExample;
  final CanonicalProductionExample productionExample;
  final String lineByLineExplanation;
  final List<CanonicalMistake> commonMistakes;
  final String performanceImplications;
  final String memoryImplications;
  final String threadingImplications;
  final String securityImplications;
  final String architectureImplications;
  final CanonicalTradeoffs tradeoffs;
  final List<String> alternatives;
  final List<String> whenToUse;
  final List<String> whenNotToUse;
  final List<String> interviewTraps;
  final List<String> faq;
  final List<CanonicalQuestion> questions;
  final List<CanonicalPracticeItem> practiceItems;
  final List<String> seniorQuestions;
  final List<String> leadQuestions;

  const CanonicalConcept({
    required this.id,
    required this.topicId,
    this.subtopicId = '',
    required this.moduleId,
    required this.categoryId,
    required this.domainId,
    required this.title,
    required this.shortDescription,
    required this.description,
    required this.order,
    this.level = SeniorityLevel.senior,
    this.tags = const [],
    this.prerequisites = const [],
    this.relatedContent = const [],
    this.estimatedTimeMinutes = 15,
    this.importance = ContentImportance.critical,
    this.interviewRelevance = 'Critical',
    this.productionRelevance = 'Critical',
    this.status = ContentMasteryStatus.notStarted,
    required this.source,
    this.version = '2.2.0',
    required this.whatIsIt,
    required this.whyDoesItExist,
    required this.whyIsItImportant,
    required this.whereIsItUsed,
    required this.howDoesItWork,
    required this.internalMechanics,
    required this.mentalModel,
    required this.syntax,
    required this.basicExample,
    required this.advancedExample,
    required this.productionExample,
    required this.lineByLineExplanation,
    this.commonMistakes = const [],
    this.performanceImplications = 'O(1) runtime operations, no allocations',
    this.memoryImplications = 'Direct stack/heap layout without side-table overhead',
    this.threadingImplications = 'Safe under Swift 6 strict concurrency model',
    this.securityImplications = 'Compliant with Apple privacy manifests',
    this.architectureImplications = 'Decoupled and testable via composition root',
    required this.tradeoffs,
    this.alternatives = const [],
    this.whenToUse = const [],
    this.whenNotToUse = const [],
    this.interviewTraps = const [],
    this.faq = const [],
    this.questions = const [],
    this.practiceItems = const [],
    this.seniorQuestions = const [],
    this.leadQuestions = const [],
  });
}

/// Code Example
class CanonicalCodeExample {
  final String title;
  final String code;
  final String language;
  final String explanation;

  const CanonicalCodeExample({
    required this.title,
    required this.code,
    this.language = 'swift',
    this.explanation = '',
  });
}

/// Production Example
class CanonicalProductionExample {
  final String scenario;
  final String code;
  final String realWorldContext;
  final String architectureImpact;

  const CanonicalProductionExample({
    required this.scenario,
    required this.code,
    required this.realWorldContext,
    required this.architectureImpact,
  });
}

/// Tradeoffs
class CanonicalTradeoffs {
  final String performance;
  final String memory;
  final String maintainability;
  final String testability;
  final String complexity;

  const CanonicalTradeoffs({
    required this.performance,
    required this.memory,
    required this.maintainability,
    required this.testability,
    required this.complexity,
  });
}

/// Common Mistake
class CanonicalMistake {
  final String title;
  final String incorrectCode;
  final String correctedCode;
  final String explanation;

  const CanonicalMistake({
    required this.title,
    required this.incorrectCode,
    required this.correctedCode,
    required this.explanation,
  });
}

/// Question Types (Phase 8)
enum QuestionType {
  definition,
  conceptual,
  howItWorks,
  internalMechanics,
  code,
  predictOutput,
  debugging,
  performance,
  memory,
  concurrency,
  architecture,
  tradeoff,
  scenario,
  production,
  systemDesign,
  interviewTrap,
  leadership,
  designReview;
}

/// 8. QUESTION (First-class Question Database)
class CanonicalQuestion {
  final String id;
  final String domainId;
  final String categoryId;
  final String moduleId;
  final String topicId;
  final String subtopicId;
  final String conceptId;
  final String question;
  final String answer;
  final String explanation;
  final int difficultyRank; // 1 to 5
  final SeniorityLevel level;
  final QuestionType type;
  final List<String> tags;
  final List<String> prerequisites;
  final List<String> relatedQuestions;
  final ContentSource source;
  final bool isInterviewTrap;
  final bool isCodingQuestion;
  final bool isScenarioQuestion;
  final bool isSystemDesignQuestion;
  final String seniorInsight;
  final String followUp;

  const CanonicalQuestion({
    required this.id,
    required this.domainId,
    this.categoryId = '',
    this.moduleId = '',
    this.topicId = '',
    this.subtopicId = '',
    this.conceptId = '',
    required this.question,
    required this.answer,
    required this.explanation,
    this.difficultyRank = 4,
    this.level = SeniorityLevel.senior,
    this.type = QuestionType.conceptual,
    this.tags = const [],
    this.prerequisites = const [],
    this.relatedQuestions = const [],
    required this.source,
    this.isInterviewTrap = false,
    this.isCodingQuestion = false,
    this.isScenarioQuestion = false,
    this.isSystemDesignQuestion = false,
    this.seniorInsight = '',
    this.followUp = '',
  });
}

/// 9. CODING QUESTION (Phase 10)
class CanonicalCodingQuestion {
  final String id;
  final String domainId;
  final String topicId;
  final String title;
  final String problem;
  final List<String> requirements;
  final List<String> constraints;
  final String starterCode;
  final String expectedSolution;
  final String alternativeSolutions;
  final String explanation;
  final String timeComplexity;
  final String spaceComplexity;
  final List<String> commonMistakes;
  final List<String> interviewFollowUps;
  final int difficultyRank;
  final SeniorityLevel level;
  final ContentSource source;

  const CanonicalCodingQuestion({
    required this.id,
    required this.domainId,
    required this.topicId,
    required this.title,
    required this.problem,
    this.requirements = const [],
    this.constraints = const [],
    required this.starterCode,
    required this.expectedSolution,
    this.alternativeSolutions = '',
    required this.explanation,
    required this.timeComplexity,
    required this.spaceComplexity,
    this.commonMistakes = const [],
    this.interviewFollowUps = const [],
    this.difficultyRank = 4,
    this.level = SeniorityLevel.senior,
    required this.source,
  });
}

/// 10. PRODUCTION SCENARIO (Phase 11)
class CanonicalProductionScenario {
  final String id;
  final String domainId;
  final String topicId;
  final String title;
  final String problem;
  final List<String> symptoms;
  final List<String> investigationSteps;
  final List<String> toolsUsed;
  final String rootCause;
  final String solution;
  final String tradeOffs;
  final String preventionStrategy;
  final String interviewQuestion;
  final String seniorFollowUp;
  final String leadFollowUp;
  final ContentSource source;

  const CanonicalProductionScenario({
    required this.id,
    required this.domainId,
    required this.topicId,
    required this.title,
    required this.problem,
    this.symptoms = const [],
    this.investigationSteps = const [],
    this.toolsUsed = const [],
    required this.rootCause,
    required this.solution,
    required this.tradeOffs,
    required this.preventionStrategy,
    required this.interviewQuestion,
    this.seniorFollowUp = '',
    this.leadFollowUp = '',
    required this.source,
  });
}

/// 11. SYSTEM DESIGN CASE (Phase 12)
class CanonicalSystemDesignCase {
  final String id;
  final String domainId;
  final String title;
  final String shortDescription;
  final List<String> functionalRequirements;
  final List<String> nonFunctionalRequirements;
  final List<String> constraints;
  final String architectureDiagram;
  final List<String> components;
  final String dataFlow;
  final String apiDesign;
  final String storageStrategy;
  final String cacheStrategy;
  final String networkingLayer;
  final String offlineStrategy;
  final String syncStrategy;
  final String concurrencyModel;
  final String securityModel;
  final String observabilityTelemetry;
  final String scalingStrategy;
  final String failureHandling;
  final String tradeOffs;
  final String alternativeArchitecture;
  final List<String> seniorQuestions;
  final List<String> leadQuestions;
  final ContentSource source;

  const CanonicalSystemDesignCase({
    required this.id,
    this.domainId = 'dom-23-system-design',
    required this.title,
    required this.shortDescription,
    this.functionalRequirements = const [],
    this.nonFunctionalRequirements = const [],
    this.constraints = const [],
    required this.architectureDiagram,
    this.components = const [],
    required this.dataFlow,
    required this.apiDesign,
    required this.storageStrategy,
    required this.cacheStrategy,
    required this.networkingLayer,
    required this.offlineStrategy,
    required this.syncStrategy,
    required this.concurrencyModel,
    required this.securityModel,
    required this.observabilityTelemetry,
    required this.scalingStrategy,
    required this.failureHandling,
    required this.tradeOffs,
    required this.alternativeArchitecture,
    this.seniorQuestions = const [],
    this.leadQuestions = const [],
    required this.source,
  });
}

/// 12. PRACTICE ITEM (Phase 5)
enum PracticeType {
  mcq,
  multipleAnswer,
  codeCompletion,
  debugging,
  predictOutput,
  refactoring,
  scenario;
}

class CanonicalPracticeItem {
  final String id;
  final String conceptId;
  final PracticeType type;
  final String prompt;
  final List<String> options;
  final dynamic correctAnswer;
  final String hint;
  final String solutionExplanation;

  const CanonicalPracticeItem({
    required this.id,
    required this.conceptId,
    required this.type,
    required this.prompt,
    this.options = const [],
    required this.correctAnswer,
    this.hint = '',
    required this.solutionExplanation,
  });
}

/// 13. LEARNING PATH (Phase 21)
class CanonicalLearningPath {
  final String id;
  final String title;
  final String description;
  final SeniorityLevel targetLevel;
  final int totalEstimatedHours;
  final List<String> orderedDomainIds;
  final List<String> keyConceptIds;

  const CanonicalLearningPath({
    required this.id,
    required this.title,
    required this.description,
    required this.targetLevel,
    required this.totalEstimatedHours,
    required this.orderedDomainIds,
    required this.keyConceptIds,
  });
}
