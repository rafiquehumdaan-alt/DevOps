# Assignment 1 – Deploy WordPress Using Terraform

## Objective

The objective of this assignment was to use **Terraform** to deploy a working WordPress website on AWS.

The infrastructure and application setup included:

- AWS Provider
- EC2 instance
- Security Group
- Amazon Linux 2023
- Apache web server
- PHP
- MariaDB
- WordPress
- EC2 User Data
- Terraform input variables
- Terraform outputs
- Public WordPress endpoint

The infrastructure was provisioned using Terraform rather than manually creating the resources through the AWS Console.

---

# Architecture

```text
                        Internet
                           |
                           | HTTP :80
                           v
                 +-------------------+
                 |  Security Group   |
                 |                   |
                 | Allow HTTP :80    |
                 +---------+---------+
                           |
                           v
                 +-------------------+
                 |   EC2 Instance    |
                 |    t3.micro       |
                 | Amazon Linux 2023 |
                 |                   |
                 | Apache            |
                 | PHP               |
                 | WordPress         |
                 | MariaDB           |
                 +-------------------+
```

WordPress, Apache, PHP and MariaDB all run on the same EC2 instance.

This keeps the architecture simple and appropriate for the assignment.

---

# Project Structure

```text
Assignment-1/
├── main.tf
├── variables.tf
├── outputs.tf
├── user-data.sh
├── .terraform.lock.hcl
├── .gitignore
└── screenshots/
```

Terraform also creates local files/directories such as:

```text
.terraform/
terraform.tfstate
```

These should not normally be committed to Git.

---

# 1. AWS Provider

Terraform requires a provider to communicate with AWS.

The AWS provider was configured in `main.tf`.

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
  region = var.aws_region
}
```

The provider can be thought of as the connection between Terraform and the AWS APIs.

```text
Terraform
    |
    v
AWS Provider
    |
    v
AWS APIs
    |
    v
EC2 / Security Groups / etc.
```

The region was not hardcoded directly into the provider configuration.

Instead, it references:

```hcl
var.aws_region
```

which is defined in `variables.tf`.

---

# 2. Terraform Variables

Input variables were used to make the Terraform configuration reusable and easier to modify.

For example:

```hcl
variable "aws_region" {
  description = "AWS region where the infrastructure will be deployed"
  type        = string
  default     = "eu-west-2"
}
```

The provider can then reference it:

```hcl
region = var.aws_region
```

Instead of hardcoding:

```hcl
region = "eu-west-2"
```

The EC2 instance type was also stored as a variable:

```hcl
variable "instance_type" {
  description = "EC2 instance type for the WordPress server"
  type        = string
  default     = "t3.micro"
}
```

It can then be referenced with:

```hcl
instance_type = var.instance_type
```

### Why use variables?

Variables separate values that may change from the main infrastructure logic.

For example:

```text
variables.tf

instance_type
      |
      v
  "t3.micro"
      |
      v
main.tf

var.instance_type
      |
      v
EC2 Instance
```

This means the infrastructure configuration can be reused with different values.

---

# 3. Finding the Amazon Linux AMI

The EC2 instance requires an Amazon Machine Image (AMI).

Instead of manually finding and hardcoding an AMI ID, Terraform was configured to look up the latest suitable Amazon Linux 2023 AMI.

```hcl
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
```

This introduced the difference between a Terraform **resource** and a **data source**.

### Resource

A resource tells Terraform to create or manage something.

Example:

```hcl
resource "aws_instance" "wordpress"
```

### Data Source

A data source asks Terraform to find/read information about something that already exists.

Example:

```hcl
data "aws_ami" "amazon_linux"
```

In this assignment:

```text
data source
     |
     | Find Amazon Linux AMI
     v
AMI ID
     |
     v
EC2 resource
```

The AMI was then referenced using:

```hcl
ami = data.aws_ami.amazon_linux.id
```

---

# 4. Security Group

A Security Group was created for the WordPress EC2 instance.

The website needed to be publicly accessible over HTTP.

Therefore inbound TCP port **80** was allowed.

```hcl
resource "aws_security_group" "wordpress_sg" {
  name        = "wordpress-sg"
  description = "Allow HTTP traffic"

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "wordpress-sg"
  }
}
```

### Ingress

Ingress controls traffic entering the instance.

```text
Internet
   |
   | HTTP TCP/80
   v
