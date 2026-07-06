from datetime import datetime

from app.db.models import VPNUser
from app.services.ocserv_service import OcservService


class UserService:

    def __init__(self, repo, log_repo):
        self.repo = repo
        self.log_repo = log_repo

    # --------------------------------
    # Users
    # --------------------------------

    def list(self):
        return self.repo.get_all()

    def get(self, username):
        return self.repo.get(username)

    def logs(self, username):
        return self.log_repo.list(username)

    # --------------------------------
    # Create
    # --------------------------------

    def create(self, data):

        if self.repo.get(data.username):
            raise Exception("Username already exists")

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
            suspended=False,
            blocked=False,
            server_id=data.server_id,
            group_id=data.group_id,
        )

        self.repo.create(user)

        self.log_repo.create(
            data.username,
            "CREATE",
            details="User created",
        )

        return user

    # --------------------------------
    # Delete
    # --------------------------------

    def delete(self, username):

        user = self.repo.get(username)

        if not user:
            raise Exception("User not found")

        OcservService.delete_user(username)

        self.repo.delete(user)

        self.log_repo.create(
            username,
            "DELETE",
            details="User deleted",
        )

    # --------------------------------
    # Password
    # --------------------------------

    def change_password(
        self,
        username,
        password,
    ):

        user = self.repo.get(username)

        if not user:
            raise Exception("User not found")

        OcservService.change_password(
            username,
            password,
        )

        self.repo.set_password(
            username,
            "",
        )

        self.log_repo.create(
            username,
            "PASSWORD",
            details="Password changed",
        )

        return True

    # --------------------------------
    # Expire
    # --------------------------------

    def extend(
        self,
        username,
        expire: datetime,
    ):

        user = self.repo.get(username)

        if not user:
            raise Exception("User not found")

        self.repo.set_expire(
            username,
            expire,
        )

        self.log_repo.create(
            username,
            "EXTEND",
            details=f"Expire changed to {expire}",
        )

        return True

    # --------------------------------
    # Traffic
    # --------------------------------

    def reset_traffic(
        self,
        username,
    ):

        user = self.repo.get(username)

        if not user:
            raise Exception("User not found")

        self.repo.set_traffic(
            username,
            0,
        )

        self.log_repo.create(
            username,
            "RESET_TRAFFIC",
            details="Traffic reset",
        )

        return True

    # --------------------------------
    # Enable / Disable
    # --------------------------------

    def enable(self, username):

        if not self.repo.set_enabled(username, True):
            raise Exception("User not found")

        self.log_repo.create(
            username,
            "ENABLE",
        )

    def disable(self, username):

        if not self.repo.set_enabled(username, False):
            raise Exception("User not found")

        self.log_repo.create(
            username,
            "DISABLE",
        )

    # --------------------------------
    # Suspend
    # --------------------------------

    def suspend(self, username):

        if not self.repo.set_suspended(username, True):
            raise Exception("User not found")

        self.log_repo.create(
            username,
            "SUSPEND",
        )

    def unsuspend(self, username):

        if not self.repo.set_suspended(username, False):
            raise Exception("User not found")

        self.log_repo.create(
            username,
            "UNSUSPEND",
        )

    # --------------------------------
    # Block
    # --------------------------------

    def block(self, username):

        if not self.repo.set_blocked(username, True):
            raise Exception("User not found")

        self.log_repo.create(
            username,
            "BLOCK",
        )

    def unblock(self, username):

        if not self.repo.set_blocked(username, False):
            raise Exception("User not found")

        self.log_repo.create(
            username,
            "UNBLOCK",
        )
