# CI/CD Notes - Part 3: YAML & Pipeline Syntax

> Covers:
>
> - What is YAML?
> - YAML Syntax
> - Indentation
> - Key-Value Pairs
> - Lists
> - GitHub Actions Workflow Structure
> - `name`
> - `on`
> - `jobs`
> - `runs-on`
> - `steps`
> - `uses`
> - `run`
> - Events, Jobs and Steps
> - Creating a Simple CI Pipeline

---

# What is YAML?

**YAML** is a human-readable data format commonly used for configuration files.

YAML originally stood for:

```text
Yet Another Markup Language
```

but is now officially interpreted as:

```text
YAML Ain't Markup Language
```

GitHub Actions workflows are written using YAML.

Workflow files normally use:

```text
.yml
```

or:

```text
.yaml
```

For example:

```text
.github/workflows/ci.yml
```

---

# Why Does GitHub Actions Use YAML?

YAML allows us to describe a CI/CD pipeline in a structured and readable format.

For example:

```yaml
name: CI Pipeline

on:
  push:

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
      - name: Say hello
        run: echo "Hello"
```

This tells GitHub Actions:

```text
Workflow Name
      ↓
Trigger
      ↓
Jobs
      ↓
Runner
      ↓
Steps
      ↓
Commands
```

---

# YAML is Indentation-Based

Indentation is extremely important in YAML.

Unlike languages that use `{ }` to define structure, YAML primarily uses spaces.

Example:

```yaml
jobs:
  build:
    runs-on: ubuntu-latest
```

The indentation tells YAML that:

```text
build

belongs inside

jobs
```

and:

```text
runs-on

belongs inside

build
```

---

# Incorrect Indentation

For example:

```yaml
jobs:
build:
runs-on: ubuntu-latest
```

This does not represent the same structure and will usually cause problems in a GitHub Actions workflow.

Correct:

```yaml
jobs:
  build:
    runs-on: ubuntu-latest
```

---

# Spaces vs Tabs

Use **spaces** for YAML indentation.

Avoid tabs.

A common convention is:

```text
2 spaces per indentation level
```

Example:

```yaml
jobs:
  build:
    steps:
      - name: Test
        run: echo "Testing"
```

---

# YAML Key-Value Pairs

A basic YAML value uses:

```text
key: value
```

Example:

```yaml
name: CI Pipeline
```

Here:

```text
name
```

is the key.

And:

```text
CI Pipeline
```

is the value.

---

# More Key-Value Examples

```yaml
name: Build Application
runs-on: ubuntu-latest
environment: production
```

Conceptually:

```text
Key              Value

name        →    Build Application

runs-on     →    ubuntu-latest

environment →    production
```

---

# Nested Values

YAML can contain values inside other values.

Example:

```yaml
jobs:
  build:
    runs-on: ubuntu-latest
```

Structure:

```text
jobs
└── build
    └── runs-on
```

This nesting is extremely important when writing GitHub Actions workflows.

---

# YAML Lists

Lists use:

```text
-
```

For example:

```yaml
branches:
  - main
  - development
```

This represents:

```text
branches

├── main
└── development
```

---

# Lists in GitHub Actions

Steps are represented as a list.

Example:

```yaml
steps:
  - name: Checkout code
    uses: actions/checkout@v4

  - name: Run tests
    run: echo "Testing"
```

There are two steps:

```text
Step 1
Checkout Code

Step 2
Run Tests
```

---

# YAML Comments

Comments start with:

```text
#
```

Example:

```yaml
# Run the pipeline on pushes to main

on:
  push:
    branches:
      - main
```

Comments are ignored when the workflow executes.

---

# Strings

Strings can often be written without quotation marks:

```yaml
name: CI Pipeline
```

They can also be quoted:

```yaml
name: "CI Pipeline"
```

Both may be valid depending on the value.

Quoting can help avoid YAML interpreting certain values unexpectedly.

---

# GitHub Actions Workflow Structure

A typical workflow contains:

```yaml
name:

on:

jobs:
```

Inside the jobs:

```yaml
runs-on:

steps:
```

And inside the steps:

```yaml
name:

uses:

run:
```

---

# Basic Workflow Example

```yaml
name: Simple CI

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

      - name: Run application test
        run: echo "Running tests"
```

