````markdown
# CI/CD Notes - Part 1: CI/CD Fundamentals

> Covers:
>
> - What is CI/CD?
> - Continuous Integration
> - Continuous Delivery
> - Continuous Deployment
> - Why CI/CD is Needed
> - CI/CD in DevOps
> - CI/CD Architecture
> - Popular CI/CD Tools
> - Benefits of CI/CD
> - Build, Test and Deploy Flow

---

# What is CI/CD?

**CI/CD** is a set of practices used to automate the process of building, testing and deploying software.

CI/CD stands for:

```text
CI = Continuous Integration

CD = Continuous Delivery
or
CD = Continuous Deployment
```

The overall goal is to move code from a developer's machine into production in a **fast, consistent and automated way**.

A basic flow looks like:

```text
Developer Writes Code

↓

Push to GitHub

↓

Build

↓

Test

↓

Deploy

↓

Application
```

Instead of engineers manually performing each step, a CI/CD pipeline automates them.

---

# The Problem Without CI/CD

Imagine developers are working on an application.

Without CI/CD:

```text
Developer writes code

↓

Manually builds application

↓

Manually runs tests

↓

Manually creates Docker image

↓

Manually uploads image

↓

Manually deploys application
```

This creates several problems:

- Human error
- Slow deployments
- Inconsistent processes
- Bugs discovered late
- Repetitive manual work
- Difficult collaboration
- Risky releases

CI/CD automates much of this process.

---

# Continuous Integration (CI)

**Continuous Integration** is the practice of frequently merging code changes into a shared repository and automatically checking those changes.

For example:

```text
Developer

↓

git push

↓

GitHub

↓

CI Pipeline

├── Build
├── Test
└── Lint
```

The goal is to detect problems as early as possible.

---

# CI Example

Suppose you have a Python application.

You change:

```text
app.py
```

Then push:

```bash
git add .
git commit -m "Update application"
git push
```

The push can automatically trigger a CI pipeline.

The pipeline could:

```text
1. Download the code

2. Install dependencies

3. Run tests

4. Check code quality

5. Build a Docker image
```

If something fails, the pipeline fails and the developer can investigate.

---

# Why Continuous Integration?

Imagine five developers working on the same application.

Without frequent integration:

```text
Developer A ───────┐
Developer B ───────┤
Developer C ───────┼── Huge Merge
Developer D ───────┤
Developer E ───────┘
```

This can create large conflicts and unexpected problems.

With Continuous Integration:

```text
Small Change

↓

Merge

↓

Test

↓

Small Change

↓

Merge

↓

Test
```

Problems are detected earlier and are generally easier to fix.

---

# Common CI Tasks

A CI pipeline commonly performs:

- Dependency installation
- Compilation/building
- Unit tests
- Integration tests
- Linting
- Security scanning
- Docker image builds

The exact tasks depend on the application.

---

# Continuous Delivery

**Continuous Delivery** means keeping software in a state where it can be released reliably at any time.

The pipeline automatically performs the steps required to prepare a release.

Example:

```text
Code Push

↓

Build

↓

Test

↓

Package

↓

Staging

↓

Manual Approval

↓

Production
```

The important part is that deployment to production may still require **manual approval**.

---

# Continuous Deployment

**Continuous Deployment** goes one step further.

If all automated checks pass, the application is automatically deployed to production.

Example:

```text
Code Push

↓

Build

↓

Test

↓

Security Checks

↓

Deploy

↓

Production
```

No manual approval is necessarily required.

---

# Continuous Delivery vs Continuous Deployment

These terms are closely related but are not identical.

### Continuous Delivery

```text
Build

↓

Test

↓

Ready to Deploy

↓

Manual Approval

↓

Production
```

### Continuous Deployment

```text
Build

↓

Test

↓

Automatic Deployment

↓

Production
```

A simple way to remember:

```text
Delivery
=
Ready to deploy

Deployment
=
Automatically deployed
```

---

# CI vs CD

### CI

Focuses primarily on:

```text
Integrating

Building

Testing

Validating
```

### CD

Focuses primarily on:

```text
Releasing

Deploying

Delivering
```

Together:

```text
CODE

↓

CI

↓

CD

↓

PRODUCTION
```

---

# What is a CI/CD Pipeline?

A **pipeline** is a sequence of automated stages that code passes through.

Example:

```text
Code

↓

Build

↓

Test

↓

Package

↓

Deploy
```

Each stage performs a specific task.

If an important stage fails, later stages should normally not continue.

---

# Example Pipeline

```text
Developer Pushes Code

↓

GitHub

↓

Install Dependencies

↓

Run Tests

↓

Build Docker Image

↓

Push Docker Image

↓

Deploy Application
```

