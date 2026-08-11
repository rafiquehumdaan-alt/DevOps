# Terraform Notes - Part 7: Terraform Cheat Sheet

> A quick-reference guide for Terraform commands, syntax, state, providers, variables, imports, modules, Git practices and common interview questions.

---

# Core Terraform Workflow

```text
Write Configuration

↓

terraform init

↓

terraform fmt

↓

terraform validate

↓

terraform plan

↓

terraform apply
```

When the infrastructure is no longer required:

```bash
terraform destroy
```

---

# Essential Terraform Commands

| Command | Purpose |
|---------|---------|
| `terraform init` | Initialise working directory |
| `terraform fmt` | Format Terraform files |
| `terraform validate` | Validate configuration |
| `terraform plan` | Preview changes |
| `terraform apply` | Apply infrastructure changes |
| `terraform destroy` | Destroy managed infrastructure |
| `terraform output` | Display outputs |
| `terraform show` | Display state or plan |
| `terraform providers` | Show required providers |

---

# Recommended Workflow

```bash
terraform init

terraform fmt

terraform validate

terraform plan

terraform apply
```

Always review the plan before applying changes.

---

# Common Terraform Files

A typical project:

```text
terraform-project/
│
├── main.tf
├── providers.tf
├── variables.tf
├── outputs.tf
├── terraform.tfvars
├── .terraform.lock.hcl
└── .gitignore
```

| File | Purpose |
|------|---------|
| `main.tf` | Main infrastructure |
| `providers.tf` | Provider configuration |
| `variables.tf` | Input variable definitions |
| `outputs.tf` | Output values |
| `terraform.tfvars` | Variable values |
| `.terraform.lock.hcl` | Provider dependency selections |

The filenames are conventions. Terraform reads all `.tf` files in the current module together.

---

# Provider Syntax

Example AWS provider requirement:

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}
```

Provider configuration:

```hcl
provider "aws" {
  region = "eu-west-2"
}
```

---

# Provider Flow

```text
Terraform

↓

AWS Provider

↓

AWS API

↓

AWS Infrastructure
```

---

# Terraform Registry

Use the Terraform Registry/provider documentation when creating resources.

It tells you:

- Available resources
- Arguments
- Attributes
- Import formats
- Examples
- Data sources

Do not guess resource syntax.

---

# Resource Syntax

General structure:

```hcl
resource "RESOURCE_TYPE" "LOCAL_NAME" {
  argument = value
}
```

Example:

```hcl
resource "aws_instance" "web" {
  ami           = "ami-12345678"
  instance_type = "t3.micro"
}
```

---

# Resource Address

```text
aws_instance.web
│            │
│            └── Local Name
│
└── Resource Type
```

Reference an attribute:

```hcl
aws_instance.web.public_ip
```

---

# Resource References

Example VPC:

```hcl
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}
```

Subnet referencing the VPC:

```hcl
resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
}
```

Terraform automatically understands the dependency:

```text
VPC

↓

Subnet
```

---

# Explicit Dependencies

Use:

```hcl
depends_on
```

only when Terraform cannot infer a real dependency automatically.

Example:

```hcl
depends_on = [
  aws_internet_gateway.main
]
```

Prefer implicit dependencies created through resource references where possible.

---

# Input Variables

Define:

```hcl
variable "instance_type" {
  type        = string
  default     = "t3.micro"
  description = "EC2 instance type"
}
```

Reference:

```hcl
var.instance_type
```

---

# Common Variable Types

| Type | Example |
|------|---------|
| `string` | `"t3.micro"` |
| `number` | `3` |
| `bool` | `true` |
| `list(string)` | `["a", "b"]` |
| `map(string)` | `{ dev = "t3.micro" }` |
| `object` | Structured data |

---

# `.tfvars`

Example:

```hcl
instance_type = "t3.small"
environment   = "dev"
```

Terraform automatically loads:

```text
terraform.tfvars
```

and:

```text
*.auto.tfvars
```

Custom variable file:

```bash
terraform plan -var-file="dev.tfvars"
```

---

# Command-Line Variables

```bash
terraform plan -var="instance_type=t3.small"
```

Useful for temporary overrides.

---

# Terraform Environment Variables

Terraform input variables can use:

```text
TF_VAR_variable_name
```

Example:

```bash
export TF_VAR_instance_type="t3.small"
```

---

# Local Values

Define:

```hcl
locals {
  project_name = "terraform-demo"
  environment  = "dev"
}
```

Reference:

```hcl
local.project_name
```

---

# Inputs vs Locals

| Input Variable | Local |
|----------------|-------|
| Comes from outside | Defined internally |
| `var.name` | `local.name` |
| Can vary by environment | Used for reuse/calculation |

---

# Outputs

Define:

```hcl
output "public_ip" {
  value       = aws_instance.web.public_ip
  description = "EC2 public IP"
}
```

Display outputs:

```bash
terraform output
```

Specific output:

```bash
terraform output public_ip
```

---

# Terraform State

Terraform state maps your Terraform configuration to real infrastructure.

Default local file:

```text
terraform.tfstate
```

Conceptually:

```text
Terraform Code

