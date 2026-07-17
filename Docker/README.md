# Docker

## Overview

Docker is a containerisation platform that allows applications and their dependencies to be packaged into lightweight, portable containers. Containers provide consistent environments, making it easy to develop, test and deploy applications across different machines.

Unlike traditional virtual machines, containers share the host operating system's kernel, making them much faster to start and significantly more resource efficient.

## Why Docker?

Docker solves the common problem of software working on one machine but not another by packaging everything an application needs into a single image.

Benefits include:

- Consistent environments
- Fast deployment
- Lightweight compared to virtual machines
- Improved scalability
- Easy application distribution
- Simplified dependency management
- Better resource utilisation

## Core Docker Components

- **Docker Engine** – The software responsible for building and running containers.
- **Docker Image** – A read-only template used to create containers.
- **Docker Container** – A running instance of an image.
- **Dockerfile** – A text file containing instructions for building an image.
- **Docker Compose** – A tool for managing multi-container applications.
- **Docker Registry** – Stores Docker images (e.g. Docker Hub).

## Typical Docker Workflow

Source Code

↓

Dockerfile

↓

Docker Image

↓

Docker Container

## Skills Covered

- Building Docker images
- Running containers
- Docker networking
- Docker volumes
- Multi-container applications
- Docker Compose
- Environment variables
- Persistent storage
- Load balancing