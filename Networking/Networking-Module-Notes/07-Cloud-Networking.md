# Networking Notes - Part 7: Cloud Networking (AWS)

> Covers:
>
> - Traditional vs Cloud Networking
> - Virtual Private Cloud (VPC)
> - Subnets
> - Route Tables
> - Internet Gateway (IGW)
> - NAT Gateway
> - Security Groups
> - Network ACLs (NACLs)
> - High Availability
> - AWS Networking Overview

---

# What is Cloud Networking?

Cloud networking is the process of creating and managing networks using cloud services instead of physical networking equipment.

Instead of buying:

- Routers
- Switches
- Firewalls
- Cables

Cloud providers create these resources virtually.

---

# Traditional vs Cloud Networking

### Traditional Networking

```text
Servers

↓

Physical Switches

↓

Physical Routers

↓

Firewall

↓

Internet
```

Requires purchasing and maintaining hardware.

---

### Cloud Networking

```text
EC2

↓

VPC

↓

Route Tables

↓

Internet Gateway

↓

Internet
```

Everything is created using software.

---

# What is a VPC?

A **VPC (Virtual Private Cloud)** is your own private network inside AWS.

Think of it as your own isolated section of the AWS cloud.

Within a VPC you can create:

- Subnets
- Route Tables
- Internet Gateways
- NAT Gateways
- Security Groups
- EC2 Instances

---

# VPC Example

```text
AWS Cloud

↓

VPC

↓

Public Subnet

Private Subnet
```

Resources inside one VPC are isolated from other customers' VPCs.

---

# What is a Subnet?

A subnet is a smaller network inside a VPC.

Common types:

### Public Subnet

Has a route to the Internet Gateway.

Typical resources:

- Web Servers
- Load Balancers
- Bastion Hosts

---

### Private Subnet

No direct route to the internet.

Typical resources:

- Databases
- Internal APIs
- Backend services

---

# Public vs Private Subnet

| Public | Private |
|----------|----------|
| Internet access | No direct internet access |
| Public IPs | Private IPs |
| Web servers | Databases |
| Bastion hosts | Internal services |

---

# Route Tables

A route table tells AWS where network traffic should go.

Example:

| Destination | Target |
|-------------|---------|
| Local | VPC |
| 0.0.0.0/0 | Internet Gateway |

Every subnet must be associated with a route table.

---

# Internet Gateway (IGW)

An **Internet Gateway** connects a VPC to the public internet.

Without an IGW:

- Public subnets cannot reach the internet.
- Internet users cannot access your public resources.

---

# Internet Gateway Example

```text
Internet

↓

Internet Gateway

↓

Public Subnet

↓

EC2
```

---

# NAT Gateway

A **NAT Gateway** allows resources in a private subnet to access the internet **without allowing inbound internet connections**.

Example uses:

- Software updates
- Downloading packages
- Accessing AWS services

---

# NAT Gateway Example

```text
Private EC2

↓

NAT Gateway

↓

Internet Gateway

↓

Internet
```

The internet cannot initiate connections back to the private EC2 instance.

---

# Security Groups

Security Groups act as **virtual firewalls** for AWS resources.

They control:

- Inbound traffic
- Outbound traffic

Characteristics:

- Stateful
- Attached to resources (e.g. EC2)

Example:

Allow:

- SSH (22)
- HTTPS (443)

Block everything else.

---

# Security Group Example

```text
Internet

↓

Security Group

↓

EC2 Instance
```

---

# Network ACLs (NACLs)

Network ACLs protect entire subnets.

Characteristics:

- Stateless
- Applied to subnets
- Separate inbound and outbound rules

---

# Security Groups vs NACLs

| Security Group | NACL |
|----------------|------|
| Protects instances | Protects subnets |
| Stateful | Stateless |
| Allow rules only | Allow and deny rules |
| Applied to EC2 | Applied to subnet |

---

# High Availability

AWS networking is designed for high availability.

Example:

```text
VPC

↓

Public Subnet (AZ A)

↓

Public Subnet (AZ B)

↓

Load Balancer
```

If one Availability Zone fails, the application can continue running in another.

---

# Typical AWS Network

```text
Internet

↓

Internet Gateway

↓

Application Load Balancer

↓

Public Subnet

↓

Private Subnet

↓

Database
```

This is a common architecture for web applications.

---

# Real AWS Example

```text
Internet

↓

CloudFront

↓

Application Load Balancer

↓

EC2 Instances

↓

RDS Database
```

Each service has a specific role:

- CloudFront → Content Delivery
- ALB → Load balancing
- EC2 → Compute
- RDS → Database

---

# Best Practices

- Use public subnets only for internet-facing resources.
- Keep databases in private subnets.
- Use NAT Gateways for outbound internet access from private subnets.
- Apply least-privilege rules in Security Groups.
- Deploy resources across multiple Availability Zones.
- Use separate Security Groups for different application tiers.

---

# Common Mistakes

### Placing Databases in Public Subnets

Databases should almost always be deployed in private subnets to reduce exposure to the internet.

---

### Allowing SSH from Anywhere

Avoid rules such as:

```text
0.0.0.0/0 → Port 22
```

Instead, restrict SSH access to trusted IP addresses or use a bastion host.

---

### Confusing Security Groups and NACLs

Remember:

- **Security Groups** protect individual resources and are stateful.
- **NACLs** protect subnets and are stateless.

---

# Key Takeaways

- Cloud networking replaces physical networking hardware with software-defined resources.
- A VPC is your private network in AWS.
- Subnets divide a VPC into smaller networks.
- Public subnets have internet access; private subnets do not.
- Internet Gateways connect VPCs to the internet.
- NAT Gateways provide outbound internet access for private subnets.
- Security Groups protect resources.
- NACLs protect subnets.
- High availability is achieved by deploying across multiple Availability Zones.

---

# Quick Revision

| AWS Component | Purpose |
|---------------|---------|
| VPC | Private network |
| Public Subnet | Internet-facing resources |
| Private Subnet | Internal resources |
| Route Table | Determines traffic flow |
| Internet Gateway | Internet connectivity |
| NAT Gateway | Outbound internet for private subnets |
| Security Group | Stateful firewall for resources |
| NACL | Stateless firewall for subnets |

---

# Typical AWS Architecture

```text
Internet

↓

CloudFront

↓

Application Load Balancer

↓

Public Subnet

↓

Private EC2

↓

Database
```

---

# Interview Questions

### What is a VPC?

A Virtual Private Cloud (VPC) is an isolated virtual network within AWS where you can launch and manage cloud resources securely.

### What is the difference between a public and private subnet?

A public subnet has a route to an Internet Gateway, allowing internet access. A private subnet has no direct internet route and is typically used for internal resources such as databases.

### What is the purpose of a NAT Gateway?

A NAT Gateway allows resources in private subnets to initiate outbound internet connections while preventing unsolicited inbound connections from the internet.

### What is the difference between a Security Group and a Network ACL?

A Security Group is a stateful firewall applied to individual resources, while a Network ACL is a stateless firewall applied to entire subnets.

### Why are applications often deployed across multiple Availability Zones?

Deploying across multiple Availability Zones improves high availability and fault tolerance by ensuring the application continues running even if one Availability Zone experiences an outage.