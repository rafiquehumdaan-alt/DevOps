# AWS Notes - Part 7: AWS Networking (VPC)

> Covers:
>
> - Amazon VPC
> - CIDR & Subnet Masks
> - Public vs Private Subnets
> - Internet Gateway (IGW)
> - Bastion Hosts
> - NAT Gateway
> - NAT Gateway vs NAT Instance
> - Network ACLs (NACL)
> - Security Groups vs NACLs
> - VPC Peering
> - VPC Endpoints (PrivateLink)
> - IPv6
> - Egress-Only Internet Gateway

---

# What is Amazon VPC?

A **Virtual Private Cloud (VPC)** is your own private network inside AWS.

Think of it as your own isolated data centre where you control:

- IP address ranges
- Subnets
- Routing
- Internet access
- Firewalls
- Network security

Every AWS resource (EC2, RDS, Lambda, etc.) is deployed into a VPC.

---

# Default VPC

Every AWS account comes with a **Default VPC**.

Features:

- Already configured
- Public subnets
- Internet Gateway attached
- Internet access works immediately

Useful for:

- Learning
- Testing
- Quick deployments

Production environments usually use **custom VPCs**.

---

# Custom VPC

A custom VPC gives complete control over networking.

Example:

```text
VPC (10.0.0.0/16)

├── Public Subnet
│
└── Private Subnet
```

---

# CIDR (Classless Inter-Domain Routing)

CIDR defines the IP address range available inside a network.

Example:

```
10.0.0.0/16
```

This means:

- Network starts at **10.0.0.0**
- Subnet mask is **/16**

---

# Common CIDR Blocks

| CIDR | Number of IP Addresses |
|------|------------------------|
| /16 | 65,536 |
| /24 | 256 |
| /28 | 16 |
| /32 | 1 |

As the CIDR number increases, the number of available IP addresses decreases.

---

# Example VPC

```text
10.0.0.0/16

↓

Public Subnet

10.0.1.0/24

↓

Private Subnet

10.0.2.0/24
```

Each subnet gets its own range of IP addresses.

---

# Public vs Private Subnets

## Public Subnet

A public subnet has a route to the Internet Gateway.

Typical resources:

- Web servers
- Bastion Hosts
- Load Balancers

---

## Private Subnet

A private subnet has **no direct internet access**.

Typical resources:

- Databases
- Internal APIs
- Backend servers

---

# Public vs Private Architecture

```text
                Internet
                    │
          Internet Gateway
                    │
             Public Subnet
                    │
            Web Server / ALB
                    │
             Private Subnet
                    │
           Database / Backend
```

---

# Internet Gateway (IGW)

An Internet Gateway connects your VPC to the public internet.

Without an IGW:

- No internet access
- No public websites
- No SSH from your laptop

---

# Route Tables

Route Tables tell AWS where network traffic should go.

Example:

| Destination | Target |
|------------|---------|
| 10.0.0.0/16 | Local |
| 0.0.0.0/0 | Internet Gateway |

`0.0.0.0/0` means **all internet traffic**.

---

# Bastion Host

A Bastion Host is a secure EC2 instance placed in a public subnet.

It is used to access servers inside private subnets.

Example:

```text
Laptop

↓

Bastion Host

↓

Private EC2
```

Benefits:

- Only one server is exposed to the internet.
- Private servers remain protected.

---

# NAT Gateway

A NAT Gateway allows **private subnet resources to access the internet** without being publicly accessible.

Example:

Private EC2 needs to:

- Install updates
- Download packages
- Access AWS services

It sends traffic through the NAT Gateway.

---

# NAT Gateway Architecture

```text
Private EC2

↓

NAT Gateway

↓

Internet Gateway

↓

Internet
```

The internet **cannot initiate connections back** to the private EC2.

---

# High Availability for NAT Gateway

A NAT Gateway exists within one Availability Zone.

For production:

- Deploy one NAT Gateway per Availability Zone.

This prevents a single point of failure.

---

# NAT Gateway vs NAT Instance

| NAT Gateway | NAT Instance |
|-------------|--------------|
| Managed by AWS | EC2 Instance |
| Highly Available | You manage it |
| Automatically scales | Manual scaling |
| Recommended | Legacy option |

Use **NAT Gateway** unless you have a specific reason not to.

---

# Network ACL (NACL)

A Network ACL is a firewall that protects an entire subnet.

Unlike Security Groups, NACLs operate at the subnet level.

---

# NACL Characteristics

- Stateless
- Allow rules
- Deny rules
- Applies to entire subnet

---

