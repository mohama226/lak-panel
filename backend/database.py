from flask_sqlalchemy import SQLAlchemy
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker

from config import SQLALCHEMY_DATABASE_URI

db = SQLAlchemy()

engine = create_engine(

    SQLALCHEMY_DATABASE_URI,

    pool_pre_ping=True,

    pool_recycle=300,

    pool_size=20,

    max_overflow=40,

    future=True

)

SessionLocal = sessionmaker(

    bind=engine,

    autoflush=False,

    autocommit=False,

    expire_on_commit=False

)


def get_db():

    session = SessionLocal()

    try:

        yield session

    finally:

        session.close()
