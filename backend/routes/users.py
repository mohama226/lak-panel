from flask import Blueprint, render_template

from backend.models.user import User

users_bp = Blueprint(
    "users",
    __name__
)


@users_bp.route("/users")
def users():

    users = User.query.order_by(
        User.username
    ).all()

    return render_template(
        "users.html",
        users=users
    )
