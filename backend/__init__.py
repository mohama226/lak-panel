from flask import Flask
from backend.extensions import db
from backend.config import Config


def create_app():

    app = Flask(__name__)

    app.config.from_object(Config)


    db.init_app(app)


    from backend.models import (
        User,
        Server,
        Session
    )


    with app.app_context():
        db.create_all()


    return app
