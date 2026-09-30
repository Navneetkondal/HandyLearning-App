import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_learning_hub/features/ai_engineering/models/ai_engineer_roadmap_models.dart';
import 'package:flutter_learning_hub/features/ai_engineering/screens/ai_engineer_roadmap_screen.dart';

void main() {
  group('AI Engineer & Claude Mastery Roadmap Tests', () {
    test('aiRoadmapLessons contains all 5 tiers and lessons', () {
      expect(aiRoadmapLessons.length, greaterThanOrEqualTo(8));

      final tiers = aiRoadmapLessons.map((l) => l.tier).toSet();
      expect(tiers.contains(RoadmapTier.apprentice), isTrue);
      expect(tiers.contains(RoadmapTier.mechanist), isTrue);
      expect(tiers.contains(RoadmapTier.craftsman), isTrue);
      expect(tiers.contains(RoadmapTier.architect), isTrue);
      expect(tiers.contains(RoadmapTier.master), isTrue);

      for (final lesson in aiRoadmapLessons) {
        expect(lesson.title.isNotEmpty, isTrue);
        expect(lesson.childAnalogy.isNotEmpty, isTrue);
        expect(lesson.engineeringExplanation.isNotEmpty, isTrue);
        expect(lesson.fromScratchSnippet.isNotEmpty, isTrue);
        expect(lesson.claudeSnippet.isNotEmpty, isTrue);
        expect(lesson.officialSourceUrl.startsWith('http'), isTrue);
        expect(lesson.ccdvDomainAlignment.isNotEmpty, isTrue);
        expect(lesson.keyTakeaways.length, greaterThanOrEqualTo(3));
      }
    });

    testWidgets('AiEngineerRoadmapScreen renders header, filters, and lesson cards',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AiEngineerRoadmapScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Check App Title
      expect(find.text('AI Engineer & Claude Mastery'), findsOneWidget);

      // Check Hero Card
      expect(find.text('Child to Master AI Engineer Roadmap'), findsOneWidget);

      // Check Filter Chips
      expect(find.text('All 5 Levels'), findsOneWidget);
      final chipFinder = find.widgetWithText(FilterChip, 'L1: Apprentice');
      expect(chipFinder, findsOneWidget);

      // Check at least one lesson title
      expect(find.text('Words are Lego Bricks: How Claude Reads (Tokens)'), findsOneWidget);

      // Filter by Apprentice
      await tester.tap(chipFinder);
      await tester.pumpAndSettle();

      // Tap to expand first lesson
      final expansionTileFinder = find.byType(ExpansionTile).first;
      await tester.tap(expansionTileFinder);
      await tester.pumpAndSettle();

      // Check child analogy presence
      expect(find.text("Explain Like I'm 5 (ELIF5)"), findsOneWidget);
    });
  });
}
