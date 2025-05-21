from flask import Flask
from prometheus_flask_exporter import PrometheusMetrics
import logging

app = Flask(__name__)
metrics = PrometheusMetrics(app)
logging.basicConfig(level=logging.INFO)

@app.route("/health")
def health_check():
    return "OK", 200

@app.route('/error-endpoint')
def trigger_error():
    # 模拟 500 错误
    abort(500)

@app.route('/')
def home():
    return "Welcome to Flask Docker App", 200

@app.route('/')
def index():
    return "Hello, World!"

if __name__ == "__main__":
    # 必须绑定到0.0.0.0以允许外部访问
    app.run(host="0.0.0.0", port=5000)
