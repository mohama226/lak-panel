from sqlalchemy.orm import Session
from sqlalchemy import or_

from app.db.models import UserLog


class UserLogRepository:

    def __init__(self, db: Session):
        self.db = db


    def create(
        self,
        username: str,
        event: str,
        ip: str = "",
        details: str = "",
    ):

        log = UserLog(
            username=username,
            event=event,
            ip=ip,
            details=details,
        )

        self.db.add(log)
        self.db.commit()
        self.db.refresh(log)

        return log


    def list(
        self,
        username: str,
        limit: int = 200,
    ):

        return (
            self.db.query(UserLog)
            .filter(
                UserLog.username == username
            )
            .order_by(
                UserLog.created_at.desc()
            )
            .limit(limit)
            .all()
        )


    def list_paginated(
        self,
        username: str,
        page: int = 1,
        per_page: int = 10,
        search: str | None = None,
        date_from=None,
        date_to=None,
    ):

        query = (
            self.db.query(UserLog)
            .filter(
                UserLog.username == username
            )
        )


        if search:

            query = query.filter(
                or_(
                    UserLog.event.ilike(
                        f"%{search}%"
                    ),
                    UserLog.details.ilike(
                        f"%{search}%"
                    ),
                    UserLog.ip.ilike(
                        f"%{search}%"
                    ),
                )
            )


        if date_from:

            query = query.filter(
                UserLog.created_at >= date_from
            )


        if date_to:

            query = query.filter(
                UserLog.created_at <= date_to
            )


        total = query.count()


        logs = (
            query
            .order_by(
                UserLog.created_at.desc()
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


    def get_user_logs(
        self,
        username: str,
        limit: int = 200,
    ):

        return self.list(
            username,
            limit
        )


    def clear(
        self,
        username: str,
    ):

        (
            self.db.query(UserLog)
            .filter(
                UserLog.username == username
            )
            .delete()
        )

        self.db.commit()
