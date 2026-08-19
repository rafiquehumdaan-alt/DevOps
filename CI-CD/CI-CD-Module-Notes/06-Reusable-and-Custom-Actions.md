# CI/CD Notes - Part 6: Reusable Workflows & Custom Actions

> Covers:
>
> - Reusable CI/CD
> - Why Reusability Matters
> - DRY Principle
> - Reusable Workflows
> - `workflow_call`
> - Workflow Inputs
> - Workflow Secrets
> - Calling Reusable Workflows
> - Custom GitHub Actions
> - Composite Actions
> - `action.yml`
> - Inputs and Outputs
> - Sharing Actions Between Projects
> - Versioning Actions
> - Reusable Workflows vs Custom Actions

---

# Why Make CI/CD Reusable?

As projects grow, CI/CD pipelines often contain repeated code.

For example, several repositories may all need to:

```text
Checkout Code

↓

Set Up Python

↓

Install Dependencies

↓

Run Tests

↓

Build Docker Image
```

Without reusable components, you might copy the same YAML into every project.

This creates duplication.

---

# The DRY Principle

DRY stands for:

```text
Don't Repeat Yourself
```

Instead of:

```text
Project A
└── Same CI Logic

Project B
└── Same CI Logic

Project C
└── Same CI Logic
```

we can reuse common automation:

```text
                ┌── Project A
                │
Reusable CI ────┼── Project B
                │
                └── Project C
```

This makes CI/CD easier to maintain and standardise.

---

# Why Reusability Matters

Reusable CI/CD provides:

- Less duplicated YAML
- Easier maintenance
- Consistent pipelines
- Easier collaboration
- Standardised processes
- Faster creation of new pipelines

If a shared process changes, you may only need to update it in one place.

---

# Two Important Reusability Options

GitHub Actions provides different ways to reuse automation.

Two important ones are:

```text
Reusable Workflows

and

Custom Actions
```

They solve slightly different problems.

---

# Reusable Workflows

A **reusable workflow** is an entire GitHub Actions workflow that another workflow can call.

For example:

```text
Application Workflow

↓

Reusable Testing Workflow

↓

Reusable Deployment Workflow
```

Instead of defining all jobs repeatedly, another workflow can call the reusable workflow.

---

# `workflow_call`

A reusable workflow uses:

```yaml
on:
  workflow_call:
```

This tells GitHub:

> This workflow can be called by another workflow.

---

# Basic Reusable Workflow

Example:

```yaml
name: Reusable Tests

on:
  workflow_call:

jobs:
  test:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout repository
        uses: actions/checkout@v4

      - name: Run tests
        run: echo "Running tests"
```

This workflow does not need to be triggered directly by a normal `push`.

Another workflow can call it.

---

# Calling a Reusable Workflow

Suppose the reusable workflow is:

```text
.github/workflows/reusable-tests.yml
```

Another workflow can call it:

```yaml
name: Application CI

on:
  push:

jobs:
  tests:
    uses: ./.github/workflows/reusable-tests.yml
```

Flow:

```text
Push

↓

Application CI

↓

Reusable Tests Workflow

↓

Run Tests
```

---

# Reusable Workflow Inputs

Reusable workflows can accept values from the calling workflow.

Example:

```yaml
on:
  workflow_call:
    inputs:
      python-version:
        required: true
        type: string
```

The reusable workflow can access it using:

```yaml
${{ inputs.python-version }}
```

---

# Example with Input

Reusable workflow:

```yaml
name: Reusable Python Tests

on:
  workflow_call:
    inputs:
      python-version:
        required: true
        type: string

jobs:
  test:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout repository
        uses: actions/checkout@v4

      - name: Set up Python
        uses: actions/setup-python@v5
        with:
          python-version: ${{ inputs.python-version }}

      - name: Run tests
        run: echo "Running tests"
```

---

# Passing the Input

Calling workflow:

```yaml
jobs:
  tests:
    uses: ./.github/workflows/reusable-tests.yml

    with:
      python-version: "3.12"
```

Flow:

```text
Calling Workflow

python-version = 3.12

↓

Reusable Workflow

↓

Set Up Python 3.12
```

---

# Why Inputs are Useful

Without inputs, the reusable workflow could become hardcoded.

