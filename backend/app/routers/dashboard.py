from app.core.ocserv_cache import OcservCache
from fastapi import APIRouter, Cookie, Request
from fastapi.responses import RedirectResponse, JSONResponse

from app.core.template import render, get_setting

import shutil
import subprocess
import time

try:
    import psutil
except ImportError:
    psutil = None

router = APIRouter()

BOOT_TIME = time.time()

if psutil is not None:
    BOOT_TIME = psutil.boot_time()

LAST_NETWORK = {
    "sent": 0,
    "recv": 0,
    "time": time.time(),
}


def get_ocserv_status():

    try:

        result = subprocess.run(
            ["systemctl", "is-active", "ocserv"],
            capture_output=True,
            text=True,
            timeout=2,
        )

        return result.stdout.strip()

    except Exception:

        return "unknown"





def get_stats():

    if psutil is None:

        return {

            "cpu": 0,
            "ram": 0,
            "disk": 0,

            "uptime": "-",

            "load": "0.00",

            "traffic_up": 0,
            "traffic_down": 0,

            "upload_speed": 0,
            "download_speed": 0,

            "users": 0,
            "admins": 1,
            "groups": 0,
            "servers": 0,

            "online": 0,

            "backups": 0,
            "logs": 0,

            "ocserv_status": "unknown",

        }

    vm = psutil.virtual_memory()

    du = shutil.disk_usage("/")

    cpu = round(psutil.cpu_percent(interval=0.2), 1)

    ram = vm.percent

    disk = round((du.used / du.total) * 100)

    uptime_seconds = int(time.time() - BOOT_TIME)

    days = uptime_seconds // 86400

    hours = (uptime_seconds % 86400) // 3600

    minutes = (uptime_seconds % 3600) // 60

    uptime = f"{days}d {hours}h {minutes}m"

    try:

        load = "%.2f" % psutil.getloadavg()[0]

    except Exception:

        load = "0.00"

    network = psutil.net_io_counters()

    global LAST_NETWORK

    now = time.time()

    elapsed = max(now - LAST_NETWORK["time"], 1)

    upload_speed = (
        network.bytes_sent - LAST_NETWORK["sent"]
    ) / elapsed

    download_speed = (
        network.bytes_recv - LAST_NETWORK["recv"]
    ) / elapsed

    LAST_NETWORK = {

        "sent": network.bytes_sent,

        "recv": network.bytes_recv,

        "time": now,

    }

    return {

        "cpu": cpu,

        "ram": ram,

        "disk": disk,

        "uptime": uptime,

        "load": load,

        "traffic_up": round(
            network.bytes_sent / 1024 / 1024,
            2,
        ),

        "traffic_down": round(
            network.bytes_recv / 1024 / 1024,
            2,
        ),

        "upload_speed": round(
            upload_speed / 1024,
            2,
        ),

        "download_speed": round(
            download_speed / 1024,
            2,
        ),

        "users": 0,

        "admins": 1,

        "groups": 0,

        "servers": 0,

        "online": OcservCache.online_count(),

        "backups": 0,

        "logs": 0,

        "ocserv_status": get_ocserv_status(),

    }


def get_dashboard_settings():

    return {

        "auto_refresh": get_setting(
            "dashboard_auto_refresh",
            "true",
        ).lower() == "true",

        "refresh_interval": int(
            get_setting(
                "dashboard_refresh_interval",
                "2",
            )
        ),

    }


@router.get("/dashboard")
async def dashboard(
    request: Request,
    lak_admin: str | None = Cookie(default=None),
):

    if lak_admin is None:

        return RedirectResponse("/login")

    context = get_stats()

    context["admin_id"] = lak_admin

    context["dashboard"] = get_dashboard_settings()

    return render(
        request,
        "dashboard.html",
        context,
    )


@router.get("/dashboard/content")
async def dashboard_content(
    request: Request,
    lak_admin: str | None = Cookie(default=None),
):

    if lak_admin is None:

        return RedirectResponse("/login")

    context = get_stats()

    context["admin_id"] = lak_admin

    return render(
        request,
        "dashboard_content.html",
        context,
    )


@router.get("/api/dashboard/stats")
async def dashboard_api():

    return JSONResponse(
        get_stats()
    )
