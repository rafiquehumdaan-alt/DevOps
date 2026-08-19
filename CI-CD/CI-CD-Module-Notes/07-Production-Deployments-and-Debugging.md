# CI/CD Notes - Part 7: Production Deployments & Debugging

> Covers:
>
> - CI/CD in the Real World
> - Automated Testing
> - Linting
> - Build Stages
> - Development, Staging & Production
> - Deployment Strategies
> - Security in CI/CD
> - Debugging Workflow Failures
> - Reading GitHub Actions Logs
> - Common Failure Scenarios
> - Rollbacks
> - Safe Production Practices

---

# CI/CD in the Real World

In real environments, CI/CD pipelines are used to move code through several controlled stages before it reaches users.

A typical flow may look like:

```text
Developer

↓

Feature Branch

↓

Pull Request

↓

CI Tests

↓

Merge to Main

↓

Build

↓

Staging

↓

Approval

↓

Production
```

The goal is to make releases:

- Repeatable
- Tested
- Secure
- Traceable
- Easy to troubleshoot

---

# Development Environments

A **development environment** is used for active development and testing.

Typical characteristics:

- Frequent changes
- Lower security restrictions
- Small infrastructure
- Test data
- Fast feedback

Example:

```text
Developer Push

↓

Dev Environment

↓

Test Application
```

---

# Staging Environment

A **staging environment** is designed to closely resemble production.

It is used to test the application before deployment to real users.

Typical uses:

- Integration testing
- User acceptance testing
- Deployment testing
- Performance checks
- Security checks

---

# Production Environment

**Production** is the live environment used by real users.

Changes to production should usually have stronger safeguards.

Examples:

- Required tests
- Pull request reviews
- Environment approvals
- Restricted branches
- Deployment monitoring

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

Each stage reduces the chance of broken code reaching users.

---

# Automated Testing

Automated tests are one of the most important parts of CI/CD.

Instead of relying on developers to manually test every change:

```text
Code Change

↓

Pipeline

↓

Automated Tests
```

If the tests fail, deployment can be stopped.

---

# Types of Tests

Common types include:

- Unit tests
- Integration tests
- End-to-end tests
- Smoke tests

---

# Unit Tests

Unit tests check small pieces of application logic.

Example:

```text
Function

↓

Expected Output?

↓

Pass / Fail
```

They are usually:

- Fast
- Small
- Run frequently

---

# Integration Tests

Integration tests check whether multiple parts of the application work together.

Example:

```text
Application

↓

Database

↓

API

↓

Do they work together?
```

---

# End-to-End Tests

End-to-end tests check the complete user flow.

Example:

```text
User Login

↓

Application

↓

Database

↓

Response
```

These tests are usually slower but provide broader confidence.

---

# Smoke Tests

Smoke tests are quick checks after deployment.

Example:

```bash
curl https://example.com/health
```

If the application responds correctly, the deployment is likely healthy.

---

# Linting

**Linting** automatically checks code for:

- Formatting issues
- Style problems
- Potential errors
- Suspicious patterns

Examples:

```text
Python → flake8 / ruff

JavaScript → ESLint

Shell → ShellCheck

Terraform → terraform fmt / validate
```

---

# Why Linting Matters

Linting provides fast feedback before more expensive tests run.

Example:

```text
Code Push

↓

Lint

↓

Tests

↓

Build
```

If linting fails early, the pipeline can stop quickly.

---

# Example Python CI

```yaml
- name: Install dependencies
  run: pip install -r requirements.txt

- name: Run linting
  run: ruff check .

- name: Run tests
  run: pytest
```

---

# Build Stage

The build stage creates the deployable version of the application.

Depending on the project, this could involve:

- Compiling code
- Creating binaries
- Building packages
- Building Docker images

Example:

```bash
docker build -t my-app .
```

---

# Build Once, Deploy Many

A useful CI/CD principle is:

```text
Build Once

↓

Test Artifact

↓

Deploy Same Artifact
```

For example:

```text
Docker Image v1.4

↓

Staging

↓

Production
```

You should avoid rebuilding different versions for each environment if possible.

---

# Artifact

An **artifact** is an output produced by the pipeline.

Examples:

- Docker image
- ZIP package
- Binary
- JAR file
- Build bundle

Example:

```text
Source Code

↓

Build

↓

Docker Image

↓

Artifact Registry
```

---

# Deployment to Different Environments

A pipeline may deploy the same application to different environments.

Example:

```text
develop branch

↓

Development
```

```text
main branch

↓

Staging

↓

Production
```

---

# Environment Variables

Different environments often require different configuration.

Example:

```text
Development

DB_HOST=dev-database
```

```text
Production

DB_HOST=prod-database
```

The application code remains the same.

Configuration changes between environments.

---

# Production Approvals

Production deployments may require manual approval.

Example:

```text
Tests Pass

↓

Staging Passes

↓

Production Approval

↓

Deploy
```

This is useful for:

- High-risk systems
- Regulated environments
- Critical infrastructure

