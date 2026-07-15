class Config:

    SECRET_KEY = "lpanel-secret-key"

    SQLALCHEMY_DATABASE_URI = (
        "postgresql://lpanel_user:lpanel_pass@localhost/lpanel"
    )

    SQLALCHEMY_TRACK_MODIFICATIONS = False

    SQLALCHEMY_ENGINE_OPTIONS = {
        "pool_pre_ping": True,
        "pool_recycle": 300,
        "pool_size": 10,
        "max_overflow": 20
    }
