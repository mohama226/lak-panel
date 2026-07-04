from fastapi import APIRouter

from app.services.system_service import (
    get_cpu_usage,
    get_ram_usage,
    get_disk_usage,
    get_uptime,
    get_ocserv_status,
)

router = APIRouter()


@router.get("/api/dashboard")
async def dashboard_api():

    return {
        "cpu": get_cpu_usage(),
        "ram": get_ram_usage(),
        "disk": get_disk_usage(),
        "uptime": get_uptime(),
        "ocserv": get_ocserv_status(),
    }
