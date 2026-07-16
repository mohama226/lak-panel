from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from app.database import SessionLocal
from app.models import OcservUser
from app.utils.hashing import hash_password

router = APIRouter()

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@router.post("/")
def create_user(username: str, password: str, db: Session = Depends(get_db)):
    hashed = hash_password(password)
    user = OcservUser(username=username, password=hashed)
    db.add(user)
    db.commit()
    return {"status": "created"}
