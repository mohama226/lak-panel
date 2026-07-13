import os


DATABASE_URL = os.getenv(
    "DATABASE_URL"
)


PORT = os.getenv(
    "PORT",
    "8080"
)
