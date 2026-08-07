# AWS Notes - Part 2: Security Groups & Cloud Networking Basics

> Covers:
>
> - Security Groups
> - Stateful Firewalls
> - Inbound & Outbound Rules
> - Referencing Security Groups
> - Common Network Ports
> - IPv4 vs IPv6
> - Public vs Private IP Addresses
> - Elastic IP Addresses

---

# What is a Security Group?

A **Security Group (SG)** is AWS's virtual firewall that controls network traffic to and from an AWS resource (such as an EC2 instance).

Think of it as a firewall attached directly to the instance.

Every EC2 instance must belong to at least one Security Group.

---

# What Does a Security Group Do?

A Security Group controls:

- Who can connect to your server
- Which ports are open
- Which protocols are allowed
- Which IP addresses can access your resources

Without a Security Group, no traffic can reach your EC2 instance.

---

# Inbound vs Outbound Rules

## Inbound Rules

Control traffic **coming into** the EC2 instance.

Examples:

- SSH (22)
- HTTP (80)
- HTTPS (443)

Example:

```text
Internet
     │
     ▼
Security Group
     │
     ▼
EC2 Instance
```

---

## Outbound Rules

Control traffic **leaving** the EC2 instance.

Examples:

- Downloading updates
- Connecting to databases
- Accessing AWS services
- Browsing the internet

By default, AWS allows **all outbound traffic**.

---

# Security Groups are Stateful

Security Groups are **stateful**.

This means:

If inbound traffic is allowed, the return traffic is automatically allowed.

Example:

```text
Laptop
   │ SSH (22)
   ▼
EC2

EC2
   │ Response
   ▼
Laptop
```

You **do not** need to create a separate outbound rule for the reply.

---

# Default Security Group Behaviour

### Inbound

❌ Everything denied

Unless you explicitly allow it.

### Outbound

✅ Everything allowed

Unless you change the rules.

---

# Security Group Rules

Each rule contains:

- Protocol
- Port
- Source or Destination

Example:

| Type | Protocol | Port | Source |
|------|----------|------|---------|
| SSH | TCP | 22 | Your IP |
| HTTP | TCP | 80 | 0.0.0.0/0 |
| HTTPS | TCP | 443 | 0.0.0.0/0 |

---

# Security Group Best Practices

### Don't Allow SSH From Anywhere

Avoid:

```text
0.0.0.0/0
```

Better:

```text
Your Home IP
```

Only allow yourself to connect.

---

### Only Open Required Ports

If your application only needs:

- HTTP
- HTTPS

Don't leave ports like:

- FTP
- Telnet
- RDP

open unnecessarily.

---

### Use Multiple Security Groups

Example:

Web Server SG

- HTTP
- HTTPS

Database SG

- MySQL only

This provides better security.

---

# Referencing Other Security Groups

Instead of allowing an IP address, you can allow another Security Group.

Example:

```text
Internet

↓

ALB Security Group

↓

Web Server Security Group

↓

Database Security Group
```

Example rule:

Database Security Group

Allow MySQL (3306)

Source:

```
Web Server Security Group
```

instead of

```
0.0.0.0/0
```

This is much more secure.

---

# Why Reference Security Groups?

Benefits:

- More secure
- Easier to manage
- Automatically works when instances change IP addresses
- Common production practice

---

# Common Ports to Know

| Port | Protocol | Purpose |
|------|----------|----------|
| 20/21 | FTP | File Transfer |
| 22 | SSH | Linux Remote Access |
| 23 | Telnet | Legacy Remote Access |
| 25 | SMTP | Email Sending |
| 53 | DNS | Domain Name Service |
| 80 | HTTP | Websites |
| 110 | POP3 | Email Retrieval |
| 143 | IMAP | Email Retrieval |
| 443 | HTTPS | Secure Websites |
| 3389 | RDP | Windows Remote Desktop |
| 3306 | MySQL | MySQL Database |
| 5432 | PostgreSQL | PostgreSQL Database |
| 27017 | MongoDB | MongoDB Database |

---

# IPv4

IPv4 addresses are 32-bit addresses.

Example:

```
192.168.1.25
```

Around **4.3 billion** addresses exist.

IPv4 is still the most commonly used addressing system.

---

# IPv6

IPv6 addresses are 128-bit addresses.

Example:

```
2001:db8:85a3::8a2e:370:7334
```

Advantages:

- Massive address space
- Better routing
- No address shortage

---

# IPv4 vs IPv6

| IPv4 | IPv6 |
|-------|-------|
| 32-bit | 128-bit |
| ~4.3 Billion addresses | Virtually unlimited |
| Decimal | Hexadecimal |
| NAT commonly used | NAT generally unnecessary |

---

# Public IP Addresses

A Public IP can be reached from the internet.

Example:

```
3.10.125.20
```

Used for:

- Websites
- APIs
- Bastion Hosts
- Public EC2 instances

Public IPs must be unique worldwide.

---

# Private IP Addresses

Private IPs are only usable inside private networks.

Examples:

```
10.0.0.15

172.16.5.20

192.168.1.30
```

Private IPs cannot be accessed directly from the internet.

Used for:

- Databases
- Internal servers
- Application servers

---

# Public vs Private IP

| Public IP | Private IP |
|------------|------------|
| Accessible from internet | Internal only |
| Globally unique | Reusable in many networks |
| Used for web servers | Used for backend resources |

---

# Elastic IP (EIP)

An Elastic IP is a **static public IPv4 address** provided by AWS.

Normally:

When an EC2 instance stops and starts, its public IP changes.

Elastic IPs solve this problem.

---

# Why Use an Elastic IP?

Benefits:

- Permanent public IP
- Can move between EC2 instances
- Useful for DNS records
- No need to update client configurations

---

# Elastic IP Example

Without Elastic IP

```text
Today

EC2

↓

18.135.x.x


Tomorrow

EC2 Restart

↓

52.88.x.x
```

IP address changes.

---

With Elastic IP

```text
EC2 Restart

↓

18.135.x.x

(Same IP)
```

The address remains the same.

---

# When Should You Use Elastic IPs?

Good use cases:

- Bastion Hosts
- Public-facing servers
- Legacy applications
- Fixed DNS records

Avoid using Elastic IPs unless necessary.

AWS encourages using:

- Load Balancers
- Route 53
- CloudFront

instead of assigning Elastic IPs directly to application servers.

---

# Security Group Example Architecture

```text
Internet

↓

Security Group

Allow:

22 (SSH)
80 (HTTP)
443 (HTTPS)

↓

EC2 Web Server
```

---

# Production Example

Application Load Balancer

Security Group

Allow:

80

443

↓

Web Server Security Group

Allow traffic only from the ALB Security Group

↓

Database Security Group

Allow MySQL only from the Web Server Security Group

No resource is directly exposed unless required.

---

# Best Practices

- Follow the Principle of Least Privilege.
- Only open required ports.
- Restrict SSH access to trusted IP addresses.
- Reference Security Groups instead of IP addresses where possible.
- Keep databases in private subnets.
- Avoid exposing databases to the internet.
- Use Elastic IPs only when a static public IP is genuinely required.

---

# Key Takeaways

- Security Groups act as **stateful virtual firewalls**.
- Inbound rules control incoming traffic.
- Outbound rules control outgoing traffic.
- All inbound traffic is denied by default.
- All outbound traffic is allowed by default.
- Security Groups can reference other Security Groups.
- Public IPs are internet accessible.
- Private IPs are only accessible within private networks.
- Elastic IPs provide permanent public IPv4 addresses.

---

# Quick Revision

| Term | Meaning |
|------|---------|
| Security Group | Stateful virtual firewall |
| Inbound Rule | Controls incoming traffic |
| Outbound Rule | Controls outgoing traffic |
| Public IP | Internet accessible address |
| Private IP | Internal network address |
| Elastic IP | Static public IPv4 address |
| IPv4 | 32-bit addressing |
| IPv6 | 128-bit addressing |

---

# Interview Questions

### What is a Security Group?

A virtual firewall that controls inbound and outbound traffic for AWS resources.

### Are Security Groups stateful?

Yes. Return traffic is automatically allowed.

### What's the difference between a Public IP and a Private IP?

A Public IP is accessible from the internet. A Private IP is only accessible within a private network.

### Why would you use an Elastic IP?

To assign a permanent public IP address that does not change when an EC2 instance stops and starts.

### Why should databases usually not have public IP addresses?

For security. Databases should normally only be accessible from application servers within the VPC.