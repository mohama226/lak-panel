import json
import os

BASE_DIR = os.path.dirname(os.path.dirname(__file__))

CONFIG_FILE = os.path.join(BASE_DIR, "panel_settings.json")


DEFAULT_SETTINGS = {
    "dashboard": {
        "auto_refresh": True,
        "refresh_interval": 2
    }
}


def load_settings():

    if not os.path.exists(CONFIG_FILE):

        save_settings(DEFAULT_SETTINGS)

        return DEFAULT_SETTINGS

    try:

        with open(CONFIG_FILE, "r") as f:

            return json.load(f)

    except Exception:

        save_settings(DEFAULT_SETTINGS)

        return DEFAULT_SETTINGS


def save_settings(data):

    with open(CONFIG_FILE, "w") as f:

        json.dump(data, f, indent=4)


def get_dashboard_settings():

    settings = load_settings()

    return settings.get("dashboard", DEFAULT_SETTINGS["dashboard"])


def update_dashboard_settings(auto_refresh, interval):

    settings = load_settings()

    settings["dashboard"] = {

        "auto_refresh": auto_refresh,

        "refresh_interval": interval

    }

    save_settings(settings)
