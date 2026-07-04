from fastapi import FastAPI
from app.routers import users

app = FastAPI(
    title="lak-panel",
    description="OCServ VPN Management Panel",
    version="1.0.0"
)

app.include_router(users.router, prefix="/api/users", tags=["Users"])


@app.get("/")
def root():
    return {"message": "lak-panel API is running 🚀"}
