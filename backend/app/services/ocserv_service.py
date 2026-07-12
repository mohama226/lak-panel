import subprocess
from typing import List, Dict

from app.core.ocserv_cache import OcservCache


class OcservService:

    PASSWD_FILE = "/etc/ocserv/ocpasswd"

    # =====================================================
    # Users
    # =====================================================

    @classmethod
    def add_user(cls, username: str, password: str):

        cmd = [
            "ocpasswd",
            "-c",
            cls.PASSWD_FILE,
            username,
        ]

        p = subprocess.Popen(
            cmd,
            stdin=subprocess.PIPE,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True,
        )

        p.communicate(password + "\n" + password + "\n")

        if p.returncode != 0:
            raise Exception("Failed to create user")

    @classmethod
    def delete_user(cls, username: str):

        result = subprocess.run(
            [
                "ocpasswd",
                "-c",
                cls.PASSWD_FILE,
                "-d",
                username,
            ],
            capture_output=True,
            text=True,
        )

        if result.returncode != 0:
            raise Exception(result.stderr.strip())

    @classmethod
    def change_password(cls, username: str, password: str):

        cmd = [
            "ocpasswd",
            "-c",
            cls.PASSWD_FILE,
            username,
        ]

        p = subprocess.Popen(
            cmd,
            stdin=subprocess.PIPE,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True,
        )

        p.communicate(password + "\n" + password + "\n")

        if p.returncode != 0:
            raise Exception("Failed to change password")

    @classmethod
    def user_exists(cls, username: str):

        try:

            with open(cls.PASSWD_FILE) as f:

                for line in f:

                    if line.startswith(username + ":"):
                        return True

        except Exception:
            return False

        return False

    # =====================================================
    # Server
    # =====================================================

    @classmethod
    def status(cls):

        result = subprocess.run(
            [
                "systemctl",
                "is-active",
                "ocserv",
            ],
            capture_output=True,
            text=True,
        )

        return result.stdout.strip() == "active"

    @classmethod
    def restart(cls):

        subprocess.run(
            [
                "systemctl",
                "restart",
                "ocserv",
            ]
        )

    @classmethod
    def reload(cls):

        subprocess.run(
            [
                "occtl",
                "reload",
            ]
        )

    # =====================================================
    # Cache
    # =====================================================

    @classmethod
    def online_users(cls) -> List[Dict]:

        return OcservCache.users()

    @classmethod
    def sessions(cls, username: str) -> List[Dict]:

        user = OcservCache.user(username)

        if user:
            return [user]

        return []

    @classmethod
    def disconnect_user(cls, username: str):

        result = subprocess.run(
            [
                "occtl",
                "disconnect",
                "user",
                username,
            ],
            capture_output=True,
            text=True,
        )

        if result.returncode != 0:
            raise Exception(result.stderr.strip())

        return True

    @classmethod
    def traffic(cls, username: str):

        s = OcservCache.user(username)

        if s is None:

            return {
                "status": "Offline",
                "ip": "-",
                "device": "-",
                "connected": "-",
                "rx": "0 B",
                "tx": "0 B",
                "total": "0 B",
            }

        rx = (
            s.get("RX")
            or s.get("Bytes received")
            or s.get("Recv")
            or "0 B"
        )

        tx = (
            s.get("TX")
            or s.get("Bytes sent")
            or s.get("Sent")
            or "0 B"
        )

        return {
            "status": "Online",
            "ip": s.get("Remote IP") or s.get("IP") or "-",
            "device": s.get("Device") or s.get("User Agent") or "-",
            "connected": s.get("Connected at") or s.get("Connected") or "-",
            "rx": rx,
            "tx": tx,
            "total": f"{rx} / {tx}",
        }

    @classmethod
    def online_count(cls):

        return OcservCache.online_count()