---

# Deployment Strategies

There are several ways to deploy applications safely.

Common strategies include:

- Rolling deployment
- Blue/Green deployment
- Canary deployment

---

# Rolling Deployment

Instances are updated gradually.

Example:

```text
Old Old Old Old

↓

New Old Old Old

↓

New New Old Old

↓

New New New New
```

Benefits:

- Reduced downtime
- Gradual update

---

# Blue/Green Deployment

Two complete environments exist.

```text
BLUE

Version 1

and

GREEN

Version 2
```

Traffic initially goes to Blue.

After testing Green:

```text
Traffic

↓

GREEN
```

If problems occur, traffic can quickly be switched back to Blue.

---

# Canary Deployment

A small percentage of users receive the new version first.

Example:

```text
95% → Version 1

5% → Version 2
```

If successful:

```text
50% → Version 2

↓

100% → Version 2
```

This reduces deployment risk.

---

# Deployment Strategy Comparison

| Strategy | Main Idea |
|----------|-----------|
| Rolling | Replace instances gradually |
| Blue/Green | Switch between two environments |
| Canary | Release to small percentage first |

---

# Rollbacks

A **rollback** returns the application to a previous working version.

Example:

```text
Version 2 Deployed

↓

Errors Detected

↓

Rollback

↓

Version 1 Restored
```

A good CI/CD process should make rollback possible.

---

# Why Rollbacks Matter

Even good testing cannot catch every issue.

A fast rollback can reduce:

- Downtime
- Customer impact
- Business risk

---

# Versioned Artifacts

Versioning artifacts makes rollback easier.

Example:

```text
my-app:v1.0

my-app:v1.1

my-app:v1.2
```

If:

```text
v1.2
```

fails, you can redeploy:

```text
v1.1
```

---

# Security in Production CI/CD

Production pipelines should use:

- Least privilege
- Protected branches
- GitHub Environments
- Secure secrets
- OIDC
- Approval rules
- Trusted actions

Production deployment access should not be available to every job.

---

# Example Secure Production Flow

```text
Pull Request

↓

Code Review

↓

CI Tests

↓

Merge

↓

Build Artifact

↓

Staging

↓

Manual Approval

↓

Production
```

---

# Debugging Workflow Failures

CI/CD pipelines will fail sometimes.

Good debugging means identifying **which stage failed and why**.

Example:

```text
Checkout     ✓

Dependencies ✓

Tests        ✗

Build        Not Run
```

Start by investigating the failed step.

---

# GitHub Actions Logs

GitHub Actions logs show output from every step.

Navigate to:

```text
Repository

↓

Actions

↓

Workflow Run

↓

Job

↓

Failed Step
```

The logs often contain the exact error.

---

# Debugging Method

Use a structured approach:

```text
1. Identify failed job

2. Identify failed step

3. Read error message

4. Check workflow configuration

5. Reproduce locally if possible

6. Fix issue

7. Push change

8. Verify pipeline
```

---

# Common Workflow Failure: YAML Syntax

Example:

```text
Workflow does not start
```

Possible cause:

```text
Invalid YAML
```

Check:

- Indentation
- Missing `:`
- Incorrect nesting
- Incorrect GitHub Actions syntax

---

# Common Workflow Failure: Missing File

Example:

```text
requirements.txt: No such file
```

Possible causes:

- Wrong working directory
- Repository not checked out
- File path incorrect

Check:

```yaml
uses: actions/checkout@v4
```

---

# Common Workflow Failure: Tests Fail

Example:

```text
pytest

FAILED
```

The workflow itself may be correct.

The application code or test may be broken.

Fix the application rather than bypassing the test.

---

# Common Workflow Failure: Missing Secret

Example:

```text
Authentication failed
```

Possible causes:

- Secret not created
- Wrong secret name
- Environment secret unavailable
- Secret has expired

Check:

```yaml
${{ secrets.NAME }}
```

---

# Common Workflow Failure: Permission Error

Example:

```text
403 Forbidden
```

or:

```text
Permission denied
```

Possible causes:

- `GITHUB_TOKEN` lacks permission
- AWS IAM role lacks permission
- Registry credentials lack access

Investigate permissions instead of automatically granting administrator access.

---

# Common Workflow Failure: Docker Build

Example:

```text
docker build failed
```

Check:

- Dockerfile syntax
- Build context
- Missing files
- Dependency installation
- `.dockerignore`

You should also try:

```bash
docker build .
```

locally.

---

# Common Workflow Failure: Wrong Path

Suppose your app is inside:

```text
CI-CD/Assignment-1/
```

But the workflow runs:

```bash
docker build .
```

from the repository root.

Docker may not find the correct Dockerfile.

You could use:

```bash
docker build -t app ./CI-CD/Assignment-1
```

The working directory matters.

---

# Working Directory

GitHub Actions allows you to set:

```yaml
working-directory:
```

Example:

```yaml
- name: Build application
  working-directory: ./app
  run: docker build -t my-app .
```

---

# Reproducing Failures Locally

