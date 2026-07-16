from fastapi import APIRouter, Request
from fastapi.templating import Jinja2Templates

templates = Jinja2Templates(directory="templates")

router = APIRouter()

@router.get("/")
async def dashboard(request: Request):
    return templates.TemplateResponse(
        "dashboard.html",
        {"request": request, "title": "پنل مدیریت ocserv"}
    )
