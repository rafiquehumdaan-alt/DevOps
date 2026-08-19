````markdown id="cicd5sec"
# CI/CD Notes - Part 5: Secrets & Workflow Security

> Covers:
>
> - GitHub Actions Secrets
> - Encrypted Variables
> - Repository Secrets
> - Environment Secrets
> - Referencing Secrets
> - `${{ secrets.NAME }}`
> - GitHub Tokens
> - Least Privilege
> - OIDC
> - Secure Deployment Practices
> - Common Security Mistakes

---

# Why Security Matters in CI/CD

CI/CD pipelines often have access to sensitive systems.

Examples include:

- Cloud accounts
- Container registries
- Production servers
- Databases
- API tokens
- Deployment credentials

Because of this, pipeline security is critical.

A compromised CI/CD pipeline can potentially affect the entire software delivery process.

---

# Never Hardcode Secrets

Avoid placing credentials directly inside workflow files.

Bad example:

```yaml
env:
  AWS_ACCESS_KEY_ID: ABC123
  AWS_SECRET_ACCESS_KEY: SECRET123
```

This is dangerous because workflow files are stored in Git.

If committed, the secret may remain in Git history even after being removed later.

---

# What are GitHub Secrets?

GitHub Secrets allow sensitive values to be stored securely and referenced by workflows.

Examples:

```text
DOCKER_USERNAME

DOCKER_PASSWORD

AWS_ACCESS_KEY_ID

API_TOKEN
```

The values are stored separately from the workflow file.

---

# Repository Secrets

Repository secrets are available to workflows inside a specific repository.

Example:

```text
Repository

↓

Settings

↓

Secrets and variables

↓

Actions

↓

Repository secrets
```

A workflow can then reference the secret.

---

# Referencing Secrets

GitHub Actions secrets are referenced using:

```yaml
${{ secrets.SECRET_NAME }}
```

Example:

```yaml
username: ${{ secrets.DOCKER_USERNAME }}
```

and:

```yaml
password: ${{ secrets.DOCKER_PASSWORD }}
```

---

# Example Docker Login

```yaml
- name: Login to Docker Hub
  uses: docker/login-action@v3
  with:
    username: ${{ secrets.DOCKER_USERNAME }}
    password: ${{ secrets.DOCKER_TOKEN }}
```

The actual username and token are not written directly into the workflow.

---

# Why Use Secrets?

Secrets provide several benefits:

- Keep credentials out of Git
- Centralise sensitive configuration
- Reduce accidental exposure
- Make workflows easier to reuse
- Allow credentials to be rotated independently

---

# Environment Secrets

GitHub environments can have their own secrets.

Example environments:

```text
development

staging

production
```

Each environment can have different credentials.

Example:

```text
Development

↓

Development AWS Credentials

Production

↓

Production AWS Credentials
```

This prevents one set of credentials from being used everywhere.

---

# GitHub Environments

A GitHub environment can also provide:

- Environment-specific secrets
- Protection rules
- Deployment approvals
- Restricted branches

Example:

```yaml
jobs:
  deploy:
    environment: production
```

The job now uses the `production` environment.

---

# Why Separate Environments?

Separating environments improves security.

Example:

```text
Development credentials

↓

Cannot modify production
```

and:

```text
Production credentials

↓

Used only for production deployment
```

This follows the principle of least privilege.

---

# Principle of Least Privilege

**Least privilege** means giving a user, service or workflow only the permissions it actually needs.

Bad:

```text
CI/CD Pipeline

↓

Administrator Access to Entire AWS Account
```

Better:

```text
CI/CD Pipeline

↓

Permission to:

Push to ECR

Deploy ECS service

Read required resources
```

Nothing more.

---

# GitHub Token

GitHub automatically provides workflows with a token called:

```text
GITHUB_TOKEN
```

This allows workflows to interact with GitHub.

Examples:

- Read repository contents
- Create releases
- Comment on pull requests
- Push packages

Reference:

```yaml
${{ secrets.GITHUB_TOKEN }}
```

---

# GitHub Token Permissions

Permissions should be restricted where possible.

Example:

```yaml
permissions:
  contents: read
```

This gives the workflow read-only access to repository contents.

---

# More Permission Examples

```yaml
permissions:
  contents: read
  packages: write
```

Useful when a workflow needs to:

- Read repository code
- Push container images to GitHub Packages

---

# Why Explicit Permissions Matter

Avoid giving workflows more access than necessary.

Example:

```text
Workflow only needs repository read access

↓

Give read access only
```

This reduces the impact if the workflow is compromised.

---

# Secret Masking

GitHub attempts to mask secrets in workflow logs.

Instead of displaying:

