from datetime import datetime
from typing import Optional

from pydantic import BaseModel, Field


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


class UserPassword(BaseModel):

    password: str = Field(
        min_length=4,
    )


class UserUpdate(BaseModel):

    expire: Optional[datetime] = None

    traffic: Optional[int] = None

    enabled: Optional[bool] = None

    group_id: Optional[int] = None

    server_id: Optional[int] = None


class UserOut(BaseModel):

    id: int

    username: str

    expire: Optional[datetime]

    traffic: int

    enabled: bool

    group_id: Optional[int]

    server_id: Optional[int]

    class Config:
        from_attributes = True