↓

Terraform State

↓

Real Infrastructure
```

---

# Useful State Commands

List resources:

```bash
terraform state list
```

Inspect resource:

```bash
terraform state show aws_instance.web
```

Show current state:

```bash
terraform show
```

---

# Local vs Remote State

| Local | Remote |
|-------|--------|
| Stored on your machine | Stored centrally |
| Good for learning | Better for teams |
| Simple | Better collaboration |
| No shared locking | Can support locking |
| Higher risk of local loss | Centralised backup/security |

---

# S3 Backend

Example:

```hcl
terraform {
  backend "s3" {
    bucket       = "my-terraform-state"
    key          = "production/terraform.tfstate"
    region       = "eu-west-2"
    use_lockfile = true
  }
}
```

After adding or changing a backend:

```bash
terraform init
```

---

# Remote State Best Practices

- Block public access.
- Enable encryption.
- Enable versioning.
- Restrict IAM access.
- Enable state locking.
- Never expose state publicly.

---

# State Locking

State locking prevents multiple Terraform operations from modifying the same state simultaneously.

```text
Engineer A

↓

LOCK

↓

terraform apply

↓

UNLOCK
```

This helps prevent conflicts and corruption.

---

# `.terraform.lock.hcl`

Do not confuse:

```text
.terraform.lock.hcl
```

with state locking.

`.terraform.lock.hcl`:

```text
Provider dependency selections
```

State locking:

```text
Prevents concurrent state modification
```

---

# Terraform Import

Traditional syntax:

```bash
terraform import RESOURCE_ADDRESS RESOURCE_ID
```

Example:

```bash
terraform import aws_instance.web i-0123456789abcdef0
```

---

# Import Workflow

```text
Existing Resource

↓

Create Terraform Resource Block

↓

terraform import

↓

terraform state list

↓

terraform plan

↓

Align Configuration
```

Always run:

```bash
terraform plan
```

after importing.

---

# Import Block

Modern Terraform supports:

```hcl
import {
  to = aws_instance.web
  id = "i-0123456789abcdef0"
}
```

Terraform can also assist with generating configuration:

```bash
terraform plan -generate-config-out=generated.tf
```

Review generated configuration before using it.

---

# Terraform Modules

A module is a reusable collection of Terraform configuration.

Example structure:

```text
terraform-project/
│
├── main.tf
│
└── modules/
    └── ec2/
        ├── main.tf
        ├── variables.tf
        └── outputs.tf
```

---

# Calling a Module

```hcl
module "web_server" {
  source = "./modules/ec2"

  instance_type = "t3.micro"
}
```

---

# Module Inputs

Child module:

```hcl
variable "instance_type" {
  type = string
}
```

Root module:

```hcl
module "web_server" {
  source = "./modules/ec2"

  instance_type = "t3.micro"
}
```

---

# Module Outputs

Child module:

```hcl
output "public_ip" {
  value = aws_instance.web.public_ip
}
```

Root module reference:

```hcl
module.web_server.public_ip
```

---

# Root vs Child Modules

| Module | Meaning |
|--------|---------|
| Root Module | Main Terraform configuration |
| Child Module | Module called by another module |

Every Terraform configuration directory is technically a module.

---

# DRY Principle

Terraform modules follow:

```text
DRY

Don't Repeat Yourself
```

Instead of duplicating infrastructure:

```text
Dev
Prod
Staging
```

all can reuse the same module with different variables.

---

# AWS Authentication

Avoid hardcoding:

```hcl
access_key = "..."
secret_key = "..."
```

Use secure authentication methods instead.

Examples:

- AWS CLI profiles
- Environment variables
- IAM Roles
- IAM Identity Center
- AssumeRole
- CI/CD workload credentials

---

# AWS Environment Variables

Example:

```bash
export AWS_ACCESS_KEY_ID="..."

export AWS_SECRET_ACCESS_KEY="..."

export AWS_DEFAULT_REGION="eu-west-2"
```

Do not commit credentials to Git.

---

# `.gitignore`

Example:

```gitignore
.terraform/

*.tfstate
*.tfstate.*

crash.log

*.tfvars
```

Only ignore `.tfvars` files if they contain sensitive or environment-specific values you do not want committed.

---

# What Should Be Committed?

Usually commit:

```text
main.tf
providers.tf
variables.tf
outputs.tf
modules/
.terraform.lock.hcl
.gitignore
```

Usually do **not** commit:

```text
.terraform/
terraform.tfstate
terraform.tfstate.backup
secret tfvars files
credentials
```

---

# Common Terraform Symbols

Plan output commonly includes:

| Symbol | Meaning |
|--------|---------|
| `+` | Create |
| `~` | Update |
| `-` | Destroy |
| `-/+` | Destroy then recreate |

Always review these before applying.

---

# Configuration Drift

Configuration drift occurs when infrastructure is manually changed outside Terraform.

Example:

```text
Terraform:

