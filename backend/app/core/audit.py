from sqlalchemy.orm import Session
from fastapi import Request
from app.db.models import AuditLog


def audit(
    db: Session,
    request: Request = None,
    admin_username: str = "system",
    action: str = "",
    target_user: str = "",
    details: str = "",
    old_value: str = "",
    new_value: str = "",
    ip_address: str = "",
    user_agent: str = "",
    status: str = "SUCCESS",
):
    if request:
        # اولویت با X-Forwarded-For (در صورت وجود پروکسی/لोड بالانسر)
        if request.headers.get("x-forwarded-for"):
            ip_address = request.headers["x-forwarded-for"].split(",")[0].strip()
        else:
            ip_address = request.client.host

        user_agent = request.headers.get("user-agent", "")

    log = AuditLog(
        admin_username=admin_username,
        target_user=target_user,
        action=action,
        details=details,
        old_value=old_value,
        new_value=new_value,
        ip_address=ip_address,
        user_agent=user_agent,
        status=status,
    )

    db.add(log)
    db.commit()
