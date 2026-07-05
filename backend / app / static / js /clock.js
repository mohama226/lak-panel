(function () {
  function updateClock() {
    var el = document.getElementById('datetime');
    if (!el) return;

    var now = new Date();
    var h = String(now.getHours()).padStart(2, '0');
    var m = String(now.getMinutes()).padStart(2, '0');
    var s = String(now.getSeconds()).padStart(2, '0');
    var time = h + ':' + m + ':' + s;

    try {
      var date = new Intl.DateTimeFormat('fa-IR', {
        calendar: 'persian',
        weekday: 'long',
        year:    'numeric',
        month:   'long',
        day:     'numeric',
      }).format(now);
      el.textContent = date + ' | ' + time;
    } catch (e) {
      el.textContent = time;
    }
  }

  updateClock();
  setInterval(updateClock, 1000);
})();
