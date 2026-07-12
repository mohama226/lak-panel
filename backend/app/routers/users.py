from app.core.audit import audit
from fastapi import APIRouter
from fastapi import Depends
from fastapi import HTTPException
from fastapi import Request
from fastapi import Query

from sqlalchemy.orm import Session

from app.core.auth import require_login
from app.core.template import render
from app.db.database import get_db

from app.repositories.user_repository import UserRepository
from app.repositories.user_log_repository import UserLogRepository
from app.repositories.audit_repository import AuditRepository

from app.services.user_service import UserService

from app.schemas.user import (
    UserCreate,
    UserPassword,
    UserExpire,
)

from app.db.models import AuditLog

router = APIRouter()


def get_service(
    db: Session,
    request=None,
    admin=None,
):
    repo = UserRepository(db)
    log_repo = UserLogRepository(db)
    audit_repo = AuditRepository(db)

    username = "system"

    if admin:
        username = admin.get("username")

    return UserService(
        repo,
        log_repo,
        audit_repo,
        request=request,
        admin_username=username,
    )


# ==========================================================
# Pages
# ==========================================================

@router.get("/users")
def users_page(
    request: Request,
    admin=Depends(require_login),
    db: Session = Depends(get_db),
):

    service = get_service(
        db,
        request,
        admin
    )

    users = service.list()

    for user in users:
        user.online = service.is_online(user.username)

    return render(
        request,
        "users/index.html",
        {
            "users": users,
        },
    )


@router.get("/users/new")
def new_user_page(
    request: Request,
    admin=Depends(require_login),
):

    return render(
        request,
        "users/create.html",
    )


@router.get("/users/{username}")
def profile(
    username: str,
    request: Request,
    admin=Depends(require_login),
    db: Session = Depends(get_db),
    page: int = Query(1, ge=1),
    per_page: int = Query(10, ge=1, le=100),
    date_from: str | None = Query(None),
    date_to: str | None = Query(None),
):

    service = get_service(
        db,
        request,
        admin
    )

    user = service.get(username)

    if not user:
        raise HTTPException(
            status_code=404,
            detail="User not found",
        )

    logs_data = service.logs(
        username=username,
        page=page,
        per_page=per_page,
        date_from=date_from,
        date_to=date_to,
    )


    audit_data = service.admin_activity(
        username=username,
        page=page,
        per_page=per_page,
        date_from=date_from,
        date_to=date_to,
    )


    audit_logs = audit_data["logs"]
    total_audit = audit_data["total"]

    return render(
        request,
        "users/profile.html",
        {
            "user": user,
            "logs": logs_data["logs"],
            "logs_page": logs_data["page"],
            "logs_per_page": logs_data["per_page"],
            "logs_total": logs_data["total"],
            "audit_logs": audit_logs,
            "audit_page": page,
            "audit_per_page": per_page,
            "audit_total": total_audit,
        },
    )


@router.get("/users/{username}/traffic")
def traffic_page(
    username: str,
    request: Request,
    admin=Depends(require_login),
    db: Session = Depends(get_db),
):

    service = get_service(
        db,
        request,
        admin
    )

    user = service.get(username)

    if not user:
        raise HTTPException(
            status_code=404,
            detail="User not found",
        )

    return render(
        request,
        "users/traffic.html",
        {
            "user": user,
        },
    )


# ==========================================================
# API
# ==========================================================

@router.post("/users")
def create_user(
    request: Request,
    data: UserCreate,
    admin=Depends(require_login),
    db: Session = Depends(get_db),
):

    get_service(
        db,
        request,
        admin
    ).create(data)

    return {
        "detail": "User created successfully"
    }


@router.post("/users/{username}/password")
def change_password(
    username: str,
    request: Request,
    data: UserPassword,
    admin=Depends(require_login),
    db: Session = Depends(get_db),
):

    get_service(
        db,
        request,
        admin
    ).change_password(
        username,
        data.password,
    )

    return {
        "detail": "Password changed"
    }


@router.post("/users/{username}/extend")
def extend_user(
    username: str,
    request: Request,
    data: UserExpire,
    admin=Depends(require_login),
    db: Session = Depends(get_db),
):

    get_service(
        db,
        request,
        admin
    ).extend(
        username,
        data.expire,
    )

    return {
        "detail": "Account extended"
    }