```text
super-secret-password
```

you may see:

```text
***
```

However, you should still avoid printing secrets deliberately.

---

# Do Not Echo Secrets

Avoid:

```yaml
- run: echo "${{ secrets.API_TOKEN }}"
```

Even though GitHub may mask the value, deliberately outputting secrets is poor practice.

---

# Secrets as Environment Variables

Secrets can be passed to commands through environment variables.

Example:

```yaml
- name: Run deployment
  env:
    API_TOKEN: ${{ secrets.API_TOKEN }}
  run: ./deploy.sh
```

The script can access:

```bash
$API_TOKEN
```

---

# GitHub Actions and AWS Credentials

One traditional approach is storing:

```text
AWS_ACCESS_KEY_ID

AWS_SECRET_ACCESS_KEY
```

as GitHub Secrets.

Then the workflow uses them to authenticate to AWS.

However, long-lived AWS credentials should generally be avoided when better options are available.

---

# OIDC

**OpenID Connect (OIDC)** allows GitHub Actions to authenticate to cloud providers without storing long-lived cloud access keys.

Example:

```text
GitHub Actions

↓

OIDC Identity Token

↓

AWS IAM Role

↓

Temporary Credentials
```

This is generally more secure than storing permanent AWS access keys in GitHub.

---

# Why OIDC is Better

With stored AWS keys:

```text
GitHub Secret

↓

Permanent AWS Credential
```

If compromised, the credential may remain usable until manually revoked.

With OIDC:

```text
Workflow

↓

Temporary Identity

↓

Short-Lived Credentials
```

Advantages:

- No permanent AWS keys
- Short-lived credentials
- Easier rotation
- Better security

---

# OIDC with AWS

A common production setup:

```text
GitHub Repository

↓

GitHub Actions

↓

OIDC

↓

AWS IAM Role

↓

Temporary Credentials

↓

AWS Deployment
```

The IAM role can be restricted to:

- Specific repository
- Specific branch
- Specific environment

---

# Example AWS Authentication

A workflow may use an AWS action such as:

```yaml
- name: Configure AWS credentials
  uses: aws-actions/configure-aws-credentials@v4
  with:
    role-to-assume: arn:aws:iam::123456789012:role/github-actions-role
    aws-region: eu-west-2
```

The exact IAM trust policy must also allow the appropriate GitHub OIDC identity.

---

# Protecting Production Deployments

Production deployments should usually have stronger controls than development.

Examples:

- Manual approval
- Restricted branches
- Protected environments
- Required tests
- Limited credentials

---

# Example Secure Flow

```text
Feature Branch

↓

CI Tests

↓

Pull Request

↓

Review

↓

Merge to Main

↓

Build

↓

Production Approval

↓

Deploy
```

---

# Branch Protection

Branch protection rules can help prevent unsafe changes.

Examples:

- Require pull requests
- Require reviews
- Require successful status checks
- Prevent direct pushes to `main`

This protects both application code and workflow files.

---

# Workflow File Security

GitHub Actions workflows themselves are sensitive.

A malicious workflow change could attempt to:

- Read secrets
- Upload data elsewhere
- Deploy malicious code

Because of this, workflow changes should be reviewed carefully.

---

# Third-Party Actions

A workflow can run third-party actions.

Example:

```yaml
uses: some-user/some-action@v1
```

This means you are trusting code from another repository.

Use third-party actions carefully.

---

# Safer Action Usage

Prefer:

- Official actions
- Well-maintained projects
- Trusted publishers
- Pinned versions

For higher security, actions can be pinned to a specific commit SHA.

Example:

```yaml
uses: actions/checkout@<commit-sha>
```

This prevents a tag from unexpectedly changing underneath you.

---

# Supply Chain Security

CI/CD is part of the software supply chain.

Potential risks include:

- Compromised dependencies
- Malicious third-party actions
- Stolen credentials
- Tampered build artifacts
- Untrusted pull requests

Security should be considered throughout the pipeline.

---

# Pull Requests from Forks

Workflows triggered from external forks should be handled carefully.

You should not expose sensitive deployment credentials to untrusted code.

GitHub applies protections around secrets in forked pull requests, but workflow design still matters.

---

# Separate CI and Deployment Permissions

A testing workflow may only need:

```text
Repository Read Access
```

A deployment workflow may need:

```text
Cloud Deployment Access
```

Avoid giving cloud deployment permissions to every CI job.

---

# Secrets Rotation

Secrets should be rotated when necessary.

Examples:

- Credential may have leaked
- Employee leaves team
- Periodic security policy
- Token expires

Because secrets are stored separately from the workflow, rotation does not require changing pipeline code.

---

# Example Secure Docker Workflow

