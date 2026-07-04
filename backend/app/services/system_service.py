import psutil
import shutil
import subprocess
import time


def get_cpu_usage():
    return round(psutil.cpu_percent(interval=0.5), 1)


def get_ram_usage():
    return round(psutil.virtual_memory().percent, 1)


def get_disk_usage():
    return round(shutil.disk_usage("/").used / shutil.disk_usage("/").total * 100, 1)


def get_uptime():

    uptime = time.time() - psutil.boot_time()

    days = int(uptime // 86400)

    hours = int((uptime % 86400) // 3600)

    return f"{days}d {hours}h"


def get_ocserv_status():

    result = subprocess.run(
        ["systemctl", "is-active", "ocserv"],
        capture_output=True,
        text=True
    )

    if result.stdout.strip() == "active":
        return "Online"

    return "Offline"
