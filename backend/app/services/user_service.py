from app.core.audit import audit
from app.db.models import VPNUser, AuditLog
from app.services.ocserv_service import OcservService
from app.services.audit import log_action
from app.repositories.audit_repository import AuditRepository


class UserService:
    def __init__(
        self,
        repo,
        log_repo,
        audit_repo: AuditRepository,   # اضافه شد
        request=None,
        admin_username="system",
    ):
        self.repo = repo
        self.log_repo = log_repo
        self.audit_repo = audit_repo     # اضافه شد
        self.request = request
        self.admin_username = admin_username

    # =====================================================
    # Basic
    # =====================================================
    def list(self):
        return self.repo.get_all()

    def get(self, username):
        return self.repo.get(username)

    # =====================================================
    # Logs (به‌روزرسانی شد)
    # =====================================================
    def logs(
        self,
        username: str,
        page: int = 1,
        per_page: int = 10,
        search: str | None = None,
        date_from=None,
        date_to=None,
    ):
        return self.log_repo.list_paginated(
            username=username,
            page=page,
            per_page=per_page,
            search=search,
            date_from=date_from,
            date_to=date_to,
        )

    def admin_activity(
        self,
        username: str,
        page: int = 1,
        per_page: int = 10,
        search: str | None = None,
        date_from=None,
        date_to=None,
    ):
        """فعالیت‌های ادمین روی کاربر (از طریق AuditRepository)"""
        return self.audit_repo.list_paginated(
            username=username,
            page=page,
            per_page=per_page,
            search=search,
            date_from=date_from,
            date_to=date_to,
        )

    # =====================================================
    # Online
    # =====================================================
    def online_users(self):
        return OcservService.online_users()

    def is_online(self, username):
        try:
            users = self.online_users()
            for user in users:
                name = (
                    user.get("Username")
                    or user.get("username")
                    or user.get("User")
                    or user.get("user")
                )
                if name == username:
                    return True
        except Exception:
            pass
        return False

    # =====================================================
    # Sessions
    # =====================================================
    def sessions(self, username):
        return OcservService.sessions(username)

    # =====================================================
    # Traffic
    # =====================================================
    def traffic(self, username):
        return OcservService.traffic(username)

    def traffic_usage(self, username):
        user = self.repo.get(username)
        if not user:
            raise Exception("User not found")
        return OcservService.traffic(username)

    # =====================================================
    # Disconnect
    # =====================================================
    def disconnect(
        self,
        username,
        admin_username=None,
    ):
        user = self.repo.get(username)
        if not user:
            raise Exception("User not found")
        OcservService.disconnect_user(username)
        audit(
            db=self.repo.db,
            request=self.request,
            admin_username=self.admin_username,
            action="DISCONNECT",
            target_user=username,
            details="User disconnected",
        )
        return True

    # =====================================================
    # Create
    # =====================================================
    def create(
        self,
        data,
        admin_username=None,
    ):
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
        audit(
            db=self.repo.db,
            request=self.request,
            admin_username=self.admin_username,
            action="CREATE_USER",
            target_user=data.username,
            details="User created successfully",
        )
        return user

    # =====================================================
    # Delete
    # =====================================================
    def delete(
        self,
        username,
        admin_username=None,
    ):
        user = self.repo.get(username)
        if not user:
            raise Exception("User not found")
        OcservService.delete_user(username)
        self.repo.delete(user)
        audit(
            db=self.repo.db,
            request=self.request,
            admin_username=self.admin_username,
            action="DELETE_USER",
            target_user=username,
            details="User deleted",
        )

    # =====================================================
    # Enable / Disable
    # =====================================================
    def enable(
        self,
        username,
        admin_username=None,
    ):
        user = self.repo.get(username)
        if not user:
            raise Exception("User not found")
        user.enabled = True
        self.repo.update(user)
        audit(
            db=self.repo.db,
            request=self.request,
            admin_username=self.admin_username,
            action="ENABLE",
            target_user=username,
            details="User enabled",
        )
        return user

    def disable(
        self,
        username,
        admin_username=None,
    ):
        user = self.repo.get(username)
        if not user:
            raise Exception("User not found")
        user.enabled = False
        self.repo.update(user)
        audit(
            db=self.repo.db,
            request=self.request,
            admin_username=self.admin_username,
            action="DISABLE",
            target_user=username,
            details="User disabled",
        )
        return user

    # =====================================================
    # Suspend
    # =====================================================
    def suspend(
        self,
        username,
        admin_username=None,
    ):
        user = self.repo.get(username)
        if not user:
            raise Exception("User not found")
        user.suspended = True
        self.repo.update(user)
        audit(
            db=self.repo.db,
            request=self.request,
            admin_username=self.admin_username,
            action="SUSPEND",
            target_user=username,
            details="User suspended",
        )
        return user

    def unsuspend(
        self,
        username,
        admin_username=None,
    ):
        user = self.repo.get(username)
        if not user:
            raise Exception("User not found")
        user.suspended = False
        self.repo.update(user)
        audit(
            db=self.repo.db,
            request=self.request,
            admin_username=self.admin_username,
            action="UNSUSPEND",
            target_user=username,
            details="User unsuspended",
        )
        return user

    # =====================================================
    # Block
    # =====================================================
    def block(
        self,
        username,
        admin_username=None,
    ):
        user = self.repo.get(username)
        if not user:
            raise Exception("User not found")
        user.blocked = True
        self.repo.update(user)
        audit(
            db=self.repo.db,
            request=self.request,
            admin_username=self.admin_username,
            action="BLOCK",
            target_user=username,
            details="User blocked",
        )
        return user

    def unblock(
        self,
        username,
        admin_username=None,
    ):
        user = self.repo.get(username)
        if not user:
            raise Exception("User not found")
        user.blocked = False
        self.repo.update(user)
        audit(
            db=self.repo.db,
            request=self.request,
            admin_username=self.admin_username,
            action="UNBLOCK",
            target_user=username,
            details="User unblocked",
        )
        return user

    # =====================================================
    # Password
    # =====================================================
    def change_password(
        self,
        username,
        password,
        admin_username=None,
    ):
        user = self.repo.get(username)
        if not user:
            raise Exception("User not found")
        OcservService.change_password(username, password)
        self.repo.set_password(username, "")
        audit(
            db=self.repo.db,
            request=self.request,
            admin_username=self.admin_username,
            action="PASSWORD_CHANGE",
            target_user=username,
            details="Password changed",
        )

    # =====================================================
    # Expire
    # =====================================================
    def extend(
        self,
        username,
        expire,
        admin_username=None,
    ):
        user = self.repo.get(username)
        if not user:
            raise Exception("User not found")
        self.repo.set_expire(username, expire)
        audit(
            db=self.repo.db,
            request=self.request,
            admin_username=self.admin_username,
            action="EXTEND_USER",
            target_user=username,
            details=f"Expire -> {expire}",
        )
        self.log_repo.create(
            username,
            "EXTEND",
            details=f"Expire -> {expire}",
        )

    # =====================================================
    # Traffic Reset
    # =====================================================
    def reset_traffic(
        self,
        username,
        admin_username=None,
    ):
        user = self.repo.get(username)
        if not user:
            raise Exception("User not found")
        self.repo.set_traffic(username, 0)
        audit(
            db=self.repo.db,
            request=self.request,
            admin_username=self.admin_username,
            action="RESET_TRAFFIC",
            target_user=username,
            details="Traffic reset",
        )
        self.log_repo.create(
            username,
            "TRAFFIC",
            details="Traffic reset",
        )
        return True
