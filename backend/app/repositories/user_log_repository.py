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

    def list(self, username: str):

        return (
            self.db.query(UserLog)
            .filter(UserLog.username == username)
            .order_by(UserLog.id.desc())
            .all()
        )

    def clear(self, username: str):

        self.db.query(UserLog).filter(
            UserLog.username == username
        ).delete()

        self.db.commit()
