from sqlalchemy.orm import Session
from sqlalchemy import or_

from app.db.models import AuditLog


class AuditRepository:

    def __init__(self, db: Session):
        self.db = db


    def list_user_activity(
        self,
        username: str,
        limit: int = 200,
    ):

        return (
            self.db.query(AuditLog)
            .filter(
                AuditLog.target_user == username
            )
            .order_by(
                AuditLog.created_at.desc()
            )
            .limit(limit)
            .all()
        )


    def list_paginated(
        self,
        username: str | None = None,
        page: int = 1,
        per_page: int = 10,
        search: str | None = None,
        date_from=None,
        date_to=None,
    ):

        query = self.db.query(AuditLog)


        if username:

            query = query.filter(
                AuditLog.target_user == username
            )


        if search:

            query = query.filter(
                or_(
                    AuditLog.action.ilike(
                        f"%{search}%"
                    ),
                    AuditLog.admin_username.ilike(
                        f"%{search}%"
                    ),
                    AuditLog.ip.ilike(
                        f"%{search}%"
                    ),
                    AuditLog.details.ilike(
                        f"%{search}%"
                    ),
                )
            )


        if date_from:

            query = query.filter(
                AuditLog.created_at >= date_from
            )


        if date_to:

            query = query.filter(
                AuditLog.created_at <= date_to
            )


        total = query.count()


        logs = (
            query
            .order_by(
                AuditLog.created_at.desc()
            )
            .offset(
                (page - 1) * per_page
            )
            .limit(
                per_page
            )
            .all()
        )


        return {
            "logs": logs,
            "page": page,
            "per_page": per_page,
            "total": total,
        }
