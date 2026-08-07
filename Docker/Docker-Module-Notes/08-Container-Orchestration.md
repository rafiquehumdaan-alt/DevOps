# Docker Notes - Part 8: Container Orchestration

> Covers:
>
> - What is Container Orchestration?
> - Why Orchestration is Needed
> - Kubernetes Overview
> - Docker Swarm
> - Kubernetes vs Docker Swarm
> - Clusters
> - Nodes
> - Pods
> - Scaling
> - Self-Healing
> - Load Balancing

---

# What is Container Orchestration?

Container orchestration is the **automated management of containers**.

Instead of manually starting, stopping and monitoring containers, an orchestration platform manages them for you.

It automates tasks such as:

- Deployments
- Scaling
- Networking
- Load balancing
- Self-healing
- Rolling updates

---

# Why Do We Need Orchestration?

Managing a few containers manually is easy.

Managing hundreds or thousands becomes impossible.

Example:

```text
500 Containers

↓

Application Update

↓

Restart Containers

↓

Replace Failed Containers

↓

Scale Traffic
```

Doing this manually would be slow and error-prone.

---

# Manual vs Orchestrated Deployment

Without orchestration:

```text
Developer

↓

Start Containers

↓

Monitor Containers

↓

Restart Failed Containers

↓

Scale Manually
```

---

With orchestration:

```text
Developer

↓

Deploy Application

↓

Orchestrator

↓

Everything Managed Automatically
```

---

# What is Kubernetes?

**Kubernetes (K8s)** is the world's most popular container orchestration platform.

Originally developed by Google, it is now maintained by the Cloud Native Computing Foundation (CNCF).

Kubernetes manages containers at scale.

---

# What Kubernetes Does

Kubernetes can:

- Deploy containers
- Scale applications
- Restart failed containers
- Perform rolling updates
- Roll back failed deployments
- Load balance traffic
- Manage networking
- Manage storage

---

# Kubernetes Architecture

```text
Users

↓

Load Balancer

↓

Kubernetes Cluster

↓

Worker Nodes

↓

Pods

↓

Containers
```

---

# What is a Cluster?

A **cluster** is a group of machines working together.

Example:

```text
Cluster

├── Node 1
├── Node 2
├── Node 3
```

The orchestrator distributes workloads across these nodes.

---

# What is a Node?

A **node** is a machine (physical or virtual) that runs containers.

There are two main types:

- Control Plane Node
- Worker Node

Worker nodes run the application containers.

---

# What is a Pod?

A **Pod** is the smallest deployable unit in Kubernetes.

A Pod usually contains:

- One container
- Shared networking
- Shared storage (if required)

Example:

```text
Pod

↓

Flask Container
```

---

# Scaling

Kubernetes automatically scales applications based on demand.

Example:

```text
Low Traffic

↓

2 Pods

──────────────

High Traffic

↓

20 Pods
```

Scaling can be:

- Manual
- Automatic (Horizontal Pod Autoscaler)

---

# Self-Healing

Suppose a container crashes.

Kubernetes automatically:

```text
Container Stops

↓

Kubernetes Detects Failure

↓

Creates Replacement Container
```

No manual intervention is required.

---

# Rolling Updates

Updating an application without downtime.

Example:

```text
Version 1

↓

Deploy Version 2

↓

Replace Containers Gradually

↓

Users Experience No Downtime
```

---

# Rollbacks

If an update fails:

```text
Version 2 Fails

↓

Rollback

↓

Version 1 Restored
```

Very useful in production environments.

---

# Load Balancing

Kubernetes automatically distributes traffic across healthy Pods.

Example:

```text
Users

↓

Service

↓

Pod 1

Pod 2

Pod 3
```

This prevents one container from becoming overloaded.

---

# Docker Swarm

Docker Swarm is Docker's built-in orchestration platform.

It provides:

- Clustering
- Scaling
- Load balancing
- High availability

Swarm is much simpler than Kubernetes but has fewer features.

---

# Docker Swarm Architecture

```text
Manager Node

↓

Worker Nodes

↓

Containers
```

