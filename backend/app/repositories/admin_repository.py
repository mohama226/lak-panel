from sqlalchemy.orm import Session

from app.db.models import Admin


class AdminRepository:

    def __init__(self, db: Session):
        self.db = db

    def get_all(self):
        return (
            self.db.query(Admin)
            .order_by(Admin.id.desc())
            .all()
        )

    def get_by_id(self, admin_id: int):
        return (
            self.db.query(Admin)
            .filter(Admin.id == admin_id)
            .first()
        )

    def get_by_username(self, username: str):
        return (
            self.db.query(Admin)
            .filter(Admin.username == username)
            .first()
        )

    def create(self, admin: Admin):

        self.db.add(admin)

        self.db.commit()

        self.db.refresh(admin)

        return admin

    def update(self):

        self.db.commit()

    def delete(self, admin: Admin):

        self.db.delete(admin)

        self.db.commit()
