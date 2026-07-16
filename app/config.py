from pydantic import BaseSettings

class Settings(BaseSettings):
    db_url: str = "postgresql+asyncpg://lpanel:lpanel@localhost:5432/lpanel"

    class Config:
        env_file = ".env"

settings = Settings()
