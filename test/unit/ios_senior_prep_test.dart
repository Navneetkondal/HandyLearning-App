import 'package:flutter_test/flutter_test.dart';
import 'package:handy_learn/features/ios_senior_prep/data/ios_prep_data.dart';
import 'package:handy_learn/features/ios_senior_prep/data/ios_master_handbook_data.dart';

void main() {
  group('iOS Senior & Lead Prep Hub Data Repository Tests', () {
    test('prepDomains contains 32 complete architectural domains', () {
      expect(prepDomains.length, 32);

      // Verify domain 1: Swift Language Core
      final domain1 = prepDomains.firstWhere((d) => d.domainNumber == 1);
      expect(domain1.title, contains('Swift Language Core'));
      expect(domain1.topics.isNotEmpty, true);
      expect(domain1.topics.first.title, contains('Value vs Reference'));
      expect(domain1.topics.first.codeSnippet, isNotNull);

      // Verify domain 6: Concurrency
      final domain6 = prepDomains.firstWhere((d) => d.domainNumber == 6);
      expect(domain6.title, contains('Concurrency'));

      // Verify domain 32: Mobile System Design, Staff Leadership & Crisis Playbooks
      final domain32 = prepDomains.firstWhere((d) => d.domainNumber == 32);
      expect(domain32.title, contains('Mobile System Design'));
    });

    test('seniorExamQuestions contains all 89 questions across Junior, Mid, Senior and Lead levels', () {
      expect(seniorExamQuestions.length, 89);

      final levels = seniorExamQuestions.map((q) => q.level).toSet();
      expect(levels.contains('Junior'), true);
      expect(levels.contains('Mid'), true);
      expect(levels.contains('Senior'), true);
      expect(levels.contains('Lead'), true);

      // Check specific critical questions
      final contiguousQ = seniorExamQuestions.firstWhere((q) => q.id == 1);
      expect(contiguousQ.question, contains('ContiguousArray'));
      expect(contiguousQ.level, 'Senior');

      final cowQ = seniorExamQuestions.firstWhere((q) => q.id == 4);
      expect(cowQ.question, contains('Copy-on-Write'));
    });

    test('senior100Questions contains complete 100 questions from Senior Engineers PDF', () {
      expect(senior100Questions.length, 100);
      final q1 = senior100Questions.firstWhere((q) => q.id == 1);
      expect(q1.question, contains('scalable iOS application'));
      expect(q1.bulletPoints.isNotEmpty, true);
    });

    test('prepEncyclopediaTopics contains all 115 cards across Parts A through O', () {
      expect(prepEncyclopediaTopics.length, 115);
      final parts = prepEncyclopediaTopics.map((t) => t.part).toSet();
      expect(parts.any((p) => p.contains('Part A')), true);
      expect(parts.any((p) => p.contains('Part B')), true);
      expect(parts.any((p) => p.contains('Part C')), true);
      expect(parts.any((p) => p.contains('Part D')), true);
      expect(parts.any((p) => p.contains('Part E')), true);
      expect(parts.any((p) => p.contains('Part F')), true);
      expect(parts.any((p) => p.contains('Part G')), true);
      expect(parts.any((p) => p.contains('Part H')), true);
      expect(parts.any((p) => p.contains('Part I')), true);
      expect(parts.any((p) => p.contains('Part J')), true);
      expect(parts.any((p) => p.contains('Part K')), true);
      expect(parts.any((p) => p.contains('Part L')), true);
      expect(parts.any((p) => p.contains('Part M')), true);
      expect(parts.any((p) => p.contains('Part N')), true);
      expect(parts.any((p) => p.contains('Part O')), true);
    });

    test('fullGitScenarios contains 33 scenarios', () {
      expect(fullGitScenarios.length, 33);
      for (final s in fullGitScenarios) {
        expect(s.title.isNotEmpty, true);
        expect(s.command.isNotEmpty, true);
        expect(s.explanation.isNotEmpty, true);
        expect(s.steps.isNotEmpty, true);
      }
    });

    test('benchmarkCalibrations contains 10 landmark questions with 4-tier calibration', () {
      expect(benchmarkCalibrations.length, 10);
      for (final b in benchmarkCalibrations) {
        expect(b.question.isNotEmpty, true);
        expect(b.juniorAnswer.isNotEmpty, true);
        expect(b.midAnswer.isNotEmpty, true);
        expect(b.seniorAnswer.isNotEmpty, true);
        expect(b.staffAnswer.isNotEmpty, true);
      }
    });

    test('systemDesignBlueprints contains 5 Big Tech mobile architectures', () {
      expect(systemDesignBlueprints.length, 5);

      final titles = systemDesignBlueprints.map((bp) => bp.title).toList();
      expect(titles.any((t) => t.contains('Offline-First')), true);
      expect(titles.any((t) => t.contains('Image Caching')), true);
      expect(titles.any((t) => t.contains('Real-Time Chat')), true);
      expect(titles.any((t) => t.contains('Chunked Resumable Upload')), true);
      expect(titles.any((t) => t.contains('Observability')), true);

      for (final bp in systemDesignBlueprints) {
        expect(bp.asciiDiagram.isNotEmpty, true);
        expect(bp.fivePhaseSteps.length, 5);
        expect(bp.keyDecisions.isNotEmpty, true);
      }
    });

    test('enterpriseDefenseCases covers high-stakes production scenarios', () {
      expect(enterpriseDefenseCases.length, 3);

      final stripeCase = enterpriseDefenseCases.firstWhere((c) => c.title.contains('Stripe'));
      expect(stripeCase.interviewerTrap, contains('twice'));
      expect(stripeCase.solution, contains('Idempotency Key'));
      expect(stripeCase.codeSnippet, contains('PaymentSheet'));

      final locationCase = enterpriseDefenseCases.firstWhere((c) => c.title.contains('Location'));
      expect(locationCase.codeSnippet, contains('isSimulatedBySoftware'));

      final configCase = enterpriseDefenseCases.firstWhere((c) => c.title.contains('Flavoring'));
      expect(configCase.codeSnippet, contains('EnterpriseBrandConfiguration'));
    });

    test('gitScenarios provides essential production workflows', () {
      expect(gitScenarios.length, greaterThanOrEqualTo(5));

      final commands = gitScenarios.map((s) => s.command).toList();
      expect(commands.any((c) => c.contains('rebase')), true);
      expect(commands.any((c) => c.contains('bisect')), true);
      expect(commands.any((c) => c.contains('reflog')), true);
    });

    test('seniorityRubricBands covers 0 to 12+ YoE spectrum', () {
      expect(seniorityRubricBands.length, 5);

      final yoeBands = seniorityRubricBands.map((r) => r.yoeBand).toList();
      expect(yoeBands.any((y) => y.contains('0–1 Year')), true);
      expect(yoeBands.any((y) => y.contains('8–12+ Years')), true);

      for (final band in seniorityRubricBands) {
        expect(band.disqualifyingRedFlags.isNotEmpty, true);
        expect(band.roundExpectations.isNotEmpty, true);
      }
    });

    test('staffSignals contains all 16 Staff & Principal interview calibration signals', () {
      expect(staffSignals.length, 16);

      final topics = staffSignals.map((s) => s.topic).toList();
      expect(topics.any((t) => t.contains('Struct vs. Class')), true);
      expect(topics.any((t) => t.contains('Copy-on-Write')), true);
      expect(topics.any((t) => t.contains('DispatchQueue.main.sync') || t.contains('Main Queue')), true);
      expect(topics.any((t) => t.contains('SwiftUI')), true);

      for (final s in staffSignals) {
        expect(s.strongSignal.isNotEmpty, true);
        expect(s.weakSignal.isNotEmpty, true);
        expect(s.followUpQuestion, isNotNull);
        expect(s.followUpAnswer, isNotNull);
      }
    });

    test('codeReviewCases contains live PR simulation with 7 defects and Swift 6 solution', () {
      expect(codeReviewCases.isNotEmpty, true);
      final c = codeReviewCases.first;
      expect(c.defects.length, 7);
      expect(c.submittedSnippet, contains('ProfileViewController'));
      expect(c.productionRefactoredSnippet, contains('@MainActor'));
      expect(c.productionRefactoredSnippet, contains('UserServiceProtocol'));
    });

    test('behavioralCrisisScenarios provides 3 P0 crisis engineering management playbooks', () {
      expect(behavioralCrisisScenarios.length, 3);
      final titles = behavioralCrisisScenarios.map((s) => s.title).toList();
      expect(titles.any((t) => t.contains('Outage')), true);
      expect(titles.any((t) => t.contains('Deadlocks')), true);
      expect(titles.any((t) => t.contains('Underperforming')), true);
    });

    test('codingChallenges contains all 10 Senior & Staff live coding programs', () {
      expect(codingChallenges.length, 10);

      final titles = codingChallenges.map((c) => c.title).toList();
      expect(titles.any((t) => t.contains('LRU Cache')), true);
      expect(titles.any((t) => t.contains('Image Downloader')), true);
      expect(titles.any((t) => t.contains('Debouncer')), true);
      expect(titles.any((t) => t.contains('Copy-on-Write')), true);
      expect(titles.any((t) => t.contains('Lossy Array')), true);
      expect(titles.any((t) => t.contains('Two Sum')), true);

      for (final c in codingChallenges) {
        expect(c.swiftSolution.isNotEmpty, true);
        expect(c.timeComplexity.isNotEmpty, true);
        expect(c.spaceComplexity.isNotEmpty, true);
        expect(c.edgeCases.isNotEmpty, true);
        expect(c.approaches.isNotEmpty, true);
        expect(c.approaches.length, greaterThanOrEqualTo(2));
        for (final app in c.approaches) {
          expect(app.title.isNotEmpty, true);
          expect(app.timeComplexity.isNotEmpty, true);
          expect(app.spaceComplexity.isNotEmpty, true);
          expect(app.explanation.isNotEmpty, true);
          expect(app.code.isNotEmpty, true);
          expect(app.verdict.isNotEmpty, true);
        }
      }
    });

    test('cuttingEdgeTopics contains 8 modern 2025-2026 industry standards', () {
      expect(cuttingEdgeTopics.length, 8);

      final titles = cuttingEdgeTopics.map((t) => t.title).toList();
      expect(titles.any((t) => t.contains('Privacy Manifests')), true);
      expect(titles.any((t) => t.contains('Non-Copyable') || t.contains('Swift 6')), true);
      expect(titles.any((t) => t.contains('SwiftData')), true);
      expect(titles.any((t) => t.contains('Instruments')), true);
      expect(titles.any((t) => t.contains('MetricKit')), true);

      for (final t in cuttingEdgeTopics) {
        expect(t.keyMechanics.isNotEmpty, true);
        expect(t.seniorTakeaway.isNotEmpty, true);
      }
    });

    test('masterHandbookChapters contains all 18 chapters and verified Swift 6 deep-dives', () {
      expect(masterHandbookChapters.length, 18);
      for (final ch in masterHandbookChapters) {
        expect(ch.number >= 1 && ch.number <= 18, true);
        expect(ch.title.isNotEmpty, true);
        expect(ch.subtitle.isNotEmpty, true);
        expect(ch.overview.isNotEmpty, true);
        expect(ch.keyDefinitions.isNotEmpty, true);
        expect(ch.deepDive.title.isNotEmpty, true);
        expect(ch.deepDive.swiftCode.isNotEmpty, true);
        expect(ch.deepDive.productionRules.isNotEmpty, true);
      }
    });
  });
}