When possible, run the same command locally.

For example, workflow:

```yaml
run: pytest
```

Try:

```bash
pytest
```

locally.

If it fails locally too, the problem is probably not specific to GitHub Actions.

---

# Debug Output

Temporary debugging commands can help.

Example:

```yaml
- name: Debug files
  run: |
    pwd
    ls -la
```

This tells you:

- Current directory
- Available files

Useful when troubleshooting file paths.

---

# Check Environment Variables

You can inspect non-sensitive environment configuration.

Example:

```yaml
- run: env
```

Be careful not to expose secrets.

---

# Fail Fast

Pipelines should usually stop when important validation fails.

Example:

```text
Lint Fails

↓

Stop
```

rather than:

```text
Lint Fails

↓

Deploy Anyway
```

---

# Monitoring After Deployment

CI/CD does not end when deployment completes.

You should monitor:

- Application health
- Logs
- Error rates
- Response times
- CPU and memory
- User impact

---

# Post-Deployment Verification

Example:

```text
Deploy

↓

Health Check

↓

Smoke Test

↓

Monitoring

↓

Deployment Confirmed
```

---

# Example Real-World Pipeline

```text
Developer Push

↓

Lint

↓

Unit Tests

↓

Integration Tests

↓

Build Docker Image

↓

Security Scan

↓

Push Image to Registry

↓

Deploy to Staging

↓

Smoke Test

↓

Approval

↓

Deploy to Production

↓

Monitor
```

---

# Common Mistakes

## Deploying Untested Code

Always run appropriate tests before production deployment.

---

## Rebuilding for Production

Prefer deploying the same tested artifact that passed earlier stages.

---

## No Rollback Plan

Always know how to return to a known working version.

---

## Ignoring Logs

Pipeline logs usually provide the fastest way to find the problem.

---

## Giving Production Credentials Everywhere

Only deployment jobs should have production permissions.

---

## Fixing Pipelines by Removing Checks

If tests fail, do not simply delete the tests to make the pipeline green.

Fix the actual problem.

---

# Best Practices

- Test before building and deploying.
- Use linting for fast feedback.
- Build once and deploy the same artifact.
- Separate development, staging and production.
- Protect production deployments.
- Use versioned artifacts.
- Maintain a rollback strategy.
- Read workflow logs carefully.
- Reproduce failures locally where possible.
- Monitor applications after deployment.
- Use health checks and smoke tests.
- Follow least privilege for deployment credentials.

---

# Key Takeaways

- Real CI/CD pipelines normally use multiple environments.
- Automated testing prevents broken changes from progressing.
- Linting catches problems early.
- Build artifacts should be versioned.
- The same tested artifact should ideally move between environments.
- Production deployments should have stronger security controls.
- Rollbacks are essential for reducing deployment risk.
- GitHub Actions logs are the first place to investigate workflow failures.
- Debug workflows one failed step at a time.
- CI/CD continues after deployment through monitoring and verification.

---

# Quick Revision

| Concept | Purpose |
|---------|---------|
| Development | Active development environment |
| Staging | Production-like testing |
| Production | Live application |
| Linting | Static code checks |
| Unit Test | Tests small code units |
| Integration Test | Tests components together |
| Smoke Test | Quick health verification |
| Artifact | Build output |
| Rollback | Return to previous version |
| Blue/Green | Switch between environments |
| Canary | Gradual percentage rollout |
| Rolling | Replace instances gradually |

---

# Production Pipeline Mental Model

```text
CODE

↓

LINT

↓

TEST

↓

BUILD

↓

SECURITY

↓

STAGING

↓

VERIFY

↓

APPROVE

↓

PRODUCTION

↓

MONITOR
```

---

# Troubleshooting Mental Model

```text
WORKFLOW FAILED

↓

Which Job?

↓

Which Step?

↓

What Error?

↓

Can It Be Reproduced?

↓

Fix Root Cause

↓

Push

↓

Verify
```

---

# Interview Questions

### Why use separate development, staging and production environments?

They allow changes to be tested progressively before reaching real users, reducing deployment risk.

### What is linting?

Linting automatically analyses code for style issues, errors and suspicious patterns before more expensive testing or deployment stages.

### What does "build once, deploy many" mean?

It means creating one tested artifact and promoting that same artifact through environments instead of rebuilding different versions for each environment.

### What is a rollback?

A rollback returns an application to a previous known working version when a deployment causes problems.

### What is the difference between Blue/Green and Canary deployment?

Blue/Green uses two complete environments and switches traffic between them, while Canary gradually sends a percentage of users to the new version.

### How should you debug a failed GitHub Actions workflow?

Identify the failed job and step, read the logs, reproduce the failing command locally if possible, fix the root cause and rerun the workflow.

### Why should production deployment permissions be limited?

Because production access is highly sensitive, so only jobs that genuinely require those permissions should receive them.

### What should happen after an application is deployed?

The deployment should be verified using health checks, smoke tests and monitoring to ensure the application is functioning correctly.