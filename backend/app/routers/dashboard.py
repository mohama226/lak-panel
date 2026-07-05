from datetime import datetime

from fastapi import APIRouter, Cookie, Request
from fastapi.responses import RedirectResponse
from fastapi.templating import Jinja2Templates

router = APIRouter()

templates = Jinja2Templates(directory="app/templates")


@router.get("/dashboard")
async def dashboard(
    request: Request,
    lak_admin: str | None = Cookie(default=None),
):

    if lak_admin is None:
        return RedirectResponse("/login", status_code=302)

    return templates.TemplateResponse(
        "dashboard.html",
        {
            "request": request,
            "admin_id": lak_admin,
            "server_time": datetime.now(),
        },
    )
