# Docker Notes - Part 3: Containerising an Application

> Covers:
>
> - Creating a Simple Web Application
> - Writing a Dockerfile
> - Building Docker Images
> - Running Containers
> - Port Mapping
> - Environment Variables
> - Volumes (Introduction)
> - Container Lifecycle

---

# What Does "Containerising" Mean?

Containerising an application means packaging it together with:

- Application code
- Dependencies
- Runtime
- Configuration

into a Docker Image so it can run consistently on any machine.

Instead of installing software manually, you simply run the container.

---

# Typical Workflow

```text
Write Application

↓

Create Dockerfile

↓

Build Docker Image

↓

Run Container

↓

Application Running
```

---

# Example Project Structure

```text
my-web-app/

├── app.py
├── requirements.txt
├── Dockerfile
├── .dockerignore
└── README.md
```

---

# Example Dockerfile

```dockerfile
FROM python:3.12

WORKDIR /app

COPY requirements.txt .

RUN pip install -r requirements.txt

COPY . .

EXPOSE 5000

CMD ["python", "app.py"]
```

---

# Dockerfile Breakdown

### Base Image

```dockerfile
FROM python:3.12
```

Starts from the official Python image.

---

### Working Directory

```dockerfile
WORKDIR /app
```

Creates and switches to the `/app` directory inside the container.

---

### Copy Dependencies

```dockerfile
COPY requirements.txt .
```

Copies only the dependency file first.

This improves Docker layer caching.

---

### Install Dependencies

```dockerfile
RUN pip install -r requirements.txt
```

Installs all required Python packages.

---

### Copy Application

```dockerfile
COPY . .
```

Copies the remaining application files into the image.

---

### Expose Port

```dockerfile
EXPOSE 5000
```

Documents that the application listens on port **5000**.

---

### Start the Application

```dockerfile
CMD ["python", "app.py"]
```

Runs the application when the container starts.

---

# Building the Image

Build the image:

```bash
docker build -t flask-app .
```

Explanation:

- `build` → Build an image
- `-t` → Give it a name (tag)
- `.` → Current directory is the build context

---

# Viewing Images

```bash
docker images
```

Example:

```text
REPOSITORY      TAG

flask-app       latest
```

---

# Running the Container

```bash
docker run flask-app
```

Docker creates a new container from the image.

---

# Running in Detached Mode

```bash
docker run -d flask-app
```

`-d` means **detached mode**, allowing the container to run in the background.

---

# Port Mapping

Applications inside containers are isolated.

To access them from your computer, map container ports to host ports.

Example:

```bash
docker run -p 5000:5000 flask-app
```

Format:

```text
Host Port : Container Port
```

---

# Port Mapping Example

```text
Browser

↓

localhost:5000

↓

Docker

↓

Container Port 5000
```

Without port mapping, the application cannot be accessed from outside the container.

---

# Naming Containers

Instead of random names:

```bash
docker run --name web-app flask-app
```

Now the container is called:

```
web-app
```

---

# Viewing Running Containers

```bash
docker ps
```

Shows:

- Container ID
- Image
- Status
- Ports
- Names

---

# Viewing All Containers

```bash
docker ps -a
```

Displays both running and stopped containers.

---

# Stopping a Container

```bash
docker stop web-app
```

Gracefully stops the container.

---

# Starting a Stopped Container

```bash
docker start web-app
```

Restarts the existing container.

---

# Removing a Container

```bash
docker rm web-app
```

Deletes the container.

The Docker Image remains available.

---

# Environment Variables

Containers often require configuration.

Pass environment variables using:

```bash
docker run -e APP_ENV=production flask-app
```

Example:

```bash
docker run -e DB_HOST=mysql flask-app
```

This allows the same image to be used in different environments without changing the code.

---

# Volumes (Introduction)

By default, data inside a container is lost when the container is removed.

Volumes allow data to persist outside the container.

Example:

```bash
docker run -v mydata:/app/data flask-app
```

Useful for:

- Databases
- Uploads
- Logs
- Configuration files

---

# Container Lifecycle

```text
Docker Image

↓

docker run

↓

Running Container

↓

docker stop

↓

Stopped Container

↓

docker rm

↓

Deleted Container
```

---

# Real Example

Build:

```bash
docker build -t flask-app .
```

Run:

```bash
docker run -d -p 5000:5000 --name flask flask-app
```

View:

```bash
docker ps
```

Stop:

```bash
docker stop flask
```

Remove:

```bash
docker rm flask
```

---

# Common Mistakes

### Forgetting Port Mapping

Incorrect:

```bash
docker run flask-app
```

The application runs, but you cannot access it from your browser.

Correct:

```bash
docker run -p 5000:5000 flask-app
```

---

### Removing the Wrong Container

Use:

```bash
docker ps
```

before running:

```bash
docker rm
```

---

### Installing Software Inside a Running Container

Containers should be treated as **immutable**.

Instead of modifying a running container:

- Update the Dockerfile
- Build a new image
- Replace the container

---

# Best Practices

- Use official base images.
- Keep Dockerfiles simple.
- Use environment variables for configuration.
- Name important containers.
- Keep containers stateless.
- Store persistent data in volumes.
- Rebuild images instead of modifying running containers.

---

# Key Takeaways

- Containerising packages an application with all its dependencies.
- Dockerfiles define how images are built.
- Images are built using `docker build`.
- Containers are created using `docker run`.
- Port mapping allows access to applications running inside containers.
- Environment variables provide runtime configuration.
- Volumes preserve data outside the container.
- Containers should be treated as disposable.

---

# Quick Revision

| Command | Purpose |
|----------|----------|
| `docker build -t app .` | Build image |
| `docker run app` | Run container |
| `docker run -d` | Run in background |
| `docker run -p 5000:5000` | Map ports |
| `docker run --name web` | Name a container |
| `docker ps` | Running containers |
| `docker ps -a` | All containers |
| `docker stop` | Stop container |
| `docker start` | Start container |
| `docker rm` | Remove container |
| `docker run -e` | Set environment variable |
| `docker run -v` | Mount a volume |

---

# Interview Questions

### What does it mean to containerise an application?

It means packaging an application together with its dependencies and configuration into a Docker image so it can run consistently anywhere.

### Why do we use port mapping?

Because applications inside containers are isolated. Port mapping exposes the container's port so it can be accessed from the host machine.

### What is the difference between an image and a container?

An image is a blueprint, while a container is a running instance of that image.

### Why are environment variables useful?

They allow configuration values, such as database hosts or API keys, to be supplied at runtime without modifying the application code.

### Why are Docker volumes important?

Volumes store data outside the container, ensuring important information is not lost when containers are stopped or deleted.