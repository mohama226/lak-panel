from fastapi import (
    APIRouter,
    Depends,
    HTTPException,
    Cookie,
    Request,
)
from fastapi.responses import RedirectResponse
from sqlalchemy.orm import Session

from app.core.template import render
from app.db.database import get_db
from app.schemas.user import (
    UserCreate,
    UserPassword,
)
from app.services.user_service import UserService

router = APIRouter()


@router.get("/users")
def users_page(
    request: Request,
    db: Session = Depends(get_db),
    lak_admin: str | None = Cookie(default=None),
):

    if lak_admin is None:
        return RedirectResponse("/login")

    service = UserService(db)

    rows = service.list()

    users = []

    for user in rows:

        users.append(
            {
                "id": user.id,
                "username": user.username,
                "status": "Active" if user.enabled else "Disabled",
                "enabled": user.enabled,
                "online": False,
                "traffic": user.traffic,
                "expire": user.expire,
                "group": user.group.name if user.group else "-",
                "server": user.server.name if user.server else "-",
            }
        )

    return render(
        request,
        "users/index.html",
        {
            "title": "Users",
            "users": users,
        },
    )


@router.get("/api/users")
def list_users(
    db: Session = Depends(get_db),
):

    service = UserService(db)

    rows = service.list()

    result = []

    for user in rows:

        result.append(
            {
                "id": user.id,
                "username": user.username,
                "enabled": user.enabled,
                "traffic": user.traffic,
                "expire": user.expire,
                "online": False,
                "group": user.group.name if user.group else None,
                "server": user.server.name if user.server else None,
            }
        )

    return result


@router.post("/users")
def create_user(
    payload: UserCreate,
    db: Session = Depends(get_db),
):

    service = UserService(db)

    try:

        user = service.create(
            username=payload.username,
            password=payload.password,
            expire=payload.expire,
            traffic=payload.traffic,
            group_id=payload.group_id,
            server_id=payload.server_id,
        )

        return {
            "success": True,
            "message": "User created successfully.",
            "id": user.id,
        }

    except ValueError as e:

        raise HTTPException(
            status_code=400,
            detail=str(e),
        )

    except Exception as e:

        raise HTTPException(
            status_code=500,
            detail=str(e),
        )


@router.delete("/users/{username}")
def delete_user(
    username: str,
    db: Session = Depends(get_db),
):

    service = UserService(db)

    try:

        service.delete(username)

        return {
            "success": True,
            "message": "User deleted successfully.",
        }

    except ValueError as e:

        raise HTTPException(
            status_code=404,
            detail=str(e),
        )

    except Exception as e:

        raise HTTPException(
            status_code=500,
            detail=str(e),
        )


@router.patch("/users/{username}/enable")
def enable_user(
    username: str,
    db: Session = Depends(get_db),
):

    service = UserService(db)

    service.enable(username)

    return {
        "success": True,
    }


@router.patch("/users/{username}/disable")
def disable_user(
    username: str,
    db: Session = Depends(get_db),
):

    service = UserService(db)

    service.disable(username)

    return {
        "success": True,
    }


@router.patch("/users/{username}/password")
def change_password(
    username: str,
    payload: UserPassword,
    db: Session = Depends(get_db),
):

    service = UserService(db)

    service.change_password(
        username=username,
        password=payload.password,
    )

    return {
        "success": True,
        "message": "Password updated.",
    }
