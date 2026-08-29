from pathlib import Path

backup_root = Path(r'C:\Users\gupta\Downloads\Vishal_Simoni-backup\Vishal_Simoni-main')
root = Path(r'C:\Users\gupta\Downloads\Vishal_Simoni-main\Vishal_Simoni-main')

mobile_js_backup = backup_root / 'mobile-menu.js'
if not mobile_js_backup.exists():
    raise FileNotFoundError(f'Missing backup mobile-menu.js: {mobile_js_backup}')
root.joinpath('mobile-menu.js').write_bytes(mobile_js_backup.read_bytes())
print('Restored mobile-menu.js')

button_and_overlay = '''      <button class="hamburger-menu" aria-label="Toggle navigation menu">
        <span></span>
        <span></span>
        <span></span>
      </button>
    </nav>
    <div class="mobile-nav-overlay" id="mobileNavOverlay">
      <nav class="nav-links">
        <a href="index.html">Home</a>
        <a href="couple.html">The Couple</a>
        <div class="dropdown">
          <a href="event.html">Our Story</a>
          <div class="dropdown-content">
            <a href="roka.html">Roka</a>
            <a href="engagement.html">Engagement</a>
            <a href="sangeet.html">Sangeet</a>
            <a href="haldi.html">Haldi</a>
            <a href="wedding.html">Wedding</a>
            <a href="reception.html">Reception</a>
          </div>
        </div>
        <div class="dropdown">
          <a href="venue.html">Venue</a>
          <div class="dropdown-content">
            <a href="khajuraho-history.html">Khajuraho History</a>
          </div>
        </div>
        <a href="gallery.html">Gallery</a>
      </nav>
    </div>'''

for html_file in sorted(root.glob('*.html')):
    text = html_file.read_text(encoding='utf-8')
    changed = False
    if 'mobile-menu.js' not in text:
        text = text.replace('<script src="countdown.js"></script>', '<script src="countdown.js"></script>\n  <script src="mobile-menu.js"></script>', 1)
        if 'mobile-menu.js' in text:
            changed = True
    if 'id="mobileNavOverlay"' not in text and '<header class="topbar">' in text:
        if '</div>\n    </nav>' in text:
            text = text.replace('</div>\n    </nav>', button_and_overlay, 1)
            changed = True
    if changed:
        html_file.write_text(text, encoding='utf-8')
        print(f'Updated {html_file.name}')
