# CI/CD Notes - Part 8: Manual Triggers & Cheat Sheet

> Covers:
>
> - Manual GitHub Actions Triggers
> - `workflow_dispatch`
> - Running Workflows Manually
> - Manual Inputs
> - Choice, Boolean and String Inputs
> - Using Inputs in Jobs
> - Debugging Manual Workflows
> - When Manual Triggers Are Useful
> - CI/CD Cheat Sheet
> - GitHub Actions Syntax Cheat Sheet
> - Final Module Revision

---

# What is a Manual Trigger?

Most CI/CD workflows run automatically when an event occurs.

For example:

```text
git push

↓

GitHub Actions Workflow
```

However, sometimes we want to run a workflow ourselves.

For example:

```text
GitHub

↓

Click "Run workflow"

↓

Pipeline Starts
```

GitHub Actions supports this using:

```yaml
workflow_dispatch:
```

---

# Basic Manual Workflow

Example:

```yaml
name: Manual Deployment

on:
  workflow_dispatch:

jobs:
  deploy:
    runs-on: ubuntu-latest

    steps:
      - name: Deploy
        run: echo "Deploying application"
```

This workflow can be manually started from GitHub.

---

# `workflow_dispatch`

The:

```yaml
workflow_dispatch:
```

event tells GitHub:

```text
Allow this workflow to be manually triggered
```

You can then run the workflow from the **Actions** section of the repository.

---

# Running a Workflow Manually

In GitHub:

```text
Repository

↓

Actions

↓

Select Workflow

↓

Run workflow
```

GitHub then creates a workflow run.

---

# Why Use Manual Triggers?

Not every operation should happen automatically.

For example, you may want:

```text
Push Code

↓

Automatically Test
```

but:

```text
Production Deployment

↓

Manually Trigger
```

This gives engineers more control over sensitive operations.

---

# Automatic vs Manual Trigger

Automatic:

```yaml
on:
  push:
    branches:
      - main
```

Flow:

```text
Push to main

↓

Workflow Runs Automatically
```

Manual:

```yaml
on:
  workflow_dispatch:
```

Flow:

```text
Engineer Clicks Run

↓

Workflow Runs
```

---

# Using Both Automatic and Manual Triggers

A workflow can support both.

Example:

```yaml
on:
  push:
    branches:
      - main

  workflow_dispatch:
```

Now the workflow can run:

```text
Automatically

OR

Manually
```

---

# Manual Inputs

Manual workflows can ask the user for information before running.

For example:

```text
Which environment?

development
staging
production
```

This allows one workflow to behave differently depending on the selected input.

---

# Basic Input Example

```yaml
on:
  workflow_dispatch:
    inputs:
      environment:
        description: Environment to deploy
        required: true
        default: staging
        type: string
```

When manually starting the workflow, GitHub asks for:

```text
Environment to deploy
```

---

# Accessing Inputs

Manual workflow inputs can be accessed using:

```yaml
${{ inputs.environment }}
```

Example:

```yaml
- name: Display environment
  run: echo "Deploying to ${{ inputs.environment }}"
```

If the user enters:

```text
production
```

the command becomes conceptually:

```bash
echo "Deploying to production"
```

---

# Choice Inputs

Instead of allowing any text, you can provide predefined options.

Example:

```yaml
on:
  workflow_dispatch:
    inputs:
      environment:
        description: Choose deployment environment
        required: true
        type: choice

        options:
          - development
          - staging
          - production
```

The user can select from the available environments.

---

# Why Use Choice Inputs?

Choice inputs reduce mistakes.

Instead of someone accidentally entering:

```text
prodction
```

they choose:

```text
production
```

from a predefined list.

---

# Boolean Inputs

You can also create true/false options.

Example:

```yaml
on:
  workflow_dispatch:
    inputs:
      run-tests:
        description: Run tests before deployment?
        required: true
        type: boolean
        default: true
```

This allows the user to select:

```text
true

or

false
```

---

# Using Boolean Inputs

Example:

```yaml
- name: Run tests
  if: ${{ inputs.run-tests }}
  run: pytest
```

Flow:

```text
run-tests = true?

├── Yes → Run Tests
└── No  → Skip Tests
```

