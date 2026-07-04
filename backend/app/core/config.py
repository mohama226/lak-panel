import os
from dotenv import load_dotenv

load_dotenv()

class Settings:
    PROJECT_NAME = "lak-panel"
    DATABASE_URL = os.getenv("DATABASE_URL", "sqlite:///./lakpanel.db")
    OC_SERV_USERS_FILE = os.getenv("OC_SERV_USERS_FILE", "/etc/ocserv/ocpasswd")

settings = Settings()
