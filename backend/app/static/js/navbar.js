function pad(v){

    return String(v).padStart(2,"0");

}

function updateNavbarClock(){

    const el = document.getElementById("server-time");

    if(!el)
        return;

    const now = new Date();

    el.textContent =
        now.getFullYear() + "-" +
        pad(now.getMonth()+1) + "-" +
        pad(now.getDate()) + " " +
        pad(now.getHours()) + ":" +
        pad(now.getMinutes()) + ":" +
        pad(now.getSeconds());

}

updateNavbarClock();

setInterval(updateNavbarClock,1000);

async function refreshNavbarStatus(){

    try{

        const r = await fetch(
            "/api/dashboard/stats",
            {
                cache:"no-store"
            }
        );

        if(!r.ok)
            return;

        const data = await r.json();

        const badge = document.querySelector(".badge");

        if(!badge)
            return;

        if(data.ocserv_status==="active"){

            badge.className="badge success";

            badge.innerHTML='<i class="fa-solid fa-circle"></i> OCServ Online';

        }else{

            badge.className="badge danger";

            badge.innerHTML='<i class="fa-solid fa-circle"></i> OCServ Offline';

        }

    }catch(e){

        console.log(e);

    }

}

refreshNavbarStatus();

setInterval(refreshNavbarStatus,5000);
