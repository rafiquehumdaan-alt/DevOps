# AWS Notes - Part 5: Containers

> Covers:
>
> - Containers
> - Docker
> - Docker Images
> - Docker vs Virtual Machines
> - Amazon ECS
> - Amazon ECR
> - Amazon EKS
> - ECS Auto Scaling
> - Load Balancer Integration

---

# What are Containers?

A **container** is a lightweight package that contains everything an application needs to run.

A container includes:

- Application code
- Runtime
- Libraries
- Dependencies
- Configuration

This allows the application to run consistently on any machine.

---

# Why Use Containers?

Without containers:

"My application works on my computer, but not on yours."

Different operating systems or software versions can cause problems.

With containers:

The application behaves the same everywhere because everything it needs is packaged together.

---

# Benefits of Containers

- Fast startup
- Lightweight
- Portable
- Consistent environments
- Easy to scale
- Great for DevOps and CI/CD

---

# What is Docker?

Docker is the most popular container platform.

It allows developers to:

- Build containers
- Run containers
- Share containers
- Deploy containers consistently

Docker is not AWS-specific and can run almost anywhere.

---

# Docker Components

| Component | Purpose |
|-----------|----------|
| Docker Image | Blueprint for a container |
| Docker Container | Running instance of an image |
| Dockerfile | Instructions to build an image |
| Docker Engine | Software that runs containers |

---

# Docker Image

A Docker Image is a read-only template.

It contains:

- Application
- Dependencies
- Configuration

Think of it like a blueprint.

Example:

```
Ubuntu Image

↓

Nginx Installed

↓

Application Copied

↓

Final Image
```

---

# Docker Container

A container is a running instance of a Docker Image.

One image can create many containers.

Example:

```text
Docker Image

↓

Container 1

Container 2

Container 3
```

---

# Where are Docker Images Stored?

Docker Images are stored in **Container Registries**.

Examples:

- Docker Hub
- Amazon ECR
- GitHub Container Registry

Developers pull images from a registry before running them.

---

# Docker vs Virtual Machines

## Virtual Machine

```text
Application

↓

Operating System

↓

Hypervisor

↓

Physical Server
```

Each VM has its own operating system.

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

# Docker vs Virtual Machines

| Docker | Virtual Machine |
|----------|----------------|
| Lightweight | Heavier |
| Starts in seconds | Takes longer to boot |
| Shares Host OS | Full Operating System |
| Lower resource usage | Higher resource usage |
| Highly portable | Less portable |

---

# Why Containers are Faster

Containers do **not** need to boot an operating system.

They simply start the application.

This makes them ideal for:

- Microservices
- CI/CD
- Scaling
- Cloud deployments

---

# Containers on AWS

AWS provides several services for running containers.

| Service | Purpose |
|----------|----------|
| ECS | AWS container orchestration |
| EKS | Kubernetes |
| ECR | Docker image registry |
| Fargate | Serverless containers |

---

# Amazon ECS

Amazon Elastic Container Service (ECS) is AWS's container orchestration service.

It manages:

- Container deployment
- Scheduling
- Scaling
- Monitoring

You focus on your application rather than managing containers manually.

---

# ECS Components

| Component | Purpose |
|-----------|----------|
| Cluster | Collection of compute resources |
| Task Definition | Blueprint for containers |
| Task | Running container |
| Service | Keeps tasks running |
| Container | Your application |

---

# ECS Cluster

An ECS Cluster is a group of compute resources that run containers.

A cluster can use:

- EC2
- AWS Fargate

---

# ECS Launch Types

## EC2 Launch Type

You manage:

- EC2 Instances
- Operating System
- Patching
- Scaling

AWS manages ECS.

More control.

Lower cost.

---

## Fargate Launch Type

AWS manages:

- Servers
- Operating System
- Scaling
- Infrastructure

You simply provide your container.

Less management.

Higher cost.

---

# ECS Task Definition

A Task Definition describes how a container should run.

It includes:

- Docker Image
- CPU
- Memory
- Ports
- Environment Variables
- IAM Role

Think of it as the blueprint for your containers.

---

# ECS Service

An ECS Service ensures the required number of containers are always running.

Example:

Desired Tasks:

```
3
```

If one crashes:

```
AWS automatically launches another.
```

---

# IAM Roles for ECS

Containers often need access to AWS services.

Instead of storing AWS credentials inside containers, assign an IAM Role.

