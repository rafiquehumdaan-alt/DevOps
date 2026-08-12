from flask import Flask
import os
import redis
import socket

app = Flask(__name__)

# Read the Redis connection details from environment variables.
# The second values are defaults if the variables are not provided.
redis_host = os.getenv("REDIS_HOST", "redis")
redis_port = int(os.getenv("REDIS_PORT", "6379"))

r = redis.Redis(
    host=redis_host,
    port=redis_port,
    decode_responses=True
)


@app.route("/")
def home():
    container_name = socket.gethostname()

    return (
        "Welcome to the Flask and Redis application! "
        f"Served by container: {container_name}"
    )


@app.route("/count")
def count():
    visits = r.incr("visits")
    container_name = socket.gethostname()

    return (
        f"This page has been visited {visits} times. "
        f"Served by container: {container_name}"
    )


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)