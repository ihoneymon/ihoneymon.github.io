#!/usr/bin/env python3
"""Jekyll to Hugo post migration script."""
import os
import re

SRC = '/Users/honeymon/git-repos/ihoneymon.github.io/_posts'
DST = '/Users/honeymon/git-repos/ihoneymon.github.io/content/posts'

os.makedirs(DST, exist_ok=True)


def fix_liquid_urls(text):
    """Convert Jekyll liquid URL filters to plain paths."""
    # {{ "/assets/post/..." | absolute_url }} -> /assets/post/...
    # {{"/.../path.png" | absolute_url }} -> /.../path.png
    text = re.sub(
        r'\{\{["\s]*(/[^"}\s]+)["\s]*\|\s*(?:absolute_url|relative_url)\s*\}\}',
        r'\1',
        text
    )
    return text


def convert_frontmatter(fm):
    """Clean up Jekyll front matter for Hugo."""
    # Remove layout field
    fm = re.sub(r'^layout:\s*.+\n', '', fm, flags=re.MULTILINE)
    # Rename category -> categories (Hugo taxonomy uses plural)
    fm = re.sub(r'^category:', 'categories:', fm, flags=re.MULTILINE)
    return fm


migrated = 0
for filename in sorted(os.listdir(SRC)):
    if not (filename.endswith('.md') or filename.endswith('.markdown')):
        continue

    src_path = os.path.join(SRC, filename)
    dst_filename = filename.replace('.markdown', '.md')
    dst_path = os.path.join(DST, dst_filename)

    with open(src_path, 'r', encoding='utf-8') as f:
        content = f.read()

    if content.startswith('---'):
        parts = content.split('---', 2)
        if len(parts) >= 3:
            fm = convert_frontmatter(parts[1])
            body = fix_liquid_urls(parts[2])
            content = '---' + fm + '---' + body

    with open(dst_path, 'w', encoding='utf-8') as f:
        f.write(content)

    migrated += 1
    print(f"  {filename}")

print(f"\nMigrated {migrated} posts to {DST}")
