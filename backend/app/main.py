from fastapi import FastAPI
from fastapi.staticfiles import StaticFiles

from app.db.database import Base
from app.db.database import engine

# مدل‌ها را import می‌کنیم تا SQLAlchemy همه جدول‌ها را بشناسد
from app.db import models

# Routers
from app.routers import auth
from app.routers import dashboard
from app.routers import users
from app.routers import servers
from app.routers import groups
from app.routers import settings

app = FastAPI(
    title="LAK Panel",
)

# ایجاد جداول
Base.metadata.create_all(bind=engine)

# اجرای Migration های خودکار

# Static Files
app.mount(
    "/static",
    StaticFiles(directory="app/static"),
    name="static",
)

# Routers
app.include_router(auth.router)
app.include_router(dashboard.router)
app.include_router(users.router)
app.include_router(servers.router)
app.include_router(groups.router)
app.include_router(settings.router)
