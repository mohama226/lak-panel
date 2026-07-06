from pathlib import Path

from pydantic_settings import BaseSettings, SettingsConfigDict


BASE_DIR = Path(__file__).resolve().parent.parent.parent


class Settings(BaseSettings):

    model_config = SettingsConfigDict(
        env_file=BASE_DIR / ".env",
        extra="ignore"      # <<< این خط مهم است
    )

    APP_NAME: str = "LAK Panel"

    APP_VERSION: str = "0.1.0-alpha"

    APP_HOST: str = "0.0.0.0"

    APP_PORT: int = 2096

    SECRET_KEY: str = "CHANGE_ME"

    DATABASE_URL: str = "sqlite:///./lakpanel.db"

    LOG_LEVEL: str = "INFO"

    OC_SERV_USERS_FILE: str = "/etc/ocserv/ocpasswd"


settings = Settings()
