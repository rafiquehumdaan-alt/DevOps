# Terraform Notes - Part 2: Terraform State & Backends

> Covers:
>
> - What is Terraform State?
> - `terraform.tfstate`
> - Why Terraform Needs State
> - Desired vs Current State
> - Local State
> - Remote State
> - Terraform Backends
> - S3 Backend
> - State Locking
> - State Security
> - State Backups
> - Team Collaboration

---

# What is Terraform State?

Terraform uses a **state file** to keep track of the infrastructure it manages.

By default, this file is called:

```text
terraform.tfstate
```

The state file maps resources in your Terraform configuration to real resources in your infrastructure.

Example:

```text
Terraform Code

aws_instance.web

        ↓

Terraform State

        ↓

AWS

EC2: i-0123456789
```

Terraform therefore knows that:

```hcl
aws_instance.web
```

corresponds to a specific EC2 instance in AWS.

---

# Why Does Terraform Need State?

Terraform needs state to understand what infrastructure already exists.

Without state, Terraform would struggle to determine:

- Which resources it created
- Which resources already exist
- Which resources need updating
- Which resources need deleting
- Relationships between resources

State allows Terraform to manage infrastructure over time.

---

# Desired State vs Current State

Your `.tf` files describe your **desired state**.

For example:

```hcl
resource "aws_instance" "web" {
  ami           = "ami-12345678"
  instance_type = "t3.micro"
}
```

This tells Terraform:

```text
I want an EC2 instance
with instance type t3.micro.
```

Terraform then compares this configuration with the real infrastructure, using its state and provider refresh information.

```text
Desired State
(.tf files)

        ↓

Terraform

        ↕

State + AWS

        ↓

Execution Plan
```

---

# Example

Current infrastructure:

```text
EC2 Instance

Instance Type:
t3.micro
```

You change your Terraform configuration to:

```hcl
instance_type = "t3.small"
```

Then run:

```bash
terraform plan
```

Terraform detects the difference and proposes the required change.

---

# Terraform State File

The default state file is:

```text
terraform.tfstate
```

It contains structured data describing Terraform-managed resources.

Terraform manages this file automatically.

You generally should **not manually edit it**.

---

# Important: State Can Contain Sensitive Data

Terraform state can contain sensitive information depending on the resources being managed.

This could include:

- Resource IDs
- IP addresses
- Database information
- Configuration values
- Secrets or credentials exposed by resource attributes

Therefore, state files must be protected.

---

# Local State

By default, Terraform stores state locally:

```text
terraform-project/
│
├── main.tf
├── variables.tf
├── outputs.tf
└── terraform.tfstate
```

This is called **local state**.

---

# Advantages of Local State

Local state is:

- Simple
- Easy to understand
- Automatically created
- Useful for learning
- Suitable for small personal projects

---

# Problems with Local State

Local state becomes problematic when multiple engineers work on the same infrastructure.

Example:

```text
Engineer A

terraform.tfstate

Engineer B

different terraform.tfstate
```

They may have different views of the infrastructure.

This can cause:

- Conflicting changes
- Incorrect plans
- State corruption
- Accidental resource changes

---

# Remote State

**Remote state** stores the Terraform state in a central location instead of on an engineer's computer.

Examples include:

- Amazon S3
- HCP Terraform
- Other supported remote backends

Example:

```text
Engineer A ──┐
             │
Engineer B ──┼──► Remote State
             │
CI/CD ───────┘
```

Everyone works from the same state.

---

# Benefits of Remote State

Remote state provides:

- Centralised storage
- Team collaboration
- Better security options
- State locking support
- Backups/versioning
- CI/CD integration

Remote state is generally preferred for production and team environments.

---

# What is a Terraform Backend?

A **backend** determines where Terraform stores its state and, depending on the backend, how operations such as locking are handled.

By default, Terraform uses the:

```text
local
```

backend.

You can configure a remote backend instead.

---

# S3 Backend

AWS S3 is commonly used to store Terraform state remotely.

Example:

