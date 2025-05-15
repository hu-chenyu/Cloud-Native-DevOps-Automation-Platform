from flask import Flask
import logging

app = Flask(__name__)
logging.basicConfig(level=logging.INFO)

@app.route("/health")
def health_check():
    return "OK", 200

@app.route('/')
def home():
    return "Welcome to Flask Docker App", 200

if __name__ == "__main__":
    # 必须绑定到0.0.0.0以允许外部访问
    app.run(host="0.0.0.0", port=5000)
