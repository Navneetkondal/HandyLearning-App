import '../models/ios_prep_hierarchy_models.dart';
import '../models/ios_prep_models.dart';
import '../models/master_handbook_models.dart';
import '../data/ios_prep_master_hierarchy_data.dart';
import '../data/ios_prep_data.dart';
import '../data/ios_master_handbook_data.dart';
import '../services/prep_progress_service.dart';

/// Centralized Canonical Content Repository (Phase 18).
/// Single source of truth for all learning material, question banks,
/// coding challenges, system design blueprints, and production scenarios.
class CanonicalContentRepository {
  CanonicalContentRepository._();
  static final CanonicalContentRepository instance = CanonicalContentRepository._();

  final PrepProgressService _progressService = PrepProgressService.instance;

  // In-memory indexed content caches for instant O(1) lookups
  final Map<String, MasterTopic> _topicsById = {};
  final Map<String, TopicInterviewQuestion> _questionsById = {};
  final Map<String, SystemDesignCaseStudy> _systemDesignById = {};
  final Map<String, CodingChallenge> _codingById = {};
  final Map<String, EnterpriseDefenseCase> _scenariosById = {};

  bool _initialized = false;

  /// Initializes indices from canonical datasets
  void initialize() {
    if (_initialized) return;

    for (final domain in masterPrepDomains) {
      for (final module in domain.modules) {
        for (final topic in module.topics) {
          _topicsById[topic.id] = topic;
          for (final q in topic.interviewQuestions) {
            final qId = '${topic.id}_${q.question.hashCode}';
            _questionsById[qId] = q;
          }
        }
      }
    }

    for (final sd in masterSystemDesignCases) {
      _systemDesignById[sd.id.toString()] = sd;
    }

    for (final cc in codingChallenges) {
      _codingById[cc.id.toString()] = cc;
    }

    for (final sc in enterpriseDefenseCases) {
      _scenariosById[sc.id.toString()] = sc;
    }

    _initialized = true;
  }

  // MARK: - Domains (24 Master Domains)
  List<PrepDomainHierarchy> getAllDomains() {
    initialize();
    return masterPrepDomains;
  }

  PrepDomainHierarchy? getDomainById(int id) {
    initialize();
    try {
      return masterPrepDomains.firstWhere((d) => d.id == id);
    } catch (_) {
      return null;
    }
  }

  // MARK: - Topics
  MasterTopic? getTopicById(String id) {
    initialize();
    return _topicsById[id];
  }

  List<MasterTopic> getAllTopics() {
    initialize();
    return _topicsById.values.toList();
  }

  // MARK: - Questions Bank (Phase 8 & 9)
  List<ExamQuestion> getSeniorExamQuestions() {
    return seniorExamQuestions;
  }

  List<Senior100Question> getSenior100Questions() {
    return senior100Questions;
  }

  // MARK: - System Design (Phase 12)
  List<SystemDesignCaseStudy> getSystemDesignCases() {
    initialize();
    return masterSystemDesignCases;
  }

  List<SystemDesignBlueprint> getSystemDesignBlueprints() {
    return systemDesignBlueprints;
  }

  // MARK: - Coding Challenges (Phase 10)
  List<CodingChallenge> getCodingChallenges() {
    return codingChallenges;
  }

  // MARK: - Production Scenarios (Phase 11)
  List<EnterpriseDefenseCase> getProductionScenarios() {
    return enterpriseDefenseCases;
  }

  // MARK: - Master Interview Handbook (889-Page Curriculum)
  List<MasterHandbookChapter> getMasterHandbookChapters() {
    return masterHandbookChapters;
  }

  // MARK: - Benchmark Calibrations (4-Tier Calibration Bank)
  List<BenchmarkCalibration> getBenchmarkCalibrations() {
    return benchmarkCalibrations;
  }

  // MARK: - Git Masterclass Scenarios (33 Scenarios)
  List<GitScenario> getGitScenarios() {
    return fullGitScenarios;
  }

  // MARK: - Staff Signals (16 Signals)
  List<StaffSignal> getStaffSignals() {
    return staffSignals;
  }