For important production pipelines, required safety tests generally should not be optional.

---

# String Inputs

A string input accepts text.

Example:

```yaml
inputs:
  version:
    description: Version to deploy
    required: true
    type: string
```

The user could enter:

```text
v1.4.2
```

The pipeline can then deploy that specific version.

---

# Example Manual Deployment Workflow

```yaml
name: Manual Deployment

on:
  workflow_dispatch:
    inputs:
      environment:
        description: Choose environment
        required: true
        type: choice

        options:
          - development
          - staging
          - production

      version:
        description: Application version
        required: true
        type: string

jobs:
  deploy:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout repository
        uses: actions/checkout@v4

      - name: Deployment information
        run: |
          echo "Environment: ${{ inputs.environment }}"
          echo "Version: ${{ inputs.version }}"

      - name: Deploy
        run: echo "Deploying application"
```

---

# What Happens?

The engineer manually starts the workflow.

GitHub asks:

```text
Environment:

[development / staging / production]

Version:

[v1.4.2]
```

The workflow then uses those values.

---

# Manual Production Deployment

A common pattern is:

```text
CI

Automatic
```

and:

```text
Production Deployment

Controlled / Manual
```

For example:

```text
Developer Push

↓

Automatic Tests

↓

Automatic Build

↓

Artifact Created

↓

Manual Production Deployment

↓

Production
```

---

# Manual Trigger vs Approval

These are related but different concepts.

### Manual Trigger

The engineer starts the workflow.

```text
Engineer

↓

Run Workflow

↓

Deployment Begins
```

### Environment Approval

The workflow starts but pauses before accessing a protected environment.

```text
Workflow Starts

↓

Tests

↓

Production Approval Required

↓

Approved

↓

Deploy
```

Both can be useful depending on the deployment process.

---

# Debugging Manual Workflows

Manual workflows can fail for the same reasons as automatic workflows.

Common problems include:

- Invalid YAML
- Incorrect input names
- Missing secrets
- Wrong permissions
- Incorrect paths
- Failed commands
- Environment configuration problems

---

# Input Name Mismatch

Suppose you define:

```yaml
inputs:
  environment:
```

but later use:

```yaml
${{ inputs.env }}
```

These do not match.

Correct:

```yaml
${{ inputs.environment }}
```

---

# Debugging Input Values

You can temporarily print non-sensitive input values.

Example:

```yaml
- name: Debug input
  run: echo "Environment = ${{ inputs.environment }}"
```

Do not do this with passwords, tokens or other secrets.

---

# Manual Trigger Use Cases

Manual workflows are useful for:

- Production deployments
- Rollbacks
- Database maintenance
- Infrastructure operations
- Emergency procedures
- Running optional jobs
- Deploying specific versions

---

# Example Manual Rollback

Imagine production currently runs:

```text
v2.0
```

but it has a serious problem.

A manual workflow could ask:

```text
Version to deploy:
```

You enter:

```text
v1.9
```

Flow:

```text
Manual Trigger

↓

Select v1.9

↓

Deploy Previous Image

↓

Rollback Complete
```

---

# Manual Terraform Operations

Manual triggers can also be useful for Infrastructure as Code.

For example:

```text
Engineer

↓

Run Workflow

↓

terraform plan

↓

Approval

↓

terraform apply
```

This provides more control over infrastructure changes.

---

# CI/CD Module Cheat Sheet

# CI/CD

```text
CI
=
Continuous Integration
```

Focus:

```text
Integrate

Build

Test
```

---

```text
CD
=
Continuous Delivery
or
Continuous Deployment
```

Focus:

```text
Release

Deploy
```

---

# Continuous Delivery vs Deployment

```text
Continuous Delivery

Code

↓

Build

↓

Test

↓

Ready for Production

↓

Manual Decision
```

```text
Continuous Deployment

Code

↓

Build

↓

Test

↓

Automatically Deploy
```

---

# GitHub Actions

```text
GitHub Actions
=
GitHub Automation Platform
```

Used for:

- CI/CD
- Testing
- Building
- Docker
- Deployments
- Terraform
- Security checks

---

