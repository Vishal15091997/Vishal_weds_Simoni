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

  const hardcodedImages = {
    roka: ["photo1.jpg", "photo2.jpg", "photo3.jpg", "photo4.jpg", "photo5.jpg", "photo6.jpg", "photo7.jpg", "photo8.jpg"],
    engagement: ["ring.jpg"],
    haldi: ["haldi.jpg"],
    reception: ["vs.jpg"],
    sangeet: ["sangeet.jpg"],
    wedding: ["wedding.jpg"]
  };

  const files = hardcodedImages[folder] || [];
  if (!files.length) return;

  const images = files.map(file => `images/${folder}/${file}`);
  
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
    if (!items.length) return;

    const clones = items.map((item) => item.cloneNode(true));
    clones.forEach((clone) => track.appendChild(clone));

    let duplicationPasses = 0;
    while (track.scrollWidth <= track.clientWidth * 1.25 && duplicationPasses < 6) {
      const extra = Array.from(items).map((item) => item.cloneNode(true));
      extra.forEach((e) => track.appendChild(e));
      duplicationPasses += 1;
    }

    const loopBoundary = track.scrollWidth / 2;
    const scrollSpeed = window.innerWidth <= 768 ? 0.5 : 0.9;
    let isPaused = false;

    const stepTrack = () => {
      if (!track) return;
      if (!isPaused) {
        track.scrollLeft += scrollSpeed;
        if (track.scrollLeft >= loopBoundary) {
          track.scrollLeft -= loopBoundary;
        }
      }
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
