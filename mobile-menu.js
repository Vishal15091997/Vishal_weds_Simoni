document.addEventListener('DOMContentLoaded', () => {
  const hamburger = document.querySelector('.hamburger-menu');
  const drawer = document.getElementById('mobileDrawer');
  const overlay = document.getElementById('mobileDrawerOverlay');
  const closeBtn = document.querySelector('.drawer-close');
  
  const toggleMenu = () => {
    hamburger.classList.toggle('active');
    drawer.classList.toggle('active');
    overlay.classList.toggle('active');
    document.body.classList.toggle('mobile-menu-open');
  };

  if (hamburger && drawer && overlay && closeBtn) {
    hamburger.addEventListener('click', toggleMenu);
    closeBtn.addEventListener('click', toggleMenu);
    overlay.addEventListener('click', toggleMenu);
  }

  const dropdownBtns = document.querySelectorAll('.drawer-dropdown-btn');
  dropdownBtns.forEach(btn => {
    btn.addEventListener('click', (e) => {
      const dropdown = e.target.closest('.drawer-dropdown');
      dropdown.classList.toggle('open');
    });
  });
});
