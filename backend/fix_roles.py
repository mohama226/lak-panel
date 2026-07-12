from app.db.database import SessionLocal
from app.db.models import Role

db = SessionLocal()

roles = [
    ("Super Admin", "Full Access"),
    ("Admin", "Manage Servers & Users"),
    ("Operator", "Manage VPN Users"),
    ("Support", "Support Team"),
    ("Viewer", "Read Only"),
]

for name, desc in roles:

    role = (
        db.query(Role)
        .filter(Role.name == name)
        .first()
    )

    if role is None:

        db.add(
            Role(
                name=name,
                description=desc,
            )
        )

db.commit()

print("Done")
