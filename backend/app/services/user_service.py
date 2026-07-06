from app.db.models import VPNUser
from app.services.ocserv_service import OcservService


class UserService:

    def __init__(self, repo, log_repo):
        self.repo = repo
        self.log_repo = log_repo

    def list(self):
        return self.repo.get_all()

    def get(self, username):
        return self.repo.get(username)

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

    def enable(self, username):

        user = self.repo.get(username)

        if not user:
            raise Exception("User not found")

        user.enabled = True

        self.repo.update(user)

        self.log_repo.create(
            username,
            "ENABLE",
        )

        return user

    def disable(self, username):

        user = self.repo.get(username)

        if not user:
            raise Exception("User not found")

        user.enabled = False

        self.repo.update(user)

        self.log_repo.create(
            username,
            "DISABLE",
        )

        return user

    def suspend(self, username):

        user = self.repo.get(username)

        if not user:
            raise Exception("User not found")

        user.suspended = True

        self.repo.update(user)

        self.log_repo.create(
            username,
            "SUSPEND",
        )

        return user

    def unsuspend(self, username):

        user = self.repo.get(username)

        if not user:
            raise Exception("User not found")

        user.suspended = False

        self.repo.update(user)

        self.log_repo.create(
            username,
            "UNSUSPEND",
        )

        return user

    def block(self, username):

        user = self.repo.get(username)

        if not user:
            raise Exception("User not found")

        user.blocked = True

        self.repo.update(user)

        self.log_repo.create(
            username,
            "BLOCK",
        )

        return user

    def unblock(self, username):

        user = self.repo.get(username)

        if not user:
            raise Exception("User not found")

        user.blocked = False

        self.repo.update(user)

        self.log_repo.create(
            username,
            "UNBLOCK",
        )

        return user

    def logs(self, username):
        return self.log_repo.get_user_logs(username)
