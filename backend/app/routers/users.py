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

    return render(
        request,
        "users/index.html",
        {
            "users": get_service(db).list(),
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
    username,
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
    username,
    admin=Depends(require_login),
    db: Session = Depends(get_db),
):

    get_service(db).reset_traffic(username)

    return {
        "detail": "Traffic reset"
    }


@router.post("/users/{username}/disconnect")
def disconnect_user(
    username,
    admin=Depends(require_login),
    db: Session = Depends(get_db),
):

    get_service(db).disconnect(username)

    return {
        "detail": "User disconnected"
    }


@router.post("/users/{username}/enable")
def enable_user(
    username,
    admin=Depends(require_login),
    db: Session = Depends(get_db),
):

    get_service(db).enable(username)

    return {
        "detail": "User enabled"
    }


@router.post("/users/{username}/disable")
def disable_user(
    username,
    admin=Depends(require_login),
    db: Session = Depends(get_db),
):

    get_service(db).disable(username)

    return {
        "detail": "User disabled"
    }


@router.post("/users/{username}/block")
def block_user(
    username,
    admin=Depends(require_login),
    db: Session = Depends(get_db),
):

    get_service(db).block(username)

    return {
        "detail": "User blocked"
    }


@router.post("/users/{username}/unblock")
def unblock_user(
    username,
    admin=Depends(require_login),
    db: Session = Depends(get_db),
):

    get_service(db).unblock(username)

    return {
        "detail": "User unblocked"
    }


@router.post("/users/{username}/suspend")
def suspend_user(
    username,
    admin=Depends(require_login),
    db: Session = Depends(get_db),
):

    get_service(db).suspend(username)

    return {
        "detail": "User suspended"
    }


@router.post("/users/{username}/unsuspend")
def unsuspend_user(
    username,
    admin=Depends(require_login),
    db: Session = Depends(get_db),
):

    get_service(db).unsuspend(username)

    return {
        "detail": "User unsuspended"
    }


@router.delete("/users/{username}")
def delete_user(
    username,
    admin=Depends(require_login),
    db: Session = Depends(get_db),
):

    get_service(db).delete(username)

    return {
        "detail": "User deleted"
    }


# ==========================================================
# Live APIs
# ==========================================================

@router.get("/users/{username}/sessions")
def user_sessions(
    username,
    admin=Depends(require_login),
    db: Session = Depends(get_db),
):

    return get_service(db).sessions(username)


@router.get("/users/{username}/traffic/live")
def user_live_traffic(
    username,
    admin=Depends(require_login),
    db: Session = Depends(get_db),
):

    return get_service(db).traffic_usage(username)
