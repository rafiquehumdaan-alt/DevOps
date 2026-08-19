````markdown
# CI/CD Notes - Part 2: GitHub Actions Setup

> Covers:
>
> - What is GitHub Actions?
> - GitHub Actions and CI/CD
> - Common Use Cases
> - GitHub Repositories
> - `.github/workflows/`
> - Workflow Files
> - Runners
> - GitHub-Hosted Runners
> - Self-Hosted Runners
> - Basic GitHub Actions Setup

---

# What is GitHub Actions?

**GitHub Actions** is GitHub's automation platform.

It allows you to automatically run tasks when events happen inside a GitHub repository.

For example:

```text
Developer

↓

git push

↓

GitHub Repository

↓

GitHub Actions

↓

Build

↓

Test

↓

Deploy
```

This makes GitHub Actions a popular tool for implementing **CI/CD pipelines**.

---

# GitHub Actions and CI/CD

GitHub stores your source code.

GitHub Actions can automatically process that code.

For example:

```text
GitHub Repository

↓

GitHub Actions

├── Install Dependencies
├── Run Tests
├── Build Application
├── Build Docker Image
└── Deploy Application
```

This means the repository and its CI/CD automation can exist in the same platform.

---

# Why Use GitHub Actions?

Without automation:

```text
Developer

↓

Push Code

↓

Manually Run Tests

↓

Manually Build

↓

Manually Deploy
```

With GitHub Actions:

```text
Developer

↓

Push Code

↓

GitHub Actions Automatically Runs

↓

Test

↓

Build

↓

Deploy
```

This reduces repetitive manual work.

---

# Common GitHub Actions Use Cases

GitHub Actions can automate many tasks.

Common examples include:

- Running tests
- Linting code
- Building applications
- Building Docker images
- Pushing Docker images
- Deploying applications
- Running Terraform checks
- Security scanning
- Creating releases
- Running scheduled jobs

---

# Example: Docker CI/CD

A common DevOps use case is automatically building a Docker image.

```text
Developer

↓

git push

↓

GitHub Actions

↓

Build Docker Image

↓

Login to Container Registry

↓

Push Docker Image
```

Instead of manually running:

```bash
docker build
```

and:

```bash
docker push
```

every time the application changes, GitHub Actions can automate these commands.

---

# GitHub Actions Terminology

Important GitHub Actions concepts include:

```text
Workflow
Event
Job
Step
Action
Runner
```

These work together to create an automation pipeline.

---

# Workflow

A **workflow** is the complete automated process.

For example:

```text
CI Workflow

├── Build
├── Test
└── Push Docker Image
```

Workflows are defined using YAML files.

---

# Event

An **event** is something that triggers a workflow.

Examples include:

```text
Push

Pull Request

Manual Trigger

Schedule

Release
```

For example:

```text
git push

↓

push event

↓

Workflow Starts
```

---

# Job

A **job** is a group of steps that runs on a runner.

Example:

```text
Workflow

├── Job: Test
│
└── Job: Build
```

A workflow can contain one or many jobs.

By default, separate jobs can run in parallel unless dependencies are configured between them.

---

# Step

A **step** is an individual task inside a job.

Example:

```text
Job: Build

├── Step 1: Checkout Code
├── Step 2: Install Dependencies
├── Step 3: Run Tests
└── Step 4: Build Application
```

Steps inside the same job normally execute in order.

---

# Action

An **action** is a reusable piece of automation.

For example:

```yaml
- uses: actions/checkout@v4
```

This uses the official checkout action to download your repository's code onto the runner.

Instead of writing the checkout logic yourself, you reuse an existing action.

---

# Runner

A **runner** is the machine that actually executes the workflow.

This is important:

> GitHub itself stores the workflow, but a runner executes the commands.

Example:

```text
GitHub Repository

↓

Workflow Triggered

↓

Runner Created

↓

Runner Executes Steps
```

---

# GitHub Actions Structure

The basic hierarchy is:

```text
Workflow

↓

Jobs

↓

Steps

↓

Actions / Commands
```

For example:

```text
CI Workflow

└── Build Job

    ├── Checkout Code

    ├── Install Dependencies

    ├── Run Tests

    └── Build Docker Image
```

---

# Where Are GitHub Actions Workflows Stored?

GitHub Actions workflows must be stored inside:

```text
.github/workflows/
```

For example:

```text
my-project/
│
├── app.py
├── Dockerfile
├── requirements.txt
│
└── .github/
    └── workflows/
        └── ci.yml
```

The workflow file uses:

```text
.yml
```

or:

```text
.yaml
```

---

# Example Workflow File

Example:

```text
.github/workflows/ci.yml
```

Contents:

```yaml
name: CI Pipeline

on:
  push:
    branches:
      - main

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout repository
        uses: actions/checkout@v4

      - name: Say hello
        run: echo "CI pipeline is running"
```

---

# Understanding the Example

## `name`

