from app.db.database import SessionLocal, engine, Base
from app.db.models import Admin, Role
from app.core.security import hash_password

Base.metadata.create_all(bind=engine)

db = SessionLocal()

role = db.query(Role).filter(Role.name == "Super Admin").first()

if role is None:
    role = Role(
        name="Super Admin",
        description="Full Access"
    )
    db.add(role)
    db.commit()
    db.refresh(role)

admin = db.query(Admin).filter(Admin.username == "admin").first()

if admin is None:

    admin = Admin(
        username="admin",
        fullname="Administrator",
        password=hash_password("admin123"),
        role_id=role.id,
        active=True
    )

    db.add(admin)
    db.commit()

print("Admin Created")
