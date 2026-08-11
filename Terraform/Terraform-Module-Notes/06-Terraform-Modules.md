# Terraform Notes - Part 6: Terraform Modules

> Covers:
>
> - What is a Terraform Module?
> - Root Modules
> - Child Modules
> - Why Modules are Useful
> - DRY Principle
> - Module Structure
> - Calling Modules
> - Module Sources
> - Passing Variables into Modules
> - Module Outputs
> - Reusing Modules
> - Terraform Registry Modules
> - Module Best Practices

---

# What is a Terraform Module?

A **Terraform module** is a collection of Terraform configuration files grouped together to perform a specific infrastructure task.

For example, you could create reusable modules for:

- EC2 instances
- VPCs
- S3 buckets
- Load balancers
- Databases
- Complete applications

Instead of repeatedly writing the same Terraform code, you write it once inside a module and reuse it.

---

# Why Use Modules?

Without modules, you may repeatedly write:

```text
VPC Configuration

EC2 Configuration

Security Group Configuration

Load Balancer Configuration
```

for every environment.

With modules:

```text
Reusable VPC Module

Reusable EC2 Module

Reusable ALB Module
```

These modules can then be called whenever they are needed.

---

# DRY Principle

Modules follow the:

```text
DRY
```

principle:

> **Don't Repeat Yourself**

Instead of copying the same infrastructure code:

```text
Development
├── EC2 code
├── VPC code
└── Security Group code

Production
├── EC2 code
├── VPC code
└── Security Group code
```

you can reuse modules:

```text
Development ──┐
              │
Production ───┼──► Reusable Modules
              │
Staging ──────┘
```

---

# Benefits of Terraform Modules

Modules provide:

- Reusability
- Consistency
- Easier maintenance
- Less duplicated code
- Better collaboration
- Standardised infrastructure
- Cleaner Terraform projects

---

# Every Terraform Configuration is a Module

A directory containing Terraform configuration files is technically a module.

For example:

```text
terraform-project/
├── main.tf
├── variables.tf
└── outputs.tf
```

This is already a Terraform module.

When it is the configuration where you run Terraform, it is called the **root module**.

---

# Root Module

The **root module** is the main Terraform configuration.

Example:

```text
terraform-project/
│
├── main.tf
├── variables.tf
├── outputs.tf
└── providers.tf
```

When you run:

```bash
terraform plan
```

from this directory, Terraform treats it as the root module.

---

# Child Module

A **child module** is another module called by the root module or by another module.

Example:

```text
Root Module

    ↓

EC2 Module

    ↓

Creates EC2 Infrastructure
```

---

# Basic Module Structure

A common Terraform project structure:

```text
terraform-project/
│
├── main.tf
├── variables.tf
├── outputs.tf
├── providers.tf
│
└── modules/
    │
    └── ec2/
        ├── main.tf
        ├── variables.tf
        └── outputs.tf
```

The `modules/ec2/` directory contains reusable EC2 logic.

---

# Module Files

A module commonly contains:

```text
main.tf

variables.tf

outputs.tf
```

These filenames are conventions rather than strict Terraform requirements.

---

# `main.tf`

Contains the module's resources.

Example:

```hcl
resource "aws_instance" "web" {
  ami           = var.ami
  instance_type = var.instance_type

  tags = {
    Name = var.instance_name
  }
}
```

---

# `variables.tf`

Defines values that can be passed into the module.

Example:

```hcl
variable "ami" {
  type        = string
  description = "AMI used for the EC2 instance"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type"
}

variable "instance_name" {
  type        = string
  description = "Name tag for the EC2 instance"
}
```

---

# `outputs.tf`

Exposes useful values from the module.

Example:

```hcl
output "instance_id" {
  value = aws_instance.web.id
}

output "public_ip" {
  value = aws_instance.web.public_ip
}
```

---

# Calling a Module

Modules are called using:

```hcl
module
```

Example:

```hcl
module "ec2" {
  source = "./modules/ec2"
}
```

This tells Terraform:

```text
Use the module located at:

./modules/ec2
```

---

# Module Block Structure

General syntax:

```hcl
module "MODULE_NAME" {
  source = "MODULE_SOURCE"

  variable = value
}
```

Example:

```hcl
module "web_server" {
  source = "./modules/ec2"

  ami           = "ami-12345678"
  instance_type = "t3.micro"
  instance_name = "Web-Server"
}
```

---

# Module Name

In:

```hcl
module "web_server"
```

this:

```text
web_server
```

is the local name Terraform uses for the module.

You can reference it elsewhere using:

```text
module.web_server
```

---

# Module Source

The:

```hcl
source
```

argument tells Terraform where the module is located.

Example:

```hcl
source = "./modules/ec2"
```

This refers to a local module.

---

