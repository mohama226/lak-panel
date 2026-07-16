from fastapi import APIRouter

router = APIRouter(prefix="/ocserv", tags=["Ocserv"])

@router.get("/")
def ocserv_home():
    return {"status": "ocserv ok"}
