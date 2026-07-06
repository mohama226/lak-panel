from datetime import datetime

from app.db.models import VPNUser
from app.services.ocserv_service import OcservService


class UserService:

    def __init__(self, repo):
        self.repo = repo

    def list(self):
        return self.repo.get_all()

    def get(self, username: str):
        return self.repo.get(username)

    def create(self, data):

        exists = self.repo.get(data.username)

        if exists:
            raise Exception("Username already exists")

        # ساخت کاربر داخل ocserv
        OcservService.add_user(
            data.username,
            data.password,
        )

        user = VPNUser(
            username=data.username,
            password="",
            expire=data.expire,
            traffic=data.traffic,
            enabled=True,
            server_id=data.server_id,
            group_id=data.group_id,
        )

        return self.repo.create(user)

    def delete(self, username: str):

        user = self.repo.get(username)

        if not user:
            raise Exception("User not found")

        OcservService.delete_user(username)

        self.repo.delete(user)

    def enable(self, username: str):

        user = self.repo.get(username)

        if not user:
            raise Exception("User not found")

        user.enabled = True

        return self.repo.update(user)

    def disable(self, username: str):

        user = self.repo.get(username)

        if not user:
            raise Exception("User not found")

        user.enabled = False

        return self.repo.update(user)
