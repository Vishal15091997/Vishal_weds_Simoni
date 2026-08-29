document.addEventListener('DOMContentLoaded', () => {
  document.querySelectorAll('img').forEach(img => {
    if (!img.getAttribute('src')) return;
    if (!img.hasAttribute('srcset')) {
      const src = img.getAttribute('src');
      img.setAttribute('srcset', `${src} 1x, ${src} 2x`);
    }
    if (!img.hasAttribute('loading')) img.setAttribute('loading', 'lazy');
    if (!img.hasAttribute('decoding')) img.setAttribute('decoding', 'async');
  });
});
