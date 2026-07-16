from fastapi import FastAPI
from fastapi.staticfiles import StaticFiles
from .routers import dashboard, users

app = FastAPI(title="l-panel")

app.mount("/static", StaticFiles(directory="static"), name="static")

app.include_router(dashboard.router)
app.include_router(users.router, prefix="")

# برای اجرای مستقیم با uvicorn:
# uvicorn app.main:app --host 0.0.0.0 --port 8000
