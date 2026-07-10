from datetime import datetime

from sqlalchemy.orm import Session

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
            .filter(UserLog.username == username)
            .order_by(UserLog.created_at.desc())
            .limit(limit)
            .all()
        )

    def list_paginated(
        self,
        username: str,
        page: int = 1,
        per_page: int = 10,
        date_from: str | None = None,
        date_to: str | None = None,
    ):

        query = (
            self.db.query(UserLog)
            .filter(UserLog.username == username)
        )

        if date_from:
            try:
                query = query.filter(
                    UserLog.created_at >= datetime.fromisoformat(date_from)
                )
            except Exception:
                pass

        if date_to:
            try:
                query = query.filter(
                    UserLog.created_at <= datetime.fromisoformat(date_to)
                )
            except Exception:
                pass

        total = query.count()

        logs = (
            query.order_by(UserLog.created_at.desc())
            .offset((page - 1) * per_page)
            .limit(per_page)
            .all()
        )

        return {
            "logs": logs,
            "page": page,
            "per_page": per_page,
            "total": total,
            "pages": (total + per_page - 1) // per_page,
        }

    def get_user_logs(
        self,
        username: str,
        limit: int = 200,
    ):
        return self.list(username, limit)

    def clear(
        self,
        username: str,
    ):
        (
            self.db.query(UserLog)
            .filter(UserLog.username == username)
            .delete()
        )

        self.db.commit()
