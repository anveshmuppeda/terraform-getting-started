import os
import pymysql
from flask import Flask, request, jsonify
from dotenv import load_dotenv

# Load environment variables from .env file for local development
load_dotenv()

app = Flask(__name__)

def get_db_connection():
    """Reads DB credentials from environment variables and connects to the database."""
    try:
        db_host = os.environ.get("DB_HOST")
        db_user = os.environ.get("DB_USER")
        db_password = os.environ.get("DB_PASSWORD")
        db_name = os.environ.get("DB_NAME")

        if not all([db_host, db_user, db_password, db_name]):
            raise ValueError("Missing one or more database environment variables (DB_HOST, DB_USER, DB_PASSWORD, DB_NAME)")

        connection = pymysql.connect(
            host=db_host,
            user=db_user,
            password=db_password,
            database=db_name,
            connect_timeout=5,
            cursorclass=pymysql.cursors.DictCursor # Returns rows as dictionaries
        )

        # Create table if it doesn't exist
        with connection.cursor() as cursor:
            cursor.execute("""
                CREATE TABLE IF NOT EXISTS guestbook (
                    id INT AUTO_INCREMENT PRIMARY KEY,
                    entry VARCHAR(255) NOT NULL,
                    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
                );
            """)
        connection.commit()
        return connection
    except Exception as e:
        print(f"Error connecting to database: {e}")
        raise

@app.route("/health", methods=["GET"])
def health_check():
    """Health check endpoint to verify database connectivity."""
    try:
        conn = get_db_connection()
        conn.close()
        return jsonify({"status": "ok", "message": "Database connection successful"}), 200
    except Exception as e:
        return jsonify({"status": "error", "message": str(e)}), 500

@app.route("/entries", methods=["POST"])
def add_entry():
    """Adds a new entry to the guestbook."""
    data = request.get_json()
    if not data or 'entry' not in data:
        return jsonify({"error": "Missing 'entry' in request body"}), 400

    new_entry = data['entry']
    conn = get_db_connection()
    try:
        with conn.cursor() as cursor:
            cursor.execute("INSERT INTO guestbook (entry) VALUES (%s)", (new_entry,))
        conn.commit()
        return jsonify({"message": "Entry added successfully!"}), 201
    finally:
        conn.close()

@app.route("/entries", methods=["GET"])
def get_entries():
    """Retrieves all entries from the guestbook."""
    conn = get_db_connection()
    try:
        with conn.cursor() as cursor:
            cursor.execute("SELECT id, entry, created_at FROM guestbook ORDER BY created_at DESC")
            entries = cursor.fetchall()
            # Convert datetime objects to string for JSON serialization
            for entry in entries:
                if 'created_at' in entry and entry['created_at']:
                    entry['created_at'] = entry['created_at'].isoformat()
            return jsonify(entries)
    finally:
        conn.close()

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5000)