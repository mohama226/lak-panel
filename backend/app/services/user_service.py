from sqlalchemy.orm import Session

from app.db.models import VPNUser
from app.repositories.user_repository import UserRepository
from app.services.ocserv_service import OcservService


class UserService:

    def __init__(self, db: Session):
        self.repo = UserRepository(db)

    def list(self):
        return self.repo.get_all()

    def get(self, username: str):
        return self.repo.get(username)

    def create(
        self,
        username: str,
        password: str,
        expire=None,
        traffic: int = 0,
        group_id=None,
        server_id=None,
    ):

        exists = self.repo.get(username)

        if exists:
            raise ValueError("User already exists.")

        OcservService.add_user(
            username=username,
            password=password,
        )

        user = VPNUser(
            username=username,
            password="ocserv",
            expire=expire,
            traffic=traffic,
            enabled=True,
            group_id=group_id,
            server_id=server_id,
        )

        return self.repo.create(user)

    def delete(self, username: str):

        user = self.repo.get(username)

        if not user:
            raise ValueError("User not found.")

        OcservService.delete_user(username)

        self.repo.delete(user)

        return True

    def enable(self, username: str):

        user = self.repo.get(username)

        if not user:
            raise ValueError("User not found.")

        user.enabled = True

        return self.repo.update(user)

    def disable(self, username: str):

        user = self.repo.get(username)

        if not user:
            raise ValueError("User not found.")

        user.enabled = False

        return self.repo.update(user)

    def change_password(
        self,
        username: str,
        password: str,
    ):

        user = self.repo.get(username)

        if not user:
            raise ValueError("User not found.")

        OcservService.delete_user(username)

        OcservService.add_user(
            username=username,
            password=password,
        )

        return user
