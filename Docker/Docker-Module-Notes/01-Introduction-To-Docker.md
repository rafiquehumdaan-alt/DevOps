# Docker Notes - Part 1: Introduction to Docker

> Covers:
>
> - What are Containers?
> - Benefits of Containers
> - What is Docker?
> - Images vs Containers
> - Importance in Modern Development
> - Docker Architecture
> - Virtual Machines vs Containers (Common Interview Question)

---

# What are Containers?

A **container** is a lightweight package that contains everything an application needs to run.

A container includes:

- Application code
- Runtime
- Libraries
- Dependencies
- Configuration files

This ensures the application behaves the same regardless of where it is deployed.

Think of a container as a **portable box** that contains your entire application.

---

# Why were Containers Created?

Before containers, developers often experienced:

> "It works on my machine."

Applications behaved differently because computers had:

- Different operating systems
- Different software versions
- Missing dependencies
- Different configurations

Containers solve this problem by packaging everything the application needs.

---

# Benefits of Containers

Containers provide many advantages:

- Portable
- Lightweight
- Fast startup
- Consistent environments
- Easy to deploy
- Easy to scale
- Efficient use of resources
- Perfect for CI/CD pipelines

---

# Traditional Deployment

Without containers:

```text
Application

↓

Operating System

↓

Physical Server
```

Every server must be configured manually.

This often leads to configuration drift and deployment issues.

---

# Containerised Deployment

With containers:

```text
Application

↓

Container

↓

Container Runtime

↓

Operating System

↓

Server
```

The application runs the same everywhere.

---

# What is Docker?

Docker is the world's most popular container platform.

It allows developers to:

- Build containers
- Run containers
- Share containers
- Deploy applications consistently

Docker simplified container technology and made it easy for developers to use.

---

# Docker Components

Docker consists of several parts.

| Component | Purpose |
|-----------|----------|
| Docker Engine | Runs containers |
| Docker Image | Blueprint for a container |
| Docker Container | Running instance of an image |
| Dockerfile | Instructions to build an image |
| Docker Hub | Public image registry |

---

# What is a Docker Image?

A Docker Image is a **read-only template**.

It contains:

- Application
- Dependencies
- Libraries
- Configuration

Think of an image as a blueprint.

Example:

```text
Ubuntu

↓

Python Installed

↓

Application Copied

↓

Final Docker Image
```

---

# What is a Docker Container?

A container is a **running instance** of an image.

Example:

```text
Docker Image

↓

Container
```

One image can create many containers.

Example:

```text
Web Image

↓

Container 1

Container 2

Container 3
```

Each container runs independently.

---

# Images vs Containers

| Image | Container |
|--------|-----------|
| Blueprint | Running application |
| Read-only | Running process |
| Cannot execute | Executes code |
| Used to create containers | Created from images |

A useful analogy:

- **Image = Cake recipe**
- **Container = Finished cake**

---

# Docker Architecture

Docker uses a client-server architecture.

```text
Docker Client

↓

Docker Engine

↓

Images

↓

Containers
```

The Docker Client sends commands.

The Docker Engine performs the work.

---

# Why Docker is Important in Modern Development

Modern software is built using:

- Microservices
- Cloud platforms
- CI/CD pipelines
- Kubernetes

Containers make these technologies practical because applications are portable and easy to deploy.

Docker has become a standard tool in DevOps.

---

# Real-World Example

A developer builds a Flask application.

Without Docker:

- Install Python
- Install Flask
- Install dependencies
- Configure environment
- Start application

With Docker:

```bash
docker run flask-app
```

Everything is already included inside the container.

---

# Containers in DevOps

Containers are widely used because they support automation.

Example workflow:

```text
Developer

↓

GitHub

↓

CI/CD Pipeline

↓

Docker Image Built

↓

Deploy Container

↓

Production
```

This makes deployments faster and more reliable.

---

# Virtual Machines vs Containers

This is one of the most common Docker interview questions.

---

## Virtual Machine

```text
Application

↓

Guest Operating System

↓

Hypervisor

↓

Host Operating System

↓

Physical Server
```

Every Virtual Machine has its own operating system.

---

## Container

```text
Application

↓

Container Runtime

↓

Host Operating System

↓

Physical Server
```

Containers share the host operating system.

---

# VM vs Container Comparison

| Virtual Machine | Container |
|-----------------|-----------|
| Includes full OS | Shares host OS |
| Large | Lightweight |
| Slower startup | Starts in seconds |
| Higher resource usage | Lower resource usage |
| Stronger isolation | Lightweight isolation |
| Good for multiple operating systems | Good for microservices |

---

# When to Use Containers

Containers are ideal for:

- Web applications
- APIs
- CI/CD pipelines
- Microservices
- Cloud-native applications
- Development environments

---

# When to Use Virtual Machines

Virtual Machines are better when:

- Running different operating systems
- Strong isolation is required
- Legacy software depends on a full operating system
- Hardware virtualisation is needed

---

# Common Misconceptions

❌ Containers are not Virtual Machines.

❌ Containers do not include a full operating system.

❌ Docker is not the container itself—it is the platform used to build and run containers.

---

# Best Practices

- Keep containers focused on a single application.
- Use official base images where possible.
- Avoid installing unnecessary software.
- Treat containers as disposable.
- Store application data outside containers using volumes.
- Keep images as small as possible.

---

# Key Takeaways

- Containers package applications with all required dependencies.
- Docker is the most widely used container platform.
- Images are templates used to create containers.
- Containers are running instances of images.
- Containers are lightweight because they share the host operating system.
- Docker enables consistent deployments across development, testing and production.
- Containers are fundamental to modern DevOps workflows.

---

# Quick Revision

| Term | Meaning |
|------|---------|
| Container | Packaged application with dependencies |
| Docker | Container platform |
| Docker Image | Blueprint for a container |
| Docker Container | Running instance of an image |
| Docker Engine | Software that runs containers |
| Dockerfile | Instructions to build an image |
| Docker Hub | Public Docker image registry |

---

# Interview Questions

### What is a container?

A lightweight package that contains an application and everything it needs to run consistently across different environments.

### What is Docker?

Docker is a platform used to build, package, distribute and run containers.

### What is the difference between an image and a container?

An image is a read-only template, while a container is a running instance of that image.

### Why are containers faster than Virtual Machines?

Containers share the host operating system instead of running their own operating system, making them much lighter and faster to start.

### Why is Docker important in DevOps?

Docker provides consistent environments, simplifies deployments, supports CI/CD pipelines and makes applications portable across different systems.