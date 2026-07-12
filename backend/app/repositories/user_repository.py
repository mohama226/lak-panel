from sqlalchemy.orm import Session
from sqlalchemy.orm import joinedload

from app.db.models import VPNUser


class UserRepository:

    def __init__(self, db: Session):
        self.db = db

    def get_all(self):
        return (
            self.db.query(VPNUser)
            .options(
                joinedload(VPNUser.server),
                joinedload(VPNUser.group),
            )
            .order_by(VPNUser.id.desc())
            .all()
        )

    def get(self, username: str):
        return (
            self.db.query(VPNUser)
            .options(
                joinedload(VPNUser.server),
                joinedload(VPNUser.group),
            )
            .filter(VPNUser.username == username)
            .first()
        )

    def create(self, user: VPNUser):
        self.db.add(user)
        self.db.commit()
        self.db.refresh(user)
        return user

    def update(self, user: VPNUser):
        self.db.commit()
        self.db.refresh(user)
        return user

    def delete(self, user: VPNUser):
        self.db.delete(user)
        self.db.commit()

    def count(self):
        return self.db.query(VPNUser).count()

    # -------------------------
    # User Actions
    # -------------------------

    def set_password(
        self,
        username: str,
        password: str,
    ):
        user = self.get(username)

        if not user:
            return None

        user.password = password

        return self.update(user)

    def set_expire(
        self,
        username: str,
        expire,
    ):
        user = self.get(username)

        if not user:
            return None

        user.expire = expire

        return self.update(user)

    def set_traffic(
        self,
        username: str,
        traffic: int,
    ):
        user = self.get(username)

        if not user:
            return None

        user.traffic = traffic

        return self.update(user)

    def set_enabled(
        self,
        username: str,
        enabled: bool,
    ):
        user = self.get(username)

        if not user:
            return None

        user.enabled = enabled

        return self.update(user)

    def set_suspended(
        self,
        username: str,
        suspended: bool,
    ):
        user = self.get(username)

        if not user:
            return None

        user.suspended = suspended

        return self.update(user)

    def set_blocked(
        self,
        username: str,
        blocked: bool,
    ):
        user = self.get(username)

        if not user:
            return None

        user.blocked = blocked

        return self.update(user)

    def edit(
        self,
        username: str,
        **kwargs,
    ):
        user = self.get(username)

        if not user:
            return None

        for key, value in kwargs.items():

            if hasattr(user, key):

                setattr(user, key, value)

        return self.update(user)
