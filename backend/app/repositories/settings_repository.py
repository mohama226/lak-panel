from sqlalchemy.orm import Session

from app.db.models import Setting


class SettingsRepository:

    def __init__(self, db: Session):
        self.db = db

    def get(self, key: str):

        return (
            self.db.query(Setting)
            .filter(Setting.key == key)
            .first()
        )

    def get_value(self, key: str, default=None):

        item = self.get(key)

        if item:
            return item.value

        return default

    def set(self, key: str, value: str):

        item = self.get(key)

        if item is None:

            item = Setting(
                key=key,
                value=value,
            )

            self.db.add(item)

        else:

            item.value = value

        self.db.commit()

        return item

    def all(self):

        return self.db.query(Setting).all()
