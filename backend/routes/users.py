from flask import Blueprint, render_template, request, redirect, url_for
from backend.extensions import db
from backend.models.user import User
from datetime import datetime


users_bp = Blueprint(
    "users",
    __name__,
    url_prefix="/users"
)


@users_bp.route("/")
def users():

    users = User.query.order_by(
        User.username
    ).all()

    from backend.database.update_users import update_users_table
    update_users_table()

    return render_template(
        "users/list.html",
        users=users
    )


@users_bp.route("/add", methods=["GET","POST"])
def add_user():

    if request.method == "POST":

        user = User(
            username=request.form["username"],
            password=request.form["password"],
            traffic_limit=int(
                request.form.get(
                    "traffic_limit",
                    0
                )
            ),
            status="active"
        )

        db.session.add(user)
        db.session.commit()

        return redirect(
            url_for("users.users")
        )

    return render_template(
        "users/add.html"
    )


@users_bp.route("/edit/<int:id>", methods=["GET","POST"])
def edit_user(id):

    user = User.query.get_or_404(id)

    if request.method == "POST":

        user.username = request.form["username"]
        user.password = request.form["password"]

        user.traffic_limit = int(
            request.form.get(
                "traffic_limit",
                0
            )
        )

        user.status = request.form["status"]

        db.session.commit()

        return redirect(
            url_for("users.users")
        )

    return render_template(
        "users/edit.html",
        user=user
    )


@users_bp.route("/delete/<int:id>")
def delete_user(id):

    user = User.query.get_or_404(id)

    db.session.delete(user)
    db.session.commit()

    return redirect(
        url_for("users.users")
    )


@users_bp.route("/toggle/<int:id>")
def toggle_user(id):

    user = User.query.get_or_404(id)

    if user.status == "active":
        user.status = "disabled"
    else:
        user.status = "active"

    db.session.commit()

    return redirect(
        url_for("users.users")
    )
