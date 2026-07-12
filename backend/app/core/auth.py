from contextlib import closing

from fastapi import Cookie
from fastapi import HTTPException

from app.db.database import SessionLocal
from app.db.models import Admin


def require_login(
    lak_admin: str | None = Cookie(default=None),
):

    if not lak_admin:
        raise HTTPException(status_code=401)

    with closing(SessionLocal()) as db:

        admin = (
            db.query(Admin)
            .filter(Admin.id == int(lak_admin))
            .first()
        )

        if admin is None:
            raise HTTPException(status_code=401)

        admin_id = admin.id
        admin_username = admin.username
        admin_fullname = admin.fullname
        admin_role_id = admin.role_id

    return {
        "id": admin_id,
        "username": admin_username,
        "fullname": admin_fullname,
        "role_id": admin_role_id,
    }
