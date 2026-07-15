from backend.extensions import db


class Server(db.Model):

    __tablename__ = "servers"


    id = db.Column(
        db.Integer,
        primary_key=True
    )


    name = db.Column(
        db.String(100),
        nullable=False
    )


    address = db.Column(
        db.String(255)
    )


    port = db.Column(
        db.Integer,
        default=443
    )


    status = db.Column(
        db.String(20),
        default="active"
    )
