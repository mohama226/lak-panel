@router.get("/dashboard/content")
async def dashboard_content(
    request: Request,
    lak_admin: str | None = Cookie(default=None),
):

    if lak_admin is None:
        return RedirectResponse("/login")

    return templates.TemplateResponse(
        "dashboard_content.html",
        {
            "request": request,
            "admin_id": lak_admin,

            # بعداً اینها از دیتابیس می‌آیند
            "users": 0,
            "admins": 1,
            "groups": 0,
            "servers": 0,
            "online": 0,
            "traffic": "0 GB",
            "backups": 0,
            "logs": 0,
        },
    )
