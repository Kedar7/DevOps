Flask + MongoDB example

This project contains a simple Flask app with:

- /api - returns a JSON list read from backend/data.json
- /submit - form that inserts into MongoDB (MONGODB_URI required)
- /success - success page

Setup

1. Create a Python virtual environment and install requirements:

   python3 -m venv venv
   source venv/bin/activate
   pip install -r requirements.txt

2. Set environment variables (see .env.example). For local testing, you can use a local MongoDB or MongoDB Atlas. Example:

   export MONGODB_URI="mongodb://localhost:27017"
   export MONGODB_DB="test"

3. Run the app:

   python3 app.py

4. Visit:
   - http://localhost:5000/api to get JSON data
   - http://localhost:5000/submit to view the form

Notes

- Do NOT commit real credentials. Use environment variables or a secrets manager.
- For deployment, configure the MONGODB_URI securely and set PORT if needed.
