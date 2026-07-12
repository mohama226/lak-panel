let dashboardTimer = null;

function setValue(id, value) {

    const el = document.getElementById(id);

    if (el)
        el.textContent = value;

}

function updateBar(barId, textId, value) {

    const bar = document.getElementById(barId);

    const text = document.getElementById(textId);

    if (!bar || !text)
        return;

    bar.style.width = value + "%";

    text.textContent = value + "%";

    bar.classList.remove(
        "green-bar",
        "yellow-bar",
        "orange-bar",
        "red-bar"
    );

    if (value < 50)
        bar.classList.add("green-bar");

    else if (value < 70)
        bar.classList.add("yellow-bar");

    else if (value < 90)
        bar.classList.add("orange-bar");

    else
        bar.classList.add("red-bar");

}

async function refreshDashboard() {

    try {

        const response = await fetch(
            "/api/dashboard/stats",
            {
                cache: "no-store"
            }
        );

        if (!response.ok)
            return;

        const data = await response.json();

        setValue("users-value", data.users);
        setValue("admins-value", data.admins);
        setValue("servers-value", data.servers);
        setValue("online-value", data.online);

        updateBar(
            "cpu-bar",
            "cpu-text",
            data.cpu
        );

        updateBar(
            "ram-bar",
            "ram-text",
            data.ram
        );

        updateBar(
            "disk-bar",
            "disk-text",
            data.disk
        );

        setValue(
            "load-value",
            data.load
        );

        setValue(
            "uptime-value",
            data.uptime
        );

        setValue(
            "upload-value",
            data.traffic_up + " MB"
        );

        setValue(
            "download-value",
            data.traffic_down + " MB"
        );

        setValue(
            "upload-speed",
            data.upload_speed + " KB/s"
        );

        setValue(
            "download-speed",
            data.download_speed + " KB/s"
        );

    }

    catch (err) {

        console.log(err);

    }

}

document.addEventListener(

    "DOMContentLoaded",

    () => {

        if (
            typeof window.dashboardSettings === "undefined"
        )
            return;

        refreshDashboard();

        if (!window.dashboardSettings.autoRefresh)
            return;

        dashboardTimer = setInterval(

            refreshDashboard,

            window.dashboardSettings.interval * 1000

        );

    }

);