@router.post("/users/{username}/traffic/reset")
def reset_traffic(
    username: str,
    request: Request,
    admin=Depends(require_login),
    db: Session = Depends(get_db),
):

    get_service(
        db,
        request,
        admin
    ).reset_traffic(username)

    return {
        "detail": "Traffic reset"
    }


@router.post("/users/{username}/disconnect")
def disconnect_user(
    username: str,
    request: Request,
    admin=Depends(require_login),
    db: Session = Depends(get_db),
):

    get_service(
        db,
        request,
        admin
    ).disconnect(username)

    return {
        "detail": "User disconnected"
    }


@router.post("/users/{username}/enable")
def enable_user(
    username: str,
    request: Request,
    admin=Depends(require_login),
    db: Session = Depends(get_db),
):

    get_service(
        db,
        request,
        admin
    ).enable(username)

    return {
        "detail": "User enabled"
    }


@router.post("/users/{username}/disable")
def disable_user(
    username: str,
    request: Request,
    admin=Depends(require_login),
    db: Session = Depends(get_db),
):

    get_service(
        db,
        request,
        admin
    ).disable(username)

    return {
        "detail": "User disabled"
    }


@router.post("/users/{username}/block")
def block_user(
    username: str,
    request: Request,
    admin=Depends(require_login),
    db: Session = Depends(get_db),
):

    get_service(
        db,
        request,
        admin
    ).block(username)

    return {
        "detail": "User blocked"
    }


@router.post("/users/{username}/unblock")
def unblock_user(
    username: str,
    request: Request,
    admin=Depends(require_login),
    db: Session = Depends(get_db),
):

    get_service(
        db,
        request,
        admin
    ).unblock(username)

    return {
        "detail": "User unblocked"
    }


@router.post("/users/{username}/suspend")
def suspend_user(
    username: str,
    request: Request,
    admin=Depends(require_login),
    db: Session = Depends(get_db),
):

    get_service(
        db,
        request,
        admin
    ).suspend(username)

    return {
        "detail": "User suspended"
    }


@router.post("/users/{username}/unsuspend")
def unsuspend_user(
    username: str,
    request: Request,
    admin=Depends(require_login),
    db: Session = Depends(get_db),
):

    get_service(
        db,
        request,
        admin
    ).unsuspend(username)

    return {
        "detail": "User unsuspended"
    }


@router.delete("/users/{username}")
def delete_user(
    username: str,
    request: Request,
    admin=Depends(require_login),
    db: Session = Depends(get_db),
):

    get_service(
        db,
        request,
        admin
    ).delete(username)

    return {
        "detail": "User deleted"
    }


@router.post("/users/bulk")
async def bulk_users(
    request: Request,
    admin=Depends(require_login),
    db: Session = Depends(get_db),
):

    data = await request.json()

    users = data.get("users", [])
    action = data.get("action")
    days = int(data.get("days", 0))

    service = get_service(
        db,
        request,
        admin
    )

    for username in users:

        if action == "enable":
            service.enable(username)

        elif action == "disable":
            service.disable(username)

        elif action == "block":
            service.block(username)

        elif action == "unblock":
            service.unblock(username)

        elif action == "disconnect":
            service.disconnect(username)

        elif action == "reset_traffic":
            service.reset_traffic(username)

        elif action == "delete":
            service.delete(username)

        elif action == "extend":

            user = service.get(username)

            if user and user.expire:

                from datetime import timedelta

                service.extend(
                    username,
                    user.expire + timedelta(days=days)
                )

    return {
        "detail":"Bulk operation completed"
    }
    
# ==========================================================
# Live APIs
# ==========================================================

@router.get("/users/{username}/sessions")
def user_sessions(
    username: str,
    request: Request,
    admin=Depends(require_login),
    db: Session = Depends(get_db),
):

    return get_service(
        db,
        request,
        admin
    ).sessions(username)


@router.get("/users/{username}/traffic/live")
def user_live_traffic(
    username: str,
    request: Request,
    admin=Depends(require_login),
    db: Session = Depends(get_db),
):

    return get_service(
        db,
        request,
        admin
    ).traffic(username)


@router.get("/api/users/{username}/traffic")
def user_traffic_api(
    username: str,
    request: Request,
    admin=Depends(require_login),
    db: Session = Depends(get_db),
):

    service = get_service(
        db,
        request,
        admin
    )

    user = service.get(username)

    if not user:
        raise HTTPException(
            status_code=404,
            detail="User not found",
        )

    return service.traffic(username)
