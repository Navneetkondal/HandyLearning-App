import json
import re
import os

html_path = '/Users/navneet/.gemini/antigravity-cli/brain/d395ff4c-c8f5-4e07-b7fb-1379a5f6400c/.system_generated/steps/3297/content.md'
output_dir = '/Users/navneet/.gemini/antigravity-cli/brain/d395ff4c-c8f5-4e07-b7fb-1379a5f6400c'

with open(html_path, 'r', encoding='utf-8') as f:
    text = f.read()

enqueue_blocks = re.findall(r'streamController\.enqueue\((.*?)\);', text, re.DOTALL)
inner = json.loads(json.loads(enqueue_blocks[0]))
strings = [x for x in inner if isinstance(x, str)]
long_strings = [x for x in strings if len(x) > 500]

print(f"Total raw long message blocks: {len(long_strings)}")

# Save all raw messages in ordered sequence for full reference
with open(os.path.join(output_dir, 'all_chatgpt_conversation_blocks.txt'), 'w', encoding='utf-8') as f_out:
    for idx, block in enumerate(long_strings):
        f_out.write(f"\n\n{'='*80}\nBLOCK #{idx+1}\n{'='*80}\n\n")
        f_out.write(block)

print(f"Saved full conversation text to {os.path.join(output_dir, 'all_chatgpt_conversation_blocks.txt')}")

# Extract headers (#, ##, ###, Q&A, Traps)
topic_pattern = re.compile(r'^(#{1,3})\s+(.+)$', re.MULTILINE)
question_pattern = re.compile(r'^(?:Q\d*[:.]|\*\*Q\d*[:.]|\d+\.\s+\*\*|\d+\.\s+)(.+?\?)', re.MULTILINE)

all_extracted_headers = []
all_extracted_questions = []

for block in long_strings:
    for match in topic_pattern.finditer(block):
        level = len(match.group(1))
        title = match.group(2).strip()
        all_extracted_headers.append({'level': level, 'title': title})
    
    for match in question_pattern.finditer(block):
        q = match.group(1).replace('**', '').strip()
        if len(q) > 10 and q not in all_extracted_questions:
            all_extracted_questions.append(q)

print(f"Extracted {len(all_extracted_headers)} headers across the conversation.")
print(f"Extracted {len(all_extracted_questions)} distinct questions across the conversation.")
