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


        from backend.database.migrations import migrate_database

        migrate_database()



    from backend.routes import (
        dashboard_bp,
        users_bp,
        servers_bp,
        sessions_bp,
        auth_bp
    )


    app.register_blueprint(dashboard_bp)
    app.register_blueprint(users_bp)
    app.register_blueprint(servers_bp)
    app.register_blueprint(sessions_bp)
    app.register_blueprint(auth_bp)



    from backend.api import (
        users_api,
        servers_api,
        sessions_api
    )


    app.register_blueprint(users_api)
    app.register_blueprint(servers_api)
    app.register_blueprint(sessions_api)


    return app
