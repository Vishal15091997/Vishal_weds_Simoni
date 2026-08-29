$css = @"

@media (max-width: 768px) {
  .footer-content { flex-direction: column; justify-content: center; gap: 1.5rem; }
  .footer-text { text-align: center; max-width: 100%; margin: 0 auto; }
  .countdown { justify-content: center; flex-wrap: wrap; }
  .brand { font-size: 1.8rem; }
  .glass-card { padding: 1.5rem 1rem; margin: 0 1rem; width: auto; max-width: 90%; }
  .glass-card h1 { font-size: 2.5rem; }
  .loader-text { font-size: 1.3rem; text-align: center; width: 100%; }
  .hero { min-height: 70vh; }
  .info-grid { padding: 0 1rem; box-sizing: border-box; overflow: hidden; }
  .story-images { width: 100%; padding: 0 1rem; box-sizing: border-box; overflow: hidden; }
  .section-block h2, .section-block h3 { font-size: 2rem; }
  .image-wrapper { width: 100%; }
}
"@

Add-Content style.css $css
