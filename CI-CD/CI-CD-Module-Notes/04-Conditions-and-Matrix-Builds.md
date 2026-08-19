````markdown id="cicd4mx"
# CI/CD Notes - Part 4: Conditions, Expressions & Matrix Builds

> Covers:
>
> - Advanced GitHub Actions
> - Conditions
> - Expressions
> - `${{ }}`
> - `if`
> - Branch-Based Conditions
> - Job Conditions
> - Step Conditions
> - Matrix Builds
> - Parallel Testing
> - Multiple Versions
> - `fail-fast`
> - Common Matrix Patterns

---

# What are GitHub Actions Expressions?

GitHub Actions expressions allow workflow behaviour to change dynamically.

Expressions use:

```text
${{ }}
```

Example:

```yaml
if: ${{ github.ref == 'refs/heads/main' }}
```

This means:

```text
If branch is main

↓

Run the step/job
```

---

# Why Use Conditions?

Conditions allow you to control when parts of a pipeline should run.

For example:

```text
Push to feature branch

↓

Run Tests

↓

Do NOT Deploy
```

But:

```text
Push to main

↓

Run Tests

↓

Build

↓

Deploy
```

This prevents unnecessary or unsafe pipeline actions.

---

# The `if` Keyword

Use:

```yaml
if:
```

to apply a condition.

Example:

```yaml
- name: Deploy
  if: ${{ github.ref == 'refs/heads/main' }}
  run: echo "Deploying"
```

The deploy step only runs on the `main` branch.

---

# Step-Level Conditions

Conditions can be added to individual steps.

Example:

```yaml
steps:
  - name: Run tests
    run: pytest

  - name: Deploy
    if: ${{ github.ref == 'refs/heads/main' }}
    run: ./deploy.sh
```

Flow:

```text
Tests

↓

Branch = main?

├── Yes → Deploy
└── No  → Skip
```

---

# Job-Level Conditions

Conditions can also be applied to an entire job.

Example:

```yaml
jobs:
  deploy:
    if: ${{ github.ref == 'refs/heads/main' }}

    runs-on: ubuntu-latest

    steps:
      - name: Deploy application
        run: echo "Deploying"
```

If the condition is false, the entire job is skipped.

---

# Common Expression Contexts

GitHub Actions provides context objects containing useful information.

Common examples:

```text
github
env
secrets
matrix
needs
steps
runner
```

---

# `github` Context

Contains information about the current workflow event and repository.

Example:

```yaml
${{ github.ref }}
```

Could return:

```text
refs/heads/main
```

Other useful values include:

```yaml
${{ github.repository }}
```

```yaml
${{ github.actor }}
```

```yaml
${{ github.event_name }}
```

---

# Branch Condition Example

```yaml
if: ${{ github.ref == 'refs/heads/main' }}
```

Meaning:

```text
Current branch

==

main
```

If true, the action runs.

---

# Event Condition Example

Run only for a push:

```yaml
if: ${{ github.event_name == 'push' }}
```

Run only for a pull request:

```yaml
if: ${{ github.event_name == 'pull_request' }}
```

---

# Logical Operators

Expressions support common logical operators.

| Operator | Meaning |
|----------|---------|
| `==` | Equal |
| `!=` | Not equal |
| `&&` | AND |
| `||` | OR |
| `!` | NOT |

---

# AND Example

```yaml
if: ${{ github.ref == 'refs/heads/main' && github.event_name == 'push' }}
```

This runs only when:

```text
Branch = main

AND

Event = push
```

---

# OR Example

```yaml
if: ${{ github.ref == 'refs/heads/main' || github.ref == 'refs/heads/develop' }}
```

Runs when either branch matches.

---

# Success and Failure Conditions

GitHub Actions provides built-in functions.

Examples include:

```text
success()
failure()
always()
cancelled()
```

---

# `success()`

Runs when previous required steps succeeded.

Example:

```yaml
if: ${{ success() }}
```

---

# `failure()`

Runs when a previous step failed.

Example:

```yaml
- name: Report failure
  if: ${{ failure() }}
  run: echo "Something failed"
```

Useful for:

- Error reporting
- Notifications
- Debugging

---

# `always()`

Runs regardless of whether previous steps succeeded or failed.

Example:

```yaml
- name: Upload logs
  if: ${{ always() }}
  run: echo "Uploading logs"
```

Useful for diagnostic tasks.

---

# Using Environment Variables in Conditions

Example:

```yaml
env:
  ENVIRONMENT: production
```

Then:

```yaml
if: ${{ env.ENVIRONMENT == 'production' }}
```

---

# Why Use Matrix Builds?

A **matrix build** allows the same job to run multiple times using different values.

Example:

```text
Test Python 3.10

Test Python 3.11

Test Python 3.12
```

