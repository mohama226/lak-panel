from fastapi import FastAPI

from .database import Base, engine

from .models import *


Base.metadata.create_all(
    bind=engine
)


app = FastAPI(
    title="LAK Panel",
    version="0.1.0"
)



@app.get("/")
def home():

    return {
        "status":"running",
        "panel":"LAK Panel"
    }