Example permissions:

- Read from S3
- Write to CloudWatch
- Access DynamoDB
- Read Secrets Manager

This is much more secure.

---

# ECS with Load Balancer

A common production architecture:

```text
Internet

↓

Application Load Balancer

↓

ECS Service

↓

Container
Container
Container
```

The Load Balancer distributes requests across containers.

---

# ECS Service Auto Scaling

ECS Services can automatically increase or decrease the number of running containers.

Scaling can be based on:

- CPU Usage
- Memory Usage
- Request Count

Example:

```text
CPU > 70%

↓

Launch More Containers

↓

Traffic Balanced
```

---

# Amazon ECR

Amazon Elastic Container Registry (ECR) is AWS's private Docker image registry.

Instead of Docker Hub, AWS customers often store images in ECR.

Benefits:

- Private repositories
- Secure
- AWS integration
- IAM authentication
- High availability

---

# ECR Workflow

```text
Developer

↓

Build Docker Image

↓

Push to ECR

↓

ECS Pulls Image

↓

Container Starts
```

---

# Amazon EKS

Amazon Elastic Kubernetes Service (EKS) is AWS's managed Kubernetes service.

AWS manages:

- Kubernetes Control Plane
- High Availability
- Updates

You manage:

- Worker Nodes (or Fargate)
- Applications

---

# Why Kubernetes?

Kubernetes helps manage large container environments.

Features include:

- Scaling
- Self-healing
- Rolling updates
- Service discovery
- Load balancing

---

# EKS Architecture

```text
Users

↓

Load Balancer

↓

Kubernetes Cluster

↓

Pods

↓

Containers
```

---

# EKS Node Types

## Managed Node Groups

AWS manages:

- Node provisioning
- Updates
- Scaling

Recommended for most users.

---

## Self-Managed Nodes

You manage:

- EC2 Instances
- Updates
- Configuration

Provides greater control.

---

## AWS Fargate

Containers run without managing any servers.

Simplest option.

---

# ECS vs EKS

| ECS | EKS |
|------|------|
| AWS Native | Kubernetes |
| Easier to learn | More complex |
| AWS-specific | Cloud agnostic |
| Less management | More flexibility |

---

# ECS vs Fargate

| ECS EC2 | ECS Fargate |
|-----------|-------------|
| Manage EC2 | AWS manages servers |
| Lower cost | Higher cost |
| More control | Less management |

---

# Real-World Example

A company builds a web application.

Workflow:

```text
Developer

↓

Build Docker Image

↓

Push to Amazon ECR

↓

ECS Service

↓

Application Load Balancer

↓

Users
```

If traffic increases:

- ECS launches more containers.
- The Load Balancer automatically distributes traffic.

---

# Best Practices

- Store Docker Images in ECR.
- Use IAM Roles instead of AWS credentials.
- Keep container images small.
- Use Load Balancers for production workloads.
- Enable Auto Scaling.
- Store secrets in AWS Secrets Manager.
- Use Fargate if you don't want to manage servers.

---

# Key Takeaways

- Containers package applications and their dependencies.
- Docker is the most popular container platform.
- Images are templates used to create containers.
- Containers are lightweight compared to Virtual Machines.
- ECS is AWS's native container orchestration service.
- ECR stores Docker images.
- EKS is AWS's managed Kubernetes service.
- Fargate allows you to run containers without managing servers.

---

# Quick Revision

| Term | Meaning |
|------|---------|
| Container | Packaged application |
| Docker | Container platform |
| Docker Image | Blueprint for a container |
| Docker Container | Running instance of an image |
| ECS | AWS Container Service |
| ECR | Docker Image Registry |
| EKS | Managed Kubernetes |
| Fargate | Serverless Containers |
| Task Definition | Blueprint for ECS Tasks |
| ECS Service | Keeps containers running |

---

# Interview Questions

### What is a container?

A lightweight package containing an application and all of its dependencies.

### What is Docker?

A platform used to build, package and run containers.

### What is Amazon ECR?

A private Docker image registry provided by AWS.

### What is the difference between ECS and EKS?

ECS is AWS's native container orchestration service, while EKS is AWS's managed Kubernetes service.

### When would you choose Fargate?

When you want to run containers without managing EC2 instances or the underlying infrastructure.

### Why are containers preferred over Virtual Machines?

They are lighter, start faster, use fewer resources and are easier to scale.