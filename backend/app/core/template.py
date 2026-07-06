from datetime import datetime

from fastapi.templating import Jinja2Templates

templates = Jinja2Templates(directory="app/templates")


SETTINGS = {}


def get_setting(key: str, default=None):
    return SETTINGS.get(key, default)


def set_setting(key: str, value):
    SETTINGS[key] = value


def render(request, template, context=None):

    if context is None:
        context = {}

    context.update(
        {
            "request": request,
            "server_time": datetime.now(),
            "app_name": get_setting("app_name", "LAK PANEL"),
            "app_version": get_setting("app_version", "2.0"),
            "company_name": get_setting("company_name", "LAK"),
        }
    )

    return templates.TemplateResponse(
        template,
        context,
    )
