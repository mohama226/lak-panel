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


def get_service(db: Session):
    repo = UserRepository(db)
    log_repo = UserLogRepository(db)
    return UserService(repo, log_repo)


# ==========================================================
# Pages
# ==========================================================

@router.get("/users")
def users_page(
    request: Request,
    admin=Depends(require_login),
    db: Session = Depends(get_db),
):

    service = get_service(db)

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

    service = get_service(db)

    user = service.get(username)

    if not user:
        raise HTTPException(
            status_code=404,
            detail="User not found",
        )

    return render(
        request,
        "users/profile.html",
        {
            "user": user,
            "logs": service.logs(username),
        },
    )


@router.get("/users/{username}/traffic")
def traffic_page(
    username: str,
    request: Request,
    admin=Depends(require_login),
    db: Session = Depends(get_db),
):

    service = get_service(db)

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
    data: UserCreate,
    admin=Depends(require_login),
    db: Session = Depends(get_db),
):

    get_service(db).create(data)

    return {
        "detail": "User created successfully"
    }


@router.post("/users/{username}/password")
def change_password(
    username: str,
    data: UserPassword,
    admin=Depends(require_login),
    db: Session = Depends(get_db),
):

    get_service(db).change_password(
        username,
        data.password,
    )

    return {
        "detail": "Password changed"
    }


@router.post("/users/{username}/extend")
def extend_user(
    username: str,
    data: UserExpire,
    admin=Depends(require_login),
    db: Session = Depends(get_db),
):

    get_service(db).extend(
        username,
        data.expire,
    )

    return {
        "detail": "Account extended"
    }


@router.post("/users/{username}/traffic/reset")
def reset_traffic(
    username: str,
    admin=Depends(require_login),
    db: Session = Depends(get_db),
):

    get_service(db).reset_traffic(username)

    return {
        "detail": "Traffic reset"
    }


@router.post("/users/{username}/disconnect")
def disconnect_user(
    username: str,
    admin=Depends(require_login),
    db: Session = Depends(get_db),
):

    get_service(db).disconnect(username)

    return {
        "detail": "User disconnected"
    }


@router.post("/users/{username}/enable")
def enable_user(
    username: str,
    admin=Depends(require_login),
    db: Session = Depends(get_db),
):

    get_service(db).enable(username)

    return {
        "detail": "User enabled"
    }


@router.post("/users/{username}/disable")
def disable_user(
    username: str,
    admin=Depends(require_login),
    db: Session = Depends(get_db),
):

    get_service(db).disable(username)

    return {
        "detail": "User disabled"
    }


@router.post("/users/{username}/block")
def block_user(
    username: str,
    admin=Depends(require_login),
    db: Session = Depends(get_db),
):

    get_service(db).block(username)

    return {
        "detail": "User blocked"
    }


@router.post("/users/{username}/unblock")
def unblock_user(
    username: str,
    admin=Depends(require_login),
    db: Session = Depends(get_db),
):

    get_service(db).unblock(username)

    return {
        "detail": "User unblocked"
    }


@router.post("/users/{username}/suspend")
def suspend_user(
    username: str,
    admin=Depends(require_login),
    db: Session = Depends(get_db),
):

    get_service(db).suspend(username)

    return {
        "detail": "User suspended"
    }


@router.post("/users/{username}/unsuspend")
def unsuspend_user(
    username: str,
    admin=Depends(require_login),
    db: Session = Depends(get_db),
):

    get_service(db).unsuspend(username)

    return {
        "detail": "User unsuspended"
    }


@router.delete("/users/{username}")
def delete_user(
    username: str,
    admin=Depends(require_login),
    db: Session = Depends(get_db),
):

    get_service(db).delete(username)

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

    service = get_service(db)

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
    admin=Depends(require_login),
    db: Session = Depends(get_db),
):

    return get_service(db).sessions(username)


@router.get("/users/{username}/traffic/live")
def user_live_traffic(
    username: str,
    admin=Depends(require_login),
    db: Session = Depends(get_db),
):

    return get_service(db).traffic(username)


@router.get("/api/users/{username}/traffic")
def user_traffic_api(
    username: str,
    admin=Depends(require_login),
    db: Session = Depends(get_db),
):

    service = get_service(db)

    user = service.get(username)

    if not user:
        raise HTTPException(
            status_code=404,
            detail="User not found",
        )

    return service.traffic(username)
