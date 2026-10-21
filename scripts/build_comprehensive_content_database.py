import json
import re
import os

chat_file = '/Users/navneet/.gemini/antigravity-cli/brain/d395ff4c-c8f5-4e07-b7fb-1379a5f6400c/all_chatgpt_conversation_blocks.txt'
out_db_json = '/Users/navneet/.gemini/antigravity-cli/brain/d395ff4c-c8f5-4e07-b7fb-1379a5f6400c/handylearn_ios_senior_lead_prep_content_database.json'
out_db_md = '/Users/navneet/.gemini/antigravity-cli/brain/d395ff4c-c8f5-4e07-b7fb-1379a5f6400c/handylearn_ios_senior_lead_prep_content_database.md'

with open(chat_file, 'r', encoding='utf-8') as f:
    text = f.read()

# Split into main modules
module_splits = re.split(r'(?:^|\n)# (Advanced [^\n]+)', text)
raw_modules = []
for i in range(1, len(module_splits), 2):
    title = module_splits[i].strip()
    body = module_splits[i+1]
    raw_modules.append({'title': title, 'body': body})

# Map each module to one of the 24 Master Domains
def map_module_to_domain(title):
    t = title.lower()
    if 'permission' in t or 'privacy' in t or 'security' in t:
        return 22, 'Security, Privacy & Permissions'
    if 'build system' in t or 'xcode' in t or 'configuration' in t or 'code signing' in t or 'developer account' in t:
        return 17, 'Build Systems, Xcode & Release'
    if 'flavor' in t or 'environment' in t or 'ci/cd' in t or 'app store connect' in t or 'testflight' in t:
        return 17, 'Build Systems, Xcode & Release'
    if 'extension' in t:
        return 16, 'App Size Optimization & Extensions'
    if 'size' in t or 'thinning' in t or 'on-demand' in t:
        return 16, 'App Size Optimization & Extensions'
    if 'uikit' in t or 'view rendering' in t or 'lifecycle' in t:
        return 7, 'UIKit Architecture & Lifecycle'
    if 'runtime' in t or 'reflection' in t or 'dispatch' in t:
        return 1, 'Swift Language Core & Type System'
    if 'generics' in t or 'protocols' in t or 'type system' in t:
        return 2, 'Protocols & Protocol-Oriented Programming'
    if 'error handling' in t or 'result' in t:
        return 1, 'Swift Language Core & Type System'
    if 'ownership' in t or 'memory model' in t or 'move' in t or 'arc' in t or 'memory management' in t:
        return 4, 'Memory Management, ARC & Move Semantics'
    if 'testing' in t or 'quality' in t:
        return 18, 'Testing & Code Quality'
    if 'swiftui' in t or 'state ownership' in t:
        return 8, 'SwiftUI Architecture & Rendering'
    if 'system design' in t or 'distributed' in t:
        return 23, 'System Design for iOS'
    if 'networking' in t or 'urlsession' in t:
        return 9, 'Networking & API Layer'
    if 'persistence' in t or 'core data' in t or 'offline-first' in t:
        return 13, 'Data Persistence & Core Data'
    if 'concurrency' in t or 'thread safety' in t or 'gcd' in t:
        return 5, 'Swift Concurrency'
    if 'modularization' in t or 'package manager' in t or 'dependency management' in t:
        return 10, 'Architecture & Modularization'
    if 'dependency injection' in t or 'composition root' in t:
        return 12, 'Design Patterns & Dependency Injection'
    if 'instruments' in t or 'ui performance' in t or 'performance optimization' in t:
        return 15, 'Xcode Instruments Profiling'
    if 'reactive' in t or 'combine' in t:
        return 6, 'GCD & OperationQueue'
    if 'notification' in t or 'background' in t:
        return 21, 'Push Notifications & APNs'
    if 'bluetooth' in t:
        return 19, 'Bluetooth Low Energy (CoreBluetooth)'
    if 'design pattern' in t or 'solid' in t or 'architecture' in t:
        return 11, 'SOLID & Clean Code Principles'
    return 24, 'Senior & Lead Engineering'

