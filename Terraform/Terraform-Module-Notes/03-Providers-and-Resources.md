# Terraform Notes - Part 3: Providers & Resources

> Covers:
>
> - What is a Terraform Provider?
> - AWS Provider
> - Required Providers
> - Provider Versions
> - Terraform Registry
> - Resource Blocks
> - Resource Types & Names
> - Required vs Optional Arguments
> - Resource Attributes
> - Resource References
> - Dependencies
> - AWS Credentials
> - Basic EC2 Example

---

# What is a Terraform Provider?

A **provider** is a plugin that allows Terraform to communicate with an external platform or service.

Examples include:

- AWS
- Microsoft Azure
- Google Cloud
- Kubernetes
- Cloudflare
- GitHub

Terraform itself does not know how to create an EC2 instance.

Instead:

```text
Terraform

↓

AWS Provider

↓

AWS API

↓

EC2 / S3 / VPC / etc.
```

The provider translates Terraform configuration into API requests that the platform understands.

---

# AWS Provider

To manage AWS infrastructure, Terraform uses the **AWS Provider** maintained by HashiCorp.

Example:

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

This tells Terraform:

- Provider name → `aws`
- Provider source → `hashicorp/aws`
- Version constraint → `~> 6.0`

---

# `required_providers`

The `required_providers` block defines the providers needed by the Terraform configuration.

Example:

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

Terraform downloads the required provider when you run:

```bash
terraform init
```

---

# Provider Configuration

After declaring the provider requirement, you can configure the provider.

Example:

```hcl
provider "aws" {
  region = "eu-west-2"
}
```

This tells the AWS provider which AWS region to work with.

Example:

```text
eu-west-2
```

is the AWS London region.

---

# Provider Version Constraints

Terraform allows you to control which provider versions can be installed.

Example:

```hcl
version = "~> 6.0"
```

The `~>` operator allows compatible versions within the specified range while preventing unexpected major upgrades.

Version constraints help provide:

- Consistency
- Predictable deployments
- Reduced compatibility issues

---

# Terraform Lock File

After:

```bash
terraform init
```

Terraform normally creates:

```text
.terraform.lock.hcl
```

This records the provider versions Terraform selected.

You should normally commit this file to Git.

---

# Terraform Registry

The **Terraform Registry** contains documentation for:

- Providers
- Resources
- Data sources
- Modules

When using AWS Terraform resources, the Registry documentation tells you:

- Available resources
- Required arguments
- Optional arguments
- Resource attributes
- Examples

---

# Using the Registry

Suppose you want to create an EC2 instance.

Search the Terraform Registry documentation for:

```text
aws_instance
```

The documentation explains how to configure the resource.

Example:

```hcl
resource "aws_instance" "web" {
  ami           = "ami-12345678"
  instance_type = "t3.micro"
}
```

---

# What is a Terraform Resource?

A **resource** represents infrastructure Terraform should create or manage.

Examples:

```text
EC2 Instance
S3 Bucket
VPC
Subnet
Security Group
Load Balancer
Database
```

Resources are the main building blocks of Terraform configurations.

---

# Resource Block Syntax

General syntax:

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

# Resource Type

In:

```hcl
resource "aws_instance" "web"
```

this:

```text
aws_instance
```

is the **resource type**.

It tells Terraform what type of infrastructure to manage.

In this case:

```text
AWS EC2 Instance
```

---

# Resource Local Name

In:

```hcl
resource "aws_instance" "web"
```

this:

```text
web
```

is the Terraform **local resource name**.

It is used to reference the resource elsewhere in your Terraform configuration.

It does **not** automatically become the AWS resource's displayed `Name` tag.

---

# Resource Address

Together:

```text
aws_instance.web
```

forms the resource address.

Structure:

```text
resource_type.resource_name
```

Example:

```text
aws_instance.web
```

This is how Terraform identifies the resource within the configuration and state.

---

# Arguments

Arguments configure a resource.

Example:

```hcl
resource "aws_instance" "web" {
  ami           = "ami-12345678"
  instance_type = "t3.micro"
}
```

Arguments include:

