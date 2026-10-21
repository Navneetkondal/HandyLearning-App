import json
import re
import os

chat_file = '/Users/navneet/.gemini/antigravity-cli/brain/d395ff4c-c8f5-4e07-b7fb-1379a5f6400c/all_chatgpt_conversation_blocks.txt'
out_db_json = '/Users/navneet/.gemini/antigravity-cli/brain/d395ff4c-c8f5-4e07-b7fb-1379a5f6400c/handylearn_ios_senior_lead_prep_content_database.json'
out_db_md = '/Users/navneet/.gemini/antigravity-cli/brain/d395ff4c-c8f5-4e07-b7fb-1379a5f6400c/handylearn_ios_senior_lead_prep_content_database.md'
out_gap_analysis = '/Users/navneet/.gemini/antigravity-cli/brain/d395ff4c-c8f5-4e07-b7fb-1379a5f6400c/chatgpt_coverage_and_deduplication_audit.md'

with open(chat_file, 'r', encoding='utf-8') as f:
    text = f.read()

# Split into main modules by '# Advanced '
module_splits = re.split(r'(?:^|\n)# (Advanced [^\n]+)', text)

raw_modules = []
for i in range(1, len(module_splits), 2):
    title = module_splits[i].strip()
    body = module_splits[i+1]
    raw_modules.append({'title': title, 'body': body})

print(f"Parsed {len(raw_modules)} raw '# Advanced' modules from ChatGPT conversation.")

# Parse topics from each module body
# Topics are separated by '# 1. Name', '## 1. Name', or '### 1. Name'
def parse_topics_from_body(body, module_name):
    # Match headers starting with a number: e.g. '# 1. What is DI'
    pattern = re.compile(r'(?:^|\n)(#{1,3})\s+(\d+\.\s+[^\n]+)\n')
    matches = list(pattern.finditer(body))
    
    topics = []
    for idx in range(len(matches)):
        start = matches[idx].end()
        end = matches[idx+1].start() if idx+1 < len(matches) else len(body)
        raw_title = matches[idx].group(2).strip()
        topic_body = body[start:end].strip()
        
        # Clean title
        clean_title = re.sub(r'^\d+\.\s*', '', raw_title).strip()
        # Remove trailing markdown
        clean_title = re.sub(r'[*_`]', '', clean_title).strip()
        
        # Extract code blocks
        code_blocks = re.findall(r'```(?:swift)?\n(.*?)```', topic_body, re.DOTALL)
        minimal_code = code_blocks[0].strip() if len(code_blocks) > 0 else ""
        production_code = code_blocks[1].strip() if len(code_blocks) > 1 else minimal_code
        
        # Extract diagrams / ASCII art
        ascii_blocks = re.findall(r'```(?:text)?\n(.*?)```', topic_body, re.DOTALL)
        mental_model = ascii_blocks[0].strip() if len(ascii_blocks) > 0 else ""
        
        # Extract quick answer / definition (first paragraph or lines starting with '→' or '**')
        paragraphs = [p.strip() for p in topic_body.split('\n\n') if p.strip()]
        quick_answer = ""
        explanation_lines = []
        for p in paragraphs:
            if p.startswith('```'):
                continue
            if not quick_answer and ('→' in p or '**' in p or len(p) > 20):
                quick_answer = p.replace('→', '').replace('**', '').strip()
            else:
                explanation_lines.append(p)
                
        if not quick_answer and paragraphs:
            quick_answer = paragraphs[0].replace('```', '').strip()
            
        topics.append({
            'module': module_name,
            'title': clean_title,
            'raw_title': raw_title,
            'quick_answer': quick_answer,
            'mental_model': mental_model,
            'minimal_code': minimal_code,
            'production_code': production_code,
            'explanation': "\n\n".join(explanation_lines[:3]),
            'body_length': len(topic_body),
            'sourceType': 'chatgpt_conversation',
            'sourceUrl': 'https://chatgpt.com/share/6ac3b1d4-00a4-83ee-a269-46ff853b8d46',
            'sourceStatus': 'extracted'
        })
    return topics

all_parsed_topics = []
for m in raw_modules:
    mod_topics = parse_topics_from_body(m['body'], m['title'])
    all_parsed_topics.extend(mod_topics)

print(f"Total raw topics extracted: {len(all_parsed_topics)}")

# Deduplication: normalize by lower case title
deduped_topics = {}
duplicate_records = []

for t in all_parsed_topics:
    key = t['title'].lower().strip()
    # Normalize minor variations
    key = re.sub(r'[^a-z0-9]', '', key)
    if not key:
        continue
        
    if key in deduped_topics:
        existing = deduped_topics[key]
        duplicate_records.append({
            'title': t['title'],
            'canonical_module': existing['module'],
            'secondary_module': t['module']
        })
        # If the new one has more content or code, merge details
        if len(t['minimal_code']) > len(existing['minimal_code']):
            existing['minimal_code'] = t['minimal_code']
        if len(t['production_code']) > len(existing['production_code']):
            existing['production_code'] = t['production_code']
        if len(t['mental_model']) > len(existing['mental_model']):
            existing['mental_model'] = t['mental_model']
        if len(t['explanation']) > len(existing['explanation']):
            existing['explanation'] = t['explanation']
    else:
        deduped_topics[key] = t

print(f"Deduplicated unique topics count: {len(deduped_topics)}")
print(f"Total duplicate occurrences unified: {len(duplicate_records)}")

# Write deduplication audit report
with open(out_gap_analysis, 'w', encoding='utf-8') as f:
    f.write("# ChatGPT Conversation Coverage & Deduplication Audit\n\n")
    f.write(f"**Source URL**: https://chatgpt.com/share/6ac3b1d4-00a4-83ee-a269-46ff853b8d46  \n")
    f.write(f"**Total Raw Modules Parsed**: {len(raw_modules)}  \n")
    f.write(f"**Total Raw Topics Parsed**: {len(all_parsed_topics)}  \n")
    f.write(f"**Deduplicated Unique Topics**: {len(deduped_topics)}  \n")
    f.write(f"**Unified Duplicate Mentions**: {len(duplicate_records)}  \n\n")
    
    f.write("## 1. 18 Key Modules Breakdown\n\n")
    for idx, m in enumerate(raw_modules[:18]):
        count = sum(1 for t in deduped_topics.values() if t['module'] == m['title'])
        f.write(f"- **Module {idx+1}**: {m['title']} ({count} canonical unique topics)\n")
        
    f.write("\n## 2. Sample Deduplicated Topics Unified Across Modules\n\n")
    f.write("| Topic | Primary / Canonical Module | Also Mentioned In |\n")
    f.write("|---|---|---|\n")
    for d in duplicate_records[:30]:
        f.write(f"| {d['title']} | {d['canonical_module']} | {d['secondary_module']} |\n")

print(f"Saved audit report to {out_gap_analysis}")
