function pad(n){

    return String(n).padStart(2,"0");

}

function updateClock(){

    const el = document.getElementById("server-time");

    if(!el)
        return;

    const d = new Date();

    el.textContent =
        d.getFullYear() + "-" +
        pad(d.getMonth()+1) + "-" +
        pad(d.getDate()) + " " +
        pad(d.getHours()) + ":" +
        pad(d.getMinutes()) + ":" +
        pad(d.getSeconds());

}

updateClock();

setInterval(updateClock,1000);
