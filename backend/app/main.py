from fastapi import FastAPI
from fastapi.staticfiles import StaticFiles

from app.db.database import Base, engine
import app.db.models

from app.routers.auth import router as auth_router
from app.routers.dashboard import router as dashboard_router
from app.routers.users import router as users_router
from app.routers.admins import router as admins_router
from app.routers.settings import router as settings_router
from app.routers.api import router as api_router

app = FastAPI(title="LAK Panel")

Base.metadata.create_all(bind=engine)

app.mount(
    "/static",
    StaticFiles(directory="app/static"),
    name="static",
)

app.include_router(auth_router)
app.include_router(dashboard_router)
app.include_router(users_router)
app.include_router(admins_router)
app.include_router(settings_router)
app.include_router(api_router)
