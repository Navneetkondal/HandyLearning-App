import os
import re

app_root = '/Users/navneet/Desktop/PRACTICE_PROJ/POCDevelopment/handyLearn/lib'

# 1. Search for usages of all data variables across lib/
data_vars = [
    'prepDomains',
    'masterPrepDomains',
    'detailedPrepDomains',
    'prepEncyclopediaTopics',
    'seniorExamQuestions',
    'seniorExam89Questions',
    'senior100Questions',
    'systemDesignBlueprints',
    'masterSystemDesignCases',
    'enterpriseDefenseCases',
    'gitScenarios',
    'fullGitScenarios',
    'seniorityRubricBands',
    'staffSignals',
    'codeReviewCases',
    'behavioralCrisisScenarios',
    'codingChallenges',
    'cuttingEdgeTopics',
    'leadOutputPuzzles',
    'benchmarkCalibrations'
]

var_usages = {v: [] for v in data_vars}

for root, _, files in os.walk(app_root):
    for f in files:
        if f.endswith('.dart'):
            p = os.path.join(root, f)
            rel = os.path.relpath(p, app_root)
            with open(p, 'r', encoding='utf-8') as fl:
                content = fl.read()
            for v in data_vars:
                # search for whole word usage, excluding definition in data/
                if re.search(r'\b' + v + r'\b', content) and not rel.startswith('features/ios_senior_prep/data/' + v):
                    var_usages[v].append(rel)

print("=== DATA VARIABLE USAGE AUDIT ===")
for v, usages in var_usages.items():
    print(f"{v:30s}: used in {len(usages)} files -> {usages}")

# 2. Check for content directly in UI screens
print("\n=== HARDCODED CONTENT IN UI SCREENS ===")
screens_dir = os.path.join(app_root, 'features/ios_senior_prep/screens')
for f in os.listdir(screens_dir):
    if f.endswith('.dart'):
        p = os.path.join(screens_dir, f)
        with open(p, 'r', encoding='utf-8') as fl:
            content = fl.read()
        # Look for hardcoded lists of strings or maps
        lists = re.findall(r'(?:final|const|static const)\s+(?:List<[^>]+>|Map<[^>]+>)\s+(\w+)\s*=\s*(\[|\{)', content)
        if lists:
            print(f"Screen {f}: {lists}")
