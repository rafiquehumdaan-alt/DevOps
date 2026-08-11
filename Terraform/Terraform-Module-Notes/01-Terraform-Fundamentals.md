# Terraform Notes - Part 1: Terraform Fundamentals

> Covers:
>
> - What is Terraform?
> - Infrastructure as Code (IaC)
> - Declarative Configuration
> - Cloud-Agnostic Infrastructure
> - Terraform Files
> - Core Terraform Workflow
> - Desired vs Current State
> - Idempotency
> - Basic Project Structure

---

# What is Terraform?

**Terraform** is an Infrastructure as Code (IaC) tool created by HashiCorp.

It allows you to create and manage infrastructure using configuration files instead of manually creating resources through a cloud console.

For example, instead of manually creating an EC2 instance in AWS, you can define it in Terraform:

```hcl
resource "aws_instance" "web" {
  ami           = "ami-12345678"
  instance_type = "t3.micro"
}
```

Terraform reads this configuration and creates the infrastructure for you.

---

# What is Infrastructure as Code (IaC)?

**Infrastructure as Code (IaC)** means managing infrastructure through code rather than manually configuring resources.

Infrastructure can include:

- Virtual machines
- Networks
- Subnets
- Load balancers
- Databases
- Storage
- Security groups
- DNS

Instead of:

```text
AWS Console
    ↓
Click through menus
    ↓
Create infrastructure manually
```

You can use:

```text
Terraform Code
    ↓
Terraform
    ↓
AWS
    ↓
Infrastructure Created
```

---

# Why Use Infrastructure as Code?

IaC provides several benefits:

- Automation
- Repeatability
- Consistency
- Version control
- Faster deployments
- Easier disaster recovery
- Reduced human error

Your infrastructure can also be stored in Git alongside application code.

---

# Terraform is Cloud-Agnostic

Terraform is **cloud-agnostic**, meaning it can manage infrastructure across many different platforms.

Examples include:

- AWS
- Microsoft Azure
- Google Cloud
- Kubernetes
- Cloudflare
- GitHub

Terraform communicates with these platforms using **providers**.

Example:

```text
Terraform
   ↓
AWS Provider
   ↓
AWS
```

---

# Declarative Configuration

Terraform uses a **declarative** approach.

You describe **what you want**, and Terraform determines how to achieve it.

For example:

```hcl
resource "aws_instance" "web" {
  instance_type = "t3.micro"
}
```

You are telling Terraform:

> I want an EC2 instance with this configuration.

You do not need to write every individual API step required to create the instance.

---

# Declarative vs Imperative

### Declarative

```text
"I want 3 EC2 instances."
```

Terraform determines how to achieve that state.

### Imperative

```text
Create instance 1
Create instance 2
Create instance 3
```

You manually define each step.

Terraform primarily uses the **declarative approach**.

---

# Terraform Configuration Files

Terraform configuration files normally use:

```text
.tf
```

Examples:

```text
main.tf
variables.tf
outputs.tf
providers.tf
```

Terraform automatically reads `.tf` files in the current working directory as one configuration.

---

# HCL

Terraform configurations are commonly written using:

**HCL — HashiCorp Configuration Language**

Example:

```hcl
resource "aws_instance" "web" {
  ami           = "ami-12345678"
  instance_type = "t3.micro"
}
```

HCL is designed to be human-readable.

---

# Basic Terraform Project Structure

A simple project could look like:

```text
terraform-project/
│
├── main.tf
├── providers.tf
├── variables.tf
├── outputs.tf
└── terraform.tfvars
```

Typical purposes:

| File | Purpose |
|------|---------|
| `main.tf` | Main infrastructure resources |
| `providers.tf` | Provider configuration |
| `variables.tf` | Input variables |
| `outputs.tf` | Output values |
| `terraform.tfvars` | Variable values |

These filenames are conventions rather than strict requirements.

---

# The Terraform Workflow

The core Terraform workflow is:

```text
Write
  ↓
Init
  ↓
Validate
  ↓
Plan
  ↓
Apply
```

When infrastructure is no longer required:

```text
Destroy
```

---

# `terraform init`

Run:

```bash
terraform init
```

This initializes the Terraform working directory.

It can:

- Download providers
- Initialize modules
- Configure the backend
- Prepare the directory for Terraform commands

Usually this is the first command run after creating or cloning a Terraform project.

---

# `terraform validate`

Run:

```bash
terraform validate
```

Checks whether the Terraform configuration is syntactically valid and internally consistent.

Example:

```text
Success! The configuration is valid.
```

This does **not** create infrastructure.

---

# `terraform plan`

Run:

```bash
terraform plan
```

Terraform compares your configuration with the infrastructure/state it knows about and creates an execution plan.

It shows what Terraform intends to:

```text
+ create

~ update

- destroy
```

Always review the plan before applying changes.

---

# `terraform apply`

Run:

```bash
terraform apply
```

Terraform generates a plan and asks for confirmation before making the changes.

Example:

```text
Do you want to perform these actions?

Enter a value: yes
```

Terraform then creates, modifies or deletes resources as required.

---

# `terraform destroy`

Run:

```bash
terraform destroy
```

Terraform creates a plan to remove resources managed by the current configuration/state.

You should carefully review the destroy plan before confirming.

This is especially useful when cleaning up temporary lab infrastructure.

---

# Terraform Workflow Example

```text
main.tf
   ↓
terraform init
   ↓
terraform validate
   ↓
terraform plan
   ↓
terraform apply
   ↓
AWS Resources
```

---

# Desired State

