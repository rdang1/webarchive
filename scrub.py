import sys
from pathlib import Path
from bs4 import BeautifulSoup

try:
    filepath = Path(sys.argv[1])
    
    content = filepath.read_text(encoding='utf-8', errors='ignore')
    soup = BeautifulSoup(content, 'html.parser')

    for tag_name in ['script', 'noscript']:
        for tag in soup.find_all(tag_name):
            tag.decompose()

    for tag in soup.find_all(True):
        attrs = list(tag.attrs.keys()) 
        for attr in attrs:
            if attr.startswith('on'):
                del tag.attrs[attr]
    
    filepath.write_text(str(soup), encoding='utf-8')

except Exception as e:
    pass
