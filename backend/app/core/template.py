from fastapi.templating import Jinja2Templates

templates = Jinja2Templates(
    directory="app/templates"
)


def render(request, template, context=None):
    if context is None:
        context = {}

    context["request"] = request

    return templates.TemplateResponse(
        template,
        context,
    )


def get_setting(key, default=None):
    return default
