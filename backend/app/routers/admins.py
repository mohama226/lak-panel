from fastapi import APIRouter
from fastapi import Request
from fastapi import Form
from fastapi import Cookie

from fastapi.responses import RedirectResponse
from fastapi.templating import Jinja2Templates

from app.db.database import SessionLocal
from app.db.models import Role

from app.repositories.admin_repository import AdminRepository
from app.services.admin_service import AdminService

router = APIRouter()

templates = Jinja2Templates(
    directory="app/templates"
)


def check_login(admin_cookie):

    if admin_cookie is None:
        return False

    return True


@router.get("/admins")
async def admin_list(
    request: Request,
    lak_admin: str | None = Cookie(default=None),
):

    if not check_login(lak_admin):
        return RedirectResponse("/login")

    db = SessionLocal()

    repo = AdminRepository(db)

    service = AdminService(repo)

    admins = service.get_admins()

    return templates.TemplateResponse(
        "admins/list.html",
        {
            "request": request,
            "admins": admins,
        },
    )


@router.get("/admins/create")
async def create_page(
    request: Request,
    lak_admin: str | None = Cookie(default=None),
):

    if not check_login(lak_admin):
        return RedirectResponse("/login")

    db = SessionLocal()

    roles = db.query(Role).all()

    return templates.TemplateResponse(
        "admins/create.html",
        {
            "request": request,
            "roles": roles,
        },
    )


@router.post("/admins/create")
async def create_admin(
    request: Request,
    username: str = Form(...),
    password: str = Form(...),
    fullname: str = Form(...),
    role_id: int = Form(...),
):

    db = SessionLocal()

    repo = AdminRepository(db)

    service = AdminService(repo)

    try:

        service.create_admin(
            username=username,
            password=password,
            fullname=fullname,
            role_id=role_id,
        )

    except Exception as e:

        roles = db.query(Role).all()

        return templates.TemplateResponse(
            "admins/create.html",
            {
                "request": request,
                "roles": roles,
                "error": str(e),
            },
        )

    return RedirectResponse(
        "/admins",
        status_code=302,
    )


@router.get("/admins/delete/{admin_id}")
async def delete_admin(
    admin_id: int,
    lak_admin: str | None = Cookie(default=None),
):

    if not check_login(lak_admin):
        return RedirectResponse("/login")

    db = SessionLocal()

    repo = AdminRepository(db)

    service = AdminService(repo)

    admin = service.get_admin(admin_id)

    if admin:
        service.delete_admin(admin)

    return RedirectResponse(
        "/admins",
        status_code=302,
    )
