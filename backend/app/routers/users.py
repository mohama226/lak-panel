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
from app.services.user_log_service import UserLogService

from app.schemas.user import UserCreate

router = APIRouter()


@router.get("/users")
def users_page(
    request: Request,
    admin=Depends(require_login),
    db: Session =Depends(get_db),
):

    repo = UserRepository(db)
    service = UserService(repo)

    users = service.list()

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


@router.post("/users")
def create_user(
    data: UserCreate,
    admin=Depends(require_login),
    db: Session = Depends(get_db),
):

    repo = UserRepository(db)
    service = UserService(repo)

    log_repo = UserLogRepository(db)
    log_service = UserLogService(log_repo)

    try:

        user = service.create(data)

        log_service.log(
            username=user.username,
            event="CREATE",
            details="User created",
        )

        return {
            "detail": "User created successfully"
        }

    except Exception as e:

        raise HTTPException(
            status_code=500,
            detail=str(e),
        )


@router.get("/users/{username}")
def profile(
    username: str,
    request: Request,
    admin=Depends(require_login),
    db: Session = Depends(get_db),
):

    repo = UserRepository(db)

    user = repo.get(username)

    if not user:

        raise HTTPException(
            status_code=404,
            detail="User not found",
        )

    log_repo = UserLogRepository(db)
    log_service = UserLogService(log_repo)

    logs = log_service.list(username)

    return render(
        request,
        "users/profile.html",
        {
            "user": user,
            "logs": logs,
        },
    )