```yaml
name: CI Pipeline
```

Gives the workflow a readable name.

---

## `on`

```yaml
on:
  push:
    branches:
      - main
```

Defines the event that triggers the workflow.

In this example:

```text
Push to main

↓

Start Workflow
```

---

## `jobs`

```yaml
jobs:
```

Contains the jobs that the workflow will run.

---

## `build`

```yaml
build:
```

This is the ID of the job.

You could have other jobs such as:

```text
test

build

deploy
```

---

## `runs-on`

```yaml
runs-on: ubuntu-latest
```

Defines what type of runner should execute the job.

In this case, GitHub provides an Ubuntu runner.

---

## `steps`

```yaml
steps:
```

Contains the tasks performed by the job.

---

## `uses`

```yaml
uses: actions/checkout@v4
```

Runs an existing reusable GitHub Action.

Here it checks out the repository onto the runner.

---

## `run`

```yaml
run: echo "CI pipeline is running"
```

Runs a shell command directly on the runner.

---

# Why Do We Need `actions/checkout`?

When a workflow starts, the runner does not automatically have your repository's files available in its working directory.

This action:

```yaml
uses: actions/checkout@v4
```

checks out your repository.

After this:

```text
Runner

↓

Repository Files Available

├── app.py
├── Dockerfile
└── requirements.txt
```

Later steps can now work with those files.

---

# GitHub-Hosted Runners

GitHub provides runners that can execute workflows for you.

Examples include:

```yaml
runs-on: ubuntu-latest
```

```yaml
runs-on: windows-latest
```

```yaml
runs-on: macos-latest
```

GitHub manages the underlying machines.

---

# GitHub-Hosted Runner Flow

```text
Workflow Triggered

↓

GitHub Provides Runner

↓

Repository Checked Out

↓

Commands Execute

↓

Job Finishes

↓

Runner Environment Discarded
```

This means you normally do not need to maintain the server running your pipeline.

---

# Benefits of GitHub-Hosted Runners

Advantages include:

- Easy setup
- GitHub manages the infrastructure
- Clean environment for jobs
- Multiple operating systems available
- No server maintenance required

They are suitable for many CI/CD workloads.

---

# Self-Hosted Runners

You can also provide your own machine to execute GitHub Actions.

This is called a:

```text
Self-Hosted Runner
```

Example:

```text
GitHub

↓

Workflow

↓

Your Server

↓

Commands Execute
```

---

# Why Use a Self-Hosted Runner?

A self-hosted runner can be useful when you need:

- Custom software
- Special hardware
- Access to private internal networks
- Greater control over the environment
- Specific operating system configurations

However, you are responsible for maintaining and securing the machine.

---

# GitHub-Hosted vs Self-Hosted

| GitHub-Hosted | Self-Hosted |
|---------------|-------------|
| Managed by GitHub | Managed by you |
| Easy setup | More setup |
| Temporary environment | Can be persistent |
| Good default option | More control |
| GitHub maintains runner | You maintain runner |

---

# Creating a Repository for CI/CD

A typical project could contain:

```text
my-project/
│
├── app.py
├── requirements.txt
├── Dockerfile
├── README.md
│
└── .github/
    └── workflows/
        └── ci.yml
```

The application and pipeline configuration are both stored in Git.

---

# Creating the Workflow Directory

From your repository root:

```bash
mkdir -p .github/workflows
```

Then create a workflow:

```bash
touch .github/workflows/ci.yml
```

Structure:

```text
.github/
└── workflows/
    └── ci.yml
```

---

# What Happens When You Push the Workflow?

You commit:

```bash
git add .
```

Then:

```bash
git commit -m "Add CI workflow"
```

Then:

```bash
git push
```

If the workflow listens for a `push` event:

```text
Push

↓

GitHub Detects Workflow

↓

Runner Starts

↓

Jobs Execute

↓

Results Displayed in GitHub Actions
```

---

# Viewing Workflow Runs

Workflow runs can be viewed from the:

```text
Actions
```

section of the GitHub repository.

There you can inspect:

- Successful runs
- Failed runs
- Individual jobs
- Individual steps
- Logs
- Error messages

This is important when debugging CI/CD pipelines.

---

# Successful Workflow

A successful workflow means all required jobs and steps completed successfully.

Conceptually:

```text
Checkout       ✓

Dependencies   ✓

Tests          ✓

Build          ✓
```

Result:

```text
Workflow Passed
```

---

# Failed Workflow

If a command fails:

```text
Checkout       ✓

Dependencies   ✓

Tests          ✗

Build          Not Run
```

The workflow can be marked as failed.

You can inspect the logs to identify the problem.

---

# GitHub Actions and Your Repository

The important relationship is:

```text
Repository

Contains:

Application Code
+
Dockerfile
+
Terraform
+
Tests
+
GitHub Actions Workflows
```

GitHub Actions can then automate operations against those files.

---

