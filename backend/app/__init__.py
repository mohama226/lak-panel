from flask import Flask

from flask_cors import CORS

from config import *

from database import db



def create_app():

    app = Flask(__name__)


    app.config["SECRET_KEY"] = SECRET_KEY


    app.config["SQLALCHEMY_DATABASE_URI"] = (
        SQLALCHEMY_DATABASE_URI
    )


    app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False



    CORS(
        app,
        resources={
            r"/api/*":{
                "origins":"*"
            }
        }
    )



    db.init_app(app)



    # Authentication Routes

    from routes.auth import auth

    app.register_blueprint(

        auth,

        url_prefix="/api"

    )



    @app.get("/api/health")
    def health():

        return {

            "status":"ok",

            "panel":"L-PANEL"

        }



    with app.app_context():

        db.create_all()



    return app
