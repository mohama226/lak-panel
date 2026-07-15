from backend.extensions import db
from datetime import datetime


class Session(db.Model):

    __tablename__ = "sessions"


    id = db.Column(
        db.Integer,
        primary_key=True
    )


    username = db.Column(
        db.String(64),
        nullable=False
    )


    ip_address = db.Column(
        db.String(64)
    )


    device = db.Column(
        db.String(100)
    )


    upload = db.Column(
        db.BigInteger,
        default=0
    )


    download = db.Column(
        db.BigInteger,
        default=0
    )


    connected_at = db.Column(
        db.DateTime,
        default=datetime.utcnow
    )


    disconnected_at = db.Column(
        db.DateTime
    )
