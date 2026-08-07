# Docker Notes - Part 4: Docker Networking

> Covers:
>
> - Docker Networking
> - Network Drivers
> - Bridge Networks
> - Host Networks
> - Container Communication
> - Linking Containers
> - DNS Resolution
> - Debugging Network Issues

---

# What is Docker Networking?

Docker Networking allows containers to communicate with:

- Other containers
- The host machine
- External networks
- The Internet

By default, each container runs in its own isolated network namespace.

---

# Why is Docker Networking Important?

Many applications consist of multiple services.

Example:

```text
Frontend

↓

Backend API

↓

Database
```

Each service often runs inside its own container.

Docker networking allows these containers to communicate securely.

---

# Example Architecture

```text
Browser

↓

Frontend Container

↓

Backend Container

↓

MySQL Container
```

Without networking, the containers would not be able to communicate.

---

# Docker Network Drivers

Docker supports several network drivers.

| Driver | Purpose |
|---------|----------|
| Bridge | Default network for containers on one host |
| Host | Shares the host's network stack |
| None | No networking |
| Overlay | Networking across multiple Docker hosts |
| Macvlan | Gives containers their own MAC address |

For most local development, the **Bridge** network is used.

---

# Bridge Network

The default Docker network.

When multiple containers are attached to the same bridge network, they can communicate using container names.

Example:

```text
Flask Container

↓

Bridge Network

↓

MySQL Container
```

---

# Viewing Networks

List available Docker networks:

```bash
docker network ls
```

Example output:

```text
bridge
host
none
```

---

# Inspecting a Network

View detailed information:

```bash
docker network inspect bridge
```

Shows:

- Connected containers
- Network settings
- IP addresses
- Subnet information

---

# Creating a Network

Create a custom bridge network:

```bash
docker network create app-network
```

---

# Running Containers on a Network

Example:

```bash
docker run -d --name mysql --network app-network mysql
```

```bash
docker run -d --name flask --network app-network flask-app
```

Both containers can now communicate directly.

---

# DNS Resolution

Docker automatically provides DNS for containers on the same network.

Instead of using IP addresses:

```text
172.18.0.3
```

You simply use:

```text
mysql
```

The container name becomes the hostname.

Example:

```text
DB_HOST=mysql
```

This is much more reliable than using IP addresses.

---

# Container Communication

Example:

```text
Flask Container

↓

mysql

↓

MySQL Container
```

The Flask application connects using:

```text
mysql
```

not

```text
172.18.0.3
```

---

# Linking Containers

Older versions of Docker used:

```bash
docker run --link mysql:mysql app
```

This created communication between containers.

Today this approach is considered **legacy**.

Modern Docker uses:

- User-defined bridge networks
- Docker Compose

instead.

---

# Host Network

Host mode removes network isolation.

Example:

```bash
docker run --network host nginx
```

The container shares the host machine's network stack.

Advantages:

- Better performance
- No port mapping required

Disadvantages:

- Less isolation
- Linux only
- Rarely used in development

---

# None Network

```bash
docker run --network none
```

The container has:

- No internet
- No external connectivity
- No communication with other containers

Useful for highly isolated workloads.

---

# Network Example

```text
Browser

↓

localhost:5000

↓

Flask Container

↓

Docker Bridge Network

↓

MySQL Container
```

---

# Common Networking Issue

Incorrect:

```text
DB_HOST=localhost
```

Inside a container, `localhost` refers to **that container itself**, not another container.

Correct:

```text
DB_HOST=mysql
```

where `mysql` is the name of the database container.

---

# Testing Connectivity

Open a shell inside a running container:

```bash
docker exec -it flask bash
```

Then test connectivity:

```bash
ping mysql
```

or

```bash
curl http://backend:5000
```

This helps verify that containers can communicate.

---

# Debugging MySQL Connection Errors

Common causes:

- Containers are on different networks.
- Database container is not running.
- Wrong hostname (`localhost` instead of container name).
- Incorrect credentials.
- Database not fully started.

Always check:

```bash
docker ps
```

and

```bash
docker network inspect app-network
```

---

# Connecting an Existing Container

Attach a running container to a network:

```bash
docker network connect app-network flask
```

---

# Disconnecting a Container

```bash
docker network disconnect app-network flask
```

---

# Removing a Network

Delete an unused network:

```bash
docker network rm app-network
```

Containers must be disconnected first.

---

# Real Example

Create a network:

```bash
docker network create my-network
```

Run MySQL:

```bash
docker run -d \
--name mysql \
--network my-network \
mysql
```

Run Flask:

```bash
docker run -d \
--name flask \
--network my-network \
-p 5000:5000 \
flask-app
```

The Flask application connects using:

```text
DB_HOST=mysql
```

---

# Common Mistakes

### Using localhost

Incorrect:

```text
DB_HOST=localhost
```

Correct:

```text
DB_HOST=mysql
```

---

### Different Networks

Containers must be attached to the same Docker network to communicate.

---

### Using Container IP Addresses

Avoid:

```text
172.18.0.4
```

Use container names instead.

Docker's DNS will resolve them automatically.

---

# Best Practices

- Use custom bridge networks instead of the default bridge.
- Use container names for communication.
- Avoid using IP addresses.
- Avoid the legacy `--link` option.
- Use Docker Compose to manage networking automatically.
- Inspect networks when troubleshooting connectivity issues.

---

# Key Takeaways

- Docker Networking enables communication between containers.
- Bridge networks are the default and most commonly used network type.
- Docker provides built-in DNS for containers on the same network.
- Use container names instead of IP addresses.
- `localhost` inside a container refers only to that container.
- Docker Compose automatically creates networks for services.
- Most networking issues are caused by incorrect hostnames or containers not sharing the same network.

---

# Quick Revision

| Command | Purpose |
|----------|----------|
| `docker network ls` | List networks |
| `docker network create` | Create a network |
| `docker network inspect` | View network details |
| `docker network connect` | Connect a container |
| `docker network disconnect` | Disconnect a container |
| `docker network rm` | Remove a network |
| `docker exec -it` | Open a shell inside a container |

---

# Interview Questions

### What is Docker Networking?

Docker Networking enables containers to communicate with each other, the host machine and external networks.

### What is the default Docker network?

The default network driver is the **bridge** network.

### Why should you use container names instead of IP addresses?

Docker provides automatic DNS resolution, making container names stable while IP addresses can change.

### Why doesn't `localhost` work when connecting to another container?

Inside a container, `localhost` refers to that container itself. To reach another container, use its container name or service name.

### What has replaced Docker's `--link` feature?

User-defined bridge networks and Docker Compose are the modern and recommended approaches for container communication.