Security Group
   |
   v
EC2
```

`0.0.0.0/0` allows HTTP connections from any IPv4 address.

This is required because the WordPress website needs to be publicly accessible.

### Egress

Egress controls traffic leaving the instance.

Outbound access was required so the EC2 instance could:

- Update packages
- Download software
- Download WordPress

SSH was not required for the assignment, so port 22 did not need to be publicly exposed.

---

# 5. EC2 Instance

The WordPress server was created using an `aws_instance` resource.

```hcl
resource "aws_instance" "wordpress" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = var.instance_type
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.wordpress_sg.id]

  user_data = file("${path.module}/user-data.sh")

  tags = {
    Name = "wordpress-server"
  }
}
```

Several Terraform concepts are demonstrated here.

### AMI reference

```hcl
ami = data.aws_ami.amazon_linux.id
```

Terraform takes the ID returned by the AMI data source and supplies it to EC2.

### Variable reference

```hcl
instance_type = var.instance_type
```

Terraform retrieves the instance type from `variables.tf`.

### Resource reference

```hcl
vpc_security_group_ids = [aws_security_group.wordpress_sg.id]
```

Terraform retrieves the ID of the Security Group it created and attaches it to the EC2 instance.

This creates an implicit dependency.

```text
Security Group
      |
      | Security Group ID
      v
EC2 Instance
```

Terraform understands that the Security Group must exist before it can be attached to the EC2 instance.

---

# 6. Public IP Address

The EC2 instance was configured with:

```hcl
associate_public_ip_address = true
```

This ensures the instance receives a public IPv4 address.

The public IP allows users on the internet to access the WordPress server.

```text
Browser
   |
   v
Public IP
   |
   v
Security Group
   |
   v
EC2
```

---

# 7. EC2 User Data

One of the main requirements of the assignment was to use **User Data or cloud-init** to install the necessary dependencies.

The EC2 resource references:

```hcl
user_data = file("${path.module}/user-data.sh")
```

`file()` reads the contents of the external script.

`${path.module}` refers to the directory containing the Terraform configuration.

Therefore Terraform passes:

```text
user-data.sh
```

to EC2 when the instance launches.

The process is:

```text
Terraform creates EC2
        |
        v
EC2 boots
        |
        v
cloud-init processes User Data
        |
        v
user-data.sh executes
        |
        +--> Install Apache
        |
        +--> Install PHP
        |
        +--> Install MariaDB
        |
        +--> Create database
        |
        +--> Download WordPress
        |
        +--> Configure WordPress
        |
        v
WordPress becomes available
```

This is important because WordPress was not manually installed after creating the server.

The deployment was automated.

---

# 8. Installing Apache, PHP and MariaDB

The User Data script first updated the system:

```bash
dnf update -y
```

Amazon Linux 2023 uses `dnf` as its package manager.

The required packages were then installed.

The main components were:

### Apache

Apache (`httpd`) acts as the web server.

```text
Browser
   |
   v
Apache
   |
   v
WordPress
```

### PHP

WordPress is primarily written in PHP.

PHP allows Apache to execute the WordPress application.

### MariaDB

MariaDB provides the database used by WordPress.

WordPress stores information such as:

- Posts
- Pages
- Users
- Settings
- Comments
- Plugin configuration

inside the database.

The overall application stack is:

```text
Browser
   |
   v
Apache
   |
   v
PHP / WordPress
   |
   v
MariaDB
```

---

# 9. Starting the Services

Apache was started and configured to start automatically:

```bash
systemctl enable --now httpd
```

MariaDB was also started:

```bash
systemctl enable --now mariadb
```

`enable` means the service will automatically start during future system boots.

`--now` starts the service immediately.

---

# 10. Creating the WordPress Database

A database called:

```text
wordpress
```

was created.

A MariaDB user was also created and granted access to the database.

Conceptually:

```text
WordPress
    |
    | Database credentials
    v
MariaDB
    |
    v
wordpress database
```

WordPress uses this database for its persistent application data.

For a production deployment, database credentials should be handled using an appropriate secrets-management solution rather than hardcoded into scripts.

---

# 11. Downloading WordPress

WordPress was downloaded using:

```bash
wget
```

and extracted using:

```bash
tar
```

The WordPress files were then copied into:

```text
/var/www/html/
```

This is Apache's web document directory.

Therefore:

```text
/var/www/html/
      |
      v
