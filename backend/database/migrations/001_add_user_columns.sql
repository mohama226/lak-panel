ALTER TABLE users
ADD COLUMN IF NOT EXISTS traffic_limit BIGINT DEFAULT 0;

ALTER TABLE users
ADD COLUMN IF NOT EXISTS used_traffic BIGINT DEFAULT 0;

ALTER TABLE users
ADD COLUMN IF NOT EXISTS status VARCHAR(20) DEFAULT 'active';

ALTER TABLE users
ADD COLUMN IF NOT EXISTS created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP;

ALTER TABLE users
ADD COLUMN IF NOT EXISTS server_id INTEGER;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM information_schema.table_constraints
        WHERE constraint_name = 'users_server_id_fkey'
    )
    THEN
        ALTER TABLE users
        ADD CONSTRAINT users_server_id_fkey
        FOREIGN KEY (server_id)
        REFERENCES servers(id);
    END IF;
END $$;
