from datetime import datetime

from sqlalchemy import (
    Boolean,
    Column,
    DateTime,
    ForeignKey,
    Integer,
    String,
)

from sqlalchemy.orm import relationship

from app.db.database import Base


# ---------------- Roles ----------------

class Role(Base):
    __tablename__ = "roles"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String(50), unique=True, nullable=False)
    description = Column(String(255))

    admins = relationship("Admin", back_populates="role")


# ---------------- Admins ----------------

class Admin(Base):
    __tablename__ = "admins"

    id = Column(Integer, primary_key=True, index=True)

    username = Column(String(100), unique=True)
    password = Column(String(255))
    fullname = Column(String(100))

    active = Column(Boolean, default=True)

    created_at = Column(
        DateTime,
        default=datetime.utcnow,
    )

    role_id = Column(
        Integer,
        ForeignKey("roles.id"),
    )

    role = relationship(
        "Role",
        back_populates="admins",
    )


# ---------------- Servers ----------------

class Server(Base):
    __tablename__ = "servers"

    id = Column(Integer, primary_key=True)

    name = Column(String(100), unique=True)

    host = Column(String(100))

    port = Column(Integer, default=22)

    username = Column(String(100))

    password = Column(String(255))

    enabled = Column(Boolean, default=True)

    users = relationship(
        "VPNUser",
        back_populates="server",
    )


# ---------------- Groups ----------------

class Group(Base):
    __tablename__ = "groups"

    id = Column(Integer, primary_key=True)

    name = Column(String(100), unique=True)

    description = Column(String(255))

    users = relationship(
        "VPNUser",
        back_populates="group",
    )


# ---------------- VPN Users ----------------

class VPNUser(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True)

    username = Column(
        String(100),
        unique=True,
        index=True,
    )

    password = Column(String(255))

    expire = Column(DateTime)

    traffic = Column(Integer, default=0)

    enabled = Column(Boolean, default=True)

    suspended = Column(Boolean, default=False)

    blocked = Column(Boolean, default=False)

    created_at = Column(
        DateTime,
        default=datetime.utcnow,
    )

    last_login = Column(
        DateTime,
        nullable=True,
    )

    last_ip = Column(
        String(64),
        nullable=True,
    )

    server_id = Column(
        Integer,
        ForeignKey("servers.id"),
    )

    group_id = Column(
        Integer,
        ForeignKey("groups.id"),
    )

    server = relationship(
        "Server",
        back_populates="users",
    )

    group = relationship(
        "Group",
        back_populates="users",
    )

    logs = relationship(
        "UserLog",
        back_populates="user",
        cascade="all, delete-orphan",
    )


# ---------------- User Logs ----------------

class UserLog(Base):
    __tablename__ = "user_logs"

    id = Column(
        Integer,
        primary_key=True,
    )

    username = Column(
        String(100),
        ForeignKey("users.username"),
    )

    event = Column(String(100))

    ip = Column(String(64))

    details = Column(String(500))

    created_at = Column(
        DateTime,
        default=datetime.utcnow,
    )

    user = relationship(
        "VPNUser",
        back_populates="logs",
    )


# ---------------- Settings ----------------

class Setting(Base):
    __tablename__ = "settings"

    id = Column(Integer, primary_key=True)

    key = Column(
        String(100),
        unique=True,
    )

    value = Column(String(500))


# ---------------- Audit Logs ----------------

class AuditLog(Base):
    __tablename__ = "audit_logs"

    id = Column(
        Integer,
        primary_key=True,
        index=True,
    )

    created_at = Column(
        DateTime,
        default=datetime.utcnow,
        index=True,
    )

    admin_username = Column(
        String(100),
        nullable=False,
        index=True,
    )

    target_user = Column(
        String(100),
        nullable=True,
        index=True,
    )

    action = Column(
        String(100),
        nullable=False,
    )

    details = Column(
        String(1000),
        default="",
    )

    old_value = Column(
        String(1000),
        default="",
    )

    new_value = Column(
        String(1000),
        default="",
    )

    ip_address = Column(
        String(64),
        default="",
    )

    user_agent = Column(
        String(255),
        default="",
    )

    status = Column(
        String(20),
        default="SUCCESS",
    )
