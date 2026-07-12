from datetime import datetime
from typing import Optional

from pydantic import BaseModel


class UserUpdate(BaseModel):

    password: Optional[str] = None

    traffic: Optional[int] = None

    expire: Optional[datetime] = None

    enabled: Optional[bool] = None

    server_id: Optional[int] = None

    group_id: Optional[int] = None
