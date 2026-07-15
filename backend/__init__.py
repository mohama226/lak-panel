from flask import Flask
from backend.extensions import db
from backend.config import Config

def create_app():
    app = Flask(__name__)

    # بارگذاری تنظیمات
    app.config.from_object(Config)

    # اتصال دیتابیس
    db.init_app(app)

    # Import مدل‌ها
    from backend.models import (
        User,
        Server,
        Session
    )

    # ایجاد جداول دیتابیس
    with app.app_context():
        db.create_all()

    # ======================== Blueprints ========================
    from backend.routes import (
        dashboard_bp,
        users_bp,
        servers_bp,
        sessions_bp,
        auth_bp
    )

    app.register_blueprint(dashboard_bp)
    app.register_blueprint(users_bp)          # فقط همین یک بار
    app.register_blueprint(servers_bp)
    app.register_blueprint(sessions_bp)
    app.register_blueprint(auth_bp)

    # ======================== API Blueprints ========================
    from backend.api import (
        users_api,
        servers_api,
        sessions_api
    )

    app.register_blueprint(users_api)
    app.register_blueprint(servers_api)
    app.register_blueprint(sessions_api)

    # هیچ ثبت اضافه‌ای برای users وجود ندارد

    return app
