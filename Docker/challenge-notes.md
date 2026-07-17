# Docker Challenge – Multi-Container Flask Application

## Overview

The aim of this challenge was to build a complete multi-container application using Docker and Docker Compose.

Rather than running a single application inside one container, the project separates different responsibilities into independent services. This follows the same design principles used in modern cloud applications and microservice architectures.

The application consists of:

- A Flask web application
- A Redis database
- An NGINX reverse proxy
- Docker Compose to orchestrate the environment

During the challenge I learned how multiple containers communicate, how Docker networking works, how persistent storage is achieved using volumes, and how applications can be scaled horizontally.

---

# Project Architecture

```
                    Browser
                       │
                 localhost:5000
                       │
                NGINX Reverse Proxy
                       │
        ┌──────────────┼──────────────┐
        │              │              │
     Flask 1        Flask 2        Flask 3
        │              │              │
        └──────────────┼──────────────┘
                       │
                    Redis
                       │
                 Docker Volume
```

Each container performs a single responsibility, following Docker best practices.

---

# Stage 1 - Building the Flask Application

The first step was creating a simple Python Flask application.

The application exposes two endpoints:

## /

Returns a welcome message.

## /count

Every request increments a value stored inside Redis and returns the updated visit count.

This demonstrated how an application can communicate with another container over Docker's internal network.

Initially the Redis hostname was hardcoded:

```python
host="redis"
```

Docker Compose automatically provides DNS resolution between containers, meaning the Flask container can locate Redis simply by using its service name.

---

# Stage 2 - Containerising the Application

The Flask application was then containerised using a Dockerfile.

The Dockerfile performs several tasks:

- Starts from an official Python image
- Creates a working directory
- Copies the application files
- Installs dependencies
- Exposes the application port
- Starts the Flask application

Workflow:

```
Application Code

↓

Dockerfile

↓

Docker Image

↓

Running Container
```

Building an image allows the application to run consistently regardless of the underlying operating system.

---

# Stage 3 - Introducing Docker Compose

Managing several containers individually quickly becomes difficult.

Docker Compose solves this problem by allowing every service to be defined in a single YAML configuration file.

Compose automatically:

- Builds images
- Starts containers
- Creates networks
- Connects containers together
- Manages volumes

This allows the entire application to be started using a single command.

```bash
docker compose up
```

---

# Stage 4 - Docker Networking

One of the most important concepts learned during this challenge was Docker networking.

Docker Compose automatically creates a private bridge network for every project.

Each service joins this network and receives automatic DNS resolution.

Instead of connecting to Redis using an IP address, the Flask application simply connects to:

```python
host="redis"
```

Docker resolves this service name automatically.

This removes the need to manage IP addresses manually.

---

# Stage 5 - Persistent Storage

Initially, Redis stored all data inside its own container.

This created a problem.

If the Redis container was deleted, the visit counter would also disappear.

To solve this, a Docker volume was introduced.

```yaml
volumes:
  - redis-data:/data
```

Docker volumes exist independently of containers.

This means that containers can be recreated without losing application data.

Benefits include:

- Persistent data
- Easier backups
- Data survives container recreation
- Better production practices

---

# Stage 6 - Environment Variables

Originally the Redis connection details were written directly inside the Python application.

To improve flexibility, these values were moved into environment variables.

Docker Compose now provides:

```yaml
environment:
  REDIS_HOST: redis
  REDIS_PORT: 6379
```

The Flask application retrieves them using:

```python
os.getenv()
```

This makes the application portable because configuration can change without modifying the source code.

---

# Stage 7 - Horizontal Scaling

The next objective was improving availability.

Instead of running a single Flask container, Docker Compose was used to launch three identical instances.

```bash
docker compose up --scale flask=3
```

Running multiple containers provides:

- Better fault tolerance
- Improved scalability
- Increased request handling capacity

Each Flask container runs exactly the same application from the same Docker image.

---

# Stage 8 - Load Balancing with NGINX

Scaling Flask introduces another challenge.

Only one container can publish port 5000 on the host machine.

To solve this, an NGINX reverse proxy was introduced.

The browser communicates only with NGINX.

NGINX forwards incoming requests to one of the available Flask containers.

Architecture:

```
Browser

↓

NGINX

↓

Flask Containers

↓

Redis
```

NGINX uses round-robin load balancing by default, distributing requests between the available Flask instances.

The Flask application displays its container hostname, making it easy to verify that different containers are serving requests.

---

# Docker Concepts Demonstrated

Throughout this challenge I gained practical experience with:

- Docker Images
- Docker Containers
- Dockerfiles
- Docker Compose
- Docker Networks
- Docker DNS
- Docker Volumes
- Environment Variables
- Reverse Proxies
- Horizontal Scaling
- Load Balancing
- Multi-container Applications

---

# Useful Commands

Build and start the application:

```bash
docker compose up -d --build
```

Scale Flask containers:

```bash
docker compose up -d --scale flask=3
```

Stop the application:

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

Follow logs in real time:

```bash
docker compose logs -f
```

List Docker volumes:

```bash
docker volume ls
```

List Docker networks:

```bash
docker network ls
```

---

# Skills Developed

By completing this project I developed practical experience in:

- Containerising applications
- Building Docker images
- Writing Dockerfiles
- Managing multi-container environments
- Understanding Docker networking
- Implementing persistent storage
- Configuring applications using environment variables
- Scaling services horizontally
- Introducing reverse proxies
- Understanding how modern containerised applications are deployed

---

# Key Takeaways

This challenge demonstrated that Docker is much more than simply running containers.

It provides an entire ecosystem for packaging, networking, scaling and managing applications in a consistent and repeatable manner.

By combining Docker Compose, networking, volumes, environment variables and NGINX, it is possible to build an application that more closely resembles how software is deployed in real production environments.