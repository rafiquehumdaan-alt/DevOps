# Assignment 2 – EC2 Deployment with Cloud-Init

## Objective

The objective of this assignment was to use **Terraform and cloud-init** to deploy an AWS EC2 instance that automatically installs and configures NGINX during its first boot.

The deployment required no manual configuration or SSH access to the EC2 instance.

## Architecture

The deployment consists of:

* AWS EC2 instance running Ubuntu 24.04
* `t3.micro` instance type
* Security group allowing HTTP traffic on port 80
* Public IPv4 address
* Cloud-init configuration passed to EC2 through Terraform `user_data`
* NGINX installed automatically during first boot
* Custom HTML page created automatically by cloud-init

### Deployment Flow

```text
Terraform
    |
    |-- Finds latest Ubuntu AMI
    |-- Creates Security Group
    |-- Creates EC2 Instance
    |
    |-- Passes cloud-init.yaml using user_data
                    |
                    v
                EC2 Boots
                    |
                    v
              Cloud-Init Runs
                    |
            +-------+-------+
            |       |       |
            v       v       v
         Update   Install   Create
        Packages   NGINX    Webpage
                    |
                    v
              Start NGINX
                    |
                    v
             Website Available
```

## Project Structure

```text
Assignment-2/
├── .gitignore
├── README.md
├── cloud-init.yaml
├── main.tf
├── outputs.tf
├── terraform.tfvars
└── variables.tf
```

## Terraform Configuration

### `main.tf`

The main Terraform configuration:

* Configures the AWS provider
* Finds the latest Ubuntu 24.04 AMI
* Creates the security group
* Creates the EC2 instance
* Assigns a public IP address
* Passes the cloud-init configuration to EC2

Cloud-init is passed to the EC2 instance using:

```hcl
user_data = file("${path.module}/cloud-init.yaml")
```

The `file()` function reads the contents of `cloud-init.yaml`, which Terraform then provides to AWS as EC2 user data.

When the instance boots, cloud-init detects and executes this configuration.

### `variables.tf`

Variables are used to make the Terraform configuration reusable rather than hard-coding values directly into the resources.

The project declares variables for:

```text
aws_region
instance_type
```

### `terraform.tfvars`

The values used for this deployment were:

```hcl
aws_region    = "eu-west-2"
instance_type = "t3.micro"
```

Terraform automatically loads values from `terraform.tfvars` and makes them available through references such as:

```hcl
var.aws_region
var.instance_type
```

### `outputs.tf`

Terraform outputs were configured to display useful information after deployment:

* EC2 instance ID
* Public IPv4 address
* Website URL

For example:

```hcl
output "website_url" {
  description = "URL of the NGINX website"
  value       = "http://${aws_instance.web.public_ip}"
}
```

## Cloud-Init Configuration

The `cloud-init.yaml` file performs the operating system configuration automatically when the EC2 instance first boots.

The configuration:

1. Updates the package information
2. Installs NGINX
3. Creates a custom `/var/www/html/index.html`
4. Enables NGINX to start automatically
5. Starts/restarts the NGINX service

Example:

```yaml
#cloud-config

package_update: true

packages:
  - nginx

write_files:
  - path: /var/www/html/index.html
    permissions: '0644'
    content: |
      <!DOCTYPE html>
      <html>
      <head>
          <title>Terraform Cloud-Init</title>
      </head>
      <body>
          <h1>Deployment successful!</h1>
          <p>This EC2 instance was created with Terraform.</p>
          <p>NGINX was installed automatically using cloud-init.</p>
      </body>
      </html>

runcmd:
  - systemctl enable nginx
  - systemctl restart nginx
```

## Terraform Workflow

### 1. Format Configuration

```bash
terraform fmt
```

Formats the Terraform configuration into the standard Terraform format.

### 2. Initialise Terraform

```bash
terraform init
```

Initialises the Terraform working directory and downloads the required AWS provider.

### 3. Validate Configuration

```bash
terraform validate
```

Checks that the Terraform configuration is syntactically valid.

### 4. Preview Infrastructure

```bash
terraform plan
```

The plan showed:

```text
Plan: 2 to add, 0 to change, 0 to destroy.
```

Terraform planned to create:

* 1 EC2 instance
* 1 security group

### 5. Deploy Infrastructure

```bash
terraform apply
```

After reviewing the plan, the deployment was approved.

Terraform successfully created the resources and returned the instance ID, public IP and website URL.

## Testing

The web server was tested from the local terminal using:

```bash
curl http://<PUBLIC-IP>
```

The EC2 instance returned:

```html
<!DOCTYPE html>
<html>
<head>
    <title>Terraform Cloud-Init</title>
</head>
<body>
    <h1>Deployment successful!</h1>
    <p>This EC2 instance was created with Terraform.</p>
    <p>NGINX was installed automatically using cloud-init.</p>
</body>
</html>
```

The same public IP was opened in a web browser and the custom NGINX webpage loaded successfully.

This confirmed that:

* The EC2 instance was reachable over HTTP
* NGINX had been installed successfully
* The custom HTML file had been created
* NGINX was running
* Cloud-init completed the server configuration automatically

No SSH connection or manual software installation was required.

## Deployment Evidence

### Terraform Apply and HTTP Test

![Terraform Apply and Test](screenshots/terraform-apply-and-test.png)

### EC2 Instance Running

![EC2 Instance Running](screenshots/ec2-instance-running.png)

### NGINX Website

![NGINX Website](screenshots/nginx-website.png)

## `user_data` vs `user_data_base64`

Terraform's AWS EC2 resource supports passing startup configuration as user data.

For this project I used:

```hcl
user_data = file("${path.module}/cloud-init.yaml")
```

This allows Terraform to read the cloud-init configuration directly from a file and provide it to the EC2 instance.

`user_data_base64` can instead be used when the supplied user data has already been Base64 encoded.

For this deployment, regular `user_data` was simpler because the cloud-init YAML could be maintained as a separate readable configuration file.

## Terraform vs Cloud-Init

An important concept demonstrated by this assignment is the separation between infrastructure provisioning and instance configuration.

**Terraform** was responsible for provisioning the infrastructure:

```text
EC2 Instance
Security Group
AMI selection
Instance type
Public IP
```

**Cloud-init** was responsible for configuring the operating system:

```text
Package updates
NGINX installation
HTML file creation
NGINX service configuration
```

Using both together allowed the complete web server to be deployed automatically.

## Cleanup

After completing and testing the assignment, the AWS resources can be removed using:

```bash
terraform destroy
```

Terraform reads its state and determines which resources it previously created.

After reviewing the destruction plan, entering:

```text
yes
```

removes the EC2 instance and security group.

## Key Learning Points

* Terraform can provision AWS infrastructure automatically.
* Cloud-init can configure an EC2 operating system during its first boot.
* Terraform can pass cloud-init configuration through EC2 `user_data`.
* `file()` can load an external cloud-init YAML file into Terraform.
* Variables separate configurable values from the main infrastructure configuration.
* Outputs expose useful information after deployment.
* Terraform and cloud-init can work together to create a fully configured server without manual SSH configuration.
* Infrastructure and server configuration can both be stored as code and version controlled.
