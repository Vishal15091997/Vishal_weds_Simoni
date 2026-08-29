$css = @"

@media (max-width: 768px) {
  .footer-compact-row {
      grid-template-columns: 1fr;
      gap: 1.5rem;
      text-align: center;
      padding: 1.5rem 1rem;
  }
  .countdown {
      justify-content: center;
      flex-direction: row;
      flex-wrap: wrap;
  }
  .wedding-seal {
      justify-self: center;
  }
  .footer-quote-inline {
      border-left: none;
      border-right: none;
      border-top: 1px solid rgba(212,175,55,0.3);
      border-bottom: 1px solid rgba(212,175,55,0.3);
      padding: 1rem 0 !important;
  }
}
"@

Add-Content style.css $css
