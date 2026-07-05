from typing import Optional
from datetime import datetime

from fastapi import APIRouter, Form, Request
from fastapi.responses import RedirectResponse
from fastapi.templating import Jinja2Templates

from app.core.settings import (
    get_dashboard_settings,
    update_dashboard_settings,
)

router = APIRouter()

templates = Jinja2Templates(directory="app/templates")


@router.get("/settings")
async def settings_page(request: Request):

    dashboard = get_dashboard_settings()

    return templates.TemplateResponse(
        "settings/index.html",
        {
            "request": request,
            "dashboard": dashboard,

            # برای navbar
            "server_time": datetime.now(),
            "panel_name": "LAK PANEL",
            "panel_version": "1.0.0",

            "title": "Panel Settings",
        },
    )


@router.post("/settings/dashboard")
async def save_dashboard_settings(

    auto_refresh: Optional[str] = Form(None),

    refresh_interval: int = Form(...),

):

    update_dashboard_settings(

        auto_refresh is not None,

        refresh_interval,

    )

    return RedirectResponse(
        "/settings",
        status_code=303,
    )