```text
ami

instance_type
```

Values include:

```text
ami-12345678

t3.micro
```

---

# Required vs Optional Arguments

Some arguments are required while others are optional.

For an EC2 instance, the exact requirements depend on the resource configuration and provider version.

For example, you need a way to define what the instance should launch from, such as an AMI or supported launch-template configuration.

Other arguments may be optional.

Always check the provider documentation rather than assuming.

---

# Resource Attributes

After Terraform creates a resource, the provider exposes information about it as **attributes**.

For an EC2 instance, examples can include:

```text
id

public_ip

private_ip

arn
```

You can reference these values elsewhere.

---

# Resource References

Terraform resources can reference attributes from other resources.

Example:

```hcl
output "instance_ip" {
  value = aws_instance.web.public_ip
}
```

Structure:

```text
Resource Type
     ↓
aws_instance.web.public_ip
             ↑       ↑
        Local Name  Attribute
```

---

# Referencing Resources

Suppose we create a VPC:

```hcl
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}
```

We can reference its ID:

```hcl
aws_vpc.main.id
```

Then use it when creating a subnet:

```hcl
resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
}
```

---

# Terraform Dependencies

Terraform automatically detects many dependencies through resource references.

Example:

```hcl
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
}
```

Terraform understands:

```text
VPC

↓

Subnet
```

The subnet depends on the VPC because it references:

```hcl
aws_vpc.main.id
```

Terraform therefore knows the VPC must exist before the subnet can be created.

---

# Implicit Dependencies

A dependency created through a resource reference is called an **implicit dependency**.

Example:

```hcl
vpc_id = aws_vpc.main.id
```

Terraform detects this automatically.

This is usually preferred.

---

# Explicit Dependencies

Sometimes Terraform cannot automatically determine a dependency.

You can use:

```hcl
depends_on
```

Example:

```hcl
resource "aws_instance" "web" {
  ami           = "ami-12345678"
  instance_type = "t3.micro"

  depends_on = [
    aws_internet_gateway.main
  ]
}
```

Use `depends_on` only when a real dependency exists that Terraform cannot infer from references.

---

# Terraform Dependency Graph

Terraform internally builds a dependency graph.

Example:

```text
VPC
 │
 ├── Public Subnet
 │
 └── Private Subnet
        │
        ↓
      EC2
```

This allows Terraform to determine the correct order for creating and destroying resources.

---

# AWS Credentials

Terraform needs permission to communicate with AWS.

AWS credentials should **not** normally be hardcoded inside Terraform files.

Avoid:

```hcl
provider "aws" {
  access_key = "SECRET"
  secret_key = "SECRET"
}
```

This creates a security risk, especially when Terraform code is stored in Git.

---

# AWS Environment Variables

One method is to provide AWS credentials through environment variables.

Example:

```bash
export AWS_ACCESS_KEY_ID="your-access-key"

export AWS_SECRET_ACCESS_KEY="your-secret-key"

export AWS_DEFAULT_REGION="eu-west-2"
```

Terraform's AWS provider can use credentials available through the AWS credential chain.

---

# AWS CLI Credentials

If the AWS CLI is configured:

```bash
aws configure
```

credentials can be stored in AWS configuration files such as:

```text
~/.aws/credentials
```

Terraform can use these credentials.

---

# Better Authentication Approaches

For real environments, prefer temporary credentials where possible.

Examples include:

- IAM Roles
- AWS IAM Identity Center
- AssumeRole
- Workload identities in CI/CD

Avoid long-lived access keys where possible.

---

# Basic EC2 Example

Example Terraform configuration:

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

resource "aws_instance" "web" {
  ami           = "ami-12345678"
  instance_type = "t3.micro"

  tags = {
    Name = "Terraform-Web-Server"
  }
}
```

---

# What Happens?

Terraform processes:

```text
required_providers

↓

Download AWS Provider

↓

Configure AWS Region

↓

Read aws_instance Resource

↓

Authenticate to AWS

↓

Call AWS API

↓