Instead of creating three separate jobs manually, use a matrix.

---

# Basic Matrix Example

```yaml
jobs:
  test:
    runs-on: ubuntu-latest

    strategy:
      matrix:
        python-version:
          - "3.10"
          - "3.11"
          - "3.12"

    steps:
      - name: Checkout repository
        uses: actions/checkout@v4

      - name: Set up Python
        uses: actions/setup-python@v5
        with:
          python-version: ${{ matrix.python-version }}

      - name: Run tests
        run: pytest
```

---

# What Happens?

GitHub Actions creates multiple job variations.

```text
Test Job

├── Python 3.10
├── Python 3.11
└── Python 3.12
```

These can run in parallel.

---

# Why Parallel Testing Matters

Without a matrix:

```text
Test 3.10

↓

Test 3.11

↓

Test 3.12
```

This may take longer.

With a matrix:

```text
         ┌── 3.10
Start ───┼── 3.11
         └── 3.12
```

The tests can run simultaneously.

---

# Multiple Matrix Dimensions

You can test several combinations.

Example:

```yaml
strategy:
  matrix:
    os:
      - ubuntu-latest
      - windows-latest

    python-version:
      - "3.11"
      - "3.12"
```

This creates:

```text
Ubuntu + Python 3.11

Ubuntu + Python 3.12

Windows + Python 3.11

Windows + Python 3.12
```

---

# Using Matrix Values

The syntax is:

```yaml
${{ matrix.variable }}
```

Example:

```yaml
runs-on: ${{ matrix.os }}
```

and:

```yaml
python-version: ${{ matrix.python-version }}
```

---

# Example Multi-Platform Matrix

```yaml
jobs:
  test:
    strategy:
      matrix:
        os:
          - ubuntu-latest
          - windows-latest

        python-version:
          - "3.11"
          - "3.12"

    runs-on: ${{ matrix.os }}

    steps:
      - uses: actions/checkout@v4

      - uses: actions/setup-python@v5
        with:
          python-version: ${{ matrix.python-version }}

      - run: pytest
```

---

# Matrix Build Flow

```text
Workflow Triggered

↓

Matrix Created

↓

┌──────────────────────┐
│ Ubuntu + Python 3.11 │
├──────────────────────┤
│ Ubuntu + Python 3.12 │
├──────────────────────┤
│ Windows + Python 3.11│
├──────────────────────┤
│ Windows + Python 3.12│
└──────────────────────┘

↓

Run in Parallel
```

---

# `fail-fast`

By default, a matrix strategy commonly cancels other in-progress matrix jobs when one variation fails.

This behaviour can be controlled with:

```yaml
strategy:
  fail-fast: false
```

Example:

```yaml
strategy:
  fail-fast: false

  matrix:
    python-version:
      - "3.10"
      - "3.11"
      - "3.12"
```

Now the other matrix jobs can continue even if one fails.

---

# Why Use `fail-fast: false`?

This is useful when you want to see the full compatibility picture.

Example:

```text
Python 3.10 → Fail

Python 3.11 → Pass

Python 3.12 → Pass
```

If you cancel everything after the first failure, you may miss useful information.

---

# Matrix `include`

You can add specific combinations using:

```yaml
include:
```

Example:

```yaml
strategy:
  matrix:
    python-version:
      - "3.11"
      - "3.12"

    include:
      - python-version: "3.13"
        experimental: true
```

This allows special cases to be added.

---

# Matrix `exclude`

You can remove unwanted combinations.

Example:

```yaml
strategy:
  matrix:
    os:
      - ubuntu-latest
      - windows-latest

    python-version:
      - "3.11"
      - "3.12"

    exclude:
      - os: windows-latest
        python-version: "3.11"
```

That specific combination will not run.

---

# Conditions with Matrix Builds

Conditions and matrices can be used together.

Example:

```yaml
- name: Special test
  if: ${{ matrix.python-version == '3.12' }}
  run: echo "Running Python 3.12 specific test"
```

---

# Job Dependencies with Matrix

Suppose:

```text
Matrix Tests

↓

All Successful

↓

Build
```

Example:

```yaml
jobs:
  test:
    strategy:
      matrix:
        python-version:
          - "3.11"
          - "3.12"

    runs-on: ubuntu-latest

    steps:
      - run: echo "Testing"

  build:
    needs: test
    runs-on: ubuntu-latest

    steps:
      - run: echo "Building"
```

The `build` job waits for the matrix test job to complete successfully.

---

# Real CI Example

Suppose a Python application supports:

```text
Python 3.11

Python 3.12
```

A good CI workflow could:

```text
Push Code

↓

Run Tests on 3.11 and 3.12 in Parallel

↓

Both Pass

↓

Build Docker Image
```

This verifies compatibility before producing the deployable image.