This entire process can happen automatically.

---

# Build Stage

The **build stage** prepares the application for use or deployment.

Depending on the project, this could mean:

- Compiling code
- Installing dependencies
- Creating application packages
- Building Docker images

Example:

```bash
docker build -t my-app .
```

---

# Test Stage

The **test stage** checks whether the application works correctly.

Examples:

```text
Unit Tests

Integration Tests

Linting

Security Checks
```

If the tests fail:

```text
Pipeline

↓

FAIL
```

The application should normally not proceed to deployment.

---

# Deploy Stage

The **deployment stage** releases the application to an environment.

Examples:

```text
Development

Staging

Production
```

Deployment targets could include:

- AWS EC2
- Amazon ECS
- Amazon EKS
- Kubernetes
- Serverless platforms

---

# Why Do We Need CI/CD?

CI/CD makes software delivery:

- Faster
- More reliable
- Repeatable
- Automated
- Easier to test
- Easier to maintain

It reduces the amount of manual work required to release applications.

---

# Automation

One of the biggest benefits of CI/CD is automation.

Without CI/CD:

```text
Engineer

↓

Run Test

↓

Build Image

↓

Login to Registry

↓

Push Image

↓

Deploy
```

With CI/CD:

```text
Engineer

↓

git push

↓

Pipeline handles the rest
```

This saves time and reduces human error.

---

# Faster Feedback

CI/CD provides developers with quick feedback.

Example:

```text
Developer Pushes Code

↓

Tests Run

↓

Test Failed

↓

Developer Notified
```

The developer discovers the problem shortly after making the change rather than during a production deployment.

---

# Consistency

Manual deployments can vary depending on who performs them.

For example:

```text
Engineer A deploys one way

Engineer B deploys another way
```

A CI/CD pipeline follows the same defined process every time.

```text
Same Code

↓

Same Pipeline

↓

Same Process
```

This improves consistency.

---

# CI/CD in DevOps

CI/CD is a major part of **DevOps**.

DevOps aims to improve collaboration between:

```text
Development

+

Operations
```

CI/CD provides the automation needed to move software through the development lifecycle.

---

# Typical DevOps Flow

```text
Developer

↓

Git

↓

CI/CD

↓

Build & Test

↓

Container Registry

↓

Cloud Infrastructure

↓

Application
```

CI/CD acts as the automation layer connecting development with deployment.

---

# CI/CD Architecture

A simplified architecture might look like:

```text
Developer
    │
    │ git push
    ▼
GitHub Repository
    │
    ▼
CI/CD Pipeline
    │
    ├── Build
    │
    ├── Test
    │
    ├── Security Checks
    │
    └── Package
    │
    ▼
Docker Registry
    │
    ▼
AWS
    │
    ▼
Application
```

---

# CI/CD with Docker

CI/CD and Docker are commonly used together.

Example:

```text
Developer

↓

GitHub

↓

CI Pipeline

↓

docker build

↓

Docker Image

↓

Container Registry

↓

Deployment
```

The same tested image can then be deployed consistently across environments.

---

# Example From a Docker Project

A common pipeline could perform:

```text
Push Code to GitHub

↓

GitHub Actions Starts

↓

Checkout Repository

↓

Build Docker Image

↓

Login to Container Registry

↓

Push Docker Image

↓

Image Available for Deployment
```

This removes the need to manually build and push the image after every change.

---

# CI/CD and Infrastructure as Code

CI/CD can also automate Infrastructure as Code tools such as Terraform.

Example:

```text
Terraform Code

↓

Git Push

↓

CI/CD

↓

terraform fmt

↓

terraform validate

↓

terraform plan

↓

Approval

↓

terraform apply
```

This allows infrastructure changes to follow controlled automated processes.

---

# Popular CI/CD Tools

Common CI/CD platforms include:

- GitHub Actions
- GitLab CI/CD
- Jenkins
- CircleCI
- Azure Pipelines
- AWS CodePipeline
- Bitbucket Pipelines

They all provide ways to automate software delivery workflows.

---

# GitHub Actions

GitHub Actions is GitHub's built-in automation platform.

It allows workflows to run when events occur in a GitHub repository.

For example:

```text
git push

↓

GitHub Event

↓

GitHub Actions

↓

CI/CD Workflow
```

Workflows are commonly defined using YAML files.

Example location:

```text
.github/
└── workflows/
    └── ci.yml
```

---

# CI/CD Trigger Events

Pipelines can be triggered by different events.

Examples include:

```text
Push

Pull Request

Merge

Manual Trigger

Schedule

Release
```