The Manager Node controls the cluster.

---

# Kubernetes vs Docker Swarm

| Kubernetes | Docker Swarm |
|-------------|--------------|
| Most popular | Less commonly used |
| More powerful | Simpler |
| Larger learning curve | Easier to learn |
| Huge ecosystem | Smaller ecosystem |
| Industry standard | Mainly small deployments |
| Highly scalable | Suitable for smaller clusters |

---

# Why Kubernetes is Popular

Most companies use Kubernetes because it provides:

- Automatic scaling
- High availability
- Self-healing
- Rolling updates
- Strong cloud integration
- Large community support

Cloud providers offer managed Kubernetes services such as:

- Amazon EKS
- Azure AKS
- Google GKE

---

# Typical DevOps Pipeline

```text
Developer

↓

GitHub

↓

CI/CD Pipeline

↓

Docker Image

↓

Container Registry

↓

Kubernetes Cluster

↓

Production
```

This is one of the most common modern deployment workflows.

---

# When Should You Use Orchestration?

Use orchestration when you need:

- Multiple containers
- High availability
- Automatic scaling
- Zero-downtime deployments
- Self-healing
- Production-grade infrastructure

For small local projects, Docker Compose is usually enough.

---

# Docker Compose vs Kubernetes

| Docker Compose | Kubernetes |
|----------------|------------|
| Local development | Production deployments |
| Single machine | Multiple machines |
| Simple setup | Advanced platform |
| Small projects | Large-scale applications |

Compose is excellent for development.

Kubernetes is designed for production environments.

---

# Common Mistakes

### Thinking Kubernetes Replaces Docker

Kubernetes manages containers.

Docker builds container images.

They solve different problems.

---

### Using Kubernetes Too Early

For local development:

✅ Docker Compose

For production at scale:

✅ Kubernetes

---

### Ignoring Monitoring

Orchestration platforms should be combined with monitoring tools such as:

- Prometheus
- Grafana
- CloudWatch

to observe application health and performance.

---

# Best Practices

- Use Docker Compose for local development.
- Use Kubernetes for production workloads.
- Keep containers stateless where possible.
- Design applications to scale horizontally.
- Use health checks for containers.
- Monitor clusters continuously.
- Use rolling updates to minimise downtime.

---

# Key Takeaways

- Container orchestration automates container management.
- Kubernetes is the industry-standard orchestration platform.
- Docker Swarm is simpler but less widely used.
- Clusters consist of multiple nodes.
- Pods are the smallest deployable unit in Kubernetes.
- Kubernetes provides scaling, self-healing and load balancing.
- Orchestration is essential for large-scale, production applications.

---

# Quick Revision

| Term | Meaning |
|------|---------|
| Orchestration | Automated container management |
| Kubernetes | Container orchestration platform |
| Docker Swarm | Docker's orchestration solution |
| Cluster | Group of machines |
| Node | Machine in a cluster |
| Pod | Smallest deployable Kubernetes unit |
| Scaling | Increase or decrease application capacity |
| Self-Healing | Automatically replace failed containers |
| Rolling Update | Deploy updates without downtime |
| Load Balancing | Distribute traffic across containers |

---

# Interview Questions

### What is container orchestration?

Container orchestration is the automated deployment, management, scaling and monitoring of containers.

### What is Kubernetes?

Kubernetes is an open-source container orchestration platform used to manage containerised applications at scale.

### What is the difference between a Pod and a Container?

A container runs an application, while a Pod is the smallest deployable unit in Kubernetes and usually contains one or more closely related containers.

### What is self-healing in Kubernetes?

Self-healing is Kubernetes' ability to automatically detect failed containers or Pods and replace them without manual intervention.

### When would you use Docker Compose instead of Kubernetes?

Docker Compose is ideal for local development and small multi-container applications, while Kubernetes is designed for large-scale, highly available production deployments.

### Why is Kubernetes considered the industry standard?

Because it provides powerful features such as automatic scaling, self-healing, rolling updates, load balancing and strong support across all major cloud providers.