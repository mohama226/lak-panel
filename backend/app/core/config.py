from pathlib import Path

from pydantic_settings import BaseSettings


BASE_DIR = Path(__file__).resolve().parent.parent.parent


class Settings(BaseSettings):

    APP_NAME: str = "LAK Panel"

    APP_VERSION: str = "0.1.0-alpha"

    APP_HOST: str = "0.0.0.0"

    APP_PORT: int = 2096

    SECRET_KEY: str = "CHANGE_ME"

    DATABASE_URL: str = "sqlite:///./database.db"

    LOG_LEVEL: str = "INFO"

    class Config:
        env_file = BASE_DIR / ".env"
        case_sensitive = True


settings = Settings()
