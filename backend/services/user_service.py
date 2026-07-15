from backend.extensions import db
from backend.models import User


class UserService:


    @staticmethod
    def get_all():

        return User.query.all()


    @staticmethod
    def get_by_id(user_id):

        return User.query.get(user_id)


    @staticmethod
    def create(data):

        user = User(
            username=data["username"],
            password=data["password"],
            expire_date=data.get("expire_date"),
            traffic_limit=data.get("traffic_limit"),
        )

        db.session.add(user)
        db.session.commit()

        return user


    @staticmethod
    def delete(user):

        db.session.delete(user)
        db.session.commit()


    @staticmethod
    def update_password(user,password):

        user.password = password

        db.session.commit()

        return user
