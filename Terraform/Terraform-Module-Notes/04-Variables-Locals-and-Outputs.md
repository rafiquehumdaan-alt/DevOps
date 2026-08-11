# Terraform Notes - Part 4: Variables, Locals & Outputs

> Covers:
>
> - Why Terraform Variables are Useful
> - Input Variables
> - Variable Blocks
> - Variable References
> - Default Values
> - Variable Types
> - `.tfvars` Files
> - Variable Precedence
> - Local Variables
> - Output Variables
> - Resource Attributes
> - Making Terraform Reusable

---

# Why Use Variables?

Variables allow Terraform configurations to be **dynamic and reusable**.

Instead of hardcoding values:

```hcl
resource "aws_instance" "web" {
  ami           = "ami-12345678"
  instance_type = "t3.micro"
}
```

We can use variables:

```hcl
resource "aws_instance" "web" {
  ami           = var.instance_ami
  instance_type = var.instance_type
}
```

Now the values can be changed without modifying the resource itself.

---

# Types of Terraform Values

Three important concepts are:

```text
Input Variables
     ↓
Values provided to Terraform

Local Variables
     ↓
Values calculated/reused internally

Output Values
     ↓
Values Terraform exposes after execution
```

---

# Input Variables

Input variables allow values to be passed into Terraform configurations.

They are declared using:

```hcl
variable
```

Example:

```hcl
variable "instance_type" {
  type        = string
  default     = "t3.micro"
  description = "EC2 instance type"
}
```

---

# Variable Structure

```hcl
variable "instance_type" {
  type        = string
  default     = "t3.micro"
  description = "EC2 instance type"
}
```

Contains:

| Property | Purpose |
|----------|---------|
| `type` | Defines expected data type |
| `default` | Default value |
| `description` | Explains the variable |

---

# Referencing Variables

Variables are referenced using:

```text
var.variable_name
```

Example:

```hcl
var.instance_type
```

Inside a resource:

```hcl
resource "aws_instance" "web" {
  ami           = var.instance_ami
  instance_type = var.instance_type
}
```

---

# Example `variables.tf`

```hcl
variable "instance_ami" {
  type        = string
  description = "AMI used for the EC2 instance"
}

variable "instance_type" {
  type        = string
  default     = "t3.micro"
  description = "EC2 instance type"
}

variable "environment" {
  type        = string
  default     = "dev"
  description = "Deployment environment"
}
```

---

# Variables Without Defaults

A variable does not need a default value.

Example:

```hcl
variable "instance_ami" {
  type        = string
  description = "AMI ID"
}
```

If Terraform cannot obtain the value from another source, it will ask for it.

Example:

```text
var.instance_ami

Enter a value:
```

---

# Default Values

A default value makes the variable optional to provide.

Example:

```hcl
variable "instance_type" {
  default = "t3.micro"
}
```

If no other value is supplied:

```text
t3.micro
```

will be used.

---

# Variable Types

Terraform supports primitive and complex data types.

Common types include:

```text
string

number

bool

list

set

map

object
```

---

# String

A string stores text.

Example:

```hcl
variable "region" {
  type    = string
  default = "eu-west-2"
}
```

Reference:

```hcl
var.region
```

---

# Number

Stores numerical values.

Example:

```hcl
variable "instance_count" {
  type    = number
  default = 2
}
```

Can be used with:

```hcl
count = var.instance_count
```

---

# Boolean

Stores:

```text
true

false
```

Example:

```hcl
variable "enable_monitoring" {
  type    = bool
  default = true
}
```

---

# List

A list stores multiple ordered values.

Example:

```hcl
variable "availability_zones" {
  type = list(string)

  default = [
    "eu-west-2a",
    "eu-west-2b"
  ]
}
```

Access an item:

```hcl
var.availability_zones[0]
```

Returns:

```text
eu-west-2a
```

---

# Map

A map stores key-value pairs.

Example:

```hcl
variable "instance_types" {
  type = map(string)

  default = {
    dev  = "t3.micro"
    prod = "t3.medium"
  }
}
```

Access:

```hcl
var.instance_types["dev"]
```

Returns:

```text
t3.micro
```

---

# Object

Objects allow structured values with specific attributes.

Example:

```hcl
variable "server" {
  type = object({
    name          = string
    instance_type = string
    monitoring    = bool
  })
}
```

Example value:

```hcl
server = {
  name          = "web-server"
  instance_type = "t3.micro"
  monitoring    = true
}
```

Reference:

```hcl
var.server.instance_type
```

---

# Variable Files

Terraform variable values can be stored inside:

```text
terraform.tfvars
```

Example:

```hcl
instance_ami  = "ami-12345678"
instance_type = "t3.micro"
environment   = "dev"
```

