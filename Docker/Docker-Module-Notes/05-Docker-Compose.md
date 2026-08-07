# Docker Notes - Part 5: Docker Compose

> Covers:
>
> - What is Docker Compose?
> - Why Docker Compose is Important
> - docker-compose.yml
> - Services
> - Networks
> - Volumes
> - Environment Variables
> - depends_on
> - Common Commands
> - Common Errors

---

# What is Docker Compose?

Docker Compose is a tool that allows you to define and manage **multiple containers** using a single YAML configuration file.

Instead of starting each container manually, you define everything once and start the entire application with one command.

---

# Why Use Docker Compose?

Imagine a web application with:

- Flask Application
- MySQL Database
- Redis Cache
- NGINX Reverse Proxy

Without Compose, you would need multiple `docker run` commands.

With Compose:

```bash
docker compose up
```

Everything starts automatically.

---

# Traditional vs Docker Compose

Without Compose:

```text
docker run ...

↓

docker run ...

↓

docker run ...

↓

docker run ...
```

Lots of manual work.

---

With Compose:

```text
docker compose up
```

All services start together.

---

# What is `docker-compose.yml`?

The `docker-compose.yml` file defines your application.

It contains:

- Services
- Networks
- Volumes
- Environment variables
- Port mappings

Example structure:

```text
docker-compose.yml

↓

Services

↓

Networks

↓

Volumes
```

---

# Basic Compose File

```yaml
services:
  web:
    build: .

  database:
    image: mysql
```

Compose reads this file and creates both services.

---

# Services

A **service** represents a container.

Example:

```yaml
services:
  web:
    build: .

  mysql:
    image: mysql

  redis:
    image: redis
```

Each service becomes its own container.

---

# Building vs Pulling Images

Build locally:

```yaml
build: .
```

Download from Docker Hub:

```yaml
image: nginx
```

Compose supports both approaches.

---

# Port Mapping

Example:

```yaml
ports:
  - "5000:5000"
```

Format:

```text
Host : Container
```

Allows the application to be accessed from your computer.

---

# Environment Variables

Environment variables are commonly used for configuration.

Example:

```yaml
environment:
  DB_HOST: mysql
  DB_PORT: 3306
```

The application can read these values at runtime.

---

# Volumes

Volumes store data outside containers.

Example:

```yaml
volumes:
  - mysql-data:/var/lib/mysql
```

Benefits:

- Data survives container removal
- Ideal for databases
- Persistent storage

---

# Networks

Docker Compose automatically creates a private network.

Example:

```text
Flask

↓

Compose Network

↓

MySQL

↓

Redis
```

Containers communicate using service names.

---

# Service Discovery

If your database service is called:

```yaml
mysql:
```

Your application connects using:

```text
DB_HOST=mysql
```

Docker Compose automatically provides DNS resolution.

---

# depends_on

Some services require others to start first.

Example:

```yaml
depends_on:
  - mysql
```

Compose starts the MySQL container before the application container.

**Important:**

`depends_on` controls startup order only. It does **not** guarantee that the database is ready to accept connections.

Applications should still handle retries or perform health checks.

---

# Example Compose File

```yaml
services:

  web:
    build: .
    ports:
      - "5000:5000"

    environment:
      DB_HOST: mysql

    depends_on:
      - mysql

  mysql:
    image: mysql

    environment:
      MYSQL_ROOT_PASSWORD: password
```

---

# Starting Services

Build and start:

```bash
docker compose up
```

---

Run in background:

```bash
docker compose up -d
```

Detached mode allows the terminal to remain available.

---

# Stopping Services

```bash
docker compose down
```

Stops and removes all containers created by Compose.

---

# Viewing Running Services

```bash
docker compose ps
```

Displays:

- Running containers
- Ports
- Status

---

# Viewing Logs

```bash
docker compose logs
```

Follow logs live:

```bash
docker compose logs -f
```

Useful when debugging.

---

# Rebuilding Containers

If the application changes:

```bash
docker compose up --build
```

Compose rebuilds the image before starting containers.

---

# Example Architecture

```text
Browser

↓

Flask

↓

Redis

↓

MySQL
```

All services communicate over the automatically created Compose network.

---

# Common Error

### Container Name Already Exists

Example:

```
Error:

Container name already exists.
```

Solution:

```bash
docker compose down
```

or

```bash
docker rm container-name
```

---

# Common Error

### Cannot Connect to Database

Usually caused by:

- Wrong hostname
- Database still starting
- Missing environment variables
- Services not on the same network

Always use:

```text
DB_HOST=mysql
```

instead of:

```text
localhost
```

---

# Common Error

### Application Changes Not Appearing

If using a built image, rebuild it:

```bash
docker compose up --build
```

---

# Best Practices

- Keep one service per container.
- Use service names instead of IP addresses.
- Store secrets outside the Compose file where possible.
- Use volumes for persistent data.
- Keep the Compose file organised and readable.
- Use `docker compose down` when cleaning up.

---

# Key Takeaways

- Docker Compose manages multi-container applications.
- Everything is defined in a `docker-compose.yml` file.
- Services represent containers.
- Compose automatically creates networks.
- Service names act as DNS hostnames.
- Volumes provide persistent storage.
- Environment variables simplify configuration.
- `depends_on` manages startup order but not service readiness.

---

# Quick Revision

| Command | Purpose |
|----------|----------|
| `docker compose up` | Start services |
| `docker compose up -d` | Start in background |
| `docker compose down` | Stop and remove services |
| `docker compose ps` | List running services |
| `docker compose logs` | View logs |
| `docker compose logs -f` | Follow logs |
| `docker compose up --build` | Rebuild and start |

---

# Interview Questions

### What is Docker Compose?

Docker Compose is a tool used to define and manage multi-container applications using a single YAML configuration file.

### Why is Docker Compose useful?

It simplifies running multiple containers by allowing them to be started, stopped and configured together with a single command.

### What is a service in Docker Compose?

A service defines a container, including its image, ports, environment variables and other configuration.

### What does `depends_on` do?

It controls the startup order of services but does not guarantee that a dependent service is fully ready.

### How do containers communicate in Docker Compose?

Containers communicate over an automatically created network using their **service names** as hostnames.

### How do you rebuild images after changing your application?

```bash
docker compose up --build
```