# Passing Variables Into Modules

Suppose the module contains:

```hcl
variable "instance_type" {
  type = string
}
```

The root module can pass a value:

```hcl
module "web_server" {
  source = "./modules/ec2"

  instance_type = "t3.micro"
}
```

Flow:

```text
Root Module

instance_type = "t3.micro"

        ↓

Child Module

var.instance_type

        ↓

EC2 Resource
```

---

# Complete Module Example

## Child Module

Directory:

```text
modules/ec2/
```

### `variables.tf`

```hcl
variable "ami" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "instance_name" {
  type = string
}
```

### `main.tf`

```hcl
resource "aws_instance" "web" {
  ami           = var.ami
  instance_type = var.instance_type

  tags = {
    Name = var.instance_name
  }
}
```

### `outputs.tf`

```hcl
output "instance_id" {
  value = aws_instance.web.id
}

output "public_ip" {
  value = aws_instance.web.public_ip
}
```

---

# Root Module

The root module calls the EC2 module:

```hcl
module "web_server" {
  source = "./modules/ec2"

  ami           = var.ami
  instance_type = "t3.micro"
  instance_name = "Terraform-Web"
}
```

Terraform then creates the EC2 instance using the child module.

---

# Module Outputs

Outputs from child modules can be accessed by the calling module.

Suppose the child module contains:

```hcl
output "public_ip" {
  value = aws_instance.web.public_ip
}
```

The root module can reference:

```hcl
module.web_server.public_ip
```

---

# Exposing Module Output

The root module can expose it again:

```hcl
output "web_server_ip" {
  value = module.web_server.public_ip
}
```

Flow:

```text
EC2 Instance

↓

aws_instance.web.public_ip

↓

Child Module Output

↓

module.web_server.public_ip

↓

Root Module Output
```

---

# Reusing the Same Module

One major advantage is that the same module can be called multiple times.

Example:

```hcl
module "web_server_1" {
  source = "./modules/ec2"

  ami           = var.ami
  instance_type = "t3.micro"
  instance_name = "Web-1"
}

module "web_server_2" {
  source = "./modules/ec2"

  ami           = var.ami
  instance_type = "t3.micro"
  instance_name = "Web-2"
}
```

Same module:

```text
EC2 Module
   │
   ├── Web Server 1
   │
   └── Web Server 2
```

---

# Modules Across Environments

Modules are especially useful when managing:

```text
Development

Staging

Production
```

You can reuse the same infrastructure logic while supplying different values.

Example:

```text
                    ┌── Development
                    │
VPC Module ─────────┼── Staging
                    │
                    └── Production
```

---

# Example

Development:

```hcl
module "dev_server" {
  source = "./modules/ec2"

  instance_type = "t3.micro"
}
```

Production:

```hcl
module "prod_server" {
  source = "./modules/ec2"

  instance_type = "t3.large"
}
```

Same infrastructure logic, different configuration.

---

# Building a VPC Module

A VPC module could contain:

```text
modules/vpc/
│
├── main.tf
├── variables.tf
└── outputs.tf
```

Resources could include:

```text
VPC

↓

Subnets

↓

Route Tables

↓

Internet Gateway

↓

NAT Gateway
```

Then the root configuration simply calls:

```hcl
module "network" {
  source = "./modules/vpc"
}
```

---

# Multiple Modules

A larger project could look like:

```text
terraform-project/
│
├── main.tf
├── variables.tf
├── outputs.tf
│
└── modules/
    ├── vpc/
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    │
    ├── ec2/
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    │
    └── alb/
        ├── main.tf
        ├── variables.tf
        └── outputs.tf
```

The root module connects everything together.

---

# Module Dependencies

One module can use the output of another module.

Example:

```hcl
module "network" {
  source = "./modules/vpc"
}

module "server" {
  source = "./modules/ec2"

  subnet_id = module.network.public_subnet_id
}
```

Terraform understands:

```text
VPC Module

↓

Subnet ID Output

↓

EC2 Module

↓

EC2 Created in Subnet
```

This also creates an implicit dependency between the modules.

---

# Terraform Registry Modules

Modules do not have to be stored locally.

Terraform has a public module registry containing reusable modules.

For example, instead of:

```hcl
source = "./modules/vpc"
```

a Registry module may use a source such as:

```hcl
source = "terraform-aws-modules/vpc/aws"
```

---

# Why Use Registry Modules?

Registry modules can save time when creating common infrastructure.

Examples include:

- VPCs
- EKS clusters
- RDS databases
- Security Groups

However, you should understand what a module creates before using it.

---

# Module Versions

When using Registry modules, pinning a version helps prevent unexpected changes.

Example:

```hcl
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "x.y.z"
}
```

Replace:

```text
x.y.z
```

