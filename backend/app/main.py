from pathlib import Path

from fastapi import FastAPI
from fastapi.responses import RedirectResponse
from fastapi.staticfiles import StaticFiles
from fastapi.templating import Jinja2Templates

from app.core.config import settings
from app.db.database import Base, engine

# Routers
from app.routers.auth import router as auth_router
from app.routers.dashboard import router as dashboard_router
from app.routers.admins import router as admins_router

from app.db.database import SessionLocal
from app.db.init_roles import seed_roles

BASE_DIR = Path(__file__).resolve().parent

# ساخت خودکار جداول
Base.metadata.create_all(bind=engine)
db = SessionLocal()

seed_roles(db)

db.close()
app = FastAPI(
    title=settings.APP_NAME,
    version=settings.APP_VERSION,
)

# Static
app.mount(
    "/static",
    StaticFiles(directory=str(BASE_DIR / "static")),
    name="static",
)

# Templates
templates = Jinja2Templates(
    directory=str(BASE_DIR / "templates")
)

# Routers
app.include_router(auth_router)
app.include_router(dashboard_router)
app.include_router(admins_router)


@app.get("/")
async def root():
    return RedirectResponse("/login")


@app.get("/health")
async def health():
    return {
        "status": "ok",
        "app": settings.APP_NAME,
        "version": settings.APP_VERSION,
    }