Terraform automatically loads:

```text
terraform.tfvars
```

and files ending in:

```text
.auto.tfvars
```

---

# Why Use `.tfvars`?

Instead of changing:

```text
variables.tf
```

you can keep the variable definitions separate from their values.

Example:

```text
variables.tf
      ↓
Defines variables

terraform.tfvars
      ↓
Provides values
```

This makes configurations cleaner and easier to reuse.

---

# Environment-Specific Variable Files

You can create separate variable files.

Example:

```text
dev.tfvars

staging.tfvars

prod.tfvars
```

Run:

```bash
terraform plan -var-file="dev.tfvars"
```

or:

```bash
terraform apply -var-file="prod.tfvars"
```

---

# Command-Line Variables

Variables can be provided directly from the command line.

Example:

```bash
terraform plan -var="instance_type=t3.small"
```

This overrides lower-priority values such as defaults.

For repeatable environments, `.tfvars` files are usually cleaner than many command-line `-var` options.

---

# Environment Variables

Terraform variables can also be supplied using environment variables.

The required format is:

```text
TF_VAR_variable_name
```

Example:

```bash
export TF_VAR_instance_type="t3.small"
```

Terraform can then use:

```hcl
var.instance_type
```

---

# Terraform Variable Precedence

If the same variable is supplied in multiple places, Terraform uses precedence rules.

A simplified way to remember the common sources is:

```text
Default Values
        ↓
Environment Variables
        ↓
.tfvars / .auto.tfvars
        ↓
-var / -var-file
```

Higher-priority values override lower-priority values.

For exact edge cases, always check Terraform's current variable precedence documentation.

---

# Example

Variable definition:

```hcl
variable "instance_type" {
  default = "t3.micro"
}
```

Then:

```text
terraform.tfvars

instance_type = "t3.small"
```

Terraform uses:

```text
t3.small
```

because the `.tfvars` value overrides the default.

---

# Local Variables

**Local values** are internal values used within a Terraform configuration.

They are declared using:

```hcl
locals {
}
```

Example:

```hcl
locals {
  environment = "development"
  project_name = "terraform-demo"
}
```

---

# Referencing Locals

Use:

```text
local.local_name
```

Example:

```hcl
local.environment
```

---

# Local Example

```hcl
locals {
  instance_ami = "ami-12345678"
}
```

Then:

```hcl
resource "aws_instance" "web" {
  ami           = local.instance_ami
  instance_type = "t3.micro"
}
```

---

# Why Use Locals?

Locals are useful when:

- A value is used repeatedly
- A value is calculated from other values
- You want to reduce duplication
- You want cleaner configuration

Example:

```hcl
locals {
  common_name = "${var.project_name}-${var.environment}"
}
```

This value can then be reused throughout the configuration.

---

# Input Variables vs Locals

| Input Variable | Local |
|----------------|-------|
| Input from outside | Internal value |
| `var.name` | `local.name` |
| Can be overridden | Defined by configuration |
| Used for customisation | Used for reuse/calculation |

---

# Output Values

Outputs expose information from Terraform after resources are created.

Example:

```hcl
output "instance_id" {
  value       = aws_instance.web.id
  description = "EC2 instance ID"
}
```

After:

```bash
terraform apply
```

Terraform might display:

```text
Outputs:

instance_id = "i-0123456789abcdef0"
```

---

# Why Use Outputs?

Outputs are useful for exposing:

- Resource IDs
- Public IP addresses
- DNS names
- URLs
- VPC IDs
- Subnet IDs

They can also pass information between Terraform modules.

---

# Output Example

```hcl
output "public_ip" {
  value       = aws_instance.web.public_ip
  description = "Public IP of the web server"
}
```

Terraform retrieves:

```hcl
aws_instance.web.public_ip
```

and exposes it as:

```text
public_ip
```

---

# Multiple Outputs

Example:

```hcl
output "instance_id" {
  value = aws_instance.web.id
}

output "public_ip" {
  value = aws_instance.web.public_ip
}

output "private_ip" {
  value = aws_instance.web.private_ip
}
```

---

# Viewing Outputs

Run:

```bash
terraform output
```

Example:

```text
instance_id = "i-0123456789"

public_ip = "18.130.x.x"
```

View one specific output:

```bash
terraform output public_ip
```

---

# Variables + Resources + Outputs

A typical Terraform flow:

```text
Input Variable

↓

Resource

↓

AWS Infrastructure

↓

Resource Attribute

↓

Output
```

Example:

```hcl
variable "instance_type" {
  default = "t3.micro"
}

resource "aws_instance" "web" {
  ami           = var.instance_ami
  instance_type = var.instance_type
}

output "public_ip" {
  value = aws_instance.web.public_ip
}
```

---

# Recommended File Structure

