from fastapi import FastAPI

from app.lifespan import lifespan

app = FastAPI(

    title="L-Panel",

    version="1.0.0",

    lifespan=lifespan

)


@app.get("/")

async def home():

    return {

        "project": "L-Panel",

        "status": "running",

        "version": "1.0.0"

    }
