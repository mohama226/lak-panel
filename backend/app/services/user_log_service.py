from app.repositories.user_log_repository import UserLogRepository


class UserLogService:

    def __init__(self, repo: UserLogRepository):
        self.repo = repo

    def log(
        self,
        username: str,
        event: str,
        ip: str = "",
        details: str = "",
    ):

        return self.repo.create(
            username=username,
            event=event,
            ip=ip,
            details=details,
        )

    def list(self, username: str):

        return self.repo.list(username)

    def clear(self, username: str):

        self.repo.clear(username)
