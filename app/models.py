from sqlalchemy import Column, Integer, String, Boolean
from app.database import Base

class OcservUser(Base):
    __tablename__ = "ocserv_users"

    id = Column(Integer, primary_key=True, index=True)
    username = Column(String, unique=True)
    password = Column(String)
    active = Column(Boolean, default=True)
