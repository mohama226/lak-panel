from fastapi import APIRouter
from fastapi import Request
from fastapi import Form
from fastapi.responses import RedirectResponse
from fastapi.templating import Jinja2Templates

router = APIRouter()

templates = Jinja2Templates(directory="app/templates")

admins = []


@router.get("/admins")
async def admin_list(request: Request):

    return templates.TemplateResponse(
        "admins/list.html",
        {
            "request": request,
            "admins": admins,
        },
    )


@router.get("/admins/create")
async def create_admin_page(request: Request):

    return templates.TemplateResponse(
        "admins/create.html",
        {
            "request": request,
        },
    )


@router.post("/admins/create")
async def create_admin(

    username: str = Form(...),

    password: str = Form(...),

    fullname: str = Form(...),

    role: str = Form(...),

):

    admins.append(
        {
            "id": len(admins) + 1,
            "username": username,
            "fullname": fullname,
            "role": role,
            "active": True,
        }
    )

    return RedirectResponse(
        "/admins",
        status_code=302,
    )
