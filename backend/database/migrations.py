from backend.extensions import db
from sqlalchemy import text


def migrate_database():

    migrations = [

        """
        ALTER TABLE users
        ADD COLUMN IF NOT EXISTS traffic_limit BIGINT DEFAULT 0;
        """,

        """
        ALTER TABLE users
        ADD COLUMN IF NOT EXISTS used_traffic BIGINT DEFAULT 0;
        """,

        """
        ALTER TABLE users
        ADD COLUMN IF NOT EXISTS status VARCHAR(20) DEFAULT 'active';
        """,

        """
        ALTER TABLE users
        ADD COLUMN IF NOT EXISTS server_id INTEGER;
        """,

        """
        ALTER TABLE users
        ADD COLUMN IF NOT EXISTS created_at TIMESTAMP DEFAULT NOW();
        """

    ]


    for sql in migrations:
        try:
            db.session.execute(text(sql))
            db.session.commit()

        except Exception as e:
            db.session.rollback()
            print("Migration error:", e)
