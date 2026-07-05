from fastapi import APIRouter
from fastapi import Request
from fastapi.templating import Jinja2Templates

router = APIRouter()

templates = Jinja2Templates(
    directory="app/templates"
)


@router.get("/admins")
async def admins_page(request: Request):

    roles = [
        "Super Admin",
        "Admin",
        "Operator",
        "Support",
        "Viewer",
    ]

    admins = []

    return templates.TemplateResponse(
        "admins/list.html",
        {
            "request": request,
            "roles": roles,
            "admins": admins,
        },
    )