Create EC2 Instance
```

---

# Running the Configuration

Initialize:

```bash
terraform init
```

Format:

```bash
terraform fmt
```

Validate:

```bash
terraform validate
```

Preview:

```bash
terraform plan
```

Create:

```bash
terraform apply
```

---

# Creating Multiple Resources

Terraform configurations commonly contain many resources.

Example:

```hcl
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
}

resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"
}
```

Terraform manages all these resources as part of the same configuration.

---

# Resource Tags

AWS resources commonly support tags.

Example:

```hcl
tags = {
  Name        = "Web-Server"
  Environment = "Development"
  ManagedBy   = "Terraform"
}
```

Tags help identify and organise AWS resources.

---

# Common Mistakes

### Hardcoding Credentials

Never store AWS access keys directly inside `.tf` files or commit them to Git.

---

### Guessing Resource Arguments

Do not guess Terraform resource syntax.

Check the Terraform Registry/provider documentation.

---

### Confusing Resource Name with AWS Name

This:

```hcl
resource "aws_instance" "web"
```

does not automatically name the EC2 instance `web` inside AWS.

Use a tag:

```hcl
tags = {
  Name = "Web-Server"
}
```

---

### Using `depends_on` Everywhere

Terraform automatically understands dependencies created through references.

Prefer:

```hcl
vpc_id = aws_vpc.main.id
```

over manually creating unnecessary dependencies.

---

# Best Practices

- Pin provider versions using sensible constraints.
- Commit `.terraform.lock.hcl`.
- Use the Terraform Registry/provider documentation.
- Never hardcode credentials.
- Prefer temporary AWS credentials where possible.
- Use meaningful Terraform resource names.
- Tag AWS resources.
- Use resource references to create dependencies.
- Run `terraform plan` before applying changes.

---

# Key Takeaways

- Providers allow Terraform to communicate with external platforms.
- The AWS Provider allows Terraform to manage AWS infrastructure.
- `terraform init` downloads required providers.
- Resources represent infrastructure Terraform manages.
- Resource blocks contain a resource type, local name and arguments.
- Resource attributes can be referenced elsewhere.
- Terraform automatically detects dependencies through references.
- `depends_on` can define dependencies Terraform cannot infer.
- AWS credentials should never be hardcoded into Terraform configuration.
- The Terraform Registry/provider documentation is essential when building configurations.

---

# Quick Revision

| Concept | Purpose |
|---------|---------|
| Provider | Connect Terraform to a platform |
| AWS Provider | Manage AWS resources |
| Resource | Infrastructure object |
| Resource Type | Type of infrastructure |
| Local Name | Terraform's name for resource |
| Argument | Configures resource |
| Attribute | Information exposed by resource |
| Reference | Uses another resource's value |
| `depends_on` | Explicit dependency |
| Registry | Provider/resource documentation |

---

# Example Resource Address

```text
aws_instance.web
│            │
│            └── Local Name
│
└── Resource Type
```

Attribute reference:

```text
aws_instance.web.public_ip
│            │      │
│            │      └── Attribute
│            └── Local Name
└── Resource Type
```

---

# Interview Questions

### What is a Terraform provider?

A provider is a plugin that allows Terraform to communicate with external APIs such as AWS, Azure, Google Cloud or Kubernetes.

### What is a Terraform resource?

A resource represents an infrastructure object that Terraform creates or manages, such as an EC2 instance, VPC or S3 bucket.

### What does `terraform init` do with providers?

It downloads and initializes the providers required by the Terraform configuration.

### What is the difference between a resource argument and an attribute?

An argument is a value you provide to configure a resource, while an attribute is information exposed by the resource that can be referenced elsewhere.

### How does Terraform determine resource dependencies?

Terraform normally detects dependencies automatically when one resource references an attribute of another resource.

### What is `depends_on`?

`depends_on` creates an explicit dependency when Terraform cannot infer the dependency automatically.

### Where should you find Terraform resource documentation?

Use the Terraform Registry and the documentation for the relevant provider.

### Should AWS access keys be stored inside Terraform files?

No. Credentials should be supplied securely through mechanisms such as environment variables, AWS profiles, IAM roles, IAM Identity Center or CI/CD workload credentials.