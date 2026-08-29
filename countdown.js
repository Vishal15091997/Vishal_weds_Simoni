(function() {
  const targetDate = new Date("Nov 20, 2026 00:00:00").getTime();
  const updateTimer = () => {
    const now = new Date().getTime();
    const distance = targetDate - now;
    if (distance <= 0) {
      const countdownEl = document.querySelector('.countdown');
      if (countdownEl) countdownEl.textContent = 'It is Wedding Day!';
      if (typeof intervalId !== 'undefined') clearInterval(intervalId);
      return;
    }
    const days = Math.floor(distance / (1000 * 60 * 60 * 24));
    const hours = Math.floor((distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
    const minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
    const seconds = Math.floor((distance % (1000 * 60)) / 1000);
    
    const daysEl = document.getElementById('days');
    const hoursEl = document.getElementById('hours');
    const minutesEl = document.getElementById('minutes');
    const secondsEl = document.getElementById('seconds');

    if (daysEl) daysEl.textContent = days;
    if (hoursEl) hoursEl.textContent = hours.toString().padStart(2, '0');
    if (minutesEl) minutesEl.textContent = minutes.toString().padStart(2, '0');
    if (secondsEl) secondsEl.textContent = seconds.toString().padStart(2, '0');
  };
  const intervalId = setInterval(updateTimer, 1000);
  updateTimer();
})();