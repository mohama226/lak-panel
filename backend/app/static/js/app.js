async function refreshDashboard() {

    const cpu = document.getElementById("cpu");

    if (!cpu)
        return;

    const response = await fetch("/api/dashboard");
    const data = await response.json();

    document.getElementById("cpu").innerText = data.cpu + " %";
    document.getElementById("ram").innerText = data.ram + " %";
    document.getElementById("disk").innerText = data.disk + " %";
    document.getElementById("uptime").innerText = data.uptime;
    document.getElementById("ocserv").innerText = data.ocserv;
}

refreshDashboard();
setInterval(refreshDashboard, 5000);
