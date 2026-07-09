from app.core.audit import audit
from fastapi import APIRouter
from fastapi import Depends
from fastapi import HTTPException
from fastapi import Request

from sqlalchemy.orm import Session

from app.core.auth import require_login
from app.core.template import render
from app.db.database import get_db

from app.repositories.user_repository import UserRepository
from app.repositories.user_log_repository import UserLogRepository

from app.services.user_service import UserService

from app.schemas.user import (
    UserCreate,
    UserPassword,
    UserExpire,
)

router = APIRouter()


def get_service(
    db: Session,
    request=None,
    admin=None,
):
    repo = UserRepository(db)
    log_repo = UserLogRepository(db)

    username = "system"

    if admin:
        username = admin.get("username")

    return UserService(
        repo,
        log_repo,
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

    from app.db.models import AuditLog

    audit_logs = (
        db.query(AuditLog)
        .filter(AuditLog.target_user == username)
        .order_by(AuditLog.created_at.desc())
        .limit(50)
        .all()
    )

    return render(
        request,
        "users/profile.html",
        {
            "user": user,
            "logs": service.logs(username),
            "audit_logs": audit_logs,
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
    audit(
        db=db,
        request=request,
        admin=admin,
        action="PASSWORD_CHANGE",
        target=username,
        details="Password changed",
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

    audit(
        db=db,
        request=request,
        admin=admin,
        action="EXTEND_USER",
        target=username,
        details=f"Expire -> {data.expire}",
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
    audit(
        db=db,
        request=request,
        admin=admin,
        action="RESET_TRAFFIC",
        target=username,
        details="Traffic reset",
    )

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
    audit(
        db=db,
        request=request,
        admin=admin,
        action="DISCONNECT",
        target=username,
        details="Disconnected by admin",
    )

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
    audit(
        db=db,
        request=request,
        admin=admin,
        action="ENABLE",
        target=username,
        details="User enabled",
    )

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
    audit(
        db=db,
        request=request,
        admin=admin,
        action="DISABLE",
        target=username,
        details="User disabled",
    )

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
