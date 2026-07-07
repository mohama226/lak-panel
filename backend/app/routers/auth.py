from contextlib import closing

from fastapi import APIRouter, Form, Request
from fastapi.responses import RedirectResponse
from fastapi.templating import Jinja2Templates

from app.db.database import SessionLocal
from app.db.models import Admin
from app.core.security import verify_password

router = APIRouter()

templates = Jinja2Templates(
    directory="app/templates"
)


@router.get("/login")
async def login_page(request: Request):

    return templates.TemplateResponse(
        "login.html",
        {
            "request": request,
            "error": None,
        },
    )


@router.post("/login")
async def login(
    request: Request,
    username: str = Form(...),
    password: str = Form(...),
):

    with closing(SessionLocal()) as db:

        admin = (
            db.query(Admin)
            .filter(Admin.username == username)
            .first()
        )

        if admin is None:

            return templates.TemplateResponse(
                "login.html",
                {
                    "request": request,
                    "error": "Invalid username",
                },
            )

        if not verify_password(password, admin.password):

            return templates.TemplateResponse(
                "login.html",
                {
                    "request": request,
                    "error": "Invalid password",
                },
            )

        admin_id = admin.id

    response = RedirectResponse(
        "/dashboard",
        status_code=302,
    )

    response.set_cookie(
        key="lak_admin",
        value=str(admin_id),
        httponly=True,
        samesite="lax",
    )

    return response


@router.get("/logout")
async def logout():

    response = RedirectResponse(
        "/login",
        status_code=302,
    )

    response.delete_cookie("lak_admin")

    return response
