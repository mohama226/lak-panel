from flask import Blueprint,render_template
from backend.models.user import User


users_bp = Blueprint(
    "users",
    __name__,
    url_prefix="/users"
)



@users_bp.route("/")
def users():

    data = User.query.order_by(
        User.username
    ).all()


    return render_template(
        "users/index.html",
        users=data
    )
