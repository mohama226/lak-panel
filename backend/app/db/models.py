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


class Role(Base):
    __tablename__ = "roles"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String(100), unique=True, nullable=False)
    description = Column(String(255))

    admins = relationship("Admin", back_populates="role")


class Admin(Base):
    __tablename__ = "admins"

    id = Column(Integer, primary_key=True, index=True)

    username = Column(String(100), unique=True, nullable=False)

    password = Column(String(255), nullable=False)

    fullname = Column(String(100))

    active = Column(Boolean, default=True)

    created_at = Column(DateTime, default=datetime.utcnow)

    role_id = Column(Integer, ForeignKey("roles.id"))

    role = relationship("Role", back_populates="admins")


class Server(Base):
    __tablename__ = "servers"

    id = Column(Integer, primary_key=True)

    name = Column(String(100), unique=True)

    host = Column(String(100))

    ssh_port = Column(Integer, default=22)

    username = Column(String(100))

    password = Column(String(255))

    enabled = Column(Boolean, default=True)

    created_at = Column(DateTime, default=datetime.utcnow)

    users = relationship("VPNUser", back_populates="server")


class Group(Base):
    __tablename__ = "groups"

    id = Column(Integer, primary_key=True)

    name = Column(String(100), unique=True)

    description = Column(String(255))

    created_at = Column(DateTime, default=datetime.utcnow)

    users = relationship("VPNUser", back_populates="group")


class VPNUser(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True)

    username = Column(String(100), unique=True)

    password = Column(String(255))

    expire = Column(DateTime)

    traffic = Column(Integer, default=0)

    enabled = Column(Boolean, default=True)

    created_at = Column(DateTime, default=datetime.utcnow)

    server_id = Column(Integer, ForeignKey("servers.id"))

    group_id = Column(Integer, ForeignKey("groups.id"))

    server = relationship("Server", back_populates="users")

    group = relationship("Group", back_populates="users")


class Setting(Base):
    __tablename__ = "settings"

    id = Column(Integer, primary_key=True)

    key = Column(String(100), unique=True)

    value = Column(String(500))
