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
    app.register_blueprint(users_bp)
    app.register_blueprint(servers_bp)
    app.register_blueprint(sessions_bp)
    app.register_blueprint(auth_bp)

    # از این به بعد مسیر "/" و سایر مسیرها از طریق Blueprint مدیریت می‌شوند

    return app
