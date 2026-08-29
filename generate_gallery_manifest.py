import json
from pathlib import Path

GALLERY_DIR = Path(__file__).resolve().parent / 'Gallery'
MANIFEST_FILE = GALLERY_DIR / 'manifest.json'

if not GALLERY_DIR.exists():
    raise SystemExit(f'Gallery directory does not exist: {GALLERY_DIR}')

images = sorted(
    [p.name for p in GALLERY_DIR.iterdir() if p.is_file() and p.suffix.lower() in {'.jpg', '.jpeg', '.png'}]
)

MANIFEST_FILE.write_text(json.dumps(images, indent=2) + '\n', encoding='utf-8')
print(f'Wrote {len(images)} gallery image entries to {MANIFEST_FILE}')