with the specific version you have reviewed and tested.

---

# Running Terraform After Adding Modules

After adding or changing a module source, run:

```bash
terraform init
```

Terraform downloads or initializes the module.

Then:

```bash
terraform validate
```

```bash
terraform plan
```

```bash
terraform apply
```

---

# Modules and State

Resources created by modules are still tracked in Terraform state.

Example resource address:

```text
module.web_server.aws_instance.web
```

Breakdown:

```text
module.web_server

↓

aws_instance.web
```

This tells Terraform the EC2 resource belongs to the `web_server` module.

---

# Modules vs Resources

A **resource** represents an individual infrastructure object.

Example:

```hcl
resource "aws_instance" "web"
```

A **module** can contain multiple resources.

Example:

```text
VPC Module

├── VPC
├── Subnets
├── Route Tables
├── Internet Gateway
└── NAT Gateway
```

---

# When Should You Create a Module?

Modules are useful when infrastructure:

- Is repeated
- Needs standardisation
- Is used across environments
- Contains multiple related resources
- Needs to be shared between teams

Avoid creating modules for every tiny piece of Terraform code.

Modules should provide meaningful reusable infrastructure components.

---

# Common Mistakes

### Hardcoding Everything Inside Modules

Avoid:

```hcl
instance_type = "t3.micro"
```

when callers may need different values.

Use:

```hcl
instance_type = var.instance_type
```

---

### Creating Too Many Small Modules

Not every individual resource needs its own module.

Prefer logical components such as:

```text
VPC Module

Application Module

Database Module
```

---

### Forgetting `terraform init`

After adding a module, run:

```bash
terraform init
```

so Terraform can initialize it.

---

### Not Exposing Required Outputs

If another module needs a resource value, expose it through an output.

Example:

```hcl
output "subnet_id" {
  value = aws_subnet.public.id
}
```

---

### Blindly Using Public Modules

Always review:

- Resources created
- Inputs
- Outputs
- Permissions
- Version
- Maintenance

before using a third-party module.

---

# Best Practices

- Follow the DRY principle.
- Keep modules focused on logical infrastructure components.
- Use variables instead of hardcoded values.
- Expose only useful outputs.
- Use meaningful module names.
- Document module inputs and outputs.
- Pin versions of external modules.
- Review public modules before using them.
- Keep reusable modules separate from environment-specific configuration.
- Avoid unnecessary module complexity.

---

# Key Takeaways

- Terraform modules are reusable collections of Terraform configuration.
- Every Terraform configuration directory is technically a module.
- The main configuration is called the root module.
- Modules called by other modules are child modules.
- Modules help reduce duplicated infrastructure code.
- Inputs pass values into modules.
- Outputs expose values from modules.
- The same module can be reused multiple times.
- Modules are useful across development, staging and production.
- Modules can be local or downloaded from sources such as the Terraform Registry.
- Modules make Terraform infrastructure easier to standardise and maintain.

---

# Quick Revision

| Concept | Purpose |
|---------|---------|
| Module | Reusable Terraform configuration |
| Root Module | Main Terraform configuration |
| Child Module | Module called by another module |
| `module` | Calls a module |
| `source` | Specifies module location |
| Input Variable | Passes values into module |
| Output | Exposes module values |
| Registry | Source of reusable public modules |
| DRY | Don't Repeat Yourself |

---

# Module Flow

```text
Root Module

↓

Input Variables

↓

Child Module

↓

Resources

↓

Module Outputs

↓

Root Module
```

---

# Example Module Call

```hcl
module "web_server" {
  source = "./modules/ec2"

  ami           = var.ami
  instance_type = "t3.micro"
  instance_name = "Web-Server"
}
```

---

# Example Module Output Reference

```hcl
module.web_server.public_ip
```

---

# Interview Questions

### What is a Terraform module?

A Terraform module is a collection of Terraform configuration files grouped together to create reusable infrastructure components.

### What is the difference between a root module and a child module?

The root module is the main Terraform configuration where Terraform is executed, while a child module is called by another module.

### Why use Terraform modules?

Modules reduce duplicated code, improve consistency, simplify maintenance and allow infrastructure components to be reused across environments.

### How do you call a local Terraform module?

Using a module block:

```hcl
module "ec2" {
  source = "./modules/ec2"
}
```

### How do you pass information into a module?

Define input variables inside the child module and provide values through the module block in the calling module.

### How do you retrieve information from a module?

Define outputs inside the child module and reference them using:

```hcl
module.module_name.output_name
```

### What is the DRY principle?

DRY means **Don't Repeat Yourself**. Terraform modules allow infrastructure code to be written once and reused rather than repeatedly copied.

### What is the Terraform Registry?

The Terraform Registry contains reusable providers and modules that can be used in Terraform configurations.