WordPress files
      |
      v
Apache serves them
      |
      v
Website
```

---

# 12. Configuring WordPress

WordPress provides:

```text
wp-config-sample.php
```

This was copied to:

```text
wp-config.php
```

The configuration was then updated with the WordPress database:

```text
Database: wordpress
Database User: wordpressuser
Database Host: localhost
```

`localhost` is used because MariaDB and WordPress are running on the same EC2 instance.

---

# 13. Terraform Outputs

The assignment required `outputs.tf` to provide useful instance information.

Three outputs were created.

### Instance ID

```hcl
output "instance_id" {
  description = "ID of the WordPress EC2 instance"
  value       = aws_instance.wordpress.id
}
```

### Public IP

```hcl
output "public_ip" {
  description = "Public IP address of the WordPress server"
  value       = aws_instance.wordpress.public_ip
}
```

### WordPress URL

```hcl
output "wordpress_url" {
  description = "Public URL for the WordPress site"
  value       = "http://${aws_instance.wordpress.public_ip}"
}
```

After deployment, Terraform automatically displayed the real values.

This meant there was no need to manually search the AWS Console for the EC2 public IP.

---

# 14. Terraform Workflow

The standard Terraform workflow was followed.

## Initialise

```bash
terraform init
```

This initialised the Terraform working directory and downloaded the required AWS provider.

---

## Format

```bash
terraform fmt
```

This formatted the Terraform configuration using Terraform's standard formatting.

---

## Validate

```bash
terraform validate
```

This checked whether the Terraform configuration was syntactically and structurally valid.

Successful result:

```text
Success! The configuration is valid.
```

---

## Plan

```bash
terraform plan
```

Terraform compared the desired configuration against the current state.

The plan showed:

```text
Plan: 2 to add, 0 to change, 0 to destroy.
```

The two resources were:

```text
aws_instance.wordpress
aws_security_group.wordpress_sg
```

No infrastructure had been created at this stage.

`terraform plan` was used to preview the changes first.

---

## Apply

```bash
terraform apply
```

After reviewing the plan, the deployment was confirmed.

Terraform returned:

```text
Apply complete! Resources: 2 added, 0 changed, 0 destroyed.
```

Terraform also displayed:

```text
instance_id
public_ip
wordpress_url
```

The WordPress URL was opened in a browser and the WordPress installation page loaded successfully.

This confirmed that the deployment was working.

---

# 15. Terraform State

After applying the configuration, Terraform automatically created:

```text
terraform.tfstate
```

The state file allows Terraform to map resources in the configuration to real infrastructure in AWS.

For example:

```text
Terraform configuration

aws_instance.wordpress
        |
        v
terraform.tfstate
        |
        v
Actual AWS EC2 instance
```

This is how Terraform knows that an EC2 instance already exists when another `terraform plan` is performed.

Without state, Terraform would not have the same record of which real infrastructure belongs to the configuration.

State files can contain sensitive infrastructure information and should not normally be committed to Git.

For team/production environments, Terraform state would normally be stored remotely using an appropriate backend rather than relying on a local state file.

---

# 16. Terraform Lock File

Running:

```bash
terraform init
```

also created:

```text
.terraform.lock.hcl
```

This is different from the state file.

The lock file records the specific provider versions selected by Terraform.

For example:

```text
main.tf
   |
   | AWS provider version constraint
   v
terraform init
   |
   | Select provider
   v
.terraform.lock.hcl
```

Unlike `terraform.tfstate`, `.terraform.lock.hcl` should normally be committed to Git.

This helps ensure consistent provider versions when other users initialise the project.

---

# 17. Git Ignore

Terraform-generated and potentially sensitive files should not all be committed.

Example `.gitignore`:

```gitignore
# Terraform state files
*.tfstate
*.tfstate.*

# Terraform working directory
.terraform/

# Saved Terraform plans
*.tfplan
tfplan

