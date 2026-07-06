import shutil
import subprocess

from app.core.config import settings


class OcservService:

    @staticmethod
    def is_installed() -> bool:
        return shutil.which("ocpasswd") is not None

    @staticmethod
    def check():
        if not OcservService.is_installed():
            raise RuntimeError(
                "OCServ is not installed on this server."
            )

    @staticmethod
    def add_user(username: str, password: str):

        OcservService.check()

        subprocess.run(
            [
                "ocpasswd",
                "-c",
                settings.OC_SERV_USERS_FILE,
                username,
            ],
            input=f"{password}\n{password}\n",
            text=True,
            check=True,
        )

    @staticmethod
    def delete_user(username: str):

        OcservService.check()

        subprocess.run(
            [
                "ocpasswd",
                "-c",
                settings.OC_SERV_USERS_FILE,
                "-d",
                username,
            ],
            check=True,
        )

    @staticmethod
    def change_password(username: str, password: str):

        OcservService.check()

        subprocess.run(
            [
                "ocpasswd",
                "-c",
                settings.OC_SERV_USERS_FILE,
                username,
            ],
            input=f"{password}\n{password}\n",
            text=True,
            check=True,
        )

    @staticmethod
    def user_exists(username: str) -> bool:

        OcservService.check()

        try:

            result = subprocess.run(
                [
                    "grep",
                    f"^{username}:",
                    settings.OC_SERV_USERS_FILE,
                ],
                capture_output=True,
                text=True,
            )

            return result.returncode == 0

        except Exception:

            return False
