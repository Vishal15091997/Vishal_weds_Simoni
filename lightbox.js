document.addEventListener('DOMContentLoaded', () => {
  const lightboxOverlay = document.getElementById('lightboxOverlay');
  const lightboxImg = document.getElementById('lightboxImg');
  const lightboxClose = document.getElementById('lightboxClose');

  if (!lightboxOverlay || !lightboxImg || !lightboxClose) {
    return;
  }

  const openLightbox = (src) => {
    lightboxImg.src = src;
    lightboxImg.srcset = `${src} 1x, ${src} 2x`;
    lightboxImg.loading = 'lazy';
    lightboxImg.decoding = 'async';
    lightboxOverlay.classList.add('active');
  };

  document.body.addEventListener('click', (e) => {
    if (e.target.tagName !== 'IMG') return;

    const clickableParent = e.target.closest('.story-frame, .kid-frame, .track__item, .photo-frame');
    const active3DCard = e.target.closest('.faux-3d-card.active');

    if (clickableParent || active3DCard) {
      openLightbox(e.target.src);
    }
  });

  lightboxClose.addEventListener('click', () => lightboxOverlay.classList.remove('active'));
  lightboxOverlay.addEventListener('click', (e) => {
    if (e.target === lightboxOverlay) lightboxOverlay.classList.remove('active');
  });
});