For example:

```yaml
python-version: "3.12"
```

Using inputs makes the workflow flexible:

```text
Project A → Python 3.11

Project B → Python 3.12

Project C → Python 3.13
```

All can reuse the same workflow.

---

# Secrets in Reusable Workflows

Reusable workflows can also receive secrets.

Example:

```yaml
on:
  workflow_call:
    secrets:
      registry-token:
        required: true
```

The reusable workflow can reference:

```yaml
${{ secrets.registry-token }}
```

---

# Passing Secrets

The calling workflow could use:

```yaml
jobs:
  deploy:
    uses: ./.github/workflows/deploy.yml

    secrets:
      registry-token: ${{ secrets.REGISTRY_TOKEN }}
```

The actual secret remains securely stored in GitHub.

---

# `secrets: inherit`

Reusable workflows can also inherit available secrets in supported scenarios.

Example:

```yaml
jobs:
  deploy:
    uses: organisation/repository/.github/workflows/deploy.yml@main
    secrets: inherit
```

This should be used carefully because workflows should only receive secrets they actually require.

---

# Calling a Workflow from Another Repository

Reusable workflows can also be stored in another repository.

General syntax:

```yaml
uses: OWNER/REPOSITORY/.github/workflows/WORKFLOW.yml@REF
```

Example:

```yaml
uses: my-org/ci-workflows/.github/workflows/python-ci.yml@v1
```

This allows an organisation to maintain central CI/CD workflows.

---

# Centralised CI/CD

Imagine an organisation has 20 applications.

Instead of maintaining 20 completely separate CI pipelines:

```text
Central CI Repository

├── Python CI
├── Docker Build
└── Deployment Workflow
```

Applications can reuse them:

```text
App A ───┐
App B ───┼──► Central CI Workflows
App C ───┘
```

This improves standardisation.

---

# What is a Custom GitHub Action?

A **custom action** is a reusable unit of functionality that can be used as a step inside workflows.

For example, suppose several workflows repeatedly run:

```bash
echo "Starting build"

docker build -t my-app .

echo "Build finished"
```

Instead of repeating those steps, you could create a custom action.

---

# Custom Action Concept

```text
Workflow

↓

Custom Action

├── Command 1
├── Command 2
└── Command 3
```

Then multiple workflows can reuse that action.

---

# Types of Custom Actions

GitHub supports different types of custom actions, including:

- JavaScript actions
- Docker container actions
- Composite actions

For DevOps learning, **composite actions** are particularly useful because they allow multiple workflow steps to be grouped together.

---

# Composite Actions

A **composite action** combines several commands or actions into one reusable action.

Example:

```text
Custom Build Action

├── Install Dependencies
├── Run Tests
└── Build Application
```

A workflow can then call the entire group as one step.

---

# Custom Action Structure

A local custom action might look like:

```text
.github/
├── actions/
│   └── setup-app/
│       └── action.yml
│
└── workflows/
    └── ci.yml
```

The:

```text
action.yml
```

file describes the custom action.

---

# Basic `action.yml`

Example:

```yaml
name: Setup Application

description: Install application dependencies

runs:
  using: composite

  steps:
    - name: Install dependencies
      shell: bash
      run: pip install -r requirements.txt
```

---

# Understanding the Custom Action

```yaml
name: Setup Application
```

Defines the action's name.

---

```yaml
description: Install application dependencies
```

Explains what the action does.

---

```yaml
runs:
  using: composite
```

Tells GitHub this is a composite action.

---

```yaml
steps:
```

Defines the tasks performed by the action.

---

# Calling a Local Custom Action

The workflow can call the action using:

```yaml
- name: Setup application
  uses: ./.github/actions/setup-app
```

Flow:

```text
Workflow

↓

uses: setup-app

↓

action.yml

↓

Install Dependencies
```

---

# Custom Action Inputs

Custom actions can accept inputs.

Example:

```yaml
inputs:
  python-version:
    description: Python version to use
    required: true
```

Reference the input using:

```yaml
${{ inputs.python-version }}
```

---

# Complete Input Example

```yaml
name: Python Setup

description: Configure Python

inputs:
  python-version:
    description: Python version
    required: true

runs:
  using: composite

  steps:
    - name: Set up Python
      uses: actions/setup-python@v5
      with:
        python-version: ${{ inputs.python-version }}
```

