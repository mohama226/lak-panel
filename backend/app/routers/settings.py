from contextlib import closing

from fastapi import APIRouter, Form, Request
from fastapi.responses import RedirectResponse

from app.core.template import render
from app.db.database import SessionLocal
from app.db.models import Setting

router = APIRouter()


def get_setting(db, key, default=""):

    item = (
        db.query(Setting)
        .filter(Setting.key == key)
        .first()
    )

    if item:
        return item.value

    return default


def set_setting(db, key, value):

    item = (
        db.query(Setting)
        .filter(Setting.key == key)
        .first()
    )

    if item:
        item.value = str(value)
    else:
        db.add(
            Setting(
                key=key,
                value=str(value),
            )
        )

    db.commit()


@router.get("/settings")
async def settings_page(request: Request):

    with closing(SessionLocal()) as db:

        dashboard = {

            "auto_refresh":
                get_setting(
                    db,
                    "dashboard_auto_refresh",
                    "true",
                ) == "true",

            "refresh_interval":
                int(
                    get_setting(
                        db,
                        "dashboard_refresh_interval",
                        "2",
                    )
                ),

        }

    return render(
        request,
        "settings/index.html",
        {
            "dashboard": dashboard,
        },
    )


@router.post("/settings/dashboard")
async def save_dashboard(

    auto_refresh: str | None = Form(default=None),
    refresh_interval: int = Form(...),

):

    with closing(SessionLocal()) as db:

        set_setting(
            db,
            "dashboard_auto_refresh",
            "true" if auto_refresh else "false",
        )

        set_setting(
            db,
            "dashboard_refresh_interval",
            refresh_interval,
        )

    return RedirectResponse(
        "/settings",
        status_code=303,
    )
