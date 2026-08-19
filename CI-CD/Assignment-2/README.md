# CI/CD Assignment 2 — Terraform Automated Testing

## Overview

This assignment demonstrates how to create a CI pipeline that automatically checks Terraform code whenever changes are pushed to GitHub.

The Terraform configuration used in this lab is intentionally simple. It does not create any cloud infrastructure because the main focus of the assignment is automated testing and code quality.

The pipeline uses GitHub Actions to automatically run Terraform checks and TFLint.

## Project Structure

```text
CI-CD/
└── Assignment-2/
    ├── main.tf
    └── README.md
```

The GitHub Actions workflow is stored separately in:

```text
.github/workflows/assignment-2-terraform.yml
```

GitHub requires workflow files to be stored inside `.github/workflows`.

## Terraform Configuration

The `main.tf` file contains a simple Terraform configuration:

```hcl
terraform {
  required_version = ">= 1.0.0"
}

variable "environment" {
  type    = string
  default = "dev"
}

output "environment_name" {
  value = var.environment
}
```

This configuration does not create any infrastructure.

It defines a Terraform version requirement, creates a variable called `environment`, and outputs its value.

The default environment value is:

```text
dev
```

This keeps the Terraform code simple while still giving the CI pipeline valid Terraform code to test.

## What the CI Pipeline Does

When changes are pushed to the Assignment-2 folder, GitHub Actions automatically starts the Terraform CI workflow.

The pipeline performs the following steps:

1. Checks out the GitHub repository.
2. Installs Terraform on the GitHub Actions runner.
3. Installs TFLint.
4. Checks Terraform formatting.
5. Initialises Terraform.
6. Validates the Terraform configuration.
7. Runs TFLint.

If any check fails, the pipeline stops and the GitHub Actions workflow is marked as failed.

If all checks pass, the workflow receives a green successful status.

## Checkout Repository

The workflow uses:

```yaml
uses: actions/checkout@v4
```

A GitHub Actions runner starts as a fresh temporary virtual machine.

It does not automatically contain the repository files.

The checkout action downloads the repository onto the runner so the pipeline can access the Terraform files.

## Setup Terraform

The workflow uses:

```yaml
uses: hashicorp/setup-terraform@v3
```

This installs Terraform on the GitHub Actions runner.

Terraform is already installed on my local machine, but GitHub Actions runners are temporary environments, so Terraform needs to be installed each time the workflow runs.

## Terraform Formatting Check

The pipeline runs:

```bash
terraform fmt -check
```

`terraform fmt` normally fixes Terraform formatting automatically.

Using:

```bash
terraform fmt -check
```

does not change the code.

Instead, it checks whether the Terraform files are already correctly formatted.

If the formatting is incorrect, the command returns a failed exit code and the CI pipeline fails.

This allows formatting standards to be enforced automatically.

## Terraform Init

The pipeline runs:

```bash
terraform init
```

This initialises the Terraform working directory.

Terraform normally uses this step to prepare providers, modules, and other required components before Terraform commands are run.

In this project there are no cloud providers because the Terraform configuration does not create infrastructure.

## Terraform Validate

The pipeline runs:

```bash
terraform validate
```

This checks whether the Terraform configuration is valid.

It can detect issues such as invalid Terraform configuration, incorrect arguments, missing brackets, and other configuration problems.

If validation fails, GitHub Actions marks the pipeline as failed.

## TFLint

The workflow also installs TFLint using:

```yaml
uses: terraform-linters/setup-tflint@v4
```

The pipeline then runs:

```bash
tflint
```

TFLint is a linting tool for Terraform.

While `terraform validate` checks whether the Terraform configuration is valid, TFLint performs additional code-quality and linting checks.

This helps identify problems and improve Terraform code quality before it is used.

## Testing the Pipeline

The pipeline was first tested with correctly formatted Terraform code.

The workflow passed successfully.

The Terraform formatting was then deliberately broken.

For example:

```hcl
variable "environment" {
type = string
default = "dev"
}
```

This caused:

```bash
terraform fmt -check
```

to fail.

GitHub Actions correctly marked the Terraform CI workflow as failed.

The formatting was then repaired using:

```bash
terraform fmt
```

After committing and pushing the corrected Terraform code, the GitHub Actions pipeline ran again and passed successfully.

This demonstrated that the pipeline can detect incorrect code rather than simply returning a successful result every time.

## Why Automated Testing Is Useful

Without CI, developers have to remember to manually run checks such as:

```bash
terraform fmt -check
terraform validate
tflint
```

before pushing their Terraform code.

It is easy for someone to forget one of these checks.

With CI, the checks happen automatically whenever code is pushed.

The process becomes:

```text
Developer changes Terraform
        ↓
Pushes code to GitHub
        ↓
GitHub Actions starts automatically
        ↓
Formatting check
        ↓
Terraform validation
        ↓
TFLint
        ↓
PASS or FAIL
```

This helps prevent badly formatted, invalid, or lower-quality Terraform code from progressing further through a development pipeline.

In a real DevOps environment, similar checks could be required before code is merged into the main branch or before infrastructure is deployed.

## Outcome

This assignment demonstrated how GitHub Actions can be used as a Continuous Integration pipeline for Terraform.

The completed pipeline automatically performs:

* Terraform formatting checks
* Terraform initialisation
* Terraform validation
* Terraform linting with TFLint

The pipeline was also deliberately tested with badly formatted Terraform code to confirm that incorrect code causes the workflow to fail.

After correcting the code, the pipeline successfully passed again.
