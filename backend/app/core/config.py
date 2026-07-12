from pydantic_settings import BaseSettings


class Settings(BaseSettings):

    PORT: int = 2096

    ADMIN_USERNAME: str = "admin"

    ADMIN_PASSWORD: str = "admin"


    class Config:
        env_file = ".env"



settings = Settings()