# Example DevOps Workflow

A more realistic workflow could eventually look like:

```text
Developer Push

↓

GitHub

↓

GitHub Actions

↓

Checkout

↓

Run Tests

↓

Build Docker Image

↓

Login to Registry

↓

Push Docker Image

↓

Deploy
```

---

# GitHub Actions with Terraform

GitHub Actions can also run Terraform.

Example:

```text
Terraform Change

↓

git push

↓

GitHub Actions

↓

terraform fmt

↓

terraform init

↓

terraform validate

↓

terraform plan
```

Production infrastructure changes can then require additional approval before `terraform apply`.

---

# GitHub Actions with AWS

GitHub Actions can also deploy resources or applications to AWS.

Example:

```text
GitHub Actions

↓

Authenticate to AWS

↓

Build Application

↓

Push Image to ECR

↓

Deploy to ECS
```

Modern CI/CD environments commonly use short-lived credentials through mechanisms such as OIDC rather than storing permanent AWS access keys.

---

# Workflow as Code

GitHub Actions workflows are stored as code.

Example:

```text
.github/workflows/ci.yml
```

This means your pipeline can be:

- Version controlled
- Reviewed
- Updated through pull requests
- Reverted
- Shared with the team

This concept is sometimes called:

```text
Pipeline as Code
```

---

# Common Mistakes

## Wrong Workflow Location

This:

```text
workflows/ci.yml
```

will not work as a normal GitHub Actions workflow location.

Use:

```text
.github/workflows/ci.yml
```

---

# Incorrect YAML Indentation

YAML depends heavily on indentation.

Incorrect indentation can cause workflow syntax errors.

Use spaces consistently.

---

# Forgetting to Checkout the Repository

If later commands require repository files, make sure the workflow includes:

```yaml
- uses: actions/checkout@v4
```

---

# Hardcoding Credentials

Never write AWS keys, passwords or registry credentials directly into workflow files.

Use secure authentication and GitHub Secrets where appropriate.

---

# Using Untrusted Actions

Third-party GitHub Actions execute code as part of your workflow.

Only use actions you trust, and pin action versions appropriately for security-sensitive workflows.

---

# Best Practices

- Store workflows under `.github/workflows/`.
- Give workflows and steps meaningful names.
- Use GitHub-hosted runners unless you specifically need self-hosted infrastructure.
- Keep workflow files in version control.
- Never hardcode secrets.
- Review workflow logs when jobs fail.
- Use trusted actions.
- Give workflow permissions only what they require.
- Keep pipelines understandable and maintainable.

---

# Key Takeaways

- GitHub Actions is GitHub's automation platform.
- It is commonly used to implement CI/CD.
- Workflows are written using YAML.
- Workflows live under `.github/workflows/`.
- Events trigger workflows.
- Workflows contain jobs.
- Jobs contain steps.
- Runners execute jobs.
- `uses` runs reusable actions.
- `run` executes commands.
- GitHub can provide hosted runners.
- Self-hosted runners provide greater control but require management.
- GitHub Actions can automate testing, Docker, Terraform and AWS deployments.

---

# Quick Revision

| Concept | Meaning |
|---------|---------|
| Workflow | Complete automated process |
| Event | Trigger for workflow |
| Job | Group of steps |
| Step | Individual task |
| Action | Reusable automation |
| Runner | Machine executing job |
| `uses` | Run an action |
| `run` | Run a command |
| `.github/workflows/` | Workflow directory |

---

# GitHub Actions Hierarchy

```text
EVENT

↓

WORKFLOW

↓

JOB

↓

STEPS

↓

ACTIONS / COMMANDS

↓

RUNNER EXECUTES THEM
```

---

# Basic Workflow

```yaml
name: CI Pipeline

on:
  push:
    branches:
      - main

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout repository
        uses: actions/checkout@v4

      - name: Run command
        run: echo "Hello from GitHub Actions"
```

---

# Interview Questions

### What is GitHub Actions?

GitHub Actions is GitHub's automation platform used to automate tasks such as building, testing and deploying software.

### Where are GitHub Actions workflows stored?

Inside:

```text
.github/workflows/
```

### What triggers a GitHub Actions workflow?

GitHub events such as pushes, pull requests, releases, schedules or manual triggers can start workflows.

### What is a job?

A job is a collection of steps executed on a runner.

### What is a step?

A step is an individual task within a job, such as running a command or using an existing action.

### What is a runner?

A runner is the machine that executes the jobs defined in a GitHub Actions workflow.

### What is the difference between `uses` and `run`?

`uses` executes a reusable GitHub Action, while `run` executes a shell command on the runner.

### What is the difference between GitHub-hosted and self-hosted runners?

GitHub-hosted runners are temporary machines managed by GitHub, while self-hosted runners are machines that you provide, manage and secure.

### What does `actions/checkout` do?

It checks out the repository's source code onto the runner so later workflow steps can access the project's files.
````