---

# Understanding `name`

```yaml
name: Simple CI
```

The `name` gives the workflow a readable name.

This is what you will see in the GitHub Actions interface.

For example:

```text
Simple CI
```

---

# Understanding `on`

The:

```yaml
on:
```

section defines **when the workflow should run**.

This is known as the workflow's **trigger**.

Example:

```yaml
on:
  push:
```

Meaning:

```text
Someone pushes code

↓

Run Workflow
```

---

# Trigger on a Specific Branch

Example:

```yaml
on:
  push:
    branches:
      - main
```

Meaning:

```text
Push to main

↓

Run Pipeline
```

A push to another branch would not trigger this particular configuration.

---

# Multiple Branches

You can specify multiple branches:

```yaml
on:
  push:
    branches:
      - main
      - development
```

Meaning:

```text
Push to main
       OR
Push to development

↓

Run Workflow
```

---

# Pull Request Trigger

A workflow can run when a pull request is opened or updated.

Example:

```yaml
on:
  pull_request:
    branches:
      - main
```

This is useful for testing code **before it is merged into `main`**.

---

# Multiple Events

A workflow can listen for multiple events.

Example:

```yaml
on:
  push:
    branches:
      - main

  pull_request:
    branches:
      - main
```

Now the workflow can run for:

```text
Push to main

OR

Pull Request targeting main
```

---

# What is a Pipeline?

A **pipeline** is a sequence of automated tasks used to process code.

Example:

```text
Code Push

↓

Install Dependencies

↓

Run Tests

↓

Build

↓

Deploy
```

In GitHub Actions, workflows are used to implement these pipelines.

---

# Events, Jobs and Steps

Three of the most important GitHub Actions concepts are:

```text
Event

Job

Step
```

Their relationship is:

```text
EVENT

↓

WORKFLOW

↓

JOB

↓

STEPS
```

---

# Event

An **event** causes the workflow to start.

Examples:

```text
push

pull_request

workflow_dispatch

schedule

release
```

Example:

```yaml
on:
  push:
```

---

# Job

A **job** is a collection of steps that run on the same runner.

Example:

```yaml
jobs:
  test:
    runs-on: ubuntu-latest
```

Here:

```text
test
```

is the job ID.

---

# Multiple Jobs

A workflow can contain several jobs.

Example:

```yaml
jobs:

  test:
    runs-on: ubuntu-latest

  build:
    runs-on: ubuntu-latest
```

Conceptually:

```text
Workflow

├── Test Job
└── Build Job
```

By default, jobs can run independently and in parallel.

---

# Job Dependencies

Sometimes one job should wait for another.

For example:

```text
Test

↓

Build

↓

Deploy
```

GitHub Actions provides:

```yaml
needs:
```

Example:

```yaml
jobs:
  test:
    runs-on: ubuntu-latest

    steps:
      - run: echo "Testing"

  build:
    needs: test
    runs-on: ubuntu-latest

    steps:
      - run: echo "Building"
```

Now:

```text
test

↓

If Successful

↓

build
```

---

# Understanding `runs-on`

Every job needs somewhere to execute.

Example:

```yaml
runs-on: ubuntu-latest
```

This tells GitHub Actions to execute the job on an Ubuntu runner.

Other examples include:

```yaml
runs-on: windows-latest
```

and:

```yaml
runs-on: macos-latest
```

---

# Step

A **step** is an individual operation inside a job.

Example:

```yaml
steps:
  - name: Run tests
    run: echo "Running tests"
```

A job can contain many steps.

---

# Steps Run Sequentially

Inside a job:

```yaml
steps:
  - name: Step 1
    run: echo "First"

  - name: Step 2
    run: echo "Second"

  - name: Step 3
    run: echo "Third"
```

Execution:

```text
Step 1

↓

Step 2

↓

Step 3
```

---

# Understanding `name` Inside Steps

Example:

```yaml
- name: Run tests
```

This gives the step a readable name.

It appears in the GitHub Actions logs.

Good names make pipelines easier to understand and debug.

---

# Understanding `run`

The:

```yaml
run:
```

keyword executes a shell command on the runner.

Example:

```yaml
- name: Display message
  run: echo "Hello"
```

The runner executes:

