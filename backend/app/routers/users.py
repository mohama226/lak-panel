from fastapi import APIRouter, Request, Cookie, Form, HTTPException
from fastapi.responses import RedirectResponse
from sqlalchemy.orm import Session

from app.core.template import render
from app.db.database import SessionLocal
from app.schemas.user import UserCreate, UserPassword
from app.services.user_service import UserService

router = APIRouter()


def db():
    return SessionLocal()


@router.get("/users")
async def users_page(
    request: Request,
    lak_admin: str | None = Cookie(default=None),
):
    if lak_admin is None:
        return RedirectResponse("/login")

    session = db()

    try:

        service = UserService(session)

        users = []

        for row in service.list():

            users.append(
                {
                    "username": row.username,
                    "status": "Active" if row.enabled else "Disabled",
                    "traffic": row.traffic,
                    "expire": row.expire or "-",
                    "group": row.group.name if row.group else "-",
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

    finally:
        session.close()


@router.get("/users/new")
async def new_user_page(
    request: Request,
    lak_admin: str | None = Cookie(default=None),
):
    if lak_admin is None:
        return RedirectResponse("/login")

    return render(
        request,
        "users/create.html",
        {
            "title": "Create User",
        },
    )


@router.post("/users/new")
async def create_user_form(
    username: str = Form(...),
    password: str = Form(...),
):

    session = db()

    try:

        UserService(session).create(
            username=username,
            password=password,
        )

        return RedirectResponse(
            "/users",
            status_code=302,
        )

    finally:
        session.close()


@router.post("/users")
async def create_user(user: UserCreate):

    session = db()

    try:

        UserService(session).create(
            username=user.username,
            password=user.password,
            expire=user.expire,
            traffic=user.traffic,
            group_id=user.group_id,
            server_id=user.server_id,
        )

        return {
            "message": "ok",
        }

    finally:
        session.close()


@router.get("/users/{username}")
async def profile(
    request: Request,
    username: str,
    lak_admin: str | None = Cookie(default=None),
):

    if lak_admin is None:
        return RedirectResponse("/login")

    session = db()

    try:

        user = UserService(session).get(username)

        if not user:
            raise HTTPException(404)

        return render(
            request,
            "users/profile.html",
            {
                "title": username,
                "user": user,
            },
        )

    finally:
        session.close()


@router.patch("/users/{username}/password")
async def password(
    username: str,
    body: UserPassword,
):

    session = db()

    try:

        UserService(session).change_password(
            username,
            body.password,
        )

        return {
            "message": "Password changed",
        }

    finally:
        session.close()


@router.patch("/users/{username}/enable")
async def enable(username: str):

    session = db()

    try:

        UserService(session).enable(username)

        return {
            "message": "enabled",
        }

    finally:
        session.close()


@router.patch("/users/{username}/disable")
async def disable(username: str):

    session = db()

    try:

        UserService(session).disable(username)

        return {
            "message": "disabled",
        }

    finally:
        session.close()


@router.delete("/users/{username}")
async def delete(username: str):

    session = db()

    try:

        UserService(session).delete(username)

        return {
            "message": "deleted",
        }

    finally:
        session.close()


@router.get("/api/users")
async def api_users():

    session = db()

    try:

        return UserService(session).list()

    finally:
        session.close()
