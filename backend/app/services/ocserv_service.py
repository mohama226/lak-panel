import subprocess
from app.core.config import settings

class OcservService:

    @staticmethod
    def add_user(username: str, password: str):
        cmd = f"echo '{password}\n{password}' | ocpasswd -c {settings.OC_SERV_USERS_FILE} {username}"
        subprocess.run(cmd, shell=True, check=True)

    @staticmethod
    def delete_user(username: str):
        cmd = f"ocpasswd -c {settings.OC_SERV_USERS_FILE} -d {username}"
        subprocess.run(cmd, shell=True, check=True)