A common Terraform structure:

```text
terraform-project/
│
├── main.tf
├── variables.tf
├── outputs.tf
├── providers.tf
└── terraform.tfvars
```

---

# `main.tf`

Usually contains infrastructure resources.

Example:

```hcl
resource "aws_instance" "web" {
  ami           = var.instance_ami
  instance_type = var.instance_type
}
```

---

# `variables.tf`

Usually contains variable definitions.

```hcl
variable "instance_type" {
  type        = string
  default     = "t3.micro"
  description = "EC2 instance type"
}
```

---

# `outputs.tf`

Usually contains outputs.

```hcl
output "public_ip" {
  value = aws_instance.web.public_ip
}
```

---

# `terraform.tfvars`

Contains variable values.

```hcl
instance_ami  = "ami-12345678"
instance_type = "t3.micro"
```

---

# Making Terraform Reusable

Without variables:

```hcl
instance_type = "t3.micro"
```

The configuration is tightly coupled to one value.

With variables:

```hcl
instance_type = var.instance_type
```

The same Terraform configuration can now be reused.

Example:

```text
Same Terraform Code

       ↓

dev.tfvars
t3.micro

       ↓

Development
```

or:

```text
Same Terraform Code

       ↓

prod.tfvars
t3.large

       ↓

Production
```

---

# Sensitive Variables

Variables can be marked:

```hcl
sensitive = true
```

Example:

```hcl
variable "database_password" {
  type      = string
  sensitive = true
}
```

This prevents Terraform from displaying the value in many CLI outputs.

However:

> `sensitive = true` does not necessarily prevent the value from being stored in Terraform state.

State must still be secured.

---

# Common Mistakes

### Hardcoding Everything

Avoid repeating values throughout your Terraform configuration.

Use variables or locals where appropriate.

---

### Confusing Variables and Locals

Remember:

```text
var.name
```

is an input variable.

```text
local.name
```

is a local value.

---

### Putting Secrets in Git

Avoid committing passwords, API keys or other secrets inside:

```text
terraform.tfvars
```

Use secure secret-management methods.

---

### Forgetting Variable Types

Defining types helps Terraform catch incorrect values.

Prefer:

```hcl
variable "instance_count" {
  type = number
}
```

rather than leaving every variable unconstrained.

---

# Best Practices

- Add descriptions to important variables.
- Define appropriate variable types.
- Use meaningful variable names.
- Avoid unnecessary hardcoding.
- Use locals for repeated or calculated values.
- Use outputs for useful resource information.
- Keep sensitive `.tfvars` files out of Git.
- Separate environment-specific values from reusable infrastructure code.
- Mark sensitive inputs and outputs appropriately.

---

# Key Takeaways

- Input variables make Terraform configurations reusable.
- Input variables are referenced using `var.name`.
- Locals are referenced using `local.name`.
- Outputs expose useful Terraform/resource values.
- Terraform supports primitive and complex variable types.
- `.tfvars` files provide variable values separately from definitions.
- Environment-specific `.tfvars` files allow the same code to configure different environments.
- Sensitive values must be handled carefully.
- Variables, locals and outputs are fundamental to reusable Terraform configurations.

---

# Quick Revision

| Type | Syntax | Purpose |
|------|--------|---------|
| Input | `var.name` | Receive values |
| Local | `local.name` | Reuse/calculate internal values |
| Output | `output` | Expose values |

---

# Common Variable Types

| Type | Example |
|------|---------|
| `string` | `"t3.micro"` |
| `number` | `3` |
| `bool` | `true` |
| `list` | `["a", "b"]` |
| `map` | `{ dev = "t3.micro" }` |
| `object` | Structured attributes |

---

# Useful Commands

```bash
terraform plan -var="instance_type=t3.small"
```

```bash
terraform plan -var-file="dev.tfvars"
```

```bash
terraform output
```

```bash
terraform output public_ip
```

---

# Interview Questions

### What are Terraform input variables?

Input variables allow values to be passed into Terraform configurations, making infrastructure code dynamic and reusable.

### How do you reference an input variable?

Using:

```hcl
var.variable_name
```

### What is the difference between a variable and a local?

An input variable receives values from outside the configuration, while a local is an internal value defined and reused within the configuration.

### What is a `.tfvars` file?

A `.tfvars` file contains values for Terraform input variables separately from their variable definitions.

### What are Terraform outputs?

Outputs expose useful information from Terraform, such as resource IDs, IP addresses and DNS names.

### Why use variable types?

Variable types allow Terraform to validate input values and help make configurations more predictable.

### Can sensitive Terraform variables appear in state?

Yes. Marking a variable as `sensitive` hides it from many CLI outputs, but the value may still exist in Terraform state, so the state must be protected.