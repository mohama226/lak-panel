import os


class Config:

    SECRET_KEY = "lpanel-secret"

    SQLALCHEMY_DATABASE_URI = (
        "postgresql://lpanel:lpanel123@localhost/lpanel"
    )

    SQLALCHEMY_TRACK_MODIFICATIONS = False
