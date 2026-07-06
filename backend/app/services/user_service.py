from app.db.models import VPNUser
from app.services.ocserv_service import OcservService


class UserService:

    def __init__(self, repo, log_repo):
        self.repo = repo
        self.log_repo = log_repo

    # -------------------------
    # Read
    # -------------------------

    def list(self):
        return self.repo.get_all()

    def get(self, username):
        return self.repo.get(username)

    def logs(self, username):
        return self.log_repo.get_user_logs(username)

    # -------------------------
    # Create
    # -------------------------

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

    # -------------------------
    # Delete
    # -------------------------

    def delete(self, username):

        user = self.repo.get(username)

        if not user:
            raise Exception("User not found")

        OcservService.delete_user(username)

        self.log_repo.create(
            username,
            "DELETE",
            details="User deleted",
        )

        self.repo.delete(user)

    # -------------------------
    # Edit
    # -------------------------

    def edit(self, username, data):

        user = self.repo.get(username)

        if not user:
            raise Exception("User not found")

        self.repo.edit(
            username,
            expire=data.expire,
            traffic=data.traffic,
            group_id=data.group_id,
            server_id=data.server_id,
        )

        self.log_repo.create(
            username,
            "EDIT",
            details="User edited",
        )

        return self.repo.get(username)

    # -------------------------
    # Password
    # -------------------------

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

    # -------------------------
    # Expire
    # -------------------------

    def set_expire(
        self,
        username,
        expire,
    ):

        self.repo.set_expire(
            username,
            expire,
        )

        self.log_repo.create(
            username,
            "EXPIRE",
            details="Expire updated",
        )

    # -------------------------
    # Traffic
    # -------------------------

    def set_traffic(
        self,
        username,
        traffic,
    ):

        self.repo.set_traffic(
            username,
            traffic,
        )

        self.log_repo.create(
            username,
            "TRAFFIC",
            details=f"Traffic set to {traffic} GB",
        )

    # -------------------------
    # Enable / Disable
    # -------------------------

    def enable(self, username):

        self.repo.set_enabled(
            username,
            True,
        )

        self.log_repo.create(
            username,
            "ENABLE",
        )

    def disable(self, username):

        self.repo.set_enabled(
            username,
            False,
        )

        self.log_repo.create(
            username,
            "DISABLE",
        )

    # -------------------------
    # Suspend
    # -------------------------

    def suspend(self, username):

        self.repo.set_suspended(
            username,
            True,
        )

        self.log_repo.create(
            username,
            "SUSPEND",
        )

    def unsuspend(self, username):

        self.repo.set_suspended(
            username,
            False,
        )

        self.log_repo.create(
            username,
            "UNSUSPEND",
        )

    # -------------------------
    # Block
    # -------------------------

    def block(self, username):

        self.repo.set_blocked(
            username,
            True,
        )

        self.log_repo.create(
            username,
            "BLOCK",
        )

    def unblock(self, username):

        self.repo.set_blocked(
            username,
            False,
        )

        self.log_repo.create(
            username,
            "UNBLOCK",
        )
