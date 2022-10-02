from flask import Flask
import time

app = Flask(__name__)

@app.route("/")
def hello_world():
    return "<p>Hello, World!</p>"


@app.route("/times")
def times():
    t=time.localtime()
    current_time = time.strftime("%H:%M:%S", t)
    return current_time

if __name__ == '__main__':
  app.run(host='0.0.0.0')