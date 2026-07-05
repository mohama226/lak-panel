from fastapi import APIRouter, Cookie, Request
from fastapi.responses import RedirectResponse, JSONResponse

from app.core.template import render, get_setting

import psutil
import shutil
import time

router = APIRouter()

BOOT_TIME = psutil.boot_time()


def get_stats():

    vm = psutil.virtual_memory()

    du = shutil.disk_usage("/")

    cpu = psutil.cpu_percent(interval=0.2)

    ram = vm.percent

    disk = round((du.used / du.total) * 100)

    uptime_seconds = int(time.time() - BOOT_TIME)

    days = uptime_seconds // 86400
    hours = (uptime_seconds % 86400) // 3600

    uptime = f"{days}d {hours}h"

    try:
        load = "%.2f" % psutil.getloadavg()[0]
    except Exception:
        load = "0.00"

    network = psutil.net_io_counters()

    return {
        "cpu": cpu,
        "ram": ram,
        "disk": disk,
        "uptime": uptime,
        "load": load,
        "traffic_up": round(network.bytes_sent / 1024 / 1024, 2),
        "traffic_down": round(network.bytes_recv / 1024 / 1024, 2),
        "users": 0,
        "admins": 1,
        "groups": 0,
        "servers": 0,
        "online": 0,
        "backups": 0,
        "logs": 0,
    }


def get_dashboard_settings():

    return {
        "auto_refresh": get_setting(
            "dashboard_auto_refresh",
            "true",
        ) == "true",

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

    return JSONResponse(get_stats())