```bash
echo "Hello"
```

---

# Running Multiple Commands

You can use:

```text
|
```

to run multiple commands.

Example:

```yaml
- name: Install and test
  run: |
    echo "Installing dependencies"
    pip install -r requirements.txt
    echo "Running tests"
    pytest
```

The commands execute in sequence.

---

# Understanding `uses`

The:

```yaml
uses:
```

keyword runs an existing reusable GitHub Action.

Example:

```yaml
- name: Checkout repository
  uses: actions/checkout@v4
```

Instead of writing the logic required to download the repository yourself, GitHub uses the existing checkout action.

---

# `run` vs `uses`

This is an important distinction.

### `run`

Runs a command:

```yaml
run: docker build -t my-app .
```

### `uses`

Runs an existing Action:

```yaml
uses: actions/checkout@v4
```

Simple way to remember:

```text
run
=
Execute a command

uses
=
Use an Action
```

---

# Why Checkout Comes First

A common first step is:

```yaml
- name: Checkout repository
  uses: actions/checkout@v4
```

This makes your repository files available to the runner.

Before:

```text
Runner

No project files checked out
```

After:

```text
Runner

├── app.py
├── Dockerfile
├── requirements.txt
└── other repository files
```

The following steps can now work with the project.

---

# Building a Simple CI Pipeline

Suppose we have a Python application.

Project:

```text
project/
├── app.py
├── requirements.txt
└── .github/
    └── workflows/
        └── ci.yml
```

We want the pipeline to:

```text
Checkout Code

↓

Set Up Python

↓

Install Dependencies

↓

Run Tests
```

---

# Example Python CI Pipeline

```yaml
name: Python CI

on:
  push:
    branches:
      - main

  pull_request:
    branches:
      - main

jobs:
  test:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout repository
        uses: actions/checkout@v4

      - name: Set up Python
        uses: actions/setup-python@v5
        with:
          python-version: "3.12"

      - name: Install dependencies
        run: pip install -r requirements.txt

      - name: Run tests
        run: pytest
```

---

# Understanding the Pipeline

## Trigger

```yaml
on:
  push:
    branches:
      - main
```

The workflow runs when code is pushed to `main`.

---

## Job

```yaml
jobs:
  test:
```

Creates a job called:

```text
test
```

---

## Runner

```yaml
runs-on: ubuntu-latest
```

The job executes on an Ubuntu runner.

---

## Checkout

```yaml
uses: actions/checkout@v4
```

Downloads the repository onto the runner.

---

## Python Setup

```yaml
uses: actions/setup-python@v5
```

Configures Python for the workflow.

---

## Install Dependencies

```yaml
run: pip install -r requirements.txt
```

Installs the application's Python dependencies.

---

## Tests

```yaml
run: pytest
```

Runs the tests.

If the tests fail, the job normally fails.

---

# Building a Docker CI Pipeline

Another example:

```yaml
name: Docker CI

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

      - name: Build Docker image
        run: docker build -t my-app .
```

Flow:

```text
Push to main

↓

Runner Starts

↓

Checkout Code

↓

docker build

↓

Docker Image Built
```

---

# Example with Testing Before Building

```yaml
name: CI Pipeline

on:
  push:
    branches:
      - main

jobs:
  test:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout repository
        uses: actions/checkout@v4

      - name: Run tests
        run: echo "Tests passed"

  build:
    needs: test
    runs-on: ubuntu-latest

    steps:
      - name: Checkout repository
        uses: actions/checkout@v4

      - name: Build application
        run: echo "Building application"
```

Flow:

```text
Push

↓

TEST JOB

↓

Tests Pass

↓

BUILD JOB
```

If the test job fails:

```text
TEST JOB

↓

FAIL

↓

BUILD DOES NOT RUN
```

---

# Why Separate Jobs?

Separating jobs can make workflows easier to organise.

For example:

```text
CI Workflow

├── Test
├── Security Scan
├── Build
└── Deploy
```

It also allows certain jobs to run in parallel where appropriate.

---

# Example Complete Pipeline Structure

```yaml
name: Application Pipeline

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
    runs-on: ubuntu-latest

    steps:
      - name: Deploy
        run: echo "Deploying application"
```

Execution:

