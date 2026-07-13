from flask import Flask,render_template,request,redirect,session
from database import db
from models import Admin
from werkzeug.security import check_password_hash


import config


app=Flask(__name__)

app.secret_key="l-panel-secret"


app.config.from_object(config)


db.init_app(app)



@app.route("/",methods=["GET","POST"])
def login():

    if request.method=="POST":

        user=request.form["username"]
        pw=request.form["password"]


        admin=Admin.query.filter_by(
            username=user
        ).first()


        if admin and check_password_hash(
            admin.password,
            pw
        ):

            session["admin"]=user

            return redirect("/dashboard")


    return render_template("login.html")




@app.route("/dashboard")
def dashboard():

    if "admin" not in session:
        return redirect("/")


    return render_template(
        "dashboard.html",
        user=session["admin"]
    )



if __name__=="__main__":
    app.run(
        host="0.0.0.0",
        port=5000
    )