# Workflow Location

```text
.github/workflows/
```

Example:

```text
.github/workflows/ci.yml
```

---

# GitHub Actions Hierarchy

```text
EVENT

↓

WORKFLOW

↓

JOBS

↓

STEPS

↓

ACTIONS / COMMANDS
```

---

# Basic Workflow Template

```yaml
name: CI

on:
  push:
    branches:
      - main

jobs:
  test:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Test
        run: pytest
```

---

# Important GitHub Actions Keywords

| Keyword | Purpose |
|---------|---------|
| `name` | Name workflow or step |
| `on` | Define trigger |
| `jobs` | Define jobs |
| `runs-on` | Select runner |
| `steps` | Define job tasks |
| `uses` | Use existing Action |
| `run` | Execute command |
| `needs` | Job dependency |
| `if` | Conditional execution |
| `with` | Pass values to Action |
| `env` | Environment variables |
| `strategy` | Job execution strategy |
| `matrix` | Multiple job combinations |

---

# Common Triggers

Push:

```yaml
on:
  push:
```

Pull request:

```yaml
on:
  pull_request:
```

Manual:

```yaml
on:
  workflow_dispatch:
```

Schedule:

```yaml
on:
  schedule:
```

---

# Job Dependency

```yaml
build:
  needs: test
```

Means:

```text
TEST

↓

BUILD
```

---

# Expressions

Syntax:

```text
${{ }}
```

Example:

```yaml
${{ github.ref }}
```

---

# Conditions

Example:

```yaml
if: ${{ github.ref == 'refs/heads/main' }}
```

Meaning:

```text
Only Run on Main
```

---

# Matrix Builds

Example:

```yaml
strategy:
  matrix:
    python-version:
      - "3.11"
      - "3.12"
```

Creates:

```text
Test Python 3.11

+

Test Python 3.12
```

These can run in parallel.

---

# Secrets

Reference secrets using:

```yaml
${{ secrets.SECRET_NAME }}
```

Example:

```yaml
password: ${{ secrets.DOCKER_TOKEN }}
```

Never:

```yaml
password: my-real-password
```

---

# Secure Cloud Authentication

Prefer:

```text
GitHub Actions

↓

OIDC

↓

Cloud IAM Role

↓

Temporary Credentials
```

instead of long-lived cloud access keys where supported.

---

# Reusable Workflow

```yaml
on:
  workflow_call:
```

Called using:

```yaml
jobs:
  ci:
    uses: ./.github/workflows/reusable.yml
```

---

# Custom Action

Usually defined with:

```text
action.yml
```

Called using:

```yaml
- uses: ./.github/actions/my-action
```

---

# Reusable Workflow vs Custom Action

```text
Reusable Workflow

=

Reuse Jobs / Workflow
```

```text
Custom Action

=

Reuse Step-Level Functionality
```

---

# Environment Flow

```text
Development

↓

Testing

↓

Staging

↓

Production
```

---

# Standard CI/CD Pipeline

```text
CODE

↓

LINT

↓

TEST

↓

BUILD

↓

SECURITY SCAN

↓

PACKAGE

↓

DEPLOY

↓

MONITOR
```

---

# Docker CI/CD Example

```text
Developer

↓

Git Push

↓

GitHub Actions

↓

Run Tests

↓

Build Docker Image

↓

Login to Registry

↓

Push Docker Image

↓

Deploy Container
```

---

# Terraform CI/CD Example

```text
Terraform Change

↓

Git Push

↓

terraform fmt

↓

terraform init

↓

terraform validate

↓

terraform plan

↓

Approval

↓

terraform apply
```

---

# Debugging Cheat Sheet

When a workflow fails:

```text
1. Open Actions

2. Open failed workflow

3. Find failed job

4. Find failed step

5. Read logs

6. Identify error

7. Reproduce locally if possible

8. Fix root cause

9. Push fix

10. Verify workflow
```

---

# Useful Debugging Commands

Current directory:

```bash
pwd
```

List files:

```bash
ls -la
```

Check Git status:

```bash
git status
```

Test Docker build:

```bash
docker build .
```

Run Python tests:

```bash
pytest
```

