from fastapi import FastAPI

app = FastAPI(
    title="LAK Panel",
    version="0.0.1"
)

@app.get("/")
async def root():
    return {
        "project": "LAK Panel",
        "version": "0.0.1",
        "status": "running"
    }
