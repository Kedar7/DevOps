Express (Node) frontend + Flask backend (Dockerized)

Structure:
- frontend/: Node/Express app serving a form and forwarding submissions to backend
- backend/: Flask app that accepts submissions and stores them in data.json
- docker-compose.yml: connects frontend and backend

Quick start (local, requires Docker & Docker Compose):

1. Build and start services:
   docker-compose up --build

2. Visit frontend:
   http://localhost:3000

3. The frontend form forwards submissions to the Flask backend and redirects to /success on success.

Pushing images to Docker Hub (example commands):
# Build images locally:
# docker build -t <dockerhub-username>/ef_backend:latest ./backend
# docker build -t <dockerhub-username>/ef_frontend:latest ./frontend

# Login to Docker Hub:
# docker login

# Push images:
# docker push <dockerhub-username>/ef_backend:latest
# docker push <dockerhub-username>/ef_frontend:latest

Notes:
- Do NOT commit secrets. Use environment variables for credentials.
- This repo includes .gitignore to avoid node_modules and virtual envs.

To run without Docker (dev):
# Backend
python3 -m venv venv && source venv/bin/activate
pip install -r backend/requirements.txt
python3 backend/app.py

# Frontend
# Node 18+ required
npm install --prefix frontend
node frontend/index.js

End of README.