# Domain template metadata
DOMAIN_NAMES = {
    1: 'Swift Language Core & Type System',
    2: 'Protocols & Protocol-Oriented Programming',
    3: 'Generics, Constraints & Type Erasure',
    4: 'Memory Management, ARC & Move Semantics',
    5: 'Swift Concurrency',
    6: 'GCD & OperationQueue',
    7: 'UIKit Architecture & Lifecycle',
    8: 'SwiftUI Architecture & Rendering',
    9: 'Networking & API Layer',
    10: 'Architecture & Modularization',
    11: 'SOLID & Clean Code Principles',
    12: 'Design Patterns & Dependency Injection',
    13: 'Data Persistence & Core Data',
    14: 'Performance Optimization',
    15: 'Xcode Instruments Profiling',
    16: 'App Size Optimization & Extensions',
    17: 'Build Systems, Xcode & Release',
    18: 'Testing & Code Quality',
    19: 'Bluetooth Low Energy (CoreBluetooth)',
    20: 'WKWebView & Hybrid Architecture',
    21: 'Push Notifications & APNs',
    22: 'Security, Privacy & Permissions',
    23: 'System Design for iOS',
    24: 'Senior & Lead Engineering',
}

domain_buckets = {d: {'id': d, 'title': DOMAIN_NAMES[d], 'topics': {}} for d in range(1, 25)}

pattern = re.compile(r'(?:^|\n)(#{1,3})\s+(\d+\.\s+[^\n]+)\n')

total_extracted_topics = 0
dedup_map = {}

for m in raw_modules:
    target_domain_id, domain_title = map_module_to_domain(m['title'])
    body = m['body']
    matches = list(pattern.finditer(body))
    
    for idx in range(len(matches)):
        start = matches[idx].end()
        end = matches[idx+1].start() if idx+1 < len(matches) else len(body)
        raw_title = matches[idx].group(2).strip()
        topic_body = body[start:end].strip()
        
        clean_title = re.sub(r'^\d+\.\s*', '', raw_title).strip()
        clean_title = re.sub(r'[*_`]', '', clean_title).strip()
        norm_key = re.sub(r'[^a-z0-9]', '', clean_title.lower())
        
        if not norm_key:
            continue
            
        # Code blocks
        code_blocks = re.findall(r'```(?:swift)?\n(.*?)```', topic_body, re.DOTALL)
        minimal_code = code_blocks[0].strip() if len(code_blocks) > 0 else ""
        production_code = code_blocks[1].strip() if len(code_blocks) > 1 else minimal_code
        
        # Diagrams
        ascii_blocks = re.findall(r'```(?:text)?\n(.*?)```', topic_body, re.DOTALL)
        mental_model = ascii_blocks[0].strip() if len(ascii_blocks) > 0 else ""
        
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
            
        topic_obj = {
            'title': clean_title,
            'sourceModule': m['title'],
            'domainId': target_domain_id,
            'domainTitle': domain_title,
            'quickAnswer': quick_answer,
            'mentalModel': mental_model,
            'minimalCode': minimal_code,
            'productionCode': production_code,
            'explanation': "\n\n".join(explanation_lines[:3]),
            'difficulty': 'Senior' if any(w in clean_title.lower() for w in ['internals', 'runtime', 'advanced', 'isolation', 'reentrancy', 'layout', 'rendering', 'lock', 'semaphore']) else 'Intermediate',
            'importance': 'Critical' if any(w in clean_title.lower() for w in ['arc', 'actor', 'sendable', 'lifecycle', 'privacy', 'signing', 'di', 'spm', 'root']) else 'High',
            'interviewRelevance': 'High',
            'productionRelevance': 'Critical',
            'sourceType': 'chatgpt_conversation',
            'sourceUrl': 'https://chatgpt.com/share/6ac3b1d4-00a4-83ee-a269-46ff853b8d46',
            'sourceStatus': 'extracted'
        }
        
        total_extracted_topics += 1
        
        # Deduplication check
        if norm_key in dedup_map:
            # Already exists in a domain - enrich if needed, but do NOT duplicate
            existing_domain, existing_key = dedup_map[norm_key]
            existing_topic = domain_buckets[existing_domain]['topics'][existing_key]
            if len(minimal_code) > len(existing_topic['minimalCode']):
                existing_topic['minimalCode'] = minimal_code
            if len(production_code) > len(existing_topic['productionCode']):
                existing_topic['productionCode'] = production_code
            if len(mental_model) > len(existing_topic['mentalModel']):
                existing_topic['mentalModel'] = mental_model
        else:
            dedup_map[norm_key] = (target_domain_id, norm_key)
            domain_buckets[target_domain_id]['topics'][norm_key] = topic_obj

