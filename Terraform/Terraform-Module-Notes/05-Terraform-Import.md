# Terraform Notes - Part 5: Terraform Import

> Covers:
>
> - What is Terraform Import?
> - Why Terraform Import is Needed
> - Terraform-Managed vs Existing Resources
> - `terraform import`
> - Resource Addresses
> - Import Workflow
> - Importing AWS Resources
> - Import Blocks
> - Checking Imported Resources
> - State After Importing
> - Common Import Problems
> - Import Best Practices

---

# What is Terraform Import?

**Terraform Import** allows you to bring existing infrastructure under Terraform management.

This is useful when a resource was created manually or by another system but you now want Terraform to manage it.

Example:

```text
Existing EC2 Instance

Created manually in AWS

        ↓

terraform import

        ↓

Terraform State

        ↓

Managed by Terraform
```

---

# Why Do We Need Terraform Import?

Terraform normally knows about resources that it created itself.

For example:

```hcl
resource "aws_instance" "web" {
  ami           = "ami-12345678"
  instance_type = "t3.micro"
}
```

After:

```bash
terraform apply
```

Terraform creates the EC2 instance and records it in state.

But what if the EC2 instance already exists?

Terraform does not automatically know that your resource block represents that existing instance.

This is where **Terraform Import** is useful.

---

# Example Scenario

Suppose someone manually created an EC2 instance through the AWS Console:

```text
EC2 Instance

i-0123456789abcdef0
```

You now want Terraform to manage it.

Instead of destroying and recreating the instance, you can import it.

---

# Terraform Import Command

Traditional import syntax:

```bash
terraform import RESOURCE_ADDRESS RESOURCE_ID
```

Example:

```bash
terraform import aws_instance.web i-0123456789abcdef0
```

This tells Terraform:

```text
aws_instance.web

        ↓

represents

        ↓

i-0123456789abcdef0
```

---

# Resource Address

The first argument is the Terraform **resource address**.

Example:

```text
aws_instance.web
```

Breakdown:

```text
aws_instance.web
│            │
│            └── Terraform Local Name
│
└── Resource Type
```

This must match the resource defined in your Terraform configuration.

---

# Resource ID

The second argument identifies the existing infrastructure resource.

For EC2:

```text
i-0123456789abcdef0
```

For other AWS resources, the required import ID may be different.

Always check the AWS provider documentation to determine the correct import format.

---

# Basic Import Workflow

A simple import workflow is:

```text
Existing AWS Resource

        ↓

Create Matching Terraform Resource Block

        ↓

terraform import

        ↓

Resource Added to Terraform State

        ↓

terraform plan

        ↓

Update Configuration Until It Matches
```

---

# Step 1 – Identify the Existing Resource

Suppose AWS contains:

```text
EC2 Instance

Instance ID:
i-0123456789abcdef0

Instance Type:
t3.micro
```

We want Terraform to manage it.

---

# Step 2 – Create the Terraform Resource Block

Create a resource address for the existing resource.

Example:

```hcl
resource "aws_instance" "web" {
  ami           = "ami-12345678"
  instance_type = "t3.micro"
}
```

The configuration should eventually describe the real infrastructure accurately.

---

# Step 3 – Initialise Terraform

Run:

```bash
terraform init
```

This ensures the required providers are available.

---

# Step 4 – Import the Resource

Run:

```bash
terraform import aws_instance.web i-0123456789abcdef0
```

Terraform connects:

```text
Terraform Resource

aws_instance.web

        ↓

Existing AWS Resource

i-0123456789abcdef0
```

---

# Step 5 – Check Terraform State

Run:

```bash
terraform state list
```

You should see:

```text
aws_instance.web
```

Terraform now tracks the resource in its state.

---

# Step 6 – Inspect the Imported Resource

Run:

```bash
terraform state show aws_instance.web
```

This displays the information Terraform knows about the resource.

Example:

```text
id            = "i-0123456789abcdef0"

instance_type = "t3.micro"

private_ip    = "10.0.1.20"
```

---

# Step 7 – Run `terraform plan`

This is one of the most important steps.

Run:

```bash
terraform plan
```

Terraform compares:

```text
Your Configuration

        ↓

Imported State / Real Infrastructure

        ↓

Differences
```

If your `.tf` configuration does not match the existing resource, Terraform may propose changes.

---

# Import Does Not Automatically Mean Configuration Matches

This is important.

Running:

```bash
terraform import
```

primarily associates an existing resource with a Terraform resource address in state.

It does not guarantee that your manually written configuration matches the existing infrastructure.

---

# Example

Real EC2 instance:

```text
Instance Type:

t3.small
```

Your Terraform configuration:

```hcl
instance_type = "t3.micro"
```

After import:

```bash
terraform plan
```

Terraform may propose changing:

```text
t3.small

↓

t3.micro
```

because Terraform wants the real infrastructure to match your configuration.

---

# Terraform State After Import

Before import:

```text
Terraform State

No aws_instance.web
```

After:

```bash
terraform import aws_instance.web i-0123456789abcdef0
```

State contains:

```text
aws_instance.web

↓

i-0123456789abcdef0
```

Terraform can now manage that EC2 instance.

---

# Importing Other AWS Resources

Terraform can import many types of existing AWS resources.

Examples include:

- EC2 Instances
- VPCs
- Subnets
- Security Groups
- S3 Buckets
- Route Tables
- IAM Resources
- Load Balancers

The import identifier differs depending on the resource.

---

# Example: Import VPC

Terraform resource:

```hcl
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}
```

Import:

```bash
terraform import aws_vpc.main vpc-0123456789
```

---

# Example: Import Subnet

Terraform resource:

```hcl
resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
}
```

Import:

```bash
terraform import aws_subnet.public subnet-0123456789
```

---

# Example: Import Security Group

Resource:

```hcl
resource "aws_security_group" "web" {
  name = "web-sg"
}
```

Import:

```bash
terraform import aws_security_group.web sg-0123456789
```

---

# Example: Import S3 Bucket

Resource:

```hcl
resource "aws_s3_bucket" "storage" {
  bucket = "my-example-bucket"
}
```

Import:

```bash
terraform import aws_s3_bucket.storage my-example-bucket
```

Notice that different resource types use different import identifiers.

Always check the provider documentation.

---

# Modern Terraform Import Blocks

Modern Terraform also supports **import blocks** inside configuration files.

Example:

```hcl
import {
  to = aws_instance.web
  id = "i-0123456789abcdef0"
}
```

Then run:

```bash
terraform plan
```

and:

```bash
terraform apply
```

This provides a configuration-driven way of performing imports.

---

# Import Block Example

```hcl
resource "aws_instance" "web" {
  ami           = "ami-12345678"
  instance_type = "t3.micro"
}

import {
  to = aws_instance.web
  id = "i-0123456789abcdef0"
}
```

Terraform understands:

```text
Existing EC2

        ↓

Import

        ↓

aws_instance.web
```

---

# Generating Configuration

With import blocks, Terraform can also help generate configuration for some imported resources.

Example:

```bash
terraform plan -generate-config-out=generated.tf
```

Terraform can generate configuration based on the resource being imported.

The generated configuration should still be reviewed and cleaned up before being used.

---

# Traditional Import vs Import Block

### Traditional

```bash
terraform import aws_instance.web i-0123456789abcdef0
```

Useful for:

- Quick imports
- Simple manual workflows

---

### Import Block

```hcl
import {
  to = aws_instance.web
  id = "i-0123456789abcdef0"
}
```

Useful because the import operation can be represented in configuration and reviewed as part of normal Terraform workflows.

---

# Import Does Not Create Infrastructure

Importing does **not** create the AWS resource.

The resource already exists.

Terraform simply begins managing it.

```text
Existing Resource

        ↓

IMPORT

        ↓

Terraform Management
```

---

# Import Does Not Duplicate the Resource

Suppose AWS already contains:

```text
EC2 Instance A
```

Terraform import does not create:

```text
EC2 Instance B
```

Instead, it tells Terraform:

```text
aws_instance.web

=

Existing EC2 Instance A
```

---

# Why `terraform plan` is Important After Import

Always run:

```bash
terraform plan
```

after importing.

This shows whether Terraform wants to:

```text
+ Create

~ Modify

- Destroy
```

anything.

You should understand these changes before running:

```bash
terraform apply
```

---

# Common Import Problem: Configuration Mismatch

Example:

AWS:

```text
Instance Type:

t3.small
```

Terraform:

```hcl
instance_type = "t3.micro"
```

Terraform may try to modify the existing instance.

Solution:

Update your configuration to accurately represent the infrastructure you want Terraform to manage.

---

# Common Import Problem: Wrong Resource Address

If your resource is:

```hcl
resource "aws_instance" "web" {
}
```

then import using:

```bash
terraform import aws_instance.web INSTANCE_ID
```

Not:

```bash
terraform import aws_instance.server INSTANCE_ID
```

The resource address must match.

---

# Common Import Problem: Wrong Resource ID

Different resources use different import identifiers.

For example:

```text
EC2 → Instance ID

VPC → VPC ID

Subnet → Subnet ID

S3 → Bucket Name
```

Always check the Terraform AWS Provider documentation.

---

# Common Import Problem: Applying Too Quickly

Do not immediately run:

```bash
terraform apply
```

after importing.

First run:

```bash
terraform plan
```

Terraform might otherwise modify or replace important infrastructure.

---

# Importing Production Infrastructure

Importing production infrastructure should be done carefully.

Recommended process:

```text
Identify Resources

↓

Back Up State

↓

Create Configuration

↓

Import

↓

terraform plan

↓

Review Differences

↓

Correct Configuration

↓

Plan Again

↓

Apply Only When Safe
```

---

# Terraform Import and State

Import is closely related to Terraform state.

Essentially:

```text
terraform import

↓

Adds Existing Resource

↓

Terraform State

↓

Terraform Can Manage Resource
```

The resource does not need to be recreated.

---

# When Should You Use Terraform Import?

Common situations include:

### Existing Manual Infrastructure

Infrastructure was created through the AWS Console.

---

### Migrating to Infrastructure as Code

A company wants to move existing AWS resources under Terraform management.

---

### Taking Ownership of Existing Resources

Terraform needs to manage infrastructure originally created by another tool or process.

---

### Gradual Terraform Adoption

Instead of rebuilding an entire environment, existing resources can be imported gradually.

---

# Best Practices

- Identify the exact resource before importing.
- Check the provider documentation for the correct import ID.
- Create or generate appropriate Terraform configuration.
- Back up important Terraform state.
- Import resources carefully.
- Run `terraform plan` immediately after import.
- Review all proposed changes.
- Make configuration match the desired infrastructure.
- Never blindly apply changes after importing production resources.

---

# Key Takeaways

- Terraform Import brings existing infrastructure under Terraform management.
- Import does not create a new resource.
- Traditional imports use `terraform import`.
- Terraform needs a resource address and resource identifier.
- Imported resources are recorded in Terraform state.
- Importing does not guarantee that your configuration matches the real resource.
- Always run `terraform plan` after importing.
- Modern Terraform also supports configuration-driven `import` blocks.
- Terraform can help generate configuration for imported resources.
- Import is useful when migrating manually created infrastructure to Infrastructure as Code.

---

# Quick Revision

| Concept | Purpose |
|---------|---------|
| Terraform Import | Manage existing infrastructure |
| Resource Address | Terraform's identifier |
| Resource ID | Existing platform resource identifier |
| `terraform import` | Traditional import command |
| `import {}` | Configuration-driven import |
| `terraform state list` | Show managed resources |
| `terraform state show` | Inspect state resource |
| `terraform plan` | Check configuration differences |

---

# Useful Commands

Import:

```bash
terraform import aws_instance.web i-0123456789abcdef0
```

Check state:

```bash
terraform state list
```

Inspect resource:

```bash
terraform state show aws_instance.web
```

Check differences:

```bash
terraform plan
```

Generate configuration:

```bash
terraform plan -generate-config-out=generated.tf
```

---

# Interview Questions

### What is Terraform Import?

Terraform Import allows existing infrastructure that was created outside Terraform to be brought under Terraform management.

### Does `terraform import` create a new resource?

No. The resource already exists. Import associates that existing resource with a Terraform resource address and records it in state.

### What is the syntax for traditional Terraform import?

```bash
terraform import RESOURCE_ADDRESS RESOURCE_ID
```

### What should you do after importing a resource?

Run:

```bash
terraform plan
```

and carefully review any differences between your Terraform configuration and the existing infrastructure.

### Does importing automatically create a perfect Terraform configuration?

No. Import associates the resource with Terraform state. Your configuration must still accurately describe the infrastructure you want Terraform to manage.

### What is an import block?

An import block is a configuration-driven method of defining an import using Terraform code.

Example:

```hcl
import {
  to = aws_instance.web
  id = "i-0123456789abcdef0"
}
```

### Why is Terraform Import useful?

It allows organisations to adopt Infrastructure as Code without necessarily destroying and rebuilding infrastructure that already exists.