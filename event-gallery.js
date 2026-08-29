document.addEventListener('DOMContentLoaded', () => {
  const pageName = window.location.pathname.split('/').pop().replace('.html', '');
  const folderMap = {
    roka: 'roka',
    engagement: 'engagement',
    sangeet: 'sangeet',
    haldi: 'haldi',
    wedding: 'wedding',
    reception: 'reception'
  };

  const folder = folderMap[pageName] || pageName;
  const track = document.querySelector('.track');
  const fauxTrack = document.querySelector('.faux-3d-track');

  if (!folder || (!track && !fauxTrack)) {
    return;
  }

  const perPageNames = {
    roka: ['photo1.jpg', 'photo2.jpg', 'photo3.jpg', 'photo4.jpg', 'photo5.jpg', 'photo6.jpg', 'photo7.jpg', 'photo8.jpg'],
    engagement: ['ring.jpg', 'engagement.jpg', 'engagement.jpeg', 'engagement.png'],
    sangeet: ['sangeet.jpg', 'photo1.jpg', 'photo2.jpg', 'photo3.jpg', 'photo4.jpg'],
    haldi: ['haldi.jpg', 'photo1.jpg', 'photo2.jpg', 'photo3.jpg', 'photo4.jpg'],
    wedding: ['wedding.jpg', 'photo1.jpg', 'photo2.jpg', 'photo3.jpg', 'photo4.jpg'],
    reception: ['vs.jpg', 'reception.jpg', 'reception.jpeg', 'reception.png']
  };

  const candidateNames = perPageNames[folder] || [];
  for (let i = 1; i <= 8; i += 1) {
    candidateNames.push(`photo${i}.jpg`);
    candidateNames.push(`photo${i}.jpeg`);
    candidateNames.push(`photo${i}.png`);
  }

  const fallbackNames = [
    `${folder}.jpg`,
    `${folder}.jpeg`,
    `${folder}.png`,
    'image.jpg',
    'image.jpeg',
    'image.png',
    'cover.jpg',
    'cover.png',
    '1.jpg',
    '2.jpg',
    '3.jpg'
  ];

  const imageUrls = [];
  const seen = new Set();

  const addIfNew = (url) => {
    if (!seen.has(url)) {
      seen.add(url);
      imageUrls.push(url);
    }
  };

  [...candidateNames, ...fallbackNames].forEach((name) => addIfNew(`images/${folder}/${name}`));

  const loadImage = (src) => new Promise((resolve) => {
    const img = new Image();
    img.onload = () => resolve(src);
    img.onerror = () => resolve(null);
    img.src = src;
  });

  const discoverImages = async () => {
    const results = [];
    for (const src of imageUrls) {
      const resolved = await loadImage(src);
      if (resolved) {
        results.push(resolved);
      }
    }

    if (results.length === 0) {
      return [];
    }

    return results;
  };

  discoverImages().then((images) => {
    if (!images.length) {
      return;
    }

    const frameCount = Math.max(images.length, 9);
    const loopedImages = Array.from({ length: frameCount }, (_, index) => images[index % images.length]);

    if (track) {
      track.innerHTML = '';
      loopedImages.forEach((src, index) => {
        const item = document.createElement('li');
        item.className = 'track__item';
        const img = document.createElement('img');
        img.src = src;
        img.srcset = `${src} 1x, ${src} 2x`;
        img.loading = 'lazy';
        img.decoding = 'async';
        img.alt = `${folder} memory ${index + 1}`;
        item.appendChild(img);
        track.appendChild(item);
      });

      const items = Array.from(track.querySelectorAll('.track__item'));
      if (!items.length) {
        return;
      }

      const clones = items.map((item) => item.cloneNode(true));
      clones.forEach((clone) => track.appendChild(clone));

      // If the cloned set is still not wider than the viewport, keep duplicating
      // until we have enough overflow to scroll. This prevents a static layout
      // when there are very few images.
      let duplicationPasses = 0;
      while (track.scrollWidth <= track.clientWidth * 1.25 && duplicationPasses < 6) {
        const extra = Array.from(items).map((item) => item.cloneNode(true));
        extra.forEach((e) => track.appendChild(e));
        duplicationPasses += 1;
      }

      const loopBoundary = track.scrollWidth / 2;

      const scrollSpeed = window.innerWidth <= 768 ? 0.5 : 0.9; // slightly faster for visibility
      let isPaused = false;

      const stepTrack = () => {
        if (!track) {
          return;
        }

        if (!isPaused) {
          track.scrollLeft += scrollSpeed;
          if (track.scrollLeft >= loopBoundary) {
            track.scrollLeft -= loopBoundary;
          }
        }

        // add a CSS class for debugging/visibility when RAF is running
        track.classList.add('is-animating');

        window.eventGalleryScrollRaf = window.requestAnimationFrame(stepTrack);
      };

      track.addEventListener('mouseenter', () => { isPaused = true; });
      track.addEventListener('mouseleave', () => { isPaused = false; });

      if (window.eventGalleryScrollRaf) {
        window.cancelAnimationFrame(window.eventGalleryScrollRaf);
      }

      track.scrollLeft = 0;
      window.eventGalleryScrollRaf = window.requestAnimationFrame(stepTrack);
      return;
    }

    if (fauxTrack) {
      fauxTrack.innerHTML = '';
      const cards = [];
      let activeIndex = 0;

      const renderCards = () => {
        cards.forEach((card, index) => {
          const offset = (index - activeIndex + cards.length) % cards.length;
          const normalizedOffset = offset > cards.length / 2 ? offset - cards.length : offset;
          const distance = Math.abs(normalizedOffset);

          const curveFactor = Math.sin(normalizedOffset * 0.9);
          const amplitudeX = 110;
          const amplitudeZ = 60;
          const amplitudeY = 28;

          const x = normalizedOffset * amplitudeX;
          const z = -40 - distance * amplitudeZ;
          const y = curveFactor * amplitudeY;
          const rotation = normalizedOffset * 18;
          const scale = distance === 0 ? 1 : distance === 1 ? 0.96 : 0.86;
          const isActive = distance === 0;
          const isNear = distance <= 1;

          card.classList.toggle('active', isActive);
          card.classList.toggle('near', isNear);
          card.style.transform = `translate3d(-50%,-50%,0) translate3d(${x}px, ${y}px, ${z}px) rotateY(${rotation}deg) scale(${scale})`;
          card.style.zIndex = String(40 - distance);
          card.style.opacity = isActive ? '1' : isNear ? '0.95' : '0.55';
        });
      };

      loopedImages.forEach((src, index) => {
        const card = document.createElement('div');
        card.className = 'faux-3d-card';

        const bg = document.createElement('div');
        bg.className = 'card-bg';
        bg.style.backgroundImage = `url(${src})`;
        bg.style.backgroundSize = 'cover';
        bg.style.backgroundPosition = 'center';
        bg.style.filter = 'blur(16px)';
        bg.style.transform = 'scale(1.06)';
        card.appendChild(bg);

        const img = document.createElement('img');
        img.src = src;
        img.srcset = `${src} 1x, ${src} 2x`;
        img.loading = 'lazy';
        img.decoding = 'async';
        img.alt = `${folder} memory ${index + 1}`;
        img.style.position = 'relative';
        img.style.zIndex = '2';
        card.appendChild(img);

        fauxTrack.appendChild(card);
        cards.push(card);
      });

      renderCards();

      window.clearInterval(window.eventGalleryRotateTimer);
      window.eventGalleryRotateTimer = window.setInterval(() => {
        activeIndex = (activeIndex + 1) % cards.length;
        renderCards();
      }, 4000);
    }
  });
});