```yaml
name: Docker Build

on:
  push:
    branches:
      - main

permissions:
  contents: read

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout repository
        uses: actions/checkout@v4

      - name: Login to Docker Hub
        uses: docker/login-action@v3
        with:
          username: ${{ secrets.DOCKER_USERNAME }}
          password: ${{ secrets.DOCKER_TOKEN }}

      - name: Build image
        run: docker build -t my-app .

      - name: Push image
        run: docker push my-app
```

Credentials remain outside the workflow file.

---

# Example Environment Deployment

```yaml
jobs:
  deploy:
    environment: production
    runs-on: ubuntu-latest

    steps:
      - name: Deploy
        run: echo "Deploying production"
```

The `production` environment can have:

- Production secrets
- Approval requirements
- Branch restrictions

---

# Common Security Mistakes

## Hardcoding Credentials

Never write:

```yaml
password: mypassword123
```

inside a workflow.

---

## Giving Administrator Access

Avoid giving a pipeline:

```text
AdministratorAccess
```

when it only needs permission to deploy one application.

---

## Printing Secrets

Do not deliberately output secrets to logs.

---

## Using Permanent Cloud Keys Everywhere

Prefer short-lived authentication such as OIDC when supported.

---

## Trusting Every Third-Party Action

Review actions before using them.

---

## Deploying Unreviewed Code

Use pull requests and branch protections for important environments.

---

## Giving Every Job Deployment Access

Testing jobs should not automatically receive production credentials.

---

# Best Practices

- Never commit secrets to Git.
- Store sensitive values in GitHub Secrets.
- Use environment-specific secrets.
- Follow least privilege.
- Restrict `GITHUB_TOKEN` permissions.
- Prefer OIDC for cloud authentication.
- Use short-lived credentials.
- Protect production environments.
- Require reviews for critical workflow changes.
- Use trusted actions.
- Avoid exposing secrets in logs.
- Rotate compromised or outdated credentials.
- Separate CI permissions from deployment permissions.

---

# Key Takeaways

- CI/CD pipelines often require sensitive credentials.
- Secrets must never be hardcoded in workflow files.
- GitHub Secrets securely store sensitive values.
- Secrets are referenced using `${{ secrets.NAME }}`.
- GitHub Environments allow environment-specific credentials and protections.
- Least privilege reduces security risk.
- `GITHUB_TOKEN` permissions should be restricted.
- OIDC allows GitHub Actions to use temporary cloud credentials without storing long-lived keys.
- Workflow files themselves should be treated as security-sensitive code.
- Third-party actions introduce supply-chain risk.

---

# Quick Revision

| Concept | Purpose |
|---------|---------|
| GitHub Secret | Secure sensitive value |
| Repository Secret | Secret for one repository |
| Environment Secret | Secret for one environment |
| `${{ secrets.NAME }}` | Reference secret |
| `GITHUB_TOKEN` | Built-in GitHub workflow token |
| `permissions` | Restrict workflow token access |
| OIDC | Temporary identity-based authentication |
| Least Privilege | Minimum required permissions |
| Environment | Deployment controls and secrets |

---

# Secure Authentication Model

```text
Less Preferred

GitHub

↓

Stored Long-Lived Key

↓

AWS
```

```text
Preferred

GitHub Actions

↓

OIDC

↓

IAM Role

↓

Temporary Credentials

↓

AWS
```

---

# Interview Questions

### Why should secrets never be hardcoded in GitHub Actions workflows?

Because workflow files are stored in version control, meaning exposed credentials could leak through the repository or Git history.

### How do you reference a GitHub Actions secret?

Using:

```yaml
${{ secrets.SECRET_NAME }}
```

### What is the principle of least privilege?

It means giving users, services and workflows only the permissions required to perform their specific task.

### What is `GITHUB_TOKEN`?

`GITHUB_TOKEN` is a temporary token automatically provided to GitHub Actions workflows for interacting with the repository and GitHub APIs.

### Why should `GITHUB_TOKEN` permissions be restricted?

Restricting permissions reduces the potential impact if a workflow or dependency is compromised.

### What are GitHub Environments?

Environments provide deployment-specific configuration such as secrets, protection rules and approval requirements.

### What is OIDC in GitHub Actions?

OIDC allows GitHub Actions to authenticate to services such as AWS using identity-based, short-lived credentials instead of storing permanent access keys.

### Why is OIDC preferable to long-lived AWS access keys?

OIDC avoids storing permanent credentials and uses temporary credentials with limited scope and lifetime.

### Why should third-party GitHub Actions be reviewed carefully?

Because they execute code within your workflow and may have access to repository contents, tokens or other sensitive resources.
