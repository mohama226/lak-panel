from flask import Blueprint, request, jsonify
from werkzeug.security import check_password_hash


auth = Blueprint(
    "auth",
    __name__
)


# موقت برای اولین تست Login
# بعداً به PostgreSQL منتقل می‌شود

ADMIN_USER = "admin"

ADMIN_PASSWORD = "admin123"



@auth.post("/login")
def login():


    data = request.get_json()


    if not data:

        return jsonify({

            "success": False,

            "message": "Invalid request"

        }),400



    username = data.get(
        "username"
    )


    password = data.get(
        "password"
    )



    if (

        username == ADMIN_USER

        and

        password == ADMIN_PASSWORD

    ):


        return jsonify({

            "success": True,

            "token": "lpanel-demo-token",

            "user":{

                "username":username,

                "role":"admin"

            }

        })



    return jsonify({

        "success":False,

        "message":"Invalid username or password"

    }),401