Your Terraform configuration describes the **desired state**.

Example:

```hcl
resource "aws_instance" "web" {
  instance_type = "t3.micro"
}
```

Desired state:

```text
An EC2 instance should exist
with instance type t3.micro.
```

---

# Current State

The **current state** represents what Terraform understands about the infrastructure it manages.

Terraform stores state information so it can map configuration resources to real infrastructure.

Conceptually:

```text
Desired State
(.tf files)

        ↓

Terraform compares

        ↓

Current State
(state + provider refresh)

        ↓

Required Changes
```

---

# Example

Suppose the current infrastructure contains:

```text
1 EC2 instance
```

But your Terraform configuration now requires:

```text
2 EC2 instances
```

Terraform detects the difference and plans the necessary change.

---

# What is Idempotency?

**Idempotency** means repeatedly applying the same desired configuration should eventually produce the same infrastructure state.

For example:

First:

```bash
terraform apply
```

Terraform creates the EC2 instance.

Run it again without changing the configuration:

```bash
terraform apply
```

Terraform should report:

```text
No changes.
Your infrastructure matches the configuration.
```

Terraform does not unnecessarily recreate everything each time.

---

# Why Idempotency Matters

Idempotency provides:

- Predictable infrastructure
- Consistent deployments
- Reduced duplication
- Safer automation

This is particularly important in DevOps and CI/CD environments.

---

# Manual Infrastructure vs Terraform

### Manual

```text
Engineer
   ↓
AWS Console
   ↓
Create EC2
   ↓
Create Security Group
   ↓
Configure Network
```

Potential problems:

- Human error
- Difficult to reproduce
- Harder to track changes

---

### Terraform

```text
Terraform Code
      ↓
terraform plan
      ↓
terraform apply
      ↓
AWS Infrastructure
```

Benefits:

- Repeatable
- Version-controlled
- Automated
- Consistent

---

# Terraform Does Not Replace AWS Knowledge

Terraform automates infrastructure creation, but you still need to understand the underlying cloud services.

For example, to create this:

```hcl
resource "aws_security_group" "web" {
}
```

you should understand what an AWS Security Group does.

Terraform controls the infrastructure.

AWS provides the infrastructure.

---

# Common Mistakes

### Skipping `terraform plan`

Avoid immediately running:

```bash
terraform apply
```

without understanding the proposed changes.

Review the plan first.

---

### Editing Infrastructure Manually

If Terraform manages a resource, manually changing it in the AWS Console can create **configuration drift**.

Terraform may detect the difference during the next plan.

---

### Committing Sensitive Files

Do not commit sensitive Terraform files or secrets to Git.

Common examples to exclude include:

```text
.terraform/
*.tfstate
*.tfstate.*
*.tfvars
```

However, `.tfvars` files are only sensitive if they contain secrets; non-sensitive example variable files can safely be version controlled.

---

# Basic `.gitignore`

Example:

```gitignore
.terraform/
*.tfstate
*.tfstate.*
crash.log
*.tfvars
```

Do **not** normally ignore:

```text
.terraform.lock.hcl
```

The dependency lock file should generally be committed to Git.

---

# Best Practices

- Run `terraform fmt` to format Terraform files.
- Run `terraform validate` before deployment.
- Always review `terraform plan`.
- Store Terraform configuration in Git.
- Avoid hardcoding secrets.
- Avoid manually modifying Terraform-managed infrastructure.
- Understand the cloud resources Terraform is creating.
- Keep Terraform projects organised.

---

# Useful Command: `terraform fmt`

Run:

```bash
terraform fmt
```

Automatically formats Terraform configuration files.

A common workflow is therefore:

```bash
terraform fmt

terraform validate

terraform plan

terraform apply
```

---

# Key Takeaways

- Terraform is an Infrastructure as Code tool.
- Terraform uses declarative configuration.
- Terraform is cloud-agnostic and works through providers.
- Terraform configurations commonly use `.tf` files written in HCL.
- `terraform init` initializes a project.
- `terraform validate` checks configuration validity.
- `terraform plan` previews infrastructure changes.
- `terraform apply` executes changes.
- `terraform destroy` removes managed infrastructure.
- Terraform compares desired configuration with existing infrastructure/state.
- Idempotency means unchanged configurations should not cause unnecessary changes.

---

# Quick Revision

| Command | Purpose |
|---------|---------|
| `terraform init` | Initialize project |
| `terraform fmt` | Format Terraform files |
| `terraform validate` | Validate configuration |
| `terraform plan` | Preview changes |
| `terraform apply` | Apply changes |
| `terraform destroy` | Remove infrastructure |

---

# Core Workflow

```text
Write Code

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

---

# Interview Questions

### What is Terraform?

Terraform is an Infrastructure as Code tool created by HashiCorp that allows infrastructure to be defined and managed using declarative configuration files.

### What is Infrastructure as Code?

Infrastructure as Code is the practice of defining and managing infrastructure through code instead of manually configuring resources.

### What does `terraform init` do?

It initializes a Terraform working directory, downloads required providers and modules, and initializes the configured backend.

### What is the difference between `terraform plan` and `terraform apply`?

`terraform plan` previews the changes Terraform intends to make, while `terraform apply` executes those changes.

### What does declarative mean?

Declarative means you describe the desired end state rather than writing every individual step required to reach that state.

### What is idempotency?

Idempotency means repeatedly applying the same unchanged configuration results in the same infrastructure state without unnecessarily recreating resources.

### Why should Terraform configuration be stored in Git?

Git provides version control, change history, collaboration and the ability to review infrastructure changes as code.