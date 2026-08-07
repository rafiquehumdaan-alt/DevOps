# Docker Notes - Part 7: Docker Commands & Best Practices

> Covers:
>
> - Essential Docker Commands
> - Image Management
> - Container Management
> - Logs
> - Executing Commands Inside Containers
> - Inspecting Containers
> - Cleaning Up Resources
> - Multi-Stage Builds
> - Docker Best Practices

---

# Essential Docker Workflow

A typical Docker workflow looks like this:

```text
Write Dockerfile

↓

Build Image

↓

Run Container

↓

Monitor

↓

Stop

↓

Remove
```

---

# Building an Image

Build an image from the current directory:

```bash
docker build -t my-app .
```

Options:

- `build` → Build an image
- `-t` → Tag (name) the image
- `.` → Current directory (build context)

---

# Listing Images

View downloaded and locally built images:

```bash
docker images
```

---

# Removing an Image

```bash
docker rmi my-app
```

The image cannot be removed if it is still being used by a container.

---

# Running a Container

```bash
docker run my-app
```

Creates a new container from an image.

---

# Running in Detached Mode

```bash
docker run -d my-app
```

Runs the container in the background.

---

# Running with Port Mapping

```bash
docker run -d -p 5000:5000 my-app
```

Format:

```text
Host Port : Container Port
```

---

# Naming a Container

```bash
docker run --name web my-app
```

Instead of a random name, the container will be called:

```
web
```

---

# Listing Containers

Running containers:

```bash
docker ps
```

All containers:

```bash
docker ps -a
```

---

# Stopping Containers

```bash
docker stop web
```

Gracefully stops the container.

---

# Starting Containers

```bash
docker start web
```

Starts an existing stopped container.

---

# Restarting Containers

```bash
docker restart web
```

Stops and immediately starts the container.

---

# Removing Containers

```bash
docker rm web
```

Deletes a stopped container.

Force removal:

```bash
docker rm -f web
```

---

# Viewing Logs

Display logs:

```bash
docker logs web
```

Follow logs in real time:

```bash
docker logs -f web
```

Useful for troubleshooting application issues.

---

# Execute Commands Inside a Container

Open a Bash shell:

```bash
docker exec -it web bash
```

For lightweight images (such as Alpine Linux):

```bash
docker exec -it web sh
```

Useful for:

- Debugging
- Viewing files
- Running commands

---

# Inspecting Containers

View detailed information:

```bash
docker inspect web
```

Shows:

- IP address
- Environment variables
- Volumes
- Networks
- Mount points

---

# Viewing Resource Usage

Monitor resource usage:

```bash
docker stats
```

Displays:

- CPU usage
- Memory usage
- Network traffic
- Disk I/O

---

# Copy Files

Copy from host to container:

```bash
docker cp file.txt web:/app/
```

Copy from container to host:

```bash
docker cp web:/app/log.txt .
```

---

# Cleaning Up

Remove stopped containers:

```bash
docker container prune
```

Remove unused images:

```bash
docker image prune
```

Remove unused volumes:

```bash
docker volume prune
```

Remove unused networks:

```bash
docker network prune
```

Remove everything unused:

```bash
docker system prune
```

To also remove unused images:

```bash
docker system prune -a
```

---

# Multi-Stage Builds

A Multi-Stage Build uses multiple `FROM` instructions in one Dockerfile.

This keeps the final image much smaller.

---

# Why Use Multi-Stage Builds?

Without Multi-Stage Builds:

```text
Compiler

↓

Source Code

↓

Dependencies

↓

Application

↓

Large Image
```

Everything remains in the final image.

---

With Multi-Stage Builds:

```text
Build Stage

↓

Compile Application

↓

Copy Finished Application

↓

Small Runtime Image
```

Only the required files are included.

---

# Example Multi-Stage Dockerfile

```dockerfile
# Build Stage
FROM golang:1.24 AS builder

WORKDIR /app

COPY . .

RUN go build -o app

# Runtime Stage
FROM alpine:latest

WORKDIR /app

COPY --from=builder /app/app .

CMD ["./app"]
```

The Go compiler is **not** included in the final image.

---

# Benefits of Multi-Stage Builds

- Smaller images
- Faster downloads
- Faster deployments
- Reduced attack surface
- Less storage usage

---

# Image Optimisation Tips

- Use small base images (e.g. Alpine where appropriate).
- Remove unnecessary packages.
- Combine related `RUN` commands.
- Use `.dockerignore`.
- Use Multi-Stage Builds.
- Avoid installing development tools in production images.

---

# Common Docker Commands

| Command | Purpose |
|----------|----------|
| `docker build` | Build an image |
| `docker run` | Create and start a container |
| `docker ps` | Running containers |
| `docker ps -a` | All containers |
| `docker stop` | Stop a container |
| `docker start` | Start a container |
| `docker restart` | Restart a container |
| `docker rm` | Remove a container |
| `docker rmi` | Remove an image |
| `docker logs` | View logs |
| `docker exec` | Run commands inside a container |
| `docker inspect` | View container details |
| `docker stats` | Monitor resource usage |

---

# Common Mistakes

### Using Large Base Images

Avoid large images when a smaller alternative meets your needs.

Example:

```dockerfile
FROM alpine
```

instead of a full Linux distribution, where appropriate.

---

### Running Everything as Root

Where possible, create and use a non-root user inside the container to improve security.

---

### Keeping Development Tools

Don't include:

- Compilers
- Build tools
- Test frameworks

in production images unless they are required.

---

### Not Cleaning Up

Old images and stopped containers consume disk space.

Regularly run cleanup commands to reclaim storage.

---

# Best Practices

- Keep one application per container.
- Use official base images.
- Name important containers.
- Use Multi-Stage Builds.
- Keep images small.
- Store persistent data in volumes.
- Use environment variables for configuration.
- Regularly remove unused Docker resources.

---

# Key Takeaways

- Docker provides commands to build, run and manage containers.
- `docker logs` is essential for troubleshooting.
- `docker exec` allows you to inspect a running container.
- `docker inspect` displays detailed configuration information.
- Multi-Stage Builds create smaller, more secure images.
- Cleaning up unused Docker resources helps save disk space.
- Smaller images lead to faster deployments and better performance.

---

# Quick Revision

| Command | Purpose |
|----------|----------|
| `docker build` | Build image |
| `docker run` | Start container |
| `docker ps` | Running containers |
| `docker stop` | Stop container |
| `docker rm` | Remove container |
| `docker rmi` | Remove image |
| `docker logs` | View logs |
| `docker exec` | Execute commands |
| `docker inspect` | Inspect container |
| `docker stats` | Resource usage |
| `docker system prune` | Remove unused resources |

---

# Interview Questions

### What is the purpose of `docker exec`?

It allows you to run commands or open a shell inside a running container for debugging or administration.

### Why are Multi-Stage Builds recommended?

They create smaller, more secure Docker images by excluding build tools and unnecessary files from the final image.

### What is the difference between `docker stop` and `docker rm`?

`docker stop` stops a running container, while `docker rm` permanently removes a stopped container.

### Which command shows application logs?

```bash
docker logs <container-name>
```

### Why should Docker images be kept as small as possible?

Smaller images download faster, use less storage, deploy more quickly and reduce the overall security attack surface.