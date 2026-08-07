# Docker Notes - Part 6: Docker Registries

> Covers:
>
> - What is a Docker Registry?
> - Docker Hub
> - Private Registries
> - Amazon Elastic Container Registry (ECR)
> - Authentication
> - Pushing Images
> - Pulling Images
> - Image Versioning
> - Best Practices

---

# What is a Docker Registry?

A **Docker Registry** is a repository used to store and distribute Docker images.

Instead of building an image on every machine, you can upload it to a registry and download it whenever needed.

Think of it as **GitHub for Docker images**.

---

# Why Use a Registry?

Registries make it easy to:

- Share images
- Deploy applications
- Store versioned images
- Integrate with CI/CD pipelines
- Distribute images across teams

---

# Registry Workflow

```text
Developer

↓

Build Docker Image

↓

Push Image

↓

Docker Registry

↓

Production Server

↓

Pull Image

↓

Run Container
```

---

# Types of Registries

There are two main types:

### Public Registry

Anyone can download images.

Example:

- Docker Hub

---

### Private Registry

Only authorised users can access images.

Examples:

- Amazon ECR
- Azure Container Registry
- Google Artifact Registry
- GitHub Container Registry

Private registries are commonly used in production.

---

# Docker Hub

Docker Hub is the world's largest public Docker registry.

It contains millions of images.

Examples:

- nginx
- redis
- mysql
- ubuntu
- python

Download an image:

```bash
docker pull nginx
```

---

# Official Images

Docker Hub provides **Official Images** maintained by Docker or trusted vendors.

Examples:

```text
ubuntu

python

mysql

redis

nginx
```

Official images are recommended because they are regularly updated and maintained.

---

# Building Your Own Image

Example:

```bash
docker build -t flask-app .
```

This creates a local image.

To share it, you must push it to a registry.

---

# Image Tags

Docker images use tags for versioning.

Example:

```text
flask-app:latest

flask-app:v1

flask-app:v2
```

The format is:

```text
repository:tag
```

---

# Tagging an Image

Create a new tag:

```bash
docker tag flask-app:latest username/flask-app:v1
```

The image is now ready to be pushed.

---

# Logging into a Registry

Authenticate before pushing images.

Docker Hub:

```bash
docker login
```

Enter:

- Username
- Password (or Personal Access Token)

---

# Pushing an Image

Upload an image:

```bash
docker push username/flask-app:v1
```

The image becomes available in your Docker Hub repository.

---

# Pulling an Image

Download an image:

```bash
docker pull username/flask-app:v1
```

Once downloaded, you can start containers from it.

---

# Amazon Elastic Container Registry (ECR)

Amazon ECR is AWS's fully managed private Docker registry.

Benefits:

- Secure
- Highly available
- Integrated with IAM
- Works with ECS, EKS and Lambda
- Supports private repositories

ECR is commonly used in AWS production environments.

---

# ECR Workflow

```text
Build Image

↓

Tag Image

↓

Login to ECR

↓

Push Image

↓

ECR Repository

↓

Pull on ECS / EC2 / EKS
```

---

# Creating an ECR Repository

Create a repository in AWS:

Example:

```text
flask-app
```

AWS provides a repository URI.

Example:

```text
123456789012.dkr.ecr.eu-west-2.amazonaws.com/flask-app
```

---

# Logging into ECR

Authenticate using the AWS CLI:

```bash
aws ecr get-login-password \
| docker login \
--username AWS \
--password-stdin <ECR-Repository-URI>
```

This grants Docker permission to push and pull images from ECR.

---

# Tagging for ECR

Example:

```bash
docker tag flask-app:latest \
<ECR-Repository-URI>:latest
```

The image now points to your ECR repository.

---

# Pushing to ECR

Upload the image:

```bash
docker push <ECR-Repository-URI>:latest
```

The image is now stored in Amazon ECR.

---

# Pulling from ECR

Download the image:

```bash
docker pull <ECR-Repository-URI>:latest
```

You can then start a container:

```bash
docker run <ECR-Repository-URI>:latest
```

---

# Image Versioning

Avoid relying on:

```text
latest
```

Instead, use meaningful tags.

Examples:

```text
v1.0.0

v1.2.3

2026-08-07

release-5
```

Versioned tags make rollbacks much easier.

---

# Example Deployment

```text
Developer

↓

GitHub

↓

CI/CD Pipeline

↓

Build Image

↓

Push to ECR

↓

Deploy to ECS
```

This is a common production workflow in AWS.

---

# Common Mistakes

### Forgetting to Login

Incorrect:

```bash
docker push ...
```

Result:

```
Access Denied
```

Always authenticate first.

---

### Using Only `latest`

Avoid:

```text
latest
```

Use versioned tags whenever possible.

---

### Pushing Untagged Images

Docker requires the image to be tagged correctly before pushing.

Always use:

```bash
docker tag
```

before:

```bash
docker push
```

---

# Best Practices

- Use official base images where possible.
- Use private registries for production.
- Tag images with meaningful versions.
- Avoid relying on `latest`.
- Authenticate using secure credentials or IAM roles.
- Remove unused images from registries to reduce storage costs.

---

# Key Takeaways

- Docker Registries store and distribute Docker images.
- Docker Hub is the largest public registry.
- Amazon ECR is AWS's managed private registry.
- Images must be tagged before pushing.
- Use `docker login` to authenticate.
- Use versioned tags for production deployments.
- Registries are essential for CI/CD pipelines and cloud deployments.

---

# Quick Revision

| Command | Purpose |
|----------|----------|
| `docker login` | Authenticate to a registry |
| `docker build -t app .` | Build image |
| `docker tag` | Create a new image tag |
| `docker push` | Upload image |
| `docker pull` | Download image |
| `aws ecr get-login-password` | Authenticate to Amazon ECR |

---

# Interview Questions

### What is a Docker Registry?

A Docker Registry is a repository used to store and distribute Docker images.

### What is Docker Hub?

Docker Hub is the world's largest public Docker registry, containing millions of publicly available images.

### What is Amazon ECR?

Amazon Elastic Container Registry (ECR) is AWS's managed private container registry for storing Docker images securely.

### Why should you avoid using the `latest` tag in production?

Because it is ambiguous and makes deployments and rollbacks harder. Versioned tags provide consistency and traceability.

### What must you do before pushing an image to a registry?

Authenticate to the registry (for example with `docker login`), ensure the image is correctly tagged, then push it using `docker push`.