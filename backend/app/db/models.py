from sqlalchemy import Column, Integer, String, Boolean
from app.db.database import Base


class User(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True, index=True)
    username = Column(String, unique=True, index=True)
    hashed_password = Column(String)


# ==========================================
# NEW: Settings Model (Auto Refresh System)
# ==========================================

class Settings(Base):
    __tablename__ = "settings"

    id = Column(Integer, primary_key=True, index=True)

    # Dashboard Auto Refresh
    dashboard_auto_refresh = Column(Boolean, default=True)
    dashboard_refresh_interval = Column(Integer, default=2)

    dashboard_refresh_users = Column(Boolean, default=True)
    dashboard_refresh_online = Column(Boolean, default=True)
    dashboard_refresh_servers = Column(Boolean, default=True)
    dashboard_refresh_traffic = Column(Boolean, default=True)
    dashboard_refresh_logs = Column(Boolean, default=False)
    dashboard_refresh_backups = Column(Boolean, default=False)