# Security Group vs NACL

| Security Group | NACL |
|---------------|------|
| Stateful | Stateless |
| Instance Level | Subnet Level |
| Allow Rules Only | Allow & Deny Rules |
| Default: Deny Inbound | Default NACL Allows All |

Security Groups are used most frequently.

---

# VPC Peering

VPC Peering allows two VPCs to communicate privately.

Example:

```text
VPC A

↓

VPC Peering

↓

VPC B
```

Traffic never leaves AWS.

---

# VPC Peering Requirements

- Non-overlapping CIDR ranges
- Update Route Tables
- Accept peering request

---

# VPC Endpoints (AWS PrivateLink)

A VPC Endpoint allows private access to AWS services **without using the internet**.

Example:

Instead of:

```
EC2

↓

Internet

↓

S3
```

Use:

```
EC2

↓

VPC Endpoint

↓

S3
```

More secure and often lower latency.

---

# Types of VPC Endpoints

## Gateway Endpoint

Supports:

- Amazon S3
- DynamoDB

Free to use.

---

## Interface Endpoint

Supports most AWS services.

Uses:

- Elastic Network Interfaces (ENIs)

Examples:

- Secrets Manager
- CloudWatch
- Systems Manager

---

# IPv6

IPv6 is the next generation of IP addressing.

Benefits:

- Massive address space
- Better routing
- No IPv4 exhaustion

Example:

```
2001:db8::1
```

---

# IPv6 in AWS

A VPC can have:

- IPv4
- IPv6
- Both (Dual Stack)

Each subnet can also receive IPv6 addresses.

---

# IPv6 Routing

IPv6 uses:

```
::/0
```

instead of:

```
0.0.0.0/0
```

for internet routes.

---

# Egress-Only Internet Gateway

The IPv6 equivalent of a NAT Gateway.

Allows:

- Outbound internet access

Blocks:

- Incoming internet connections

Used to protect private IPv6 resources.

---

# Example Production Architecture

```text
                    Internet
                        │
                Internet Gateway
                        │
        ┌──────────────────────────┐
        │      Public Subnet       │
        │                          │
        │  Application Load        │
        │      Balancer            │
        └────────────┬─────────────┘
                     │
        ┌────────────┴─────────────┐
        │      Private Subnet      │
        │                          │
        │        EC2 Servers       │
        └────────────┬─────────────┘
                     │
              NAT Gateway
                     │
                 Internet
```

---

# Best Practices

- Create custom VPCs for production.
- Keep databases in private subnets.
- Deploy resources across multiple Availability Zones.
- Use NAT Gateways instead of NAT Instances.
- Use Security Groups as the primary firewall.
- Use NACLs for additional subnet-level security.
- Use VPC Endpoints instead of internet access where possible.
- Plan CIDR ranges carefully to avoid overlaps.

---

# Key Takeaways

- A VPC is your private network in AWS.
- CIDR defines the IP range of your network.
- Public subnets can access the internet.
- Private subnets cannot be accessed directly from the internet.
- Internet Gateways provide internet connectivity.
- NAT Gateways allow private resources to access the internet securely.
- Security Groups are stateful; NACLs are stateless.
- VPC Peering connects two VPCs privately.
- VPC Endpoints provide private access to AWS services.
- IPv6 is supported alongside IPv4.

---

# Quick Revision

| Term | Meaning |
|------|---------|
| VPC | Virtual Private Cloud |
| CIDR | IP Address Range |
| Public Subnet | Internet Accessible |
| Private Subnet | Internal Only |
| IGW | Internet Gateway |
| NAT Gateway | Outbound Internet for Private Subnets |
| Bastion Host | Secure Jump Server |
| NACL | Stateless Subnet Firewall |
| Security Group | Stateful Instance Firewall |
| VPC Peering | Private VPC Connection |
| VPC Endpoint | Private AWS Service Access |
| IPv6 | Next Generation IP Protocol |

---

# Interview Questions

### What is a VPC?

A logically isolated virtual network where AWS resources are deployed.

### What is the difference between a public and private subnet?

A public subnet has a route to the Internet Gateway, while a private subnet does not.

### Why use a NAT Gateway?

To allow private resources to access the internet without exposing them to inbound connections.

### What is the difference between a Security Group and a NACL?

Security Groups are stateful and applied to instances, while NACLs are stateless and applied to subnets.

### What is VPC Peering?

A private connection between two VPCs that allows them to communicate using private IP addresses.

### What are VPC Endpoints used for?

To privately connect resources inside a VPC to AWS services without using the public internet.