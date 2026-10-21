// Models representing the 889-Page iOS Senior & Lead Engineer Interview Handbook.
// Extracted directly from `/Users/navneet/Documents/Prep/Prep Guide/iOS_Master_Interview_Handbook_Organized_Topics.pdf`.

class MasterHandbookChapter {
  final int number;
  final String title;
  final String subtitle;
  final int startPage;
  final int endPage;
  final int pageCount;
  final String iconName;
  final String overview;
  final List<MasterHandbookModule> modules;
  final HandbookProductionDeepDive deepDive;
  final List<HandbookInterviewDefinition> keyDefinitions;

  const MasterHandbookChapter({
    required this.number,
    required this.title,
    required this.subtitle,
    required this.startPage,
    required this.endPage,
    required this.pageCount,
    required this.iconName,
    required this.overview,
    required this.modules,
    required this.deepDive,
    required this.keyDefinitions,
  });
}

class MasterHandbookModule {
  final String id;
  final int moduleNumber;
  final String title;
  final int page;
  final String summary;
  final List<String> coreTakeaways;

  const MasterHandbookModule({
    required this.id,
    required this.moduleNumber,
    required this.title,
    required this.page,
    required this.summary,
    required this.coreTakeaways,
  });
}

class HandbookProductionDeepDive {
  final String title;
  final int page;
  final String architecturalRole;
  final String swiftCode;
  final List<String> productionRules;

  const HandbookProductionDeepDive({
    required this.title,
    required this.page,
    required this.architecturalRole,
    required this.swiftCode,
    required this.productionRules,
  });
}

class HandbookInterviewDefinition {
  final String term;
  final String definition;
  final String seniorInsight;

  const HandbookInterviewDefinition({
    required this.term,
    required this.definition,
    required this.seniorInsight,
  });
}