Terraform validation:

```bash
terraform validate
```

---

# Important Security Rules

Never:

```text
Hardcode Secrets

Give Every Workflow Admin Access

Print Passwords

Expose Production Credentials

Trust Random Third-Party Actions
```

Prefer:

```text
GitHub Secrets

OIDC

Least Privilege

Protected Branches

Protected Environments

Code Reviews

Versioned Actions
```

---

# CI/CD Mental Model

The easiest way to remember the entire module:

```text
DEVELOPER

↓

GIT PUSH

↓

GITHUB

↓

GITHUB ACTIONS

↓

RUNNER

↓

BUILD

↓

TEST

↓

PACKAGE

↓

DEPLOY

↓

PRODUCTION
```

---

# Example Full CI/CD Workflow

```yaml
name: Application CI/CD

on:
  push:
    branches:
      - main

  workflow_dispatch:

permissions:
  contents: read

jobs:

  test:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Run tests
        run: echo "Running tests"

  build:
    needs: test
    runs-on: ubuntu-latest

    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Build
        run: echo "Building application"

  deploy:
    needs: build

    if: ${{ github.ref == 'refs/heads/main' }}

    runs-on: ubuntu-latest

    steps:
      - name: Deploy
        run: echo "Deploying application"
```

Flow:

```text
Push to Main

↓

TEST

↓

BUILD

↓

DEPLOY
```

---

# Final Key Takeaways

- CI/CD automates the software delivery process.
- CI focuses on continuously integrating and testing code.
- CD focuses on delivering or deploying code.
- GitHub Actions is GitHub's automation platform.
- Workflows are written in YAML.
- Workflows live inside `.github/workflows/`.
- Events trigger workflows.
- Workflows contain jobs.
- Jobs contain steps.
- Runners execute jobs.
- `run` executes commands.
- `uses` executes reusable Actions.
- `needs` creates job dependencies.
- `if` adds conditional logic.
- Matrix builds allow parallel testing across multiple configurations.
- Secrets must never be hardcoded.
- OIDC can provide temporary cloud credentials.
- Reusable workflows reduce duplicated pipelines.
- Custom actions package repeated step-level functionality.
- Development, staging and production should be separated where appropriate.
- Production deployments should have stronger controls.
- Logs are essential for debugging failed workflows.
- `workflow_dispatch` allows workflows to be manually triggered.

---

# Interview Questions

### What is `workflow_dispatch`?

`workflow_dispatch` is a GitHub Actions event that allows a workflow to be manually triggered.

### Why would you use a manual workflow?

Manual workflows are useful when an operation should require deliberate human initiation, such as production deployment, rollback or infrastructure maintenance.

### Can a workflow have both automatic and manual triggers?

Yes.

For example:

```yaml
on:
  push:
    branches:
      - main

  workflow_dispatch:
```

### Can manual workflows accept input?

Yes. `workflow_dispatch` can define inputs such as strings, booleans and predefined choices.

### What is the difference between a manual trigger and an environment approval?

A manual trigger requires someone to start the workflow, while an environment approval pauses an already-running workflow before a protected deployment can continue.

### What is the overall purpose of CI/CD?

To automate and standardise the process of integrating, testing, building, delivering and deploying software.

### What is the basic GitHub Actions hierarchy?

```text
Event

↓

Workflow

↓

Job

↓

Step
```

### What is the difference between `run` and `uses`?

`run` executes a command on the runner, while `uses` runs a reusable GitHub Action.

### What is a matrix build?

A matrix build runs the same job across multiple configurations, such as several Python versions or operating systems.

### How should secrets be handled in CI/CD?

Secrets should be stored securely using mechanisms such as GitHub Secrets and referenced by the workflow rather than being hardcoded.

### What is the first thing you should do when a workflow fails?

Identify the failed job and step and inspect its logs to determine the actual error.

---

# Final CI/CD Summary

```text
CODE

↓

VERSION CONTROL

↓

CI

├── Lint
├── Test
├── Security
└── Build

↓

ARTIFACT

↓

CD

├── Development
├── Staging
└── Production

↓

MONITOR

↓

FEEDBACK

↓

NEXT CHANGE
```