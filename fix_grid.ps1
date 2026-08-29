$content = Get-Content style.css -Raw

$badBlock = @"
/* Enable horizontal scrolling for event cards on mobile */
@media (max-width: 768px) {
    .events-details {
        display: flex !important;
        flex-wrap: nowrap !important;
        overflow-x: auto !important;
        overflow-y: hidden !important;
        scroll-snap-type: x mandatory;
        -webkit-overflow-scrolling: touch;
        gap: 1.5rem;
        padding-bottom: 1.5rem; /* Add padding for the scrollbar */
        margin-left: -1.5rem;
        margin-right: -1.5rem;
        padding-left: 1.5rem;
        padding-right: 1.5rem;
    }
    
    .event-detail-card {
        min-width: 280px;
        scroll-snap-align: center;
        flex: 0 0 auto;
    }
    
    /* Also ensure the venue grid scrolls horizontally instead of squishing */
    .venue-sections {
        display: flex !important;
        flex-wrap: nowrap !important;
        overflow-x: auto !important;
        overflow-y: hidden !important;
        scroll-snap-type: x mandatory;
        -webkit-overflow-scrolling: touch;
        gap: 1.5rem;
        padding-bottom: 1.5rem;
        margin-left: -1.5rem;
        margin-right: -1.5rem;
        padding-left: 1.5rem;
        padding-right: 1.5rem;
    }
    
    .venue-card {
        min-width: 280px;
        scroll-snap-align: center;
        flex: 0 0 auto;
    }
}
"@

$goodBlock = @"
/* Ensure single column layout for grids on mobile to prevent squishing */
@media (max-width: 768px) {
    .events-details {
        grid-template-columns: 1fr !important;
    }
    .venue-sections {
        grid-template-columns: 1fr !important;
    }
}
"@

$content = $content.Replace($badBlock, $goodBlock)
Set-Content style.css -Value $content -Encoding UTF8
