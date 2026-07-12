import subprocess


class OCServDriver:

    def __init__(self, ocpasswd="/etc/ocserv/ocpasswd"):
        self.ocpasswd = ocpasswd

    def create_user(self, username: str, password: str):

        cmd = [
            "ocpasswd",
            "-c",
            self.ocpasswd,
            username,
        ]

        process = subprocess.Popen(
            cmd,
            stdin=subprocess.PIPE,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True,
        )

        process.communicate(f"{password}\n{password}\n")

        return process.returncode == 0

    def delete_user(self, username: str):

        cmd = [
            "ocpasswd",
            "-c",
            self.ocpasswd,
            "-d",
            username,
        ]

        result = subprocess.run(cmd)

        return result.returncode == 0

    def lock_user(self, username: str):

        cmd = [
            "ocpasswd",
            "-c",
            self.ocpasswd,
            "-l",
            username,
        ]

        result = subprocess.run(cmd)

        return result.returncode == 0

    def unlock_user(self, username: str):

        cmd = [
            "ocpasswd",
            "-c",
            self.ocpasswd,
            "-u",
            username,
        ]

        result = subprocess.run(cmd)

        return result.returncode == 0
