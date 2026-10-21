import json
import re

chat_path = '/Users/navneet/.gemini/antigravity-cli/brain/d395ff4c-c8f5-4e07-b7fb-1379a5f6400c/all_chatgpt_conversation_blocks.txt'
db_path = '/Users/navneet/.gemini/antigravity-cli/brain/d395ff4c-c8f5-4e07-b7fb-1379a5f6400c/handylearn_ios_senior_lead_prep_content_database.json'
dart_path = 'lib/features/ios_senior_prep/data/ios_prep_master_hierarchy_data.dart'

with open(chat_path, 'r', encoding='utf-8') as f:
    chat_text = f.read()

with open(db_path, 'r', encoding='utf-8') as f:
    db_data = json.load(f)

with open(dart_path, 'r', encoding='utf-8') as f:
    dart_text = f.read()

# Parse the 18 specific modules from chat_text
# In chat_text, each starts with "# Advanced ..."
module_pattern = re.compile(r'(?:^|\n)# (Advanced [^\n]+)')
matches = list(module_pattern.finditer(chat_text))

print(f"Total '# Advanced' modules found in chat text: {len(matches)}")

modules = []
for i in range(len(matches)):
    start = matches[i].start()
    end = matches[i+1].start() if i+1 < len(matches) else len(chat_text)
    mod_title = matches[i].group(1).strip()
    mod_content = chat_text[start:end]
    
    # Extract all numbered topics in this module
    # e.g. '# 1. Name' or '## 1. Name' or '### 1. Name'
    topics = re.findall(r'(?:^|\n)(?:#{1,3}\s+)(\d+\.\s+[^\n]+)', mod_content)
    modules.append({
        'title': mod_title,
        'topic_count': len(topics),
        'topics': topics,
        'content_len': len(mod_content)
    })

print("\n--- EXTRACTED MODULES BREAKDOWN ---")
for idx, m in enumerate(modules[:25]):
    print(f"{idx+1:2d}. {m['title']} -> {m['topic_count']} topics, {m['content_len']} chars")

# Check deduplication across all extracted topics
all_topics_normalized = {}
duplicates = []

for m in modules:
    for t in m['topics']:
        # clean topic title
        clean = re.sub(r'^\d+\.\s*', '', t).strip().lower()
        if clean in all_topics_normalized:
            duplicates.append((clean, all_topics_normalized[clean], m['title']))
        else:
            all_topics_normalized[clean] = m['title']

print(f"\nTotal unique topics identified: {len(all_topics_normalized)}")
print(f"Total topic occurrences that repeat across different modules: {len(duplicates)}")
print("Sample duplicates found:")
for d in duplicates[:10]:
    print(f"  - '{d[0]}' in '{d[1]}' AND '{d[2]}'")
