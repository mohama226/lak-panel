from app.core.security import hash_password
from app.db.models import Admin
from app.repositories.admin_repository import AdminRepository


class AdminService:

    def __init__(self, repository: AdminRepository):
        self.repository = repository

    def get_admins(self):
        return self.repository.get_all()

    def get_admin(self, admin_id: int):
        return self.repository.get_by_id(admin_id)

    def create_admin(
        self,
        username: str,
        password: str,
        fullname: str,
        role_id: int,
    ):

        # جلوگیری از ساخت کاربر تکراری
        exists = self.repository.get_by_username(username)

        if exists:
            raise Exception("Username already exists")

        admin = Admin(
            username=username,
            password=hash_password(password),
            fullname=fullname,
            role_id=role_id,
            active=True,
        )

        return self.repository.create(admin)

    def delete_admin(self, admin: Admin):
        self.repository.delete(admin)

    def update_admin(self):
        self.repository.update()
