let refreshTimer = null;

function updateDashboard() {

    fetch("/api/dashboard/stats")
        .then(r => r.json())
        .then(data => {

            const map = {
                users: data.users,
                admins: data.admins,
                servers: data.servers,
                online: data.online
            };

            document.querySelectorAll(".stat-card").forEach(card => {

                const title = card.querySelector(".stat-title").innerText.toLowerCase();

                const value = card.querySelector(".stat-value");

                if (title.includes("users"))
                    value.innerText = map.users;

                else if (title.includes("admins"))
                    value.innerText = map.admins;

                else if (title.includes("servers"))
                    value.innerText = map.servers;

                else if (title.includes("online"))
                    value.innerText = map.online;

            });

            const progressCards = document.querySelectorAll(".progress-card");

            if (progressCards.length >= 3) {

                // CPU
                progressCards[0].querySelector(".progress-bar").style.width = data.cpu + "%";
                progressCards[0].querySelector(".progress-header span:last-child").innerText = data.cpu + "%";

                // RAM
                progressCards[1].querySelector(".progress-bar").style.width = data.ram + "%";
                progressCards[1].querySelector(".progress-header span:last-child").innerText = data.ram + "%";

                // Disk
                progressCards[2].querySelector(".progress-bar").style.width = data.disk + "%";
                progressCards[2].querySelector(".progress-header span:last-child").innerText = data.disk + "%";
            }

            const info = document.querySelectorAll(".info-card");

            if (info.length >= 4) {

                info[0].querySelector("p").innerText = data.load;

                info[1].querySelector("p").innerText = data.uptime;

                info[2].querySelector("p").innerText = data.traffic_up + " MB";

                info[3].querySelector("p").innerText = data.traffic_down + " MB";

            }

        })
        .catch(() => {});
}

document.addEventListener("DOMContentLoaded", () => {

    if (typeof window.dashboardSettings === "undefined")
        return;

    if (!window.dashboardSettings.autoRefresh)
        return;

    refreshTimer = setInterval(

        updateDashboard,

        window.dashboardSettings.interval * 1000

    );

});