print(f"Total topics extracted across all modules: {total_extracted_topics}")
total_unique = sum(len(d['topics']) for d in domain_buckets.values())
print(f"Total unique topics across all 24 domains: {total_unique}")

# Convert topics dict to list per domain
domains_output = []
for d_id in sorted(domain_buckets.keys()):
    d = domain_buckets[d_id]
    topic_list = list(d['topics'].values())
    domains_output.append({
        'id': d_id,
        'title': d['title'],
        'topicCount': len(topic_list),
        'topics': topic_list
    })

db_json_data = {
    'title': 'handyLearn — iOS Senior & Lead Prep Master Content Database',
    'version': '2.0.0',
    'lastUpdated': '2026-10-05',
    'sourceUrl': 'https://chatgpt.com/share/6ac3b1d4-00a4-83ee-a269-46ff853b8d46',
    'sourceType': 'chatgpt_conversation',
    'statistics': {
        'totalMasterDomains': 24,
        'totalRawTopicsExtracted': total_extracted_topics,
        'totalUniqueCanonicalTopics': total_unique,
        'totalDeduplicatedOccurrences': total_extracted_topics - total_unique,
        'deduplicationRate': f'{((total_extracted_topics - total_unique)/total_extracted_topics)*100:.1f}%'
    },
    'domains': domains_output
}

with open(out_db_json, 'w', encoding='utf-8') as f:
    json.dump(db_json_data, f, indent=2)

print(f"Saved JSON database to {out_db_json} ({os.path.getsize(out_db_json):,} bytes)")

# Generate comprehensive Markdown summary
with open(out_db_md, 'w', encoding='utf-8') as f:
    f.write("# handyLearn — iOS Senior & Lead Prep Content Database (v2.0.0)\n\n")
    f.write(f"**Primary Source**: [ChatGPT Share Conversation](https://chatgpt.com/share/6ac3b1d4-00a4-83ee-a269-46ff853b8d46)  \n")
    f.write(f"**Total Master Domains**: 24  \n")
    f.write(f"**Total Raw Topics Extracted**: {total_extracted_topics}  \n")
    f.write(f"**Total Canonical Unique Topics (Deduplicated)**: {total_unique}  \n")
    f.write(f"**Duplicate Mentions Unified**: {total_extracted_topics - total_unique}  \n\n")
    
    f.write("## Domain Summary\n\n")
    f.write("| Domain # | Domain Title | Canonical Topics |\n")
    f.write("|---|---|---|\n")
    for d in domains_output:
        f.write(f"| {d['id']} | {d['title']} | {d['topicCount']} |\n")
        
    f.write("\n---\n\n")
    for d in domains_output:
        f.write(f"## Domain {d['id']}: {d['title']} ({d['topicCount']} Topics)\n\n")
        for idx, t in enumerate(d['topics'][:15]):
            f.write(f"### {idx+1}. {t['title']}\n")
            f.write(f"- **Quick Answer**: {t['quickAnswer']}\n")
            f.write(f"- **Difficulty**: {t['difficulty']} | **Importance**: {t['importance']}\n")
            f.write(f"- **Source Module**: {t['sourceModule']}\n")
            if t['minimalCode']:
                f.write(f"```swift\n{t['minimalCode']}\n```\n")
            if t['mentalModel']:
                f.write(f"```text\n{t['mentalModel']}\n```\n")
            f.write("\n")
        if len(d['topics']) > 15:
            f.write(f"*... and {len(d['topics']) - 15} more canonical topics in Domain {d['id']}*\n\n")

print(f"Saved Markdown database to {out_db_md} ({os.path.getsize(out_db_md):,} bytes)")
