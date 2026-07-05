// clock.js — نمایش ساعت و تاریخ شمسی زنده

(function () {

  function updateClock() {
    var timeEl = document.getElementById('clock-time');
    var dateEl = document.getElementById('clock-date');
    if (!timeEl || !dateEl) return;

    var now = new Date();

    // ساعت
    var h = String(now.getHours()).padStart(2, '0');
    var m = String(now.getMinutes()).padStart(2, '0');
    var s = String(now.getSeconds()).padStart(2, '0');
    timeEl.textContent = h + ':' + m + ':' + s;

    // تاریخ شمسی
    try {
      dateEl.textContent = new Intl.DateTimeFormat('fa-IR', {
        calendar: 'persian',
        weekday: 'long',
        year:    'numeric',
        month:   'long',
        day:     'numeric',
      }).format(now);
    } catch (e) {
      dateEl.textContent = now.toLocaleDateString('fa-IR');
    }
  }

  // چون اسکریپت آخر صفحه‌ست، المان‌ها وجود دارن — همین الان اجرا کن
  updateClock();
  setInterval(updateClock, 1000);

})();
