from sqlalchemy.orm import Session

from app.db.models import AuditLog


class AuditRepository:

    def __init__(self, db: Session):
        self.db = db

    def latest_for_user(self, username: str, limit: int = 100):
        return (
            self.db.query(AuditLog)
            .filter(AuditLog.target_user == username)
            .order_by(AuditLog.created_at.desc())
            .limit(limit)
            .all()
        )

    def latest(self, limit: int = 500):
        return (
            self.db.query(AuditLog)
            .order_by(AuditLog.created_at.desc())
            .limit(limit)
            .all()
        )
