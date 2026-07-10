from app.db.models import UserLog


class SecurityService:


    def __init__(self, db):
        self.db = db



    def analyze(self, username):


        logs = (

            self.db.query(UserLog)

            .filter(
                UserLog.username == username
            )

            .order_by(
                UserLog.created_at.desc()
            )

            .limit(50)

            .all()

        )


        ips = []

        devices = []


        for log in logs:


            if log.ip_address:

                if log.ip_address not in ips:

                    ips.append(
                        log.ip_address
                    )


            device = getattr(
                log,
                "device",
                None
            )


            if device:

                if device not in devices:

                    devices.append(
                        device
                    )



        risk = "LOW"



        if len(ips) > 5:

            risk="MEDIUM"



        if len(ips) > 10:

            risk="HIGH"



        return {


            "risk":
                risk,


            "ips":
                ips[:10],


            "devices":
                devices[:10],


            "total_ips":
                len(ips)

        }
