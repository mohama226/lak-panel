from flask import Blueprint
from flask import render_template
from flask import redirect
from flask import url_for

main_bp = Blueprint("main", __name__)


@main_bp.route("/")
def index():
    return redirect(url_for("main.login"))


@main_bp.route("/login")
def login():
    return render_template("login.html")


@main_bp.route("/dashboard")
def dashboard():
    return render_template("dashboard.html")