---

# Passing an Input to a Custom Action

Workflow:

```yaml
- name: Configure Python
  uses: ./.github/actions/python-setup
  with:
    python-version: "3.12"
```

Flow:

```text
Workflow

↓

3.12

↓

Custom Action Input

↓

Set Up Python 3.12
```

---

# Custom Action Outputs

Actions can also expose outputs.

An output allows the action to calculate or generate something and return it to the workflow.

Conceptually:

```text
Custom Action

↓

Creates Value

↓

Output

↓

Workflow Uses Value
```

---

# Example Output

An action could define:

```yaml
outputs:
  image-tag:
    description: Generated Docker image tag
    value: ${{ steps.tag.outputs.value }}
```

A workflow could then reference the action's output through the ID of the step that called the action.

---

# Step IDs

To reference an action's output, give the step an ID.

Example:

```yaml
- name: Generate image tag
  id: docker
  uses: ./.github/actions/docker-tag
```

Then:

```yaml
${{ steps.docker.outputs.image-tag }}
```

---

# Reusing Custom Actions Across Projects

Custom actions can be stored in another GitHub repository.

Example:

```yaml
uses: organisation/custom-actions/setup-app@v1
```

Now multiple projects can use the same action.

---

# Sharing Actions

Example architecture:

```text
Custom Actions Repository

├── Setup Python
├── Build Docker
└── Run Security Scan
        ▲
        │
   ┌────┼────┐
   │    │    │
 App A App B App C
```

This allows teams to standardise common tasks.

---

# Versioning Custom Actions

Reusable actions should be versioned.

For example:

```yaml
uses: organisation/my-action@v1
```

or a specific release:

```yaml
uses: organisation/my-action@v1.2.0
```

For stronger immutability and supply-chain security, a specific commit SHA can be used.

---

# Why Version Actions?

Imagine an action changes unexpectedly.

If every project references:

```text
main
```

a new commit could affect every pipeline immediately.

Versioning gives more control.

```text
App A → v1

App B → v1

Testing → v2
```

---

# Reusable Workflow vs Custom Action

These concepts are similar but operate at different levels.

### Reusable Workflow

Reuses an entire workflow containing one or more jobs.

```text
Workflow

↓

Reusable Workflow

├── Test Job
├── Build Job
└── Security Job
```

---

### Custom Action

Reuses functionality as a step within a job.

```text
Workflow

↓

Job

↓

Custom Action Step
```

---

# Simple Comparison

| Reusable Workflow | Custom Action |
|-------------------|---------------|
| Reuses workflows/jobs | Reuses steps/functionality |
| Uses `workflow_call` | Uses `action.yml` |
| Can contain multiple jobs | Used as a step |
| Good for complete CI/CD processes | Good for repeated tasks |
| Called from `jobs` | Called from `steps` |

---

# Example

Suppose every project needs:

```text
Test

↓

Build

↓

Security Scan
```

A **reusable workflow** may be appropriate.

But suppose every pipeline repeatedly needs:

```text
Configure Python
```

A **custom action** may be more appropriate.

---

# Reusable CI/CD Architecture

A larger organisation might use:

```text
Application Repository
        │
        ▼
Reusable CI Workflow
        │
        ├── Custom Setup Action
        │
        ├── Custom Test Action
        │
        └── Custom Build Action
        │
        ▼
Deployment
```

Reusable workflows and custom actions can therefore be used together.

---

# Example Reusable Workflow

```yaml
name: Reusable CI

on:
  workflow_call:
    inputs:
      python-version:
        required: true
        type: string

jobs:
  test:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Python Setup
        uses: actions/setup-python@v5
        with:
          python-version: ${{ inputs.python-version }}

      - name: Install Dependencies
        run: pip install -r requirements.txt

      - name: Test
        run: pytest
```

---

# Calling It

```yaml
name: Application CI

on:
  push:
    branches:
      - main

jobs:
  ci:
    uses: ./.github/workflows/reusable-ci.yml
    with:
      python-version: "3.12"
```

Now the main workflow remains very small.

---

# Before Reusability

