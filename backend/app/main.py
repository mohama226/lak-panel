from fastapi import FastAPI
from fastapi.responses import HTMLResponse


app = FastAPI(
    title="LAK Panel",
    version="0.1.0"
)


@app.get("/", response_class=HTMLResponse)
def home():

    return """
    <!DOCTYPE html>
    <html lang="fa">
    <head>
        <meta charset="UTF-8">
        <title>LAK Panel</title>

        <style>

        body {
            background:#111827;
            color:white;
            font-family:tahoma;
            text-align:center;
            padding-top:100px;
        }

        .box {
            background:#1f2937;
            width:400px;
            margin:auto;
            padding:40px;
            border-radius:15px;
        }

        h1 {
            color:#38bdf8;
        }

        </style>

    </head>

    <body>

    <div class="box">

    <h1>LAK PANEL</h1>

    <p>
    Panel is running successfully
    </p>

    <p>
    Version 0.1.0
    </p>

    </div>

    </body>
    </html>
    """