---

# Branch-Based Deployment Example

A common real-world structure is:

```text
Feature Branch

↓

Test Only
```

while:

```text
main

↓

Test

↓

Build

↓

Deploy
```

Example:

```yaml
- name: Deploy
  if: ${{ github.ref == 'refs/heads/main' }}
  run: ./deploy.sh
```

---

# Full Example

```yaml
name: Matrix CI

on:
  push:
    branches:
      - main
      - develop

jobs:
  test:
    strategy:
      fail-fast: false

      matrix:
        python-version:
          - "3.11"
          - "3.12"

    runs-on: ubuntu-latest

    steps:
      - name: Checkout repository
        uses: actions/checkout@v4

      - name: Set up Python
        uses: actions/setup-python@v5
        with:
          python-version: ${{ matrix.python-version }}

      - name: Install dependencies
        run: pip install -r requirements.txt

      - name: Run tests
        run: pytest

  deploy:
    needs: test

    if: ${{ github.ref == 'refs/heads/main' }}

    runs-on: ubuntu-latest

    steps:
      - name: Deploy
        run: echo "Deploying production application"
```

---

# Understanding the Example

For a push to:

```text
develop
```

the workflow does:

```text
Test Python 3.11

+

Test Python 3.12

↓

No Deployment
```

For a push to:

```text
main
```

the workflow does:

```text
Test Python 3.11

+

Test Python 3.12

↓

Tests Pass

↓

Deploy
```

---

# When Should You Use Conditions?

Use conditions when pipeline behaviour depends on things such as:

- Branch
- Event type
- Environment
- Previous job result
- Matrix value
- Manual input

---

# When Should You Use Matrix Builds?

Matrix builds are useful when testing across:

- Programming language versions
- Operating systems
- Dependency versions
- Runtime versions
- Application configurations

---

# Common Mistakes

## Duplicating Jobs Instead of Using a Matrix

Instead of:

```text
python310 job

python311 job

python312 job
```

use one matrix job when the logic is otherwise the same.

---

## Deploying Every Branch

Avoid production deployment from every branch.

Use conditions so production deployment only happens from trusted branches or environments.

---

## Making Conditions Too Complicated

Complex expressions can become hard to maintain.

Keep workflow logic understandable.

---

## Forgetting Job Independence

Separate jobs normally run independently unless you define dependencies with:

```yaml
needs:
```

---

# Best Practices

- Use conditions to protect deployment stages.
- Use matrices for repeated compatibility testing.
- Run independent tests in parallel.
- Use `needs` when jobs require previous jobs to succeed.
- Use `fail-fast: false` when you need results from all matrix combinations.
- Keep expressions readable.
- Avoid unnecessary duplicated jobs.
- Test several supported runtime versions where appropriate.

---

# Key Takeaways

- GitHub Actions expressions use `${{ }}`.
- `if` controls whether jobs or steps run.
- Conditions can inspect branches, events and other workflow data.
- Matrix strategies run the same job with multiple configurations.
- Matrix jobs can execute in parallel.
- Matrix builds reduce duplicated YAML.
- `fail-fast` controls how failures affect other matrix jobs.
- Conditions and matrices are useful for building flexible CI/CD pipelines.

---

# Quick Revision

| Syntax | Purpose |
|--------|---------|
| `${{ }}` | GitHub Actions expression |
| `if` | Conditional execution |
| `github.ref` | Current Git ref |
| `github.event_name` | Triggering event |
| `success()` | Check success |
| `failure()` | Check failure |
| `always()` | Run regardless |
| `strategy` | Job strategy |
| `matrix` | Multiple job configurations |
| `matrix.name` | Access matrix value |
| `fail-fast` | Matrix failure behaviour |
| `include` | Add matrix combination |
| `exclude` | Remove matrix combination |

---

# Interview Questions

### What are GitHub Actions expressions?

Expressions are dynamic values and conditions written using `${{ }}` that allow workflows to make decisions based on repository, event, matrix and other context data.

### What does `if` do in GitHub Actions?

`if` controls whether a job or step should execute based on a condition.

### What is a matrix build?

A matrix build runs the same job multiple times using different combinations of values, such as different Python versions or operating systems.

### Why are matrix builds useful?

They reduce duplicated workflow code and allow compatibility testing to run in parallel.

### What does `matrix.python-version` mean?

It references the current value of the `python-version` variable from the matrix strategy.

### What does `fail-fast: false` do?

It allows the remaining matrix jobs to continue running even if one matrix combination fails.

### How would you make a deployment run only on `main`?

Use a condition such as:

```yaml
if: ${{ github.ref == 'refs/heads/main' }}
```

### What is the benefit of running tests in parallel?

Parallel testing reduces pipeline execution time and provides faster feedback to developers.
