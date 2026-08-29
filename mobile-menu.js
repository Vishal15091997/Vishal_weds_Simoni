document.addEventListener('DOMContentLoaded', () => {
  const hamburger = document.querySelector('.hamburger-menu');
  const overlay = document.getElementById('mobileNavOverlay');
  
  if (hamburger && overlay) {
    hamburger.addEventListener('click', () => {
      hamburger.classList.toggle('active');
      overlay.classList.toggle('active');
      document.body.classList.toggle('mobile-menu-open');
    });
  }

  const dropdownBtns = overlay.querySelectorAll('.mobile-dropdown-btn');
  dropdownBtns.forEach(btn => {
    btn.addEventListener('click', (e) => {
      const dropdown = e.target.closest('.mobile-dropdown');
      dropdown.classList.toggle('open');
    });
  });
});
