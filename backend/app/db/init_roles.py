from sqlalchemy.orm import Session

from app.db.models import Role


DEFAULT_ROLES = [
    {
        "name": "Super Admin",
        "description": "Full system access",
    },
    {
        "name": "Admin",
        "description": "Manage servers, users and settings",
    },
    {
        "name": "Operator",
        "description": "Manage VPN users",
    },
    {
        "name": "Support",
        "description": "Support and logs access",
    },
    {
        "name": "Viewer",
        "description": "Read only access",
    },
]


def seed_roles(db: Session):

    for role in DEFAULT_ROLES:

        exists = (
            db.query(Role)
            .filter(Role.name == role["name"])
            .first()
        )

        if exists:
            continue

        db.add(
            Role(
                name=role["name"],
                description=role["description"],
            )
        )

    db.commit()
