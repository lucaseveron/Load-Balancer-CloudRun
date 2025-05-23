from flask import Flask
import os

app = Flask(__name__)

@app.route("/")
def hello():
    return "Hola mundo desde Cloud Run!"

if __name__ == "__main__":
    port = int(os.environ.get("PORT", 8080))  # Cloud Run usa esta variable
    app.run(host="0.0.0.0", port=port)





