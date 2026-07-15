from flask import Blueprint, jsonify, request

from backend.services.user_service import UserService
from backend.services.ocserv_service import OcservService

users_api = Blueprint(
    "users_api",
    __name__,
    url_prefix="/api/users"
)


# ========================= List Users =========================
@users_api.get("")
def list_users():

    users = UserService.get_all()

    return jsonify([
        {
            "id": u.id,
            "username": u.username,
            "expire_date": str(u.expire_date),
            "traffic_limit": u.traffic_limit,
            "used_traffic": u.used_traffic,
            "status": u.status,
            "server_id": u.server_id,
            "created_at": str(u.created_at)
        }
        for u in users
    ])


# ========================= Create User =========================
@users_api.post("")
def create_user():

    data = request.get_json()

    user = UserService.create(data)

    OcservService.add_user(
        user.username,
        data["password"]
    )

    return jsonify({
        "success": True,
        "id": user.id
    })


# ========================= Delete User =========================
@users_api.delete("/<int:user_id>")
def delete_user(user_id):

    user = UserService.get_by_id(user_id)

    if not user:
        return jsonify({"success": False}), 404

    OcservService.delete_user(user.username)

    UserService.delete(user)

    return jsonify({"success": True})


# ========================= Change Password =========================
@users_api.post("/<int:user_id>/password")
def password(user_id):

    user = UserService.get_by_id(user_id)

    if not user:
        return jsonify({"success": False}), 404

    data = request.get_json()

    OcservService.change_password(
        user.username,
        data["password"]
    )

    UserService.update_password(
        user,
        data["password"]
    )

    return jsonify({"success": True})
