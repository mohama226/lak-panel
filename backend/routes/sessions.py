from flask import Blueprint

sessions_bp = Blueprint(
    "sessions",
    __name__,
    url_prefix="/sessions"
)

@sessions_bp.route("/")
def sessions():

    return "Sessions"