# Variable files that may contain sensitive values
*.tfvars
*.tfvars.json
```

The following should be committed:

```text
main.tf
variables.tf
outputs.tf
user-data.sh
.terraform.lock.hcl
README.md
screenshots/
```

The following should not normally be committed:

```text
terraform.tfstate
terraform.tfstate.backup
.terraform/
```

---

# 18. Destroying the Infrastructure

Once the WordPress deployment had been tested and screenshots had been collected, the infrastructure could be removed using:

```bash
terraform destroy
```

Terraform used its state to identify the resources it was managing.

The expected destruction plan was:

```text
0 to add
0 to change
2 to destroy
```

Terraform then removed:

```text
EC2 instance
Security Group
```

This demonstrates another major benefit of Infrastructure as Code.

The same configuration used to provision the environment can also be used to manage and clean it up.

---

# Screenshots

Recommended evidence for this assignment:

1. **Working WordPress website**
   - Shows the WordPress installation/setup page successfully loading from the EC2 public endpoint.

2. **Successful `terraform apply`**
   - Shows:
   ```text
   Apply complete! Resources: 2 added, 0 changed, 0 destroyed.
   ```
   - Also shows the Terraform outputs.

3. **AWS EC2 Instance**
   - Shows the `wordpress-server` EC2 instance in the running state.

Only a small number of meaningful screenshots are required because the Terraform files themselves document how the infrastructure was configured.

---

# Key Terraform Concepts Demonstrated

## Infrastructure as Code

Instead of manually creating infrastructure through the AWS Console, the desired infrastructure was defined as code.

---

## Providers

The AWS provider allowed Terraform to communicate with AWS.

```text
Terraform → AWS Provider → AWS
```

---

## Resources

Resources represent infrastructure Terraform creates or manages.

Examples:

```text
aws_instance
aws_security_group
```

---

## Data Sources

Data sources retrieve information about existing resources.

The AMI data source was used to find an appropriate Amazon Linux 2023 image.

---

## Variables

Variables allowed configurable values such as the AWS region and EC2 instance type to be separated from the main infrastructure logic.

---

## Resource References

Terraform resources can reference attributes belonging to other resources.

For example:

```hcl
aws_security_group.wordpress_sg.id
```

This allowed the EC2 instance to automatically receive the ID of the Security Group Terraform created.

---

## Dependencies

Because the EC2 instance referenced the Security Group, Terraform understood the dependency between them.

```text
Security Group
      |
      v
EC2 Instance
```

Terraform therefore determines an appropriate resource creation order.

---

## User Data

User Data automated the configuration of the EC2 operating system after launch.

This allowed the deployment to go from:

```text
Empty Amazon Linux EC2
```

to:

```text
Working WordPress server
```

without manually installing WordPress through SSH.

---

## Outputs

Outputs exposed useful information about the infrastructure after deployment.

Examples:

```text
EC2 Instance ID
Public IP
WordPress URL
```

---

## State

Terraform state tracks the relationship between the Terraform configuration and the real AWS infrastructure.

---

## Plan

`terraform plan` allowed infrastructure changes to be reviewed before they were performed.

---

## Apply

`terraform apply` changed the real AWS infrastructure to match the desired Terraform configuration.

---

## Destroy

`terraform destroy` removed the infrastructure managed by Terraform.

---

# What I Learned

This assignment demonstrated how Terraform can manage an AWS deployment from beginning to end.

Instead of manually creating an EC2 instance, configuring its Security Group, finding its public IP and installing the application manually, the infrastructure and initial server configuration were defined as code.

The overall process was:

```text
Write Terraform configuration
        |
        v
terraform init
        |
        v
terraform validate
        |
        v
terraform plan
        |
        v
Review proposed infrastructure
        |
        v
terraform apply
        |
        v
AWS resources created
        |
        v
EC2 launches
        |
        v
User Data executes
        |
        v
Apache + PHP + MariaDB installed
        |
        v
WordPress installed
        |
        v
Public endpoint returned as output
        |
        v
WordPress tested successfully
        |
        v
terraform destroy
        |
        v
Infrastructure removed
```

The assignment provided practical experience with Terraform providers, resources, data sources, variables, outputs, state, dependencies, User Data and the Terraform deployment lifecycle.

It also demonstrated one of the main benefits of Infrastructure as Code: **infrastructure can be created, reproduced, changed and destroyed using version-controlled configuration rather than relying on manual configuration through a graphical console.**