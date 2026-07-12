from app.repositories.settings_repository import SettingsRepository


class SettingsService:

    def __init__(self, repository: SettingsRepository):
        self.repository = repository

    def get_calendar(self):
        return self.repository.get_value(
            "calendar",
            "gregorian",
        )

    def get_timezone(self):
        return self.repository.get_value(
            "timezone",
            "Asia/Tehran",
        )

    def get_time_format(self):
        return self.repository.get_value(
            "time_format",
            "24",
        )

    def save_localization(
        self,
        calendar: str,
        timezone: str,
        time_format: str,
    ):

        self.repository.set(
            "calendar",
            calendar,
        )

        self.repository.set(
            "timezone",
            timezone,
        )

        self.repository.set(
            "time_format",
            time_format,
        )

    def get_all(self):

        return {
            "calendar": self.get_calendar(),
            "timezone": self.get_timezone(),
            "time_format": self.get_time_format(),
        }
