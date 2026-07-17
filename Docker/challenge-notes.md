# Docker Challenge - Flask, Redis and NGINX

## Objective

Build a multi-container application using Docker Compose consisting of:

- Flask web application
- Redis database
- NGINX reverse proxy

The project demonstrates container networking, persistent storage, environment variables and horizontal scaling.

---

## Architecture

Browser

↓

NGINX

↓

Flask (x3)

↓

Redis

↓

Docker Volume

---

## Components

### Flask

- Python web application
- Reads Redis connection details from environment variables
- Increments a shared visit counter
- Displays the container hostname

---

### Redis

Used as the shared in-memory database.

Stores:

- Visit counter

Persistent storage is provided using a Docker volume.

---

### NGINX

Acts as a reverse proxy and load balancer.

Responsibilities:

- Accept incoming HTTP requests
- Forward traffic to Flask containers
- Distribute requests across multiple instances

---

## Docker Concepts Demonstrated

- Dockerfiles
- Images
- Containers
- Docker Compose
- Docker Networking
- Docker DNS
- Volumes
- Environment Variables
- Scaling
- Load Balancing

---

## Bonus Features

### Persistent Storage

Redis data stored using:

```yaml
volumes:
  - redis-data:/data
```

---

### Environment Variables

Flask configuration supplied through Docker Compose.

Example:

```yaml
environment:
  REDIS_HOST: redis
  REDIS_PORT: 6379
```

---

### Scaling

Three Flask containers deployed using:

```bash
docker compose up -d --build --scale flask=3
```

---

## Useful Commands

Build and start:

```bash
docker compose up -d --build
```

Scale:

```bash
docker compose up -d --scale flask=3
```

Stop:

```bash
docker compose down
```

View running containers:

```bash
docker compose ps
```

View logs:

```bash
docker compose logs
```

Follow logs:

```bash
docker compose logs -f
```

---

## Skills Gained

- Building Docker images
- Creating Dockerfiles
- Running containers
- Managing multi-container applications
- Using Docker Compose
- Configuring container networking
- Persisting application data
- Passing configuration using environment variables
- Scaling services horizontally
- Implementing basic load balancing with NGINX