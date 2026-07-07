from fastapi import Cookie
from fastapi import HTTPException

from app.db.database import SessionLocal
from app.db.models import Admin


def require_login(
    lak_admin: str | None = Cookie(default=None),
):

    if not lak_admin:
        raise HTTPException(status_code=401)

    db = SessionLocal()

    try:

        admin = (
            db.query(Admin)
            .filter(Admin.id == int(lak_admin))
            .first()
        )

        if not admin:
            raise HTTPException(status_code=401)

        return admin

    finally:

        db.close()
