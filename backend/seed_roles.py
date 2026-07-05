from app.db.database import SessionLocal
from app.db.models import Role

db = SessionLocal()

roles = [
    ("Super Admin", "Full Access"),
    ("Admin", "Manage Everything"),
    ("Operator", "Manage Users"),
    ("Support", "View Users & Logs"),
    ("Viewer", "Read Only"),
]

for name, desc in roles:

    exists = (
        db.query(Role)
        .filter(Role.name == name)
        .first()
    )

    if not exists:

        db.add(
            Role(
                name=name,
                description=desc,
            )
        )

db.commit()

print("Roles Created.")
