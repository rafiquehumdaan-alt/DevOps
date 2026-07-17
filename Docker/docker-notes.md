# Docker Notes

# What is Docker?

Docker is an open-source containerisation platform that allows developers to package applications and everything they need to run (code, libraries, dependencies and configuration) into lightweight containers.

Containers ensure applications behave consistently regardless of where they are deployed.

---

# Why Docker?

Before Docker, applications often behaved differently between development, testing and production because of differences in operating systems, installed software or dependency versions.

Docker solves this by packaging everything an application needs into a container.

Benefits include:

- Consistent environments
- Faster deployments
- Lightweight virtualisation
- Easy application distribution
- Improved scalability
- Simplified dependency management
- Better resource utilisation
- Faster startup times than virtual machines

---

# Containers vs Virtual Machines

## Virtual Machine

A virtual machine virtualises an entire operating system.

Each VM contains:

- Guest Operating System
- Libraries
- Applications

Advantages:

- Strong isolation
- Different operating systems can run simultaneously

Disadvantages:

- Large disk usage
- Slow startup
- Higher CPU and RAM consumption

---

## Container

Containers virtualise at the operating system level.

Containers share the host operating system kernel while keeping applications isolated from one another.

Advantages:

- Lightweight
- Fast startup
- Low resource usage
- Easy to scale
- Portable

---

# Docker Architecture

Docker consists of several components.

## Docker Client

The command line interface used by users.

Examples:

```bash
docker build
docker run
docker ps
```

---

## Docker Engine (Daemon)

Runs in the background and is responsible for:

- Building images
- Creating containers
- Managing networks
- Managing volumes

---

## Docker Registry

Stores Docker images.

Examples:

- Docker Hub
- Amazon ECR
- Azure Container Registry
- GitHub Container Registry

---

# Docker Images

An image is a read-only template used to create containers.

Images contain:

- Base operating system
- Application
- Dependencies
- Configuration

Examples:

```
ubuntu
nginx
redis
mysql
python
```

Images are immutable.

To make changes you normally create a new image.

---

# Docker Containers

A container is a running instance of an image.

Containers are:

- Isolated
- Portable
- Lightweight
- Temporary by default

Multiple containers can be created from the same image.

---

# Dockerfile

A Dockerfile contains instructions for building an image.

Common instructions include:

```dockerfile
FROM
WORKDIR
COPY
ADD
RUN
ENV
EXPOSE
CMD
ENTRYPOINT
```

---

## Common Dockerfile Instructions

### FROM

Specifies the base image.

Example:

```dockerfile
FROM ubuntu:24.04
```

---

### WORKDIR

Sets the working directory.

```dockerfile
WORKDIR /app
```

---

### COPY

Copies files from the host into the image.

```dockerfile
COPY . .
```

---

### RUN

Executes commands during image creation.

Example:

```dockerfile
RUN apt update
```

---

### ENV

Defines environment variables.

```dockerfile
ENV APP_ENV=production
```

---

### EXPOSE

Documents which port an application listens on.

```dockerfile
EXPOSE 80
```

---

### CMD

Specifies the default command executed when a container starts.

```dockerfile
CMD ["python","app.py"]
```

Only one CMD should normally exist.

---

### ENTRYPOINT

Defines the executable that always runs when the container starts.

Unlike CMD, ENTRYPOINT is not easily overridden.

---

# Docker Workflow

Typical workflow:

Application Code

↓

Dockerfile

↓

Docker Image

↓

Docker Container

---

# Docker Networks

Networks allow containers to communicate securely.

Common network types include:

- Bridge
- Host
- None
- Overlay
- Macvlan

The default for most local projects is a Bridge network.

---

# Docker Volumes

Containers are temporary.

Deleting a container normally deletes any data stored inside it.

Volumes provide persistent storage independent of containers.

Benefits:

- Data survives container recreation
- Easier backups
- Data sharing between containers

---

# Bind Mounts vs Volumes

## Bind Mount

Links a host directory directly into a container.

Example:

```
Host Folder

↓

Container Folder
```

Useful during development.

---

## Named Volume

Managed entirely by Docker.

Advantages:

- Easier management
- Better portability
- Preferred for production data

---

# Environment Variables

Environment variables allow configuration without modifying application code.

Examples:

- Database host
- Database password
- Port numbers
- API keys

Benefits:

- Flexible configuration
- Improved security
- Easier deployments

---

# Docker Compose

Docker Compose manages multi-container applications.

Compose files are written in YAML.

Common sections include:

```yaml
services:
volumes:
networks:
```

Compose can:

- Build images
- Start containers
- Stop containers
- Create networks
- Create volumes

---

# Image Layers

Docker images are built in layers.

Each Dockerfile instruction creates another layer.

Benefits:

- Faster builds
- Layer caching
- Smaller downloads

---

# Container Lifecycle

Container states include:

Created

↓

Running

↓

Paused

↓

Stopped

↓

Removed

---

# Docker Best Practices

- Keep images as small as possible.
- Use official base images.
- Avoid installing unnecessary packages.
- Use environment variables for configuration.
- Store persistent data in volumes.
- Use `.dockerignore` where appropriate.
- Minimise the number of image layers.
- Avoid running applications as the root user.
- Tag images with meaningful versions.
- Remove unused containers and images regularly.

---

# Common Docker Commands

## Images

```bash
docker images
docker pull
docker build
docker rmi
```

---

## Containers

```bash
docker run
docker ps
docker ps -a
docker stop
docker start
docker restart
docker rm
docker logs
docker exec -it
```

---

## Networks

```bash
docker network ls
docker network create
docker network inspect
docker network rm
```

---

## Volumes

```bash
docker volume ls
docker volume create
docker volume inspect
docker volume rm
```

---

## System

```bash
docker info
docker version
docker system df
docker system prune
```

---

# Summary

Docker allows applications to be packaged into lightweight, portable containers that run consistently across different environments.

Understanding images, containers, Dockerfiles, networking, volumes, environment variables and Docker Compose provides the foundation for deploying and managing modern containerised applications.