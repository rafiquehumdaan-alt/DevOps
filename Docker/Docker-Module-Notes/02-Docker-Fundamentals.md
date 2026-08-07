# Docker Notes - Part 2: Docker Setup & Fundamentals

> Covers:
>
> - Installing Docker
> - Docker Desktop
> - Docker Engine
> - Docker Images
> - Dockerfile
> - Build Process
> - Image Layers
> - Build Context
> - `.dockerignore`
> - Creating a Git Repository

---

# Installing Docker

Docker can be installed on:

- Windows (Docker Desktop + WSL2)
- macOS (Docker Desktop)
- Linux (Docker Engine)

For Windows, **Docker Desktop with WSL2** is the recommended setup.

---

# Docker Desktop

Docker Desktop provides a graphical interface for managing Docker.

Features include:

- Running containers
- Viewing images
- Monitoring container resources
- Managing volumes and networks
- Integrated Docker Engine

Although Docker Desktop is useful, most DevOps engineers primarily use the **Docker CLI**.

---

# Verify the Installation

Check that Docker is installed:

```bash
docker --version
```

Example output:

```text
Docker version 28.x.x
```

Check the Docker Engine:

```bash
docker info
```

This displays information about:

- Docker version
- Storage driver
- Images
- Containers
- CPU and memory allocation

---

# Docker Engine

The Docker Engine is the core component of Docker.

It is responsible for:

- Building images
- Running containers
- Managing networks
- Managing volumes

When you run a Docker command, the Docker CLI communicates with the Docker Engine.

---

# Docker Architecture

```text
Docker CLI

↓

Docker Engine

↓

Images

↓

Containers
```

The CLI sends commands, and the Engine performs the requested actions.

---

# What is a Docker Image?

A Docker Image is a read-only template used to create containers.

Images contain:

- Application code
- Runtime
- Libraries
- Dependencies
- Configuration

An image does **not** run on its own—it must be started as a container.

---

# Where Images Come From

Images can be:

- Built locally from a Dockerfile
- Downloaded from Docker Hub
- Downloaded from a private registry (e.g. Amazon ECR)

Example:

```bash
docker pull nginx
```

Downloads the official NGINX image.

---

# What is a Dockerfile?

A **Dockerfile** is a text file containing instructions for building a Docker image.

Each instruction creates a new image layer.

Example:

```dockerfile
FROM python:3.12

WORKDIR /app

COPY . .

RUN pip install -r requirements.txt

CMD ["python", "app.py"]
```

---

# Common Dockerfile Instructions

| Instruction | Purpose |
|-------------|----------|
| `FROM` | Base image |
| `WORKDIR` | Working directory inside the container |
| `COPY` | Copy files into the image |
| `RUN` | Execute commands during build |
| `CMD` | Default command when the container starts |
| `EXPOSE` | Document the port the application uses |
| `ENV` | Set environment variables |

---

# Docker Build Process

Docker reads the Dockerfile from top to bottom.

```text
Dockerfile

↓

Read Instruction

↓

Create Layer

↓

Next Instruction

↓

Final Docker Image
```

Each step creates a reusable image layer.

---

# Image Layers

Docker images are built in layers.

Example:

```text
FROM Ubuntu

↓

Install Python

↓

Install Flask

↓

Copy Application

↓

Final Image
```

If only the application code changes, Docker can reuse the previous layers, making builds much faster.

---

# Layer Caching

Docker caches unchanged layers during builds.

Example:

```dockerfile
FROM python:3.12

RUN apt update

RUN pip install flask

COPY . .
```

If only your application files change, Docker reuses the first three layers and only rebuilds the final `COPY` layer.

This significantly speeds up image builds.

---

# Build Context

The **build context** is the directory sent to Docker during a build.

Example:

```bash
docker build .
```

The `.` represents the current directory and everything inside it.

Docker can only access files within the build context.

---

# `.dockerignore`

The `.dockerignore` file prevents unnecessary files from being included in the build context.

Example:

```text
.git
.gitignore
node_modules
.env
__pycache__
```

Benefits:

- Faster builds
- Smaller images
- Improved security

---

# Building an Image

Syntax:

```bash
docker build -t my-app .
```

Explanation:

- `build` → Build an image
- `-t` → Tag (name) the image
- `.` → Current directory is the build context

---

# Viewing Images

List downloaded and locally built images:

```bash
docker images
```

Example output:

```text
REPOSITORY      TAG       IMAGE ID

my-app          latest    7f1c...

nginx           latest    34af...
```

---

# Git Repository

Store your Docker project in Git.

Typical structure:

```text
my-app/

├── app.py
├── requirements.txt
├── Dockerfile
├── .dockerignore
├── README.md
└── .gitignore
```

Version control makes collaboration and deployment much easier.

---

# Example Build Workflow

```text
Write Dockerfile

↓

docker build

↓

Docker Image

↓

docker run

↓

Running Container
```

---

# Common Mistakes

### Forgetting the Build Context

Incorrect:

```bash
docker build
```

Correct:

```bash
docker build .
```

---

### Copying Unnecessary Files

Without a `.dockerignore`, Docker may include:

- Git history
- Large dependency folders
- Secrets
- Temporary files

Always use `.dockerignore`.

---

### Poor Dockerfile Order

If frequently changing files are copied too early, Docker cannot reuse cached layers effectively.

A better approach is to copy dependency files first, install dependencies, then copy the rest of the application.

---

# Best Practices

- Use official base images whenever possible.
- Keep Dockerfiles simple and readable.
- Use `.dockerignore` to reduce build size.
- Take advantage of Docker layer caching.
- Store projects in Git.
- Build images with meaningful tags.

---

# Key Takeaways

- Docker Desktop provides an easy way to manage Docker.
- Docker Engine builds and runs containers.
- Docker Images are created from Dockerfiles.
- Every Dockerfile instruction creates a new layer.
- Docker caches layers to speed up builds.
- The build context determines which files Docker can access.
- `.dockerignore` reduces build size and improves security.

---

# Quick Revision

| Term | Meaning |
|------|---------|
| Docker Desktop | GUI for Docker |
| Docker Engine | Runs containers |
| Docker Image | Blueprint for a container |
| Dockerfile | Instructions to build an image |
| Build Context | Files available during `docker build` |
| Layer | One step in an image build |
| Cache | Reuse unchanged layers |
| `.dockerignore` | Excludes files from builds |

---

# Interview Questions

### What is a Dockerfile?

A Dockerfile is a text file containing instructions that Docker uses to build an image.

### What is the Docker Engine?

The Docker Engine is the core service responsible for building, running and managing Docker containers.

### Why does Docker build images in layers?

Layers allow Docker to cache unchanged steps, making builds faster and reducing storage usage.

### What is the purpose of `.dockerignore`?

It prevents unnecessary or sensitive files from being sent to the Docker build context, resulting in faster and smaller image builds.

### What does the following command do?

```bash
docker build -t my-app .
```

It builds a Docker image named `my-app` using the Dockerfile in the current directory as the build context.