  // MARK: - Global Search (Phase 19)
  /// Deep search across Domains, Topics, Questions, System Design, Coding Challenges, Scenarios, Git & Staff Signals
  List<CanonicalSearchResult> search(String query) {
    initialize();
    if (query.trim().isEmpty) return const [];

    final q = query.toLowerCase().trim();
    final List<CanonicalSearchResult> results = [];

    // Search Domains
    for (final d in masterPrepDomains) {
      if (d.title.toLowerCase().contains(q) ||
          d.description.toLowerCase().contains(q) ||
          d.tag.toLowerCase().contains(q)) {
        results.add(CanonicalSearchResult(
          id: 'dom_${d.id}',
          title: 'Domain ${d.domainNumber}: ${d.title}',
          subtitle: d.description,
          category: 'Domain',
          hierarchyBreadcrumb: 'Domain ${d.domainNumber}',
          matchedText: d.title,
          targetDomainId: d.id,
        ));
      }

      // Search Topics
      for (final m in d.modules) {
        for (final t in m.topics) {
          if (t.title.toLowerCase().contains(q) ||
              t.quickAnswer.toLowerCase().contains(q) ||
              t.underTheHood.toLowerCase().contains(q) ||
              t.interviewTraps.any((trap) => trap.toLowerCase().contains(q))) {
            results.add(CanonicalSearchResult(
              id: t.id,
              title: t.title,
              subtitle: t.quickAnswer,
              category: 'Topic',
              hierarchyBreadcrumb: '${d.title} → ${m.title}',
              matchedText: t.title,
              targetDomainId: d.id,
              targetTopic: t,
            ));
          }

          // Search Questions inside Topics
          for (final iq in t.interviewQuestions) {
            if (iq.question.toLowerCase().contains(q) ||
                iq.answer.toLowerCase().contains(q) ||
                iq.seniorInsight.toLowerCase().contains(q)) {
              results.add(CanonicalSearchResult(
                id: '${t.id}_${iq.question.hashCode}',
                title: iq.question,
                subtitle: iq.answer,
                category: 'Interview Q&A',
                hierarchyBreadcrumb: '${d.title} → ${t.title}',
                matchedText: iq.question,
                targetDomainId: d.id,
                targetTopic: t,
              ));
            }
          }
        }
      }
    }

    // Search System Design
    for (final sd in masterSystemDesignCases) {
      if (sd.title.toLowerCase().contains(q) ||
          sd.subtitle.toLowerCase().contains(q) ||
          sd.functionalRequirements.any((r) => r.toLowerCase().contains(q))) {
        results.add(CanonicalSearchResult(
          id: sd.id.toString(),
          title: sd.title,
          subtitle: sd.subtitle,
          category: 'System Design',
          hierarchyBreadcrumb: 'Domain 23 System Design → Case ${sd.id}',
          matchedText: sd.title,
        ));
      }
    }

    // Search Coding Challenges
    for (final cc in codingChallenges) {
      if (cc.title.toLowerCase().contains(q) ||
          cc.problemStatement.toLowerCase().contains(q) ||
          cc.optimizedApproach.toLowerCase().contains(q)) {
        results.add(CanonicalSearchResult(
          id: cc.id.toString(),
          title: cc.title,
          subtitle: cc.problemStatement,
          category: 'Coding Challenge',
          hierarchyBreadcrumb: 'Coding Bank → ${cc.category}',
          matchedText: cc.title,
        ));
      }
    }

    // Search Production Scenarios
    for (final sc in enterpriseDefenseCases) {
      if (sc.title.toLowerCase().contains(q) ||
          sc.interviewerTrap.toLowerCase().contains(q) ||
          sc.solution.toLowerCase().contains(q)) {
        results.add(CanonicalSearchResult(
          id: sc.id.toString(),
          title: sc.title,
          subtitle: sc.solution,
          category: 'Production Scenario',
          hierarchyBreadcrumb: 'Crisis Playbooks → ${sc.title}',
          matchedText: sc.title,
        ));
      }
    }

    // Search Master Handbook (889-page Curriculum)
    for (final ch in masterHandbookChapters) {
      if (ch.title.toLowerCase().contains(q) ||
          ch.subtitle.toLowerCase().contains(q) ||
          ch.overview.toLowerCase().contains(q) ||
          ch.deepDive.title.toLowerCase().contains(q) ||
          ch.keyDefinitions.any((d) => d.term.toLowerCase().contains(q) || d.definition.toLowerCase().contains(q))) {
        results.add(CanonicalSearchResult(
          id: 'handbook_ch_${ch.number}',
          title: 'Handbook Ch ${ch.number}: ${ch.title}',
          subtitle: ch.subtitle,
          category: 'Master Handbook',
          hierarchyBreadcrumb: '889p Handbook → Chapter ${ch.number} (Pages ${ch.startPage}–${ch.endPage})',
          matchedText: ch.deepDive.title,
        ));
      }
    }

    // Search Git Scenarios
    for (final git in fullGitScenarios) {
      if (git.title.toLowerCase().contains(q) ||
          git.explanation.toLowerCase().contains(q) ||
          git.command.toLowerCase().contains(q) ||
          git.steps.any((s) => s.toLowerCase().contains(q))) {
        results.add(CanonicalSearchResult(
          id: 'git_${git.id}',
          title: git.title,
          subtitle: git.explanation,
          category: 'Git Masterclass',
          hierarchyBreadcrumb: 'Git Masterclass → ${git.category}',
          matchedText: git.title,
        ));
      }
    }

    // Search Benchmark Calibrations
    for (final bm in benchmarkCalibrations) {
      if (bm.question.toLowerCase().contains(q) ||
          bm.coreCompetency.toLowerCase().contains(q) ||
          bm.seniorAnswer.toLowerCase().contains(q) ||
          bm.staffAnswer.toLowerCase().contains(q) ||
          bm.interviewEvaluationGuide.toLowerCase().contains(q)) {
        results.add(CanonicalSearchResult(
          id: 'benchmark_${bm.id}',
          title: bm.question,
          subtitle: bm.coreCompetency,
          category: 'Staff Benchmark',
          hierarchyBreadcrumb: 'Staff Benchmarks → ${bm.coreCompetency}',
          matchedText: bm.question,
        ));
      }
    }

    // Search Staff Signals
    for (final sig in staffSignals) {
      if (sig.topic.toLowerCase().contains(q) ||
          sig.category.toLowerCase().contains(q) ||
          sig.strongSignal.toLowerCase().contains(q) ||
          sig.weakSignal.toLowerCase().contains(q) ||
          (sig.followUpQuestion?.toLowerCase().contains(q) ?? false) ||
          (sig.followUpAnswer?.toLowerCase().contains(q) ?? false)) {
        results.add(CanonicalSearchResult(
          id: 'signal_${sig.id}',
          title: sig.topic,
          subtitle: sig.strongSignal,
          category: 'Staff Signal',
          hierarchyBreadcrumb: 'Staff Signals → ${sig.category}',
          matchedText: sig.topic,
        ));
      }
    }

    return results;
  }

  // MARK: - Progress Tracking (Phase 20)
  TopicMasteryStatus getTopicStatus(String topicId) {
    return _progressService.getTopicStatus(topicId);
  }

  void updateTopicStatus(String topicId, TopicMasteryStatus status) {
    _progressService.setTopicStatus(topicId, status);
  }

  double getDomainProgress(int domainNumber) {
    return _progressService.getDomainProgress(domainNumber);
  }
}

/// Search Result Entity (Phase 19)
class CanonicalSearchResult {
  final String id;
  final String title;
  final String subtitle;
  final String category;
  final String hierarchyBreadcrumb;
  final String matchedText;
  final int? targetDomainId;
  final MasterTopic? targetTopic;

  const CanonicalSearchResult({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.category,
    required this.hierarchyBreadcrumb,
    required this.matchedText,
    this.targetDomainId,
    this.targetTopic,
  });
}
