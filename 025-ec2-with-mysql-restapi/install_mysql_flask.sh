#!/bin/bash

# install_mysql_flask.sh
# This script will be executed when the EC2 instance boots up

set -e

# Update system packages
apt-get update -y

# Install Python and pip
apt-get install -y python3 python3-pip python3-venv

# Set MySQL root password non-interactively
export DEBIAN_FRONTEND=noninteractive
echo "mysql-server mysql-server/root_password password ${mysql_root_password}" | debconf-set-selections
echo "mysql-server mysql-server/root_password_again password ${mysql_root_password}" | debconf-set-selections

# Install MySQL server
apt-get install -y mysql-server mysql-client

# Start and enable MySQL service
systemctl start mysql
systemctl enable mysql

# Wait for MySQL to be ready
sleep 10

# Secure MySQL installation (automated)
mysql -u root -p${mysql_root_password} <<EOF
-- Remove anonymous users
DELETE FROM mysql.user WHERE User='';

-- Disallow root login remotely
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');

-- Remove test database
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';

-- Reload privilege tables
FLUSH PRIVILEGES;
EOF

# Create application database and user
mysql -u root -p${mysql_root_password} <<EOF
CREATE DATABASE IF NOT EXISTS guestbook_db;
CREATE USER IF NOT EXISTS 'app_user'@'localhost' IDENTIFIED BY '${app_db_password}';
GRANT ALL PRIVILEGES ON guestbook_db.* TO 'app_user'@'localhost';
FLUSH PRIVILEGES;
EOF

# Create application directory
mkdir -p /opt/flask-app
cd /opt/flask-app

# Create virtual environment
python3 -m venv venv
source venv/bin/activate

# Install Python dependencies
pip install flask pymysql python-dotenv cryptography

# Create the Flask application
cat > app.py << 'FLASK_APP_EOF'
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
FLASK_APP_EOF

# Create environment variables file
cat > .env << ENV_EOF
DB_HOST=localhost
DB_USER=app_user
DB_PASSWORD=${app_db_password}
DB_NAME=guestbook_db
ENV_EOF

# Create systemd service for Flask app
cat > /etc/systemd/system/flask-app.service << SERVICE_EOF
[Unit]
Description=Flask Guestbook Application
After=network.target mysql.service
Requires=mysql.service

[Service]
Type=simple
User=ubuntu
WorkingDirectory=/opt/flask-app
Environment=PATH=/opt/flask-app/venv/bin
ExecStart=/opt/flask-app/venv/bin/python app.py
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
SERVICE_EOF

# Set permissions
chown -R ubuntu:ubuntu /opt/flask-app
chmod +x /opt/flask-app/app.py

# Enable and start Flask service
systemctl daemon-reload
systemctl enable flask-app
systemctl start flask-app

# Log installation completion
echo "MySQL and Flask installation completed at $(date)" >> /var/log/install.log
echo "MySQL root password is set" >> /var/log/install.log
echo "Flask app started on port 5000" >> /var/log/install.log

# Create a comprehensive status check script
cat > /home/ubuntu/check_services.sh << 'SCRIPT_EOF'
#!/bin/bash
echo "=== System Status Check ==="
echo "Date: $(date)"
echo

echo "=== MySQL Status ==="
systemctl status mysql --no-pager -l | head -10
echo

echo "=== Flask App Status ==="
systemctl status flask-app --no-pager -l | head -10
echo

echo "=== MySQL Process ==="
ps aux | grep mysql | grep -v grep
echo

echo "=== Flask Process ==="
ps aux | grep python | grep -v grep
echo

echo "=== Network Ports ==="
echo "MySQL (3306):"
netstat -tlnp | grep :3306
echo "Flask (5000):"
netstat -tlnp | grep :5000
echo

echo "=== MySQL Version ==="
mysql --version
echo

echo "=== Test MySQL Connection ==="
mysql -u app_user -p${app_db_password} -D guestbook_db -e "SELECT 'MySQL connection successful' as status;" 2>/dev/null && echo "✓ MySQL connection successful" || echo "✗ MySQL connection failed"
echo

echo "=== Test Flask Health Check ==="
curl -s http://localhost:5000/health | python3 -m json.tool 2>/dev/null && echo "✓ Flask health check successful" || echo "✗ Flask health check failed"
echo

echo "=== Application Logs ==="
echo "Flask app logs (last 5 lines):"
journalctl -u flask-app --no-pager -n 5
SCRIPT_EOF

chmod +x /home/ubuntu/check_services.sh
chown ubuntu:ubuntu /home/ubuntu/check_services.sh