```hcl
terraform {
  backend "s3" {
    bucket = "my-terraform-state"
    key    = "production/terraform.tfstate"
    region = "eu-west-2"
  }
}
```

---

# Understanding the S3 Backend

### `bucket`

```hcl
bucket = "my-terraform-state"
```

The S3 bucket where the state is stored.

---

### `key`

```hcl
key = "production/terraform.tfstate"
```

The path/name of the state file inside the bucket.

---

### `region`

```hcl
region = "eu-west-2"
```

The AWS region containing the S3 bucket.

---

# Backend Architecture

```text
Terraform

↓

S3 Backend

↓

S3 Bucket

↓

terraform.tfstate
```

Instead of storing the state only on your computer, Terraform retrieves and updates it remotely.

---

# Initialising a Backend

After configuring or changing a backend, run:

```bash
terraform init
```

Terraform initializes the backend.

If migrating existing state, Terraform may ask whether you want to move the state to the new backend.

---

# What is State Locking?

**State locking** prevents multiple Terraform operations from modifying the same state simultaneously.

Example without locking:

```text
Engineer A
terraform apply
       ↓

       STATE

       ↑
Engineer B
terraform apply
```

Both operations could interfere with each other.

---

# With State Locking

```text
Engineer A

↓

LOCK STATE

↓

terraform apply

↓

UNLOCK STATE
```

While the state is locked, another conflicting Terraform operation must wait or fail rather than modifying it simultaneously.

---

# Why State Locking Matters

State locking helps prevent:

- Simultaneous modifications
- Conflicting infrastructure changes
- State corruption
- Race conditions

It is especially important for teams and CI/CD pipelines.

---

# S3 State Locking

Modern Terraform supports state locking for the S3 backend using an **S3 lock file**.

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

Older Terraform setups commonly used a **DynamoDB table** for S3 state locking.

DynamoDB-based locking is now deprecated, so new configurations should generally use S3 lock files instead.

---

# Protecting Remote State

When storing Terraform state in S3, good practices include:

- Block public access
- Enable encryption
- Enable bucket versioning
- Restrict IAM permissions
- Enable state locking
- Avoid exposing the state publicly

---

# S3 Versioning

S3 versioning keeps previous versions of the state file.

Example:

```text
terraform.tfstate

Version 1
Version 2
Version 3
```

If the current state becomes damaged or overwritten, a previous version may be recoverable.

---

# Encryption

Terraform state should be encrypted when stored remotely.

S3 supports server-side encryption.

This protects state data while stored in the bucket.

---

# IAM Permissions

Only authorised users and systems should have access to Terraform state.

Example:

```text
DevOps Engineers
       ↓
IAM Permissions
       ↓
Terraform State Bucket
```

Follow the **principle of least privilege**.

---

# Never Commit State to Git

Avoid committing:

```text
terraform.tfstate
```

or:

```text
terraform.tfstate.backup
```

to GitHub.

State may contain sensitive information and can create collaboration problems.

---

# `.gitignore`

A Terraform project should normally contain entries such as:

```gitignore
.terraform/
*.tfstate
*.tfstate.*
crash.log
```

You may also exclude sensitive `.tfvars` files:

```gitignore
*.tfvars
```

---

# Do Commit the Lock File

The following file should normally be committed:

```text
.terraform.lock.hcl
```

This file records provider dependency selections.

It helps ensure consistent provider versions across environments.

It is different from **state locking**.

---

# `.terraform.lock.hcl` vs State Locking

These are often confused.

### `.terraform.lock.hcl`

Controls:

```text
Provider dependency versions
```

### State Locking

Controls:

```text
Who can modify Terraform state at a given time
```

They solve completely different problems.

---

# Useful State Commands

List resources stored in state:

```bash
terraform state list
```

Example:

```text
aws_instance.web
aws_security_group.web
```

---

# Inspect a Resource

```bash
terraform state show aws_instance.web
```

Displays information Terraform currently stores about that resource.

---

# Show Entire State

```bash
terraform show
```

Displays the current state in a human-readable format.

---

# Configuration Drift

**Configuration drift** occurs when infrastructure changes outside Terraform.

Example:

Terraform configuration:

```text
EC2 = t3.micro
```

Someone manually changes AWS:

```text
EC2 = t3.small
```

Now Terraform's desired configuration and the real infrastructure differ.

Running:

```bash
terraform plan
```

can detect the difference and propose changes.

---

# Local vs Remote State

| Local State | Remote State |
|-------------|--------------|
| Stored locally | Stored centrally |
| Simple setup | Additional configuration |
| Good for learning | Better for teams |
| Poor collaboration | Shared state |
| Limited protection | Better security options |
| No shared locking | Supports locking |

---

# Typical Team Setup

```text
Developer

Developer

CI/CD Pipeline

     ↓

Terraform

     ↓

Remote Backend

     ↓

S3 State Bucket

     ↓

AWS Infrastructure
```

This allows the team to work from the same infrastructure state.

---

# Common Mistakes

### Committing State to GitHub

Avoid:

```bash
git add terraform.tfstate
```

State should not normally be stored in source control.

---

### Manually Editing State

Avoid manually opening and changing:

```text
terraform.tfstate
```

Use Terraform commands to manipulate state where necessary.

---

### No State Locking

Shared infrastructure without locking can result in conflicting Terraform operations.

Use a backend that supports locking.

---

### No S3 Versioning

Without versioning, recovering accidentally damaged or overwritten remote state can be more difficult.

Enable versioning on production state buckets.

---

# Best Practices

- Use local state for learning and simple personal projects.
- Use remote state for shared or production infrastructure.
- Enable state locking.
- Enable S3 versioning.
- Encrypt remote state.
- Block public access to state buckets.
- Restrict state access using IAM.
- Never commit state files to Git.
- Avoid manually modifying Terraform state.
- Always review `terraform plan` before applying changes.

---

# Key Takeaways

- Terraform state tracks infrastructure managed by Terraform.
- The default local state file is `terraform.tfstate`.
- Terraform compares configuration, state and real infrastructure to determine changes.
- Local state is suitable for learning but poor for collaboration.
- Remote state stores state centrally.
- S3 is commonly used as a Terraform remote backend on AWS.
- State locking prevents simultaneous modifications.
- Modern S3 backends can use S3 lock files for locking.
- State may contain sensitive information and must be protected.
- S3 versioning provides additional recovery protection.

---

# Quick Revision

| Concept | Purpose |
|---------|---------|
| State | Tracks managed infrastructure |
| `terraform.tfstate` | Default local state file |
| Local Backend | Stores state locally |
| Remote Backend | Stores state centrally |
| S3 Backend | AWS remote state storage |
| State Locking | Prevents simultaneous modifications |
| S3 Versioning | Keeps previous state versions |
| Encryption | Protects state data |
| `.terraform.lock.hcl` | Locks provider dependency selections |

---

# Useful Commands

| Command | Purpose |
|---------|---------|
| `terraform state list` | List state resources |
| `terraform state show` | Inspect a resource |
| `terraform show` | Display state/plan information |
| `terraform plan` | Compare and preview changes |
| `terraform init` | Initialize/configure backend |

---

# Interview Questions

### What is Terraform state?

Terraform state is data Terraform maintains to map resources in your configuration to real infrastructure and track information required to manage those resources.

### What is the difference between local and remote state?

Local state is stored on the engineer's machine, while remote state is stored centrally so teams and automation systems can share it securely.

### Why should Terraform state not be committed to Git?

State can contain sensitive infrastructure information and storing it in Git can create security and collaboration problems.

### What is state locking?

State locking prevents multiple Terraform operations from modifying the same state simultaneously, reducing the risk of conflicts and corruption.

### Why use S3 for Terraform state?

S3 provides durable centralised storage, encryption, access controls and versioning, making it suitable for shared Terraform state.

### What is the difference between `.terraform.lock.hcl` and state locking?

`.terraform.lock.hcl` records provider dependency selections, while state locking prevents concurrent operations from modifying Terraform state.