import os
import re
from html.parser import HTMLParser

class LinkParser(HTMLParser):
    def __init__(self):
        super().__init__()
        self.refs = []
        self.ids = []

    def handle_starttag(self, tag, attrs):
        for k, v in attrs:
            if k in ('src', 'href') and v:
                self.refs.append(v)
            if k == 'id' and v:
                self.ids.append(v)

root = os.getcwd()
html_files = sorted([f for f in os.listdir(root) if f.endswith('.html')])
issues = []
for fn in html_files:
    with open(fn, 'r', encoding='utf8') as f:
        text = f.read()
    parser = LinkParser()
    parser.feed(text)
    for ref in parser.refs:
        if re.match(r'^(https?:|mailto:|tel:|#|//|data:)', ref, re.I):
            continue
        normalized = os.path.normpath(os.path.join(root, ref.lstrip('/\\')))
        if not os.path.exists(normalized):
            issues.append((fn, 'MISSING', ref, normalized))
    counts = {}
    for idv in parser.ids:
        counts[idv] = counts.get(idv, 0) + 1
    for idv, count in counts.items():
        if count > 1:
            issues.append((fn, 'DUPLICATE_ID', idv, count))

print('checked', len(html_files), 'html files')
for issue in issues:
    if issue[1] == 'MISSING':
        print(f'{issue[0]}: missing ref {issue[2]} -> {issue[3]}')
    else:
        print(f'{issue[0]}: duplicate id {issue[2]} repeated {issue[3]} times')
print('total issues', len(issues))