```yaml
jobs:
  test:
    runs-on: ubuntu-latest

    steps:
      # lots of repeated configuration
```

Repeated across many repositories.

---

# After Reusability

```yaml
jobs:
  ci:
    uses: organisation/ci/.github/workflows/python.yml@v1
```

Much of the repeated logic is centralised.

---

# Benefits of Reusable CI/CD

### Consistency

Every project can follow the same process.

### Maintenance

Fix the shared automation instead of updating many duplicated pipelines.

### Security

Organisations can create approved deployment and security workflows.

### Simplicity

Application repositories contain less repeated YAML.

### Standardisation

Teams can follow common CI/CD practices.

---

# Common Mistakes

## Copying the Same Workflow Everywhere

If the same large workflow exists in many repositories, consider making it reusable.

---

## Hardcoding Values

Avoid hardcoding values that different projects need to change.

Use:

```text
inputs
```

instead.

---

## Passing Too Many Secrets

Only provide reusable workflows with secrets they actually require.

Follow least privilege.

---

## Using `main` for Everything

Avoid relying on a constantly changing branch for important shared production automation.

Use controlled versions or commit SHAs where appropriate.

---

## Creating Custom Actions for Everything

Not every command needs its own custom action.

Use custom actions when meaningful functionality is genuinely repeated.

---

# Best Practices

- Follow the DRY principle.
- Use reusable workflows for repeated CI/CD processes.
- Use custom actions for repeated step-level functionality.
- Use inputs instead of hardcoded values.
- Only pass required secrets.
- Version shared actions and workflows.
- Document inputs and outputs.
- Keep reusable components focused.
- Review shared automation carefully.
- Apply least privilege to reusable workflows.

---

# Key Takeaways

- Reusable CI/CD reduces duplicated workflow code.
- GitHub reusable workflows use `workflow_call`.
- Reusable workflows can accept inputs and secrets.
- Workflows can be reused across repositories.
- Custom actions package repeated functionality.
- Composite actions combine multiple steps.
- Custom actions are defined using `action.yml`.
- Inputs make reusable automation configurable.
- Outputs allow actions to return values.
- Reusable workflows operate at the workflow/job level.
- Custom actions operate at the step level.
- Shared automation should be versioned.

---

# Quick Revision

| Concept | Purpose |
|---------|---------|
| DRY | Don't Repeat Yourself |
| Reusable Workflow | Reuse complete workflow/jobs |
| `workflow_call` | Makes workflow reusable |
| `inputs` | Pass configurable values |
| `secrets` | Pass sensitive values |
| Custom Action | Reusable task |
| Composite Action | Combines multiple steps |
| `action.yml` | Defines custom action |
| `uses` | Calls action/workflow |
| Outputs | Return values |
| Versioning | Control reusable code versions |

---

# Reusability Mental Model

```text
Organisation CI/CD
        │
        ├── Reusable Workflows
        │       │
        │       ├── CI
        │       ├── Security
        │       └── Deployment
        │
        └── Custom Actions
                │
                ├── Setup
                ├── Build
                └── Test
                       ▲
                       │
             ┌─────────┼─────────┐
             │         │         │
          Project A Project B Project C
```

---

# Interview Questions

### What is a reusable workflow?

A reusable workflow is a GitHub Actions workflow designed to be called by another workflow, allowing complete CI/CD processes to be shared.

### How do you make a workflow reusable?

Use:

```yaml
on:
  workflow_call:
```

### Why use reusable workflows?

They reduce duplicated YAML, improve consistency and make shared CI/CD processes easier to maintain.

### What is a custom GitHub Action?

A custom action packages reusable automation that can be called as a step inside a workflow job.

### What is a composite action?

A composite action combines multiple steps or commands into a single reusable GitHub Action.

### What file defines a custom action?

Typically:

```text
action.yml
```

or:

```text
action.yaml
```

### What is the difference between a reusable workflow and a custom action?

A reusable workflow can reuse entire jobs and workflow processes, while a custom action packages functionality that is called as a step within a job.

### Why should reusable workflows use inputs?

Inputs allow the same workflow to be configured differently by different projects without hardcoding values.

### Why should shared actions and workflows be versioned?

Versioning prevents unexpected changes from immediately affecting every project that consumes the shared automation.
