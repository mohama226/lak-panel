from contextlib import closing
from datetime import datetime
from zoneinfo import ZoneInfo

from app.db.database import SessionLocal
from app.db.models import Setting


def get_setting(key: str, default: str):

    with closing(SessionLocal()) as db:

        item = (
            db.query(Setting)
            .filter(Setting.key == key)
            .first()
        )

        if item:
            return item.value

    return default


def template_context():

    timezone = get_setting(
        "timezone",
        "Asia/Tehran",
    )

    try:

        now = datetime.now(
            ZoneInfo(timezone)
        )

    except Exception:

        now = datetime.now()

    return {

        "server_time": now,
        "panel_name": "LAK PANEL",
        "panel_version": "v1.0.0",

    }
