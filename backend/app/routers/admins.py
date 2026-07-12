from fastapi import APIRouter, Depends, Request
from app.db.database import get_db
from sqlalchemy.orm import Session
from fastapi import APIRouter, Request, Form, Cookie, Query
from fastapi.responses import RedirectResponse
from fastapi.templating import Jinja2Templates
from fastapi import Depends

from app.db.database import SessionLocal, get_db
from app.db.models import Admin, Role, AuditLog
from app.core.security import hash_password
# اگر require_login دارید، import کنید (در غیر این صورت تعریف کنید)
from app.core.auth import require_login  # اگر وجود ندارد، کامنت کنید یا تعریف کنید

router = APIRouter()

templates = Jinja2Templates(
    directory="app/templates"
)


def check_login(admin_cookie):

    return admin_cookie is not None


@router.get("/admins")
async def admin_list(
    request: Request,
    lak_admin: str | None = Cookie(default=None),
):

    if not check_login(lak_admin):
        return RedirectResponse("/login")

    db = SessionLocal()

    try:

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

    finally:

        db.close()


@router.get("/admins/create")
async def create_page(
    request: Request,
    lak_admin: str | None = Cookie(default=None),
):

    if not check_login(lak_admin):
        return RedirectResponse("/login")

    db = SessionLocal()

    try:

        roles = db.query(Role).all()

        return templates.TemplateResponse(
            "admins/create.html",
            {
                "request": request,
                "roles": roles,
            },
        )

    finally:

        db.close()


@router.post("/admins/create")
async def create_admin(
    request: Request,
    username: str = Form(...),
    password: str = Form(...),
    fullname: str = Form(...),
    role_id: int = Form(...),
):

    db = SessionLocal()

    try:

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

    finally:

        db.close()


@router.get("/admins/delete/{admin_id}")
async def delete_admin(
    admin_id: int,
    lak_admin: str | None = Cookie(default=None),
):

    if not check_login(lak_admin):
        return RedirectResponse("/login")

    db = SessionLocal()

    try:

        repo = AdminRepository(db)
        service = AdminService(repo)

        admin = service.get_admin(admin_id)

        if admin:
            service.delete_admin(admin)

        return RedirectResponse(
            "/admins",
            status_code=302,
        )

    finally:

        db.close()


@router.get("/admins/edit/{admin_id}")
async def edit_page(
    admin_id: int,
    request: Request,
    lak_admin: str | None = Cookie(default=None),
):

    if not check_login(lak_admin):
        return RedirectResponse("/login")

    db = SessionLocal()

    try:

        repo = AdminRepository(db)
        service = AdminService(repo)

        admin = service.get_admin(admin_id)

        if admin is None:

            return RedirectResponse(
                "/admins",
                status_code=302,
            )

        roles = db.query(Role).all()

        return templates.TemplateResponse(
            "admins/edit.html",
            {
                "request": request,
                "admin": admin,
                "roles": roles,
            },
        )

    finally:

        db.close()


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

    try:

        admin = (
            db.query(Admin)
            .filter(Admin.id == admin_id)
            .first()
        )

        if admin is None:

            return RedirectResponse(
                "/admins",
                status_code=302,
            )

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

    finally:

        db.close()


# ==================== روت activity (جدید/اصلاح‌شده) ====================

@router.get("/admin/activity")
def activity(
    request: Request,
    admin=Depends(require_login),
    db: Session = Depends(get_db),

    page: int = Query(1, ge=1),
    per_page: int = Query(10, ge=1, le=100),

    date_from: str | None = Query(None),
    date_to: str | None = Query(None),
):

    query = db.query(AuditLog)

    if date_from:
        query = query.filter(
            AuditLog.created_at >= date_from
        )

    if date_to:
        query = query.filter(
            AuditLog.created_at <= date_to
        )

    total = query.count()

    logs = (
        query
        .order_by(AuditLog.created_at.desc())
        .offset((page-1)*per_page)
        .limit(per_page)
        .all()
    )

    return templates.TemplateResponse(
        "admin/activity.html",
        {
            "request": request,
            "logs": logs,
            "page": page,
            "per_page": per_page,
            "total": total,
        }
    )