```text
TEST

↓

BUILD

↓

DEPLOY
```

---

# Pipeline Failure Behaviour

Suppose:

```text
Test       ✓

Build      ✗

Deploy
```

Because `deploy` depends on `build`:

```text
Deploy does not run
```

This prevents failed builds from progressing further through the pipeline.

---

# YAML Syntax Errors

One common CI/CD problem is invalid YAML.

Example:

```yaml
jobs:
build:
runs-on: ubuntu-latest
```

Correct:

```yaml
jobs:
  build:
    runs-on: ubuntu-latest
```

Always pay attention to indentation.

---

# Workflow Syntax Errors

YAML itself can be valid while the GitHub Actions workflow is still incorrect.

For example, GitHub Actions expects certain keywords and structures.

This means there are two things to consider:

```text
Valid YAML

+

Valid GitHub Actions Syntax
```

---

# Pipeline as Code

Because the workflow is stored as:

```text
.github/workflows/ci.yml
```

your pipeline is version controlled alongside the application.

Benefits include:

- Changes are tracked
- Pipelines can be reviewed
- Pipelines can be reverted
- Teams can collaborate on workflows
- Pull requests can include pipeline changes

---

# Common Mistakes

## Incorrect Indentation

YAML structure depends on indentation.

---

## Using Tabs

Prefer spaces for YAML indentation.

---

## Wrong Workflow Directory

Use:

```text
.github/workflows/
```

---

## Forgetting Checkout

If your commands need repository files, use:

```yaml
uses: actions/checkout@v4
```

---

## Incorrect Job Dependencies

If one job must finish before another, use:

```yaml
needs:
```

---

## Deploying Without Testing

Avoid:

```text
Build

↓

Deploy
```

when the application should be tested first.

Prefer:

```text
Test

↓

Build

↓

Deploy
```

---

# Best Practices

- Use consistent indentation.
- Give workflows meaningful names.
- Give jobs meaningful IDs.
- Give steps descriptive names.
- Keep workflows readable.
- Test before deployment.
- Use `needs` when jobs depend on each other.
- Use reusable Actions instead of recreating common functionality.
- Keep workflow YAML in version control.
- Review pipeline changes through Git.

---

# Key Takeaways

- GitHub Actions workflows are written in YAML.
- YAML uses indentation to define structure.
- `on` defines workflow triggers.
- `jobs` defines the work performed.
- `runs-on` defines the runner.
- `steps` contains individual tasks.
- `run` executes commands.
- `uses` executes reusable Actions.
- Jobs can run independently or depend on other jobs.
- `needs` creates dependencies between jobs.
- A CI pipeline commonly performs testing and building before deployment.

---

# Quick Revision

| Syntax | Purpose |
|--------|---------|
| `name` | Workflow or step name |
| `on` | Workflow trigger |
| `jobs` | Defines workflow jobs |
| `runs-on` | Selects runner |
| `steps` | Tasks inside job |
| `uses` | Use existing Action |
| `run` | Execute command |
| `needs` | Job dependency |
| `-` | YAML list item |
| `|` | Multi-line value/commands |

---

# Workflow Mental Model

```text
EVENT

↓

WORKFLOW

↓

JOB

↓

RUNNER

↓

STEP 1

↓

STEP 2

↓

STEP 3
```

---

# Basic Template

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
        run: echo "Pipeline running"
```

---

# Interview Questions

### What is YAML?

YAML is a human-readable data format commonly used for configuration files, including GitHub Actions workflows.

### Why is indentation important in YAML?

Indentation defines the hierarchy and structure of the configuration.

### What does `on` do in GitHub Actions?

`on` defines the event or events that trigger the workflow.

### What does `jobs` contain?

`jobs` contains the jobs that the workflow will execute.

### What does `runs-on` mean?

It specifies the runner environment used to execute a job.

### What is the difference between a job and a step?

A job is a collection of steps executed on a runner, while a step is an individual task within that job.

### What is the difference between `run` and `uses`?

`run` executes a shell command, while `uses` executes a reusable GitHub Action.

### What does `needs` do?

`needs` creates a dependency between jobs so one job waits for another to complete successfully.

### What happens if a required pipeline stage fails?

Dependent stages normally do not continue, helping prevent broken code from progressing further through the pipeline.
