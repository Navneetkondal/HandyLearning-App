import 'package:flutter_test/flutter_test.dart';
import 'package:handy_learn/features/ios_senior_prep/models/ios_prep_hierarchy_models.dart';
import 'package:handy_learn/features/ios_senior_prep/services/prep_progress_service.dart';

void main() {
  group('PrepProgressService Zero-Default & Dynamic Tracking Tests', () {
    late PrepProgressService service;

    setUp(() {
      service = PrepProgressService.instance;
      service.resetAllProgress();
    });

    test('Initial state is cleanly set to 0 across all metrics', () {
      expect(service.hasStarted, isFalse);
      expect(service.completedTopicsCount, equals(0));
      expect(service.masteredTopicsCount, equals(0));
      expect(service.inProgressTopicsCount, equals(0));
      expect(service.answeredQuestionsCount, equals(0));
      expect(service.completedSystemDesignsCount, equals(0));
      expect(service.completedDomainsCount, equals(0));
      expect(service.overallProgressPercentage, equals(0.0));
      expect(service.getDomainProgress(1), equals(0.0));
      expect(service.recentlyStudiedTopicIds, isEmpty);

      // Verify active pointer starts at Domain 01
      expect(service.activeCourse, equals('iOS Senior & Lead Prep'));
      expect(service.activeModule, equals('Domain 01: Swift Language Core'));
      expect(service.activeTopic, equals('Value vs Reference Semantics'));
      expect(service.activeDomainNumber, equals(1));
    });

    test('Starting a topic dynamically triggers tracking', () {
      expect(service.hasStarted, isFalse);

      service.setActiveTopic(
        course: 'iOS Senior & Lead Prep',
        module: 'Domain 01: Swift Language Core',
        topic: 'Value vs Reference Semantics',
        topicId: 'dom01_top01',
        domainNumber: 1,
      );

      expect(service.hasStarted, isTrue);
      expect(service.getTopicStatus('dom01_top01'), equals(TopicMasteryStatus.inProgress));
      expect(service.inProgressTopicsCount, equals(1));
      expect(service.completedTopicsCount, equals(0));
      expect(service.recentlyStudiedTopicIds, contains('dom01_top01'));
      expect(service.getDomainProgress(1), greaterThan(0.0));
    });

    test('Completing topics advances overall percentage and domain progress', () {
      service.setTopicStatus('dom01_top01', TopicMasteryStatus.completed);
      service.setTopicStatus('dom01_top02', TopicMasteryStatus.completed);

      expect(service.completedTopicsCount, equals(2));
      expect(service.overallProgressPercentage, greaterThan(0.0));
      expect(service.getDomainProgress(1), equals(0.5)); // 2 of 4 topics completed = 50%
    });

    test('System design completion tracks dynamically', () {
      expect(service.isSystemDesignCompleted(1), isFalse);
      expect(service.completedSystemDesignsCount, equals(0));

      service.toggleSystemDesignCompleted(1);
      expect(service.isSystemDesignCompleted(1), isTrue);
      expect(service.completedSystemDesignsCount, equals(1));
      expect(service.hasStarted, isTrue);

      service.toggleSystemDesignCompleted(1);
      expect(service.isSystemDesignCompleted(1), isFalse);
      expect(service.completedSystemDesignsCount, equals(0));
    });

    test('resetAllProgress() returns service to clean 0-state', () {
      service.setTopicStatus('dom01_top01', TopicMasteryStatus.mastered);
      service.toggleSystemDesignCompleted(2);
      service.recordQuestionAnswered();
      expect(service.hasStarted, isTrue);

      service.resetAllProgress();

      expect(service.hasStarted, isFalse);
      expect(service.completedTopicsCount, equals(0));
      expect(service.answeredQuestionsCount, equals(0));
      expect(service.completedSystemDesignsCount, equals(0));
      expect(service.overallProgressPercentage, equals(0.0));
      expect(service.recentlyStudiedTopicIds, isEmpty);
    });
  });
}
