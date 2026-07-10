from sqlalchemy import func

from app.db.models import UserLog


class AnalyticsService:


    def __init__(self, db):
        self.db = db



    def user_summary(self, username):

        total_connections = (
            self.db.query(
                func.count(UserLog.id)
            )
            .filter(
                UserLog.username == username
            )
            .scalar()
        )


        last_connection = (
            self.db.query(UserLog)
            .filter(
                UserLog.username == username
            )
            .order_by(
                UserLog.created_at.desc()
            )
            .first()
        )


        return {

            "connections":
                total_connections or 0,


            "last_connection":
                last_connection.created_at
                if last_connection else "-",


        }



    def ip_history(self, username):

        logs = (

            self.db.query(UserLog)

            .filter(
                UserLog.username == username
            )

            .order_by(
                UserLog.created_at.desc()
            )

            .limit(20)

            .all()

        )


        return [

            {

            "ip":
                x.ip_address,


            "date":
                x.created_at,


            "device":
                getattr(
                    x,
                    "device",
                    "-"
                )

            }

            for x in logs

        ]
