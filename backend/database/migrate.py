import os
import psycopg2

from backend.config import Config


def run_migrations():

    print("Starting database migrations...")


    conn = psycopg2.connect(
        Config.SQLALCHEMY_DATABASE_URI
    )


    cur = conn.cursor()


    migration_dir = os.path.join(
        os.path.dirname(__file__),
        "migrations"
    )


    files = sorted(
        os.listdir(migration_dir)
    )


    for filename in files:

        if filename.endswith(".sql"):

            print(
                "Running:",
                filename
            )


            path = os.path.join(
                migration_dir,
                filename
            )


            with open(path, "r") as f:

                sql = f.read()


            cur.execute(sql)


            conn.commit()


    cur.close()

    conn.close()


    print(
        "Migration completed"
    )



if __name__ == "__main__":

    run_migrations()
