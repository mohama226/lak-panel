from datetime import datetime

from fastapi import Request
from sqlalchemy.orm import Session

from app.db.models import AuditLog


def log_action(
    db: Session,
    request: Request | None = None,
    admin: str = "SYSTEM",
    target: str = "",
    action: str = "",
    details: str = "",
    old_value: str = "",
    new_value: str = "",
    status: str = "SUCCESS",
):
    """
    Save Audit Log

    Example:

    log_action(
        db=db,
        request=request,
        admin="admin",
        target="user1",
        action="DELETE USER",
        details="User deleted from panel",
        old_value="Enabled",
        new_value="Deleted"
    )
    """

    ip = ""
    user_agent = ""

    if request is not None:

        try:
            ip = request.client.host
        except Exception:
            ip = ""

        try:
            user_agent = request.headers.get(
                "user-agent",
                ""
            )
        except Exception:
            user_agent = ""

    log = AuditLog(

        created_at=datetime.utcnow(),

        admin_username=admin,

        target_user=target,

        action=action,

        details=details,

        old_value=str(old_value),

        new_value=str(new_value),

        ip_address=ip,

        user_agent=user_agent,

        status=status,

    )

    db.add(log)
    db.commit()

    return log
