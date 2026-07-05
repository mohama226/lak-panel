from pathlib import Path

from fastapi import FastAPI
from fastapi.responses import RedirectResponse
from fastapi.staticfiles import StaticFiles

from app.core.config import settings
from app.db.database import Base, engine

# Routers
from app.routers.auth import router as auth_router
from app.routers.dashboard import router as dashboard_router
from app.routers.users import router as users_router

BASE_DIR = Path(__file__).resolve().parent

# Create Tables
Base.metadata.create_all(bind=engine)

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

# Routers
app.include_router(auth_router)
app.include_router(dashboard_router)

# Users
app.include_router(
    users_router,
    prefix="/users",
    tags=["Users"],
)


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