For example:

```text
Push to main

↓

Run CI/CD Pipeline
```

---

# CI/CD Environments

Applications commonly move through multiple environments.

Example:

```text
Development

↓

Testing

↓

Staging

↓

Production
```

Each environment provides another opportunity to validate the application before it reaches users.

---

# CI/CD and Security

CI/CD pipelines often require credentials for services such as:

- AWS
- Docker registries
- Deployment platforms

Credentials should never be hardcoded directly into workflow files.

Instead, CI/CD platforms provide secure mechanisms such as:

```text
Secrets

Environment Variables

Workload Identity / OIDC
```

---

# CI/CD Benefits

The major benefits include:

### Faster Releases

Automation reduces the time required to release software.

### Earlier Bug Detection

Automated tests identify problems sooner.

### Consistency

The same pipeline runs every time.

### Reduced Human Error

Manual deployment steps are reduced.

### Better Collaboration

Developers regularly integrate their work.

### Repeatability

The same process can be used across multiple deployments.

---

# Common CI/CD Mistakes

### Deploying Without Tests

Avoid:

```text
Code

↓

Production
```

Prefer:

```text
Code

↓

Build

↓

Test

↓

Deploy
```

---

### Hardcoding Secrets

Never put credentials directly inside workflow files.

Avoid:

```yaml
password: my-secret-password
```

Use secure CI/CD secrets instead.

---

### Ignoring Failed Pipelines

A failed pipeline usually means something needs investigation.

Do not deploy broken builds simply to bypass the pipeline.

---

### Making Pipelines Too Complicated

CI/CD pipelines should automate the necessary process without unnecessary complexity.

Keep workflows understandable and maintainable.

---

# Best Practices

- Automate repetitive tasks.
- Run tests before deployment.
- Keep pipelines in version control.
- Never hardcode secrets.
- Use separate environments where appropriate.
- Use manual approval for sensitive production deployments when required.
- Keep pipelines simple and readable.
- Fail early when tests or validation fail.
- Monitor and investigate pipeline failures.
- Use least-privilege permissions for CI/CD credentials.

---

# Key Takeaways

- CI/CD automates software integration, testing and delivery.
- CI stands for Continuous Integration.
- CD can mean Continuous Delivery or Continuous Deployment.
- Continuous Integration automatically validates frequent code changes.
- Continuous Delivery keeps software ready for release.
- Continuous Deployment can automatically release successful changes to production.
- CI/CD reduces manual work and human error.
- Pipelines commonly contain build, test and deploy stages.
- CI/CD is a major part of DevOps automation.
- GitHub Actions is one platform that can implement CI/CD pipelines.

---

# Quick Revision

| Concept | Purpose |
|---------|---------|
| CI | Integrate and test code continuously |
| Continuous Delivery | Keep software ready to deploy |
| Continuous Deployment | Automatically deploy successful changes |
| Pipeline | Automated sequence of tasks |
| Build | Prepare/package application |
| Test | Validate application |
| Deploy | Release application |
| GitHub Actions | GitHub automation platform |

---

# CI/CD Mental Model

```text
CODE

↓

BUILD

↓

TEST

↓

PACKAGE

↓

DEPLOY

↓

APPLICATION
```

---

# CI/CD in DevOps

```text
Developer

↓

Git Repository

↓

CI/CD Pipeline

↓

Build

↓

Test

↓

Deploy

↓

Cloud Infrastructure
```

---

# Interview Questions

### What is CI/CD?

CI/CD is a set of practices that automate the integration, testing, delivery and deployment of software.

### What is Continuous Integration?

Continuous Integration is the practice of frequently integrating code changes into a shared repository and automatically validating those changes through processes such as builds and tests.

### What is Continuous Delivery?

Continuous Delivery keeps software in a deployable state and automates the release process up to the point where production deployment may require manual approval.

### What is Continuous Deployment?

Continuous Deployment automatically deploys changes to production after they successfully pass the required pipeline stages.

### What is the difference between Continuous Delivery and Continuous Deployment?

Continuous Delivery normally keeps the application ready for production while allowing a manual production decision. Continuous Deployment automatically releases successful changes to production.

### What is a CI/CD pipeline?

A CI/CD pipeline is a sequence of automated stages used to build, test, package and deploy software.

### Why is CI/CD important in DevOps?

CI/CD automates the process of moving code from development toward production, providing faster feedback, repeatability and more reliable deployments.

### What are some popular CI/CD tools?

Examples include GitHub Actions, GitLab CI/CD, Jenkins, CircleCI, Azure Pipelines and AWS CodePipeline.
````
