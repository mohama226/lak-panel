from datetime import datetime
from typing import Optional

from pydantic import BaseModel, Field


# -----------------------------
# Create
# -----------------------------

class UserCreate(BaseModel):

    username: str = Field(
        min_length=3,
        max_length=100,
    )

    password: str = Field(
        min_length=4,
    )

    expire: Optional[datetime] = None

    traffic: int = 0

    group_id: Optional[int] = None

    server_id: Optional[int] = None


# -----------------------------
# Edit
# -----------------------------

class UserEdit(BaseModel):

    expire: Optional[datetime] = None

    traffic: int = 0

    group_id: Optional[int] = None

    server_id: Optional[int] = None


# -----------------------------
# Password
# -----------------------------

class UserPassword(BaseModel):

    password: str = Field(
        min_length=4,
    )


# -----------------------------
# Expire
# -----------------------------

class UserExpire(BaseModel):

    expire: Optional[datetime]


# -----------------------------
# Traffic
# -----------------------------

class UserTraffic(BaseModel):

    traffic: int


# -----------------------------
# Output
# -----------------------------

class UserOut(BaseModel):

    id: int

    username: str

    enabled: bool

    suspended: bool

    blocked: bool

    expire: Optional[datetime]

    traffic: int

    last_login: Optional[datetime]

    last_ip: Optional[str]

    group_id: Optional[int]

    server_id: Optional[int]

    class Config:
        from_attributes = True
