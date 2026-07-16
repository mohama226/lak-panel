@servers_bp.route("/servers")
def servers():
    # داده‌های نمونه — تو باید این‌ها را از دیتابیس یا سیستم واقعی بگیری
    servers = [
        {
            "id": 1,
            "name": "Server-1",
            "host": "185.128.137.219",
            "status": "online",
            "online_users": 12,
            "load": "0.32"
        },
        {
            "id": 2,
            "name": "Server-2",
            "host": "10.10.10.2",
            "status": "offline",
            "online_users": 0,
            "load": "-"
        }
    ]

    stats = {
        "total_servers": len(servers),
        "active_servers": len([s for s in servers if s["status"] == "online"]),
        "offline_servers": len([s for s in servers if s["status"] == "offline"]),
        "load_avg": "0.25"
    }

    return render_template("servers.html", servers=servers, stats=stats)
