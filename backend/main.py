from fastapi import FastAPI

from app.database import Base, engine

from app.admin import router as admin_router
from app.users import router as users_router


Base.metadata.create_all(bind=engine)


app = FastAPI(
    title="L-Panel",
    version="1.0.0"
)


app.include_router(
    admin_router
)

app.include_router(
    users_router
)


@app.get("/")
def home():
    return {
        "name": "L-Panel",
        "status": "running"
    }
