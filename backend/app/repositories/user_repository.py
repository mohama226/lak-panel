from sqlalchemy.orm import Session

from app.db.models import VPNUser


class UserRepository:

    def __init__(self, db: Session):
        self.db = db

    def get_all(self):
        return (
            self.db.query(VPNUser)
            .order_by(VPNUser.id.desc())
            .all()
        )

    def get(self, username: str):
        return (
            self.db.query(VPNUser)
            .filter(VPNUser.username == username)
            .first()
        )

    def create(self, user: VPNUser):
        self.db.add(user)
        self.db.commit()
        self.db.refresh(user)
        return user

    def delete(self, user: VPNUser):
        self.db.delete(user)
        self.db.commit()
