import json
import re

path = '/Users/navneet/.gemini/antigravity-cli/brain/d395ff4c-c8f5-4e07-b7fb-1379a5f6400c/.system_generated/steps/3297/content.md'
out_path = '/Users/navneet/.gemini/antigravity-cli/brain/d395ff4c-c8f5-4e07-b7fb-1379a5f6400c/extracted_chatgpt_share.md'

with open(path, 'r', encoding='utf-8') as f:
    text = f.read()

# React router enqueue chunks
# Notice window.__reactRouterContext.streamController.enqueue("...")
enqueue_blocks = re.findall(r'streamController\.enqueue\("(.*?)"\);', text)
print(f"Found {len(enqueue_blocks)} stream enqueue blocks.")

# Let's also look for all parts strings: "parts",["..."] or similar
# In JSON / JS string literals:
# We can search for all long string chunks that contain markdown formatting (# or ##)
def unescape_js_string(s):
    try:
        return json.loads(f'"{s}"')
    except Exception:
        s = s.replace('\\"', '"').replace('\\n', '\n').replace('\\t', '\t').replace('\\/', '/')
        s = re.sub(r'\\u([0-9a-fA-F]{4})', lambda m: chr(int(m.group(1), 16)), s)
        return s

# Look for all occurrences of "# Advanced "
pattern = re.compile(r'# Advanced [^"\\]+')
matches = pattern.findall(text)
print(f"Found {len(matches)} occurrences of # Advanced headers.")

unique_headers = []
for m in matches:
    clean = m.strip()
    if clean not in unique_headers:
        unique_headers.append(clean)

for h in unique_headers:
    print(f"Header: {h}")

# Now let's extract the actual message blocks
# In ChatGPT share, message text is inside "parts", [ index ] or directly as strings.
# Let's extract all strings in the file that are markdown messages (len > 500)
# A regex to capture escaped strings:
raw_strings = re.findall(r'"((?:[^"\\]|\\.)*)"', text)
print(f"Total raw string literals found: {len(raw_strings)}")

extracted_messages = []
for s in raw_strings:
    if len(s) > 1000 and ('# ' in s or '## ' in s or '```' in s):
        # looks like a markdown message
        content = unescape_js_string(s)
        # Avoid duplicates or internal template strings
        if content not in extracted_messages and ('# ' in content or '```' in content):
            extracted_messages.append(content)

print(f"Extracted {len(extracted_messages)} long markdown messages.")

with open(out_path, 'w', encoding='utf-8') as out:
    for i, msg in enumerate(extracted_messages):
        out.write(f"\n\n{'='*80}\nMESSAGE BLOCK {i+1}\n{'='*80}\n\n")
        out.write(msg)

print(f"Saved extracted messages to {out_path}")
