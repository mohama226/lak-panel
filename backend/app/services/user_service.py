from datetime import datetime, timedelta

from app.db.models import VPNUser
from app.repositories.user_repository import UserRepository
from app.drivers.ocserv import OCServDriver


class UserService:

    def __init__(self, repository: UserRepository):
        self.repository = repository
        self.driver = OCServDriver()

    def get_users(self):
        return self.repository.get_all()

    def get_user(self, username: str):
        return self.repository.get(username)

    def create_user(
        self,
        username: str,
        password: str,
        days: int,
        server_id: int | None = None,
        group_id: int | None = None,
    ):

        # بررسی تکراری نبودن کاربر
        if self.repository.get(username):
            raise Exception("User already exists.")

        # ساخت کاربر در OCServ
        if not self.driver.create_user(username, password):
            raise Exception("Failed to create user in OCServ.")

        # ثبت اطلاعات مدیریتی در دیتابیس
        user = VPNUser(
            username=username,
            expire=datetime.utcnow() + timedelta(days=days),
            enabled=True,
            server_id=server_id,
            group_id=group_id,
        )

        return self.repository.create(user)

    def delete_user(self, username: str):

        user = self.repository.get(username)

        if user is None:
            raise Exception("User not found.")

        # حذف از OCServ
        self.driver.delete_user(username)

        # حذف از دیتابیس
        return self.repository.delete(user)

    def suspend_user(self, username: str):

        user = self.repository.get(username)

        if user is None:
            raise Exception("User not found.")

        self.driver.lock_user(username)

        user.enabled = False

        self.repository.db.commit()

        return user

    def activate_user(self, username: str):

        user = self.repository.get(username)

        if user is None:
            raise Exception("User not found.")

        self.driver.unlock_user(username)

        user.enabled = True

        self.repository.db.commit()

        return user
