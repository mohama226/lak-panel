from backend.extensions import db
from datetime import datetime


class OcservUser(db.Model):

    __tablename__ = "ocserv_users"


    id = db.Column(
        db.Integer,
        primary_key=True
    )


    user_id = db.Column(
        db.Integer,
        db.ForeignKey("users.id"),
        nullable=False
    )


    oc_username = db.Column(
        db.String(64),
        unique=True,
        nullable=False
    )


    oc_password = db.Column(
        db.String(255),
        nullable=False
    )


    max_devices = db.Column(
        db.Integer,
        default=1
    )


    enabled = db.Column(
        db.Boolean,
        default=True
    )


    created_at = db.Column(
        db.DateTime,
        default=datetime.utcnow
    )


    user = db.relationship(
        "User",
        backref="ocserv_account"
    )
