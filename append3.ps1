$css = @"

:root {
  color-scheme: light;
}

@media (max-width: 768px) {
  .card-divider {
    width: 80% !important;
    height: 3px !important;
    margin: 1.5rem auto !important;
    background: linear-gradient(90deg, transparent 0%, var(--gold) 20%, var(--gold) 80%, transparent 100%) !important;
  }
  .countdown div {
    min-width: 50px;
    padding: 0.2rem 0.3rem;
  }
  .countdown span {
    font-size: 1.1rem;
  }
  .countdown small {
    font-size: 0.5rem;
  }
  .footer-compact-row {
    gap: 0.8rem;
    padding: 1rem 0.5rem;
  }
  .footer-quote-inline {
    padding: 0.5rem 0 !important;
    font-size: 1rem !important;
  }
  .wedding-seal {
    transform: scale(0.85);
    margin: 0;
  }
}
"@

Add-Content style.css $css
