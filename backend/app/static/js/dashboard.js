// ===============================
// LAK PANEL Live Dashboard
// ===============================

let dashboardTimer = null;

async function updateDashboard() {

    try {

        const response = await fetch("/api/dashboard/stats", {
            cache: "no-store"
        });

        if (!response.ok) {
            return;
        }

        const data = await response.json();

        const set = (id, value) => {
            const el = document.getElementById(id);
            if (el) el.textContent = value;
        };

        set("users", data.users);
        set("admins", data.admins);
        set("servers", data.servers);
        set("online", data.online);

        set("cpu", data.cpu + "%");
        set("ram", data.ram + "%");
        set("disk", data.disk + "%");

        set("uptime", data.uptime);
        set("load", data.load);

        set("upload", data.traffic_up + " MB");
        set("download", data.traffic_down + " MB");

        set("logs", data.logs);

    } catch (e) {

        console.log(e);

    }

}

function startDashboardRefresh() {

    if (dashboardTimer)
        clearInterval(dashboardTimer);

    let interval = 2000;

    if (
        window.dashboardSettings &&
        window.dashboardSettings.autoRefresh
    ) {

        interval =
            parseInt(window.dashboardSettings.interval) * 1000;

    }

    updateDashboard();

    dashboardTimer = setInterval(
        updateDashboard,
        interval
    );

}

document.addEventListener(
    "DOMContentLoaded",
    startDashboardRefresh
);
