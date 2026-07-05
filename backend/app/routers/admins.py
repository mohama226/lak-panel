from app.db.models import Admin
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



from app.core.security import hash_password


@router.get("/admins/edit/{admin_id}")
async def edit_page(
    admin_id: int,
    request: Request,
    lak_admin: str | None = Cookie(default=None),
):

    if not check_login(lak_admin):
        return RedirectResponse("/login")

    db = SessionLocal()

    repo = AdminRepository(db)

    service = AdminService(repo)

    admin = service.get_admin(admin_id)

    if admin is None:
        return RedirectResponse("/admins", status_code=302)

    roles = db.query(Role).all()

    return templates.TemplateResponse(
        "admins/edit.html",
        {
            "request": request,
            "admin": admin,
            "roles": roles,
        },
    )


@router.post("/admins/edit/{admin_id}")
async def edit_admin(
    admin_id: int,
    username: str = Form(...),
    fullname: str = Form(...),
    password: str = Form(""),
    role_id: int = Form(...),
    active: str | None = Form(default=None),
):

    db = SessionLocal()

    admin = (
        db.query(Admin)
        .filter(Admin.id == admin_id)
        .first()
    )

    if admin is None:
        return RedirectResponse("/admins", status_code=302)

    admin.username = username
    admin.fullname = fullname
    admin.role_id = role_id
    admin.active = active is not None

    if password.strip():
        admin.password = hash_password(password)

    db.commit()

    return RedirectResponse(
        "/admins",
        status_code=302,
    )
