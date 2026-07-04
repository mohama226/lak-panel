from fastapi import APIRouter, Form, Request
from fastapi.responses import RedirectResponse
from fastapi.templating import Jinja2Templates

from app.db.database import SessionLocal
from app.db.models import Admin
from app.core.security import verify_password

router = APIRouter()

templates = Jinja2Templates(directory="app/templates")


@router.get("/login")
async def login_page(request: Request):
    return templates.TemplateResponse(
        "login.html",
        {
            "request": request,
            "error": None
        }
    )


@router.post("/login")
async def login(
    request: Request,
    username: str = Form(...),
    password: str = Form(...)
):

    db = SessionLocal()

    admin = (
        db.query(Admin)
        .filter(Admin.username == username)
        .first()
    )

    if not admin:
        return templates.TemplateResponse(
            "login.html",
            {
                "request": request,
                "error": "Invalid username or password"
            }
        )

    if not verify_password(password, admin.password):
        return templates.TemplateResponse(
            "login.html",
            {
                "request": request,
                "error": "Invalid username or password"
            }
        )

    response = RedirectResponse(
        url="/dashboard",
        status_code=302
    )

    response.set_cookie(
        key="lak_admin",
        value=str(admin.id),
        httponly=True
    )

    return response
