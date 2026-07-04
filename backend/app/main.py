from fastapi import FastAPI

app = FastAPI(
    title="LAK Panel",
    description="Web Panel for OCServ VPN",
    version="0.1.0"
)


@app.get("/")
async def root():
    return {
        "project": "LAK Panel",
        "status": "running"
    }
