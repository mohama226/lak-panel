#!/usr/bin/env bash


source "$(dirname "$0")/variables.sh"


cd /opt/l-panel/backend


source venv/bin/activate


python3 - <<EOF

from app.database import Base,engine

Base.metadata.create_all(engine)

print("Database initialized")

EOF
