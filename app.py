"""
Flask app that:
- /api returns JSON list read from backend/data.json
- /submit (GET) shows form
- /submit (POST) inserts into MongoDB using MONGODB_URI env var
- /success shows success message

Configure:
- Set MONGODB_URI (and optional MONGODB_DB) in environment
- Install requirements from requirements.txt
"""
from flask import Flask, request, render_template, redirect, url_for, jsonify
from pymongo import MongoClient, errors
import os
import json

app = Flask(__name__)

DATA_FILE = os.path.join(os.path.dirname(__file__), "backend", "data.json")

# Initialize MongoDB client lazily
def get_db():
    uri = os.environ.get("MONGODB_URI")
    if not uri:
        raise RuntimeError("MONGODB_URI not set in environment")
    db_name = os.environ.get("MONGODB_DB") or None
    client = MongoClient(uri)
    # If DB name provided, use it; otherwise use default from URI or 'test'
    if db_name:
        return client[db_name]
    try:
        # get_default_database works when the URI includes a database
        return client.get_default_database()
    except Exception:
        return client["test"]


@app.route("/api")
def api_list():
    try:
        with open(DATA_FILE, "r", encoding="utf-8") as f:
            data = json.load(f)
    except FileNotFoundError:
        return jsonify([])
    except json.JSONDecodeError:
        return jsonify({"error": "backend data file is invalid"}), 500
    return jsonify(data)


@app.route("/submit", methods=["GET", "POST"])
def submit():
    error = None
    if request.method == "POST":
        name = request.form.get("name", "").strip()
        email = request.form.get("email", "").strip()
        message = request.form.get("message", "").strip()
        if not name or not email:
            error = "Name and email are required."
            return render_template("form.html", error=error, name=name, email=email, message=message)
        doc = {"name": name, "email": email, "message": message}
        try:
            db = get_db()
            coll = db["submissions"]
            coll.insert_one(doc)
            return redirect(url_for("success"))
        except Exception as e:
            error = str(e)
            return render_template("form.html", error=error, name=name, email=email, message=message)
    return render_template("form.html", error=error)


@app.route("/success")
def success():
    return render_template("result.html", message="Data submitted successfully")


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=int(os.environ.get("PORT", 5000)), debug=True)
