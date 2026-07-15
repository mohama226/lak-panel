from backend.models import Server
from backend.extensions import db


class ServerService:


    @staticmethod
    def all():

        return Server.query.all()



    @staticmethod
    def create(data):

        server = Server(

            name=data["name"],
            address=data["address"],
            port=data.get("port",443)

        )


        db.session.add(server)
        db.session.commit()


        return server
