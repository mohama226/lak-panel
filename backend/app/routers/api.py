from fastapi import APIRouter
from sqlalchemy import func

from app.db.database import SessionLocal
from app.db.models import Admin, VPNUser, Group, Server

router = APIRouter(prefix="/api")


@router.get("/dashboard")
def dashboard_stats():

    db = SessionLocal()

    try:

        return {
            "users": db.query(func.count(VPNUser.id)).scalar() or 0,
            "admins": db.query(func.count(Admin.id)).scalar() or 0,
            "groups": db.query(func.count(Group.id)).scalar() or 0,
            "servers": db.query(func.count(Server.id)).scalar() or 0,
        }

    finally:
        db.close()
