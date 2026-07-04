# lak-panel

Web-based management panel for OCServ VPN users.

## Features
- Create VPN users
- Delete users
- Manage expiry
- OCServ integration

## Tech Stack
- FastAPI
- SQLite
- OCServ (ocpasswd)

## Run

```bash
cd backend
pip install -r requirements.txt
uvicorn app.main:app --reload