t3.micro

↓

AWS Console Change

↓

t3.large
```

Then:

```bash
terraform plan
```

Terraform detects that the real infrastructure does not match the desired configuration.

---

# Idempotency

If configuration has not changed:

```bash
terraform apply
```

should eventually result in:

```text
No changes.
```

Terraform avoids unnecessarily recreating infrastructure.

---

# Terraform Commands Cheat Sheet

| Command | Purpose |
|---------|---------|
| `terraform init` | Initialise project |
| `terraform fmt` | Format files |
| `terraform validate` | Validate configuration |
| `terraform plan` | Preview changes |
| `terraform apply` | Apply changes |
| `terraform destroy` | Destroy resources |
| `terraform output` | Display outputs |
| `terraform show` | Show state/plan |
| `terraform state list` | List state resources |
| `terraform state show` | Inspect state resource |
| `terraform import` | Import existing resource |

---

# Common Errors

## Provider Not Installed

Run:

```bash
terraform init
```

---

## Configuration Syntax Error

Run:

```bash
terraform validate
```

Then inspect the reported file and line.

---

## Unexpected Infrastructure Changes

Run:

```bash
terraform plan
```

and carefully inspect:

```text
+
~
-
```

before applying.

---

## Wrong AWS Credentials

Check:

```bash
aws sts get-caller-identity
```

This helps confirm which AWS identity your environment is using.

---

## Resource Already Exists

If the resource exists outside Terraform, you may need to import it rather than create another one.

---

## State Lock Error

Another Terraform operation may be using the state.

Do not force-unlock state unless you are certain no valid Terraform operation is still running.

---

# Terraform Best Practices

- Store Terraform code in Git.
- Review every plan.
- Use remote state for teams.
- Protect state files.
- Enable state locking.
- Avoid hardcoding credentials.
- Use variables for reusable configuration.
- Use locals to reduce repetition.
- Use modules for reusable infrastructure.
- Pin provider/module versions appropriately.
- Commit `.terraform.lock.hcl`.
- Use meaningful resource names.
- Tag cloud resources.
- Run `terraform fmt` and `terraform validate`.
- Avoid manually changing Terraform-managed infrastructure.

---

# Terraform + AWS Example

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "eu-west-2"
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

resource "aws_instance" "web" {
  ami           = var.instance_ami
  instance_type = var.instance_type

  tags = {
    Name      = "Terraform-Web"
    ManagedBy = "Terraform"
  }
}

output "instance_id" {
  value = aws_instance.web.id
}
```

---

# Terraform Mental Model

```text
.tf Configuration
       │
       ▼
Desired Infrastructure
       │
       ▼
Terraform Plan
       │
       ├── Compare Configuration
       ├── State
       └── Real Infrastructure
       │
       ▼
Terraform Apply
       │
       ▼
Cloud Provider
       │
       ▼
Infrastructure
```

---

# Quick Revision

| Concept | Meaning |
|---------|---------|
| Terraform | Infrastructure as Code tool |
| HCL | Terraform configuration language |
| Provider | Connects Terraform to an API |
| Resource | Infrastructure Terraform manages |
| State | Tracks managed infrastructure |
| Backend | Determines state storage |
| Variable | External input |
| Local | Internal reusable value |
| Output | Exposed value |
| Module | Reusable Terraform configuration |
| Import | Bring existing infrastructure into Terraform |
| Idempotency | Same configuration produces same state |
| Drift | Infrastructure differs from configuration |

---

# Interview Questions

### What is Terraform?

Terraform is a declarative Infrastructure as Code tool used to provision and manage infrastructure through configuration files.

### What is the Terraform workflow?

The common workflow is:

```text
init → fmt → validate → plan → apply
```

### What is Terraform state?

Terraform state maps resources in Terraform configuration to real infrastructure and stores information Terraform needs to manage them.

### Why use remote state?

Remote state allows teams and automation systems to share state centrally while supporting improved security, backup and locking.

### What is a Terraform provider?

A provider is a plugin that allows Terraform to communicate with an external platform such as AWS.

### What is a Terraform resource?

A resource represents an infrastructure object Terraform creates or manages.

### What is the difference between `var.name` and `local.name`?

`var.name` references an input variable, while `local.name` references an internally defined local value.

### What is a Terraform module?

A module is a reusable collection of Terraform configuration files used to standardise and reduce duplicated infrastructure code.

### What does `terraform import` do?

It associates existing infrastructure with a Terraform resource address so Terraform can begin managing it.

### What is configuration drift?

Configuration drift occurs when real infrastructure is changed outside Terraform and no longer matches the desired Terraform configuration.

### What does `terraform plan` do?

It previews the changes Terraform intends to make before those changes are applied.

### Why should you avoid storing Terraform state in Git?

State can contain sensitive data and Git does not provide the locking and state-management capabilities required for safe collaboration.