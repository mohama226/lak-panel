import json
import subprocess
import threading
import time


class OcservCache:

    _lock = threading.Lock()

    _users = []

    _last_update = 0

    _interval = 2

    _running = False

    @classmethod
    def update(cls):

        try:

            result = subprocess.run(
                [
                    "occtl",
                    "--json",
                    "show",
                    "users",
                ],
                capture_output=True,
                text=True,
                timeout=10,
            )

            if result.returncode != 0:
                return

            data = json.loads(result.stdout)

            if not isinstance(data, list):
                data = []

            with cls._lock:

                cls._users = data

                cls._last_update = time.time()

        except Exception:
            pass

    @classmethod
    def worker(cls):

        while cls._running:

            cls.update()

            time.sleep(cls._interval)

    @classmethod
    def start(cls):

        if cls._running:
            return

        cls._running = True

        thread = threading.Thread(
            target=cls.worker,
            daemon=True,
            name="OcservCache",
        )

        thread.start()

    @classmethod
    def stop(cls):

        cls._running = False

    @classmethod
    def users(cls):

        with cls._lock:

            return list(cls._users)

    @classmethod
    def user(cls, username):

        with cls._lock:

            for item in cls._users:

                name = (
                    item.get("Username")
                    or item.get("username")
                    or item.get("User")
                    or item.get("user")
                )

                if name == username:
                    return item

        return None

    @classmethod
    def online_count(cls):

        with cls._lock:
            return len(cls._users)

    @classmethod
    def last_update(cls):

        return cls._last_update
