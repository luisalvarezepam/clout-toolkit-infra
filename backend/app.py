from flask import Flask
import os
import psycopg2
from azure.identity import DefaultAzureCredential
from azure.keyvault.secrets import SecretClient

app = Flask(__name__)

@app.route("/")
def index():
    return "Test Backend is running!"

@app.route("/db")
def test_db():
    try:
        conn = psycopg2.connect(
            host=os.environ["DB_HOST"],
            dbname=os.environ["DB_NAME"],
            user=os.environ["DB_USER"],
            password=os.environ["DB_PASSWORD"]
        )
        cur = conn.cursor()
        cur.execute("SELECT version();")
        version = cur.fetchone()
        conn.close()
        return f"Connected to DB! Version: {version}"
    except Exception as e:
        return f"DB Connection error: {str(e)}", 500

@app.route("/secret")
def get_secret():
    try:
        credential = DefaultAzureCredential()
        vault_url = os.environ["KEY_VAULT_URI"]
        secret_name = "cloudkit-db-password"

        client = SecretClient(vault_url=vault_url, credential=credential)
        secret = client.get_secret(secret_name)
        return f"Secret Value Retrieved: {secret.value}"
    except Exception as e:
        return f"Key Vault error: {str(e)}", 500

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=int(os.environ.get("PORT", 5000)))
