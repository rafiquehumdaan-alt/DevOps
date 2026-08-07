# AWS Notes - Part 1: EC2 & Compute

> Covers:
>
> - Amazon Compute
> - Amazon EC2
> - EC2 Sizing & Configuration
> - EC2 User Data
> - Running a Web Server on EC2
> - EC2 Instance Types
> - EC2 Purchasing Options

---

# What is Cloud Computing?

Cloud computing is the delivery of IT resources (servers, storage, networking, databases and software) over the internet instead of owning physical hardware.

Instead of purchasing and maintaining physical servers, you rent resources from AWS and only pay for what you use.

### Benefits

- No upfront hardware costs
- Pay-as-you-go pricing
- Easily scale resources up or down
- Highly available infrastructure
- Global data centres

---

# Amazon Compute Services

AWS provides several compute services depending on your requirements.

| Service | Purpose |
|----------|----------|
| EC2 | Virtual machines |
| Lambda | Serverless functions |
| ECS | Docker container orchestration |
| EKS | Kubernetes |
| Fargate | Serverless containers |
| Elastic Beanstalk | Simple application deployment |

EC2 is the most commonly used compute service and forms the foundation for many AWS workloads.

---

# What is Amazon EC2?

Amazon Elastic Compute Cloud (EC2) is AWS's virtual machine service.

It allows you to launch virtual servers within minutes while choosing:

- Operating System
- CPU
- RAM
- Storage
- Network configuration

AWS manages the physical infrastructure while you manage the operating system and applications.

---

# EC2 Components

Every EC2 instance normally consists of:

| Component | Purpose |
|------------|----------|
| AMI | Operating system template |
| Instance Type | CPU and memory specification |
| EBS Volume | Persistent storage |
| Security Group | Virtual firewall |
| Key Pair | Secure SSH authentication |
| Elastic IP (Optional) | Static public IP address |

---

# EC2 Lifecycle

```text
Launch
   ↓
Pending
   ↓
Running
   ↓
Stopping
   ↓
Stopped
   ↓
Starting
   ↓
Running
   ↓
Terminate
```

### Running
- Server is powered on.
- Compute charges apply.

### Stopped
- Server is powered off.
- Compute charges stop.
- Storage charges continue.

### Terminated
- Instance is permanently deleted.
- Cannot be recovered.

---

# Regions & Availability Zones

Every EC2 instance exists inside:

```text
Region
   ↓
Availability Zone
      ↓
EC2 Instance
```

Example:

```text
eu-west-2 (London)

├── eu-west-2a
├── eu-west-2b
└── eu-west-2c
```

Deploying resources across multiple Availability Zones improves availability and fault tolerance.

---

# Launching an EC2 Instance

Typical process:

1. Choose an AMI
2. Select an Instance Type
3. Configure networking
4. Attach storage
5. Configure Security Groups
6. Select or create a Key Pair
7. Launch the instance

---

# Amazon Machine Image (AMI)

An AMI (Amazon Machine Image) is a template used to launch EC2 instances.

It contains:

- Operating System
- Installed software
- Configuration
- Startup settings

Common examples include:

- Ubuntu
- Amazon Linux
- Windows Server
- Red Hat Enterprise Linux

You can also create custom AMIs containing your own software and configuration.

---

# EC2 Instance Types

An instance type defines the hardware allocated to your virtual machine.

It determines:

- Number of CPUs
- Memory
- Network performance
- Storage performance

Choosing the correct instance type helps balance performance and cost.

---

# Common Instance Families

## T Series (Burstable)

Examples:

- t2.micro
- t3.micro
- t3.small

Best for:

- Learning
- Development
- Small websites
- Testing

Advantages:

- Low cost
- Burstable CPU performance
- Eligible for AWS Free Tier (selected sizes)

---

## M Series (General Purpose)

Balanced CPU and memory.

Best for:

- Web servers
- Business applications
- Medium workloads

---

## C Series (Compute Optimised)

Higher CPU performance.

Best for:

- Build servers
- Scientific computing
- Gaming servers
- Video encoding

---

## R Series (Memory Optimised)

Large amounts of RAM.

Best for:

- Databases
- Analytics
- In-memory caching

---

## I Series (Storage Optimised)

Very fast storage performance.

Best for:

- High IOPS workloads
- Databases

---

## G & P Series (GPU)

GPU-powered instances.

Best for:

- Artificial Intelligence
- Machine Learning
- Rendering
- Video processing

---

# Example Instance Sizes

| Instance | vCPU | RAM | Typical Use |
|-----------|------|-----|-------------|
| t3.micro | 2 | 1 GB | Learning / Free Tier |
| t3.small | 2 | 2 GB | Small applications |
| t3.medium | 2 | 4 GB | Development |
| m5.large | 2 | 8 GB | Production web servers |
| c5.large | 2 | 4 GB | Compute-intensive workloads |
| r5.large | 2 | 16 GB | Databases |

---

# Choosing an Instance

Consider:

- How much CPU is required?
- How much memory is required?
- Do you need a GPU?
- How much storage is required?
- Expected traffic or users?

Oversized instances waste money.

Undersized instances reduce performance.

---

# EC2 User Data

User Data is a script that automatically runs when an EC2 instance launches.

Common uses:

- Install software
- Update packages
- Configure applications
- Start services

Automating server setup ensures consistency and saves time.

---

# Example User Data Script

```bash
#!/bin/bash

apt update

apt install nginx -y

systemctl enable nginx

systemctl start nginx
```

This script:

- Updates packages
- Installs Nginx
- Enables Nginx
- Starts the web server automatically

---

# Running a Web Server on EC2

Typical workflow:

```text
Launch EC2
      ↓
Run User Data Script
      ↓
Install Nginx
      ↓
Allow HTTP (Port 80)
      ↓
Visit Public IP
      ↓
Website Loads
```

---

# Required Security Group Rules

| Port | Protocol | Purpose |
|------|----------|----------|
| 22 | SSH | Remote administration |
| 80 | HTTP | Website traffic |
| 443 | HTTPS | Secure website traffic |

---

# EC2 Purchasing Options

AWS offers several pricing models depending on workload.

## On-Demand

- Pay by the second
- No long-term commitment
- Most flexible
- Best for development and testing

---

## Reserved Instances

- Commit for 1 or 3 years
- Significant discounts
- Best for predictable production workloads

---

## Savings Plans

- Commit to a fixed hourly spend
- Similar savings to Reserved Instances
- More flexible

---

## Spot Instances

- Use AWS spare capacity
- Up to 90% cheaper
- Can be interrupted at any time

Best for:

- Batch jobs
- CI/CD
- Testing
- Temporary workloads

---

## Dedicated Hosts

A physical server dedicated entirely to your organisation.

Used when:

- Licensing requires dedicated hardware
- Regulatory requirements exist

Most expensive option.

---

# Purchasing Option Comparison

| Option | Cost | Interruptible | Best For |
|---------|------|---------------|----------|
| On-Demand | High | No | Development & Testing |
| Reserved | Low | No | Long-term Production |
| Savings Plans | Low | No | Predictable workloads |
| Spot | Very Low | Yes | Temporary workloads |
| Dedicated Host | Highest | No | Compliance & Licensing |

---

# Best Practices

- Choose the smallest suitable instance.
- Use IAM Roles instead of storing AWS credentials.
- Restrict access with Security Groups.
- Automate setup with User Data.
- Stop unused instances to reduce costs.
- Take EBS snapshots before major changes.
- Tag resources (Name, Environment, Owner).
- Deploy production workloads across multiple Availability Zones.

---

# Key Takeaways

- EC2 provides virtual machines in AWS.
- AMIs are templates used to launch instances.
- Instance Types define CPU, RAM and performance.
- User Data automates server configuration during launch.
- EBS provides persistent storage.
- Security Groups act as stateful virtual firewalls.
- On-Demand is flexible.
- Reserved and Savings Plans reduce long-term costs.
- Spot Instances are the cheapest but can be interrupted.

---

# Quick Revision

| Term | Meaning |
|------|---------|
| EC2 | Virtual Machine |
| AMI | Operating System Template |
| EBS | Persistent Block Storage |
| User Data | Startup Automation Script |
| Security Group | Stateful Firewall |
| Instance Type | Hardware Specification |
| Availability Zone | Isolated AWS Data Centre |
| Spot Instance | Cheap, Interruptible Instance |
| Reserved Instance | Discounted Long-Term Instance |
| On-Demand | Pay-As-You-Go Pricing |

---

# Interview Questions

### What is EC2?

A virtual machine service provided by AWS that allows users to run applications in the cloud.

### What is an AMI?

A template containing an operating system and configuration used to launch EC2 instances.

### What is User Data?

A startup script that automatically configures an EC2 instance when it launches.

### What is the difference between stopping and terminating an EC2 instance?

Stopping powers off the instance while preserving storage. Terminating permanently deletes the instance.

### Which instance family is best for databases?

The R Series because it is memory optimised.

### Which pricing option is best for temporary workloads?

Spot Instances, provided interruptions are acceptable.



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



# AWS Notes - Part 3: Storage

> Covers:
>
> - Amazon EBS (Elastic Block Store)
> - Amazon Machine Images (AMI)
> - Amazon EFS (Elastic File System)

---

# AWS Storage Overview

AWS offers multiple storage services designed for different use cases.

| Service | Type | Typical Use |
|----------|------|-------------|
| EBS | Block Storage | EC2 boot drives and application storage |
| EFS | Network File Storage | Shared storage across multiple EC2 instances |
| S3 | Object Storage | Files, backups, static websites (covered later) |

---

# Amazon EBS (Elastic Block Store)

Amazon EBS is **persistent block storage** designed for EC2 instances.

Think of it like a **virtual hard drive (SSD/HDD)** attached to a virtual machine.

---

# Key Features

- Persistent storage
- High performance
- Data survives instance reboots
- Can be resized
- Supports encryption
- Can be backed up using snapshots

---

# Persistent Storage

One of EBS's biggest advantages is persistence.

If an EC2 instance stops and starts, the EBS volume remains intact.

Example:

```text
EC2 Instance
      │
      ▼
   EBS Volume
```

Stopping the EC2 instance does **not** delete the EBS volume.

However, if the instance is terminated, the root EBS volume may also be deleted unless configured otherwise.

---

# EBS Volume Types

AWS offers different EBS volume types depending on performance requirements.

| Volume Type | Best For |
|-------------|----------|
| gp3 | General-purpose SSD (recommended) |
| gp2 | Older general-purpose SSD |
| io1 / io2 | High-performance databases |
| st1 | Frequently accessed HDD workloads |
| sc1 | Low-cost archival HDD storage |

For most workloads, **gp3** is the recommended choice.

---

# Availability Zones

An EBS volume exists within **one Availability Zone**.

Example:

```text
eu-west-2a

EC2
 │
 ▼
EBS
```

You cannot directly attach an EBS volume to an EC2 instance in another Availability Zone.

---

# EBS Snapshots

Snapshots are backups of EBS volumes.

Snapshots are stored in Amazon S3 (managed by AWS).

Benefits:

- Backup data
- Disaster recovery
- Restore deleted volumes
- Create new volumes
- Copy data between regions

---

# Snapshot Workflow

```text
EBS Volume

↓

Snapshot

↓

Stored by AWS

↓

Restore New Volume
```

Snapshots are incremental, meaning only changed blocks are saved after the first snapshot.

This reduces storage costs.

---

# EBS Encryption

EBS supports encryption using AWS Key Management Service (KMS).

Encryption protects:

- Stored data
- Snapshots
- Data moving between EC2 and EBS

Encryption is recommended for production workloads.

---

# Resizing EBS Volumes

EBS volumes can be resized without replacing them.

You can increase:

- Storage capacity
- Performance
- IOPS (depending on volume type)

After resizing, the operating system may also need the filesystem expanded.

---

# Amazon Machine Image (AMI)

An AMI (Amazon Machine Image) is a template used to launch EC2 instances.

It contains:

- Operating System
- Installed software
- Configuration
- Startup settings

---

# Types of AMIs

### AWS Managed

Provided by AWS.

Examples:

- Amazon Linux
- Ubuntu
- Windows Server

---

### Marketplace AMIs

Created by third-party vendors.

Often include:

- Security software
- Databases
- Monitoring tools
- Commercial applications

Some Marketplace AMIs incur additional charges.

---

### Custom AMIs

Created by you.

Useful when you've already configured:

- Software
- Users
- Security settings
- Updates

Instead of configuring every new server manually, launch new instances from the custom AMI.

---

# Why Use Custom AMIs?

Without a custom AMI:

```text
Launch Server

↓

Install Software

↓

Configure Server

↓

Repeat
```

With a custom AMI:

```text
Launch Custom AMI

↓

Server Ready
```

This improves consistency and saves time.

---

# Amazon EFS (Elastic File System)

Amazon EFS is a fully managed **network file system**.

Unlike EBS, multiple EC2 instances can access the same EFS file system simultaneously.

---

# Key Features

- Shared storage
- Highly available
- Automatically scales
- Managed by AWS
- Supports Linux workloads

---

# EFS Architecture

```text
          EFS
        /  |  \
      EC2 EC2 EC2
```

Every EC2 instance sees the same files.

---

# EBS vs EFS

| Feature | EBS | EFS |
|----------|-----|-----|
| Storage Type | Block Storage | Network File Storage |
| Multiple EC2 Instances | No | Yes |
| Availability Zone | Single AZ | Multiple AZs |
| Performance | Very High | High |
| Typical Use | Single server | Shared storage |

---

# When to Use EBS

Use EBS when:

- Hosting a database
- Running a web server
- Booting an EC2 instance
- High-performance storage is required

---

# When to Use EFS

Use EFS when:

- Multiple EC2 instances need the same files
- Shared application storage
- Shared web content
- Container storage
- Home directories

---

# Example Architecture

```text
            Internet
                │
                ▼
        Load Balancer
             │
     ┌───────┴────────┐
     ▼                ▼
   EC2              EC2
      \            /
       \          /
        ▼        ▼
            Amazon EFS
```

Both EC2 instances access the same files.

---

# Best Practices

- Use **gp3** volumes for most workloads.
- Take regular EBS snapshots.
- Enable encryption for production.
- Create custom AMIs after configuring servers.
- Use EFS when multiple EC2 instances need shared storage.
- Avoid storing shared application files on individual EBS volumes.

---

# Key Takeaways

- **EBS** is persistent block storage attached to EC2.
- EBS volumes exist in a single Availability Zone.
- Snapshots back up EBS volumes.
- AMIs are templates used to launch EC2 instances.
- Custom AMIs speed up deployments.
- **EFS** is shared file storage accessible by multiple EC2 instances.
- EFS automatically scales as storage requirements grow.

---

# Quick Revision

| Term | Meaning |
|------|---------|
| EBS | Persistent Block Storage |
| Snapshot | Backup of an EBS Volume |
| AMI | EC2 Launch Template |
| Custom AMI | Your own configured server image |
| EFS | Shared Network File System |
| gp3 | Recommended General-Purpose SSD |

---

# Interview Questions

### What is Amazon EBS?

Persistent block storage used primarily by EC2 instances.

### What is the difference between EBS and EFS?

EBS is attached to a single EC2 instance, while EFS can be shared across multiple EC2 instances simultaneously.

### What is an AMI?

A template containing an operating system and configuration used to launch EC2 instances.

### Why use EBS Snapshots?

To back up volumes, recover data, migrate between regions, and create new volumes.

### When would you choose EFS over EBS?

When multiple EC2 instances need to access the same files at the same time.



# AWS Notes - Part 4: Load Balancing & Scalability

> Covers:
>
> - Scalability
> - High Availability
> - Elastic Load Balancers (ELB)
> - Application Load Balancer (ALB)
> - Network Load Balancer (NLB)
> - Target Groups
> - Health Checks
> - Sticky Sessions
> - SSL/TLS
> - Auto Scaling Groups (ASG)
> - CloudWatch Scaling Policies

---

# What is Scalability?

Scalability is the ability of a system to handle increasing demand without affecting performance.

Example:

- 10 users → Server works fine
- 1,000 users → Server slows down

A scalable system can handle the increased traffic.

---

# Types of Scalability

AWS supports two types:

- Vertical Scaling
- Horizontal Scaling

---

# Vertical Scaling (Scaling Up)

Increase the power of a single server.

Example:

```text
2 vCPU
4 GB RAM

↓

8 vCPU
32 GB RAM
```

Advantages:

- Easy to implement
- No application changes required

Disadvantages:

- Has hardware limits
- Downtime may be required
- Expensive for very large workloads

Typical Uses:

- Databases
- Small applications

---

# Horizontal Scaling (Scaling Out)

Instead of making one server bigger, add more servers.

Example:

```text
        Users
          │
          ▼
    Load Balancer
     │    │    │
     ▼    ▼    ▼
   EC2   EC2   EC2
```

Advantages:

- Better fault tolerance
- Easier to handle large traffic
- No single point of failure

Typical Uses:

- Web applications
- APIs
- Microservices

---

# High Availability (HA)

High Availability means keeping applications available even if a server fails.

AWS achieves this using:

- Multiple EC2 instances
- Multiple Availability Zones
- Load Balancers
- Auto Scaling

---

# Example High Availability Architecture

```text
               Internet
                   │
                   ▼
        Application Load Balancer
            │              │
            ▼              ▼
      EC2 (AZ-A)      EC2 (AZ-B)
```

If one Availability Zone fails, the application continues running.

---

# What is Load Balancing?

A Load Balancer distributes incoming traffic across multiple servers.

Instead of every request reaching one server, traffic is shared.

---

# Why Use a Load Balancer?

Benefits:

- Improves availability
- Prevents server overload
- Supports horizontal scaling
- Automatically removes failed servers
- Single public entry point
- SSL termination
- Better performance

---

# Elastic Load Balancer (ELB)

Elastic Load Balancer is AWS's managed load balancing service.

AWS handles:

- Scaling
- Availability
- Monitoring
- Health checks
- Maintenance

You simply attach your EC2 instances.

---

# Types of AWS Load Balancers

| Load Balancer | Layer | Best For |
|---------------|-------|----------|
| Application Load Balancer (ALB) | Layer 7 | HTTP/HTTPS |
| Network Load Balancer (NLB) | Layer 4 | TCP/UDP |
| Gateway Load Balancer (GWLB) | Layer 3 | Network appliances |

Most web applications use **ALB**.

---

# Application Load Balancer (ALB)

Works at **Layer 7 (Application Layer)**.

It understands HTTP and HTTPS traffic.

Can make routing decisions based on:

- URL path
- Hostname
- HTTP headers
- Query strings

---

# ALB Example

```text
example.com/api

↓

API Server

example.com/images

↓

Image Server
```

One ALB can route requests to different applications.

---

# Target Groups

A Target Group is a collection of resources that receive traffic from a Load Balancer.

Targets can include:

- EC2 Instances
- ECS Tasks
- Lambda Functions
- IP Addresses

Example:

```text
ALB

↓

Target Group

↓

EC2
EC2
EC2
```

---

# Health Checks

The Load Balancer regularly checks if targets are healthy.

Example:

```text
GET /

↓

HTTP 200

Healthy
```

If a server fails:

```text
HTTP 500

↓

Removed from rotation
```

Traffic is only sent to healthy servers.

---

# Health Check Components

Common settings:

- Protocol (HTTP/HTTPS)
- Port
- Path (e.g. /health)
- Healthy threshold
- Unhealthy threshold
- Timeout
- Interval

---

# Load Balancer Security Groups

Typically:

### ALB Security Group

Allow:

- HTTP (80)
- HTTPS (443)

From:

```
0.0.0.0/0
```

---

### EC2 Security Group

Allow:

- HTTP (80)

Source:

```
ALB Security Group
```

Instead of exposing EC2 directly to the internet.

---

# Network Load Balancer (NLB)

Works at **Layer 4 (Transport Layer).**

Supports:

- TCP
- UDP
- TLS

Advantages:

- Extremely fast
- Millions of requests
- Static IP addresses
- Low latency

Used for:

- Gaming
- Financial systems
- High-performance networking

---

# ALB vs NLB

| Feature | ALB | NLB |
|----------|-----|-----|
| Layer | 7 | 4 |
| HTTP Routing | Yes | No |
| TCP Support | Limited | Yes |
| Static IP | No | Yes |
| Performance | High | Extremely High |
| Best For | Websites & APIs | High-performance networking |

---

# Sticky Sessions

Normally:

```text
User

↓

Request 1 → Server A

Request 2 → Server B

Request 3 → Server C
```

With Sticky Sessions:

```text
User

↓

Server A

↓

Server A

↓

Server A
```

The user continues communicating with the same server.

Useful for:

- Shopping carts
- User sessions
- Legacy applications

---

# SSL / TLS

SSL/TLS encrypts data between users and servers.

Without HTTPS:

```text
Browser

↓

Plain Text

↓

Server
```

Anyone could intercept the traffic.

---

With HTTPS:

```text
Browser

↓

Encrypted Data

↓

Server
```

Data remains secure.

---

# SSL Certificates

AWS Load Balancers use certificates stored in **AWS Certificate Manager (ACM).**

Benefits:

- Free AWS certificates
- Automatic renewal
- Easy integration

---

# Server Name Indication (SNI)

SNI allows multiple HTTPS websites to share one Load Balancer.

Example:

```
api.company.com

shop.company.com

blog.company.com
```

Each website can use its own SSL certificate.

---

# Connection Draining (Deregistration Delay)

When removing an EC2 instance:

Without connection draining:

```text
User

↓

Connection Lost
```

With connection draining:

Existing users finish their requests before the server is removed.

No interrupted sessions.

---

# Auto Scaling Groups (ASG)

An Auto Scaling Group automatically manages EC2 instances.

It can:

- Launch instances
- Remove instances
- Replace failed instances

Automatically.

---

# Why Use Auto Scaling?

Benefits:

- High Availability
- Reduced costs
- Automatic scaling
- Fault tolerance
- Better performance

---

# ASG Example

```text
Users Increase

↓

CPU 80%

↓

Launch New EC2

↓

Traffic Shared
```

---

# Minimum, Desired & Maximum Capacity

Example:

```
Minimum: 2

Desired: 3

Maximum: 8
```

AWS always tries to maintain the desired number of instances.

---

# Auto Scaling with Load Balancer

```text
              Internet
                   │
                   ▼
      Application Load Balancer
           │      │      │
           ▼      ▼      ▼
        EC2     EC2     EC2
           ▲
           │
   Auto Scaling Group
```

New EC2 instances are automatically registered with the Load Balancer.

---

# CloudWatch

CloudWatch monitors AWS resources.

Common metrics:

- CPU Usage
- Memory (custom)
- Network Traffic
- Disk Activity

CloudWatch can trigger scaling actions.

---

# Scaling Policies

## Target Tracking

Example:

Maintain:

```
CPU = 50%
```

AWS automatically adjusts capacity.

Recommended for most workloads.

---

## Step Scaling

Example:

```
CPU > 70%

↓

Add 1 Instance

CPU > 90%

↓

Add 3 Instances
```

---

## Scheduled Scaling

Scale based on time.

Example:

```
9AM

↓

Launch Extra Servers

6PM

↓

Remove Servers
```

Useful for predictable workloads.

---

# Auto Scaling Activities

ASG continuously:

- Launches new instances
- Terminates excess instances
- Replaces unhealthy instances
- Registers instances with the Load Balancer

Everything happens automatically.

---

# Real-World Example

An online store experiences heavy traffic during Black Friday.

Architecture:

```text
Internet

↓

Application Load Balancer

↓

Auto Scaling Group

↓

EC2
EC2
EC2
EC2
```

Traffic increases.

CloudWatch detects high CPU.

ASG launches additional EC2 instances.

Traffic decreases later.

ASG automatically removes unnecessary servers to reduce costs.

---

# Best Practices

- Deploy across multiple Availability Zones.
- Use Application Load Balancers for web applications.
- Enable health checks.
- Keep EC2 instances stateless where possible.
- Store user sessions externally (Redis, DynamoDB, etc.).
- Use Target Tracking scaling policies for most workloads.
- Monitor applications using CloudWatch.
- Use HTTPS for all internet-facing applications.

---

# Key Takeaways

- Vertical Scaling increases server size.
- Horizontal Scaling adds more servers.
- High Availability keeps applications online during failures.
- Load Balancers distribute incoming traffic.
- ALBs operate at Layer 7.
- NLBs operate at Layer 4.
- Health Checks ensure traffic only reaches healthy servers.
- Sticky Sessions keep users connected to the same server.
- SSL/TLS encrypts network traffic.
- Auto Scaling Groups automatically adjust EC2 capacity.
- CloudWatch metrics trigger scaling events.

---

# Quick Revision

| Term | Meaning |
|------|---------|
| Vertical Scaling | Increase server size |
| Horizontal Scaling | Add more servers |
| High Availability | Minimise downtime |
| ELB | AWS Load Balancer |
| ALB | Layer 7 Load Balancer |
| NLB | Layer 4 Load Balancer |
| Target Group | Collection of backend resources |
| Health Check | Verifies server health |
| Sticky Session | User stays on same server |
| ACM | AWS Certificate Manager |
| ASG | Auto Scaling Group |
| CloudWatch | AWS Monitoring Service |

---

# Interview Questions

### What is the difference between Vertical and Horizontal Scaling?

Vertical Scaling upgrades a single server, while Horizontal Scaling adds additional servers.

### Why use an Application Load Balancer?

It distributes HTTP/HTTPS traffic and supports advanced routing based on URLs, hostnames and headers.

### What is a Target Group?

A collection of resources (such as EC2 instances) that receive traffic from a Load Balancer.

### What happens if an EC2 instance fails a health check?

The Load Balancer stops sending traffic to it until it becomes healthy again.

### What is the purpose of an Auto Scaling Group?

To automatically launch, replace and terminate EC2 instances based on demand or health.


# AWS Notes - Part 5: Containers

> Covers:
>
> - Containers
> - Docker
> - Docker Images
> - Docker vs Virtual Machines
> - Amazon ECS
> - Amazon ECR
> - Amazon EKS
> - ECS Auto Scaling
> - Load Balancer Integration

---

# What are Containers?

A **container** is a lightweight package that contains everything an application needs to run.

A container includes:

- Application code
- Runtime
- Libraries
- Dependencies
- Configuration

This allows the application to run consistently on any machine.

---

# Why Use Containers?

Without containers:

"My application works on my computer, but not on yours."

Different operating systems or software versions can cause problems.

With containers:

The application behaves the same everywhere because everything it needs is packaged together.

---

# Benefits of Containers

- Fast startup
- Lightweight
- Portable
- Consistent environments
- Easy to scale
- Great for DevOps and CI/CD

---

# What is Docker?

Docker is the most popular container platform.

It allows developers to:

- Build containers
- Run containers
- Share containers
- Deploy containers consistently

Docker is not AWS-specific and can run almost anywhere.

---

# Docker Components

| Component | Purpose |
|-----------|----------|
| Docker Image | Blueprint for a container |
| Docker Container | Running instance of an image |
| Dockerfile | Instructions to build an image |
| Docker Engine | Software that runs containers |

---

# Docker Image

A Docker Image is a read-only template.

It contains:

- Application
- Dependencies
- Configuration

Think of it like a blueprint.

Example:

```
Ubuntu Image

↓

Nginx Installed

↓

Application Copied

↓

Final Image
```

---

# Docker Container

A container is a running instance of a Docker Image.

One image can create many containers.

Example:

```text
Docker Image

↓

Container 1

Container 2

Container 3
```

---

# Where are Docker Images Stored?

Docker Images are stored in **Container Registries**.

Examples:

- Docker Hub
- Amazon ECR
- GitHub Container Registry

Developers pull images from a registry before running them.

---

# Docker vs Virtual Machines

## Virtual Machine

```text
Application

↓

Operating System

↓

Hypervisor

↓

Physical Server
```

Each VM has its own operating system.

---

## Container

```text
Application

↓

Container Runtime

↓

Host Operating System

↓

Physical Server
```

Containers share the host operating system.

---

# Docker vs Virtual Machines

| Docker | Virtual Machine |
|----------|----------------|
| Lightweight | Heavier |
| Starts in seconds | Takes longer to boot |
| Shares Host OS | Full Operating System |
| Lower resource usage | Higher resource usage |
| Highly portable | Less portable |

---

# Why Containers are Faster

Containers do **not** need to boot an operating system.

They simply start the application.

This makes them ideal for:

- Microservices
- CI/CD
- Scaling
- Cloud deployments

---

# Containers on AWS

AWS provides several services for running containers.

| Service | Purpose |
|----------|----------|
| ECS | AWS container orchestration |
| EKS | Kubernetes |
| ECR | Docker image registry |
| Fargate | Serverless containers |

---

# Amazon ECS

Amazon Elastic Container Service (ECS) is AWS's container orchestration service.

It manages:

- Container deployment
- Scheduling
- Scaling
- Monitoring

You focus on your application rather than managing containers manually.

---

# ECS Components

| Component | Purpose |
|-----------|----------|
| Cluster | Collection of compute resources |
| Task Definition | Blueprint for containers |
| Task | Running container |
| Service | Keeps tasks running |
| Container | Your application |

---

# ECS Cluster

An ECS Cluster is a group of compute resources that run containers.

A cluster can use:

- EC2
- AWS Fargate

---

# ECS Launch Types

## EC2 Launch Type

You manage:

- EC2 Instances
- Operating System
- Patching
- Scaling

AWS manages ECS.

More control.

Lower cost.

---

## Fargate Launch Type

AWS manages:

- Servers
- Operating System
- Scaling
- Infrastructure

You simply provide your container.

Less management.

Higher cost.

---

# ECS Task Definition

A Task Definition describes how a container should run.

It includes:

- Docker Image
- CPU
- Memory
- Ports
- Environment Variables
- IAM Role

Think of it as the blueprint for your containers.

---

# ECS Service

An ECS Service ensures the required number of containers are always running.

Example:

Desired Tasks:

```
3
```

If one crashes:

```
AWS automatically launches another.
```

---

# IAM Roles for ECS

Containers often need access to AWS services.

Instead of storing AWS credentials inside containers, assign an IAM Role.

Example permissions:

- Read from S3
- Write to CloudWatch
- Access DynamoDB
- Read Secrets Manager

This is much more secure.

---

# ECS with Load Balancer

A common production architecture:

```text
Internet

↓

Application Load Balancer

↓

ECS Service

↓

Container
Container
Container
```

The Load Balancer distributes requests across containers.

---

# ECS Service Auto Scaling

ECS Services can automatically increase or decrease the number of running containers.

Scaling can be based on:

- CPU Usage
- Memory Usage
- Request Count

Example:

```text
CPU > 70%

↓

Launch More Containers

↓

Traffic Balanced
```

---

# Amazon ECR

Amazon Elastic Container Registry (ECR) is AWS's private Docker image registry.

Instead of Docker Hub, AWS customers often store images in ECR.

Benefits:

- Private repositories
- Secure
- AWS integration
- IAM authentication
- High availability

---

# ECR Workflow

```text
Developer

↓

Build Docker Image

↓

Push to ECR

↓

ECS Pulls Image

↓

Container Starts
```

---

# Amazon EKS

Amazon Elastic Kubernetes Service (EKS) is AWS's managed Kubernetes service.

AWS manages:

- Kubernetes Control Plane
- High Availability
- Updates

You manage:

- Worker Nodes (or Fargate)
- Applications

---

# Why Kubernetes?

Kubernetes helps manage large container environments.

Features include:

- Scaling
- Self-healing
- Rolling updates
- Service discovery
- Load balancing

---

# EKS Architecture

```text
Users

↓

Load Balancer

↓

Kubernetes Cluster

↓

Pods

↓

Containers
```

---

# EKS Node Types

## Managed Node Groups

AWS manages:

- Node provisioning
- Updates
- Scaling

Recommended for most users.

---

## Self-Managed Nodes

You manage:

- EC2 Instances
- Updates
- Configuration

Provides greater control.

---

## AWS Fargate

Containers run without managing any servers.

Simplest option.

---

# ECS vs EKS

| ECS | EKS |
|------|------|
| AWS Native | Kubernetes |
| Easier to learn | More complex |
| AWS-specific | Cloud agnostic |
| Less management | More flexibility |

---

# ECS vs Fargate

| ECS EC2 | ECS Fargate |
|-----------|-------------|
| Manage EC2 | AWS manages servers |
| Lower cost | Higher cost |
| More control | Less management |

---

# Real-World Example

A company builds a web application.

Workflow:

```text
Developer

↓

Build Docker Image

↓

Push to Amazon ECR

↓

ECS Service

↓

Application Load Balancer

↓

Users
```

If traffic increases:

- ECS launches more containers.
- The Load Balancer automatically distributes traffic.

---

# Best Practices

- Store Docker Images in ECR.
- Use IAM Roles instead of AWS credentials.
- Keep container images small.
- Use Load Balancers for production workloads.
- Enable Auto Scaling.
- Store secrets in AWS Secrets Manager.
- Use Fargate if you don't want to manage servers.

---

# Key Takeaways

- Containers package applications and their dependencies.
- Docker is the most popular container platform.
- Images are templates used to create containers.
- Containers are lightweight compared to Virtual Machines.
- ECS is AWS's native container orchestration service.
- ECR stores Docker images.
- EKS is AWS's managed Kubernetes service.
- Fargate allows you to run containers without managing servers.

---

# Quick Revision

| Term | Meaning |
|------|---------|
| Container | Packaged application |
| Docker | Container platform |
| Docker Image | Blueprint for a container |
| Docker Container | Running instance of an image |
| ECS | AWS Container Service |
| ECR | Docker Image Registry |
| EKS | Managed Kubernetes |
| Fargate | Serverless Containers |
| Task Definition | Blueprint for ECS Tasks |
| ECS Service | Keeps containers running |

---

# Interview Questions

### What is a container?

A lightweight package containing an application and all of its dependencies.

### What is Docker?

A platform used to build, package and run containers.

### What is Amazon ECR?

A private Docker image registry provided by AWS.

### What is the difference between ECS and EKS?

ECS is AWS's native container orchestration service, while EKS is AWS's managed Kubernetes service.

### When would you choose Fargate?

When you want to run containers without managing EC2 instances or the underlying infrastructure.

### Why are containers preferred over Virtual Machines?

They are lighter, start faster, use fewer resources and are easier to scale.


# AWS Notes - Part 6: Serverless

> Covers:
>
> - Serverless Computing
> - AWS Lambda
> - Benefits of Lambda
> - Supported Programming Languages
> - Event-Driven Architecture
> - Real-World Example

---

# What is Serverless?

Serverless is a cloud computing model where you write and deploy code **without managing servers**.

You don't need to:

- Launch EC2 instances
- Install operating systems
- Patch servers
- Scale infrastructure

AWS automatically manages all of this.

> **Note:** "Serverless" doesn't mean there are no servers. It means **AWS manages the servers instead of you.**

---

# Traditional vs Serverless

## Traditional

```text
Application

↓

EC2 Instance

↓

Operating System

↓

AWS Infrastructure
```

You manage the EC2 instance and operating system.

---

## Serverless

```text
Application Code

↓

AWS Lambda

↓

AWS Infrastructure
```

AWS manages everything except your code.

---

# What is AWS Lambda?

AWS Lambda is AWS's serverless compute service.

It allows you to run code **only when it's needed**.

Lambda functions are triggered by events instead of running continuously.

---

# How Lambda Works

```text
Event

↓

Lambda Function

↓

Code Executes

↓

Returns Result
```

After the function finishes, AWS stops it automatically.

---

# Event-Driven Computing

Lambda is **event-driven**, meaning code only runs when something triggers it.

Common triggers include:

- API Gateway request
- File uploaded to S3
- CloudWatch Event
- DynamoDB change
- SNS notification
- SQS message

---

# Example

A user uploads an image.

```text
Upload Image

↓

Amazon S3

↓

Lambda Triggered

↓

Resize Image

↓

Save Thumbnail
```

No server is running all day waiting for uploads.

---

# Why Use AWS Lambda?

Benefits include:

- No server management
- Automatic scaling
- Pay only when code runs
- High availability
- Fast deployment
- Easy integration with AWS services

---

# Automatic Scaling

Suppose:

- 1 person visits your website.
- Later, 10,000 people visit at the same time.

Lambda automatically creates enough instances of your function to handle the load.

No manual scaling is required.

---

# Pay Per Use

Unlike EC2:

```text
EC2

Running

↓

Pay for entire runtime
```

Lambda:

```text
Function Runs

↓

Pay only for execution time
```

If the function doesn't run, you pay nothing for compute.

---

# Lambda Execution Time

Lambda functions are designed for **short-lived tasks**.

Examples:

- Process uploaded files
- Send emails
- Validate data
- Handle API requests

They are **not** designed for long-running applications.

---

# Common Lambda Use Cases

- REST APIs
- Image processing
- File conversion
- Scheduled tasks
- Automation
- Data processing
- Chatbots
- Backend services

---

# Supported Programming Languages

AWS Lambda supports several languages, including:

- Python
- JavaScript (Node.js)
- Java
- C#
- Go
- Ruby
- PowerShell

You can also use custom runtimes if required.

---

# Lambda and API Gateway

One of the most common architectures is:

```text
User

↓

API Gateway

↓

Lambda

↓

Database
```

API Gateway receives the request.

Lambda processes it.

The response is sent back to the user.

---

# Lambda and S3

Another common architecture:

```text
File Upload

↓

Amazon S3

↓

Lambda

↓

Process File

↓

Store Result
```

Example:

- Resize uploaded images
- Convert PDFs
- Scan files for malware

---

# Lambda and CloudWatch

CloudWatch can trigger Lambda on a schedule.

Example:

```text
Every Day

↓

CloudWatch Event

↓

Lambda

↓

Generate Report
```

Useful for automation tasks.

---

# Lambda Permissions

Lambda functions often need access to AWS services.

Instead of storing credentials, assign an **IAM Role**.

Example permissions:

- Read from S3
- Write to DynamoDB
- Send CloudWatch Logs
- Access Secrets Manager

This follows AWS security best practices.

---

# Advantages of Lambda

- No infrastructure management
- Automatic scaling
- Highly available
- Cost-effective
- Fast deployment
- Integrates with many AWS services

---

# Limitations of Lambda

- Not suitable for long-running applications
- Limited execution time
- Cold starts may introduce slight delays
- Less control over the underlying environment

---

# EC2 vs Lambda

| EC2 | Lambda |
|------|---------|
| Manage servers | AWS manages servers |
| Runs continuously | Runs only when triggered |
| Pay while running | Pay only when executed |
| Manual scaling | Automatic scaling |
| Full OS access | No OS access |

---

# Real-World Example

A company allows users to upload profile pictures.

Architecture:

```text
User

↓

Amazon S3

↓

AWS Lambda

↓

Resize Image

↓

Save Thumbnail

↓

User Downloads Thumbnail
```

No servers need to be running permanently.

---

# Best Practices

- Keep Lambda functions small and focused.
- Give each function a single responsibility.
- Use IAM Roles instead of credentials.
- Store configuration in environment variables.
- Monitor functions using CloudWatch.
- Keep deployment packages small.
- Use API Gateway for serverless APIs.

---

# Key Takeaways

- Serverless means AWS manages the infrastructure.
- AWS Lambda runs code in response to events.
- You only pay when your code executes.
- Lambda automatically scales with demand.
- Lambda integrates with many AWS services.
- IAM Roles provide secure access to AWS resources.
- Lambda is ideal for short-lived, event-driven workloads.

---

# Quick Revision

| Term | Meaning |
|------|---------|
| Serverless | AWS manages the servers |
| Lambda | Serverless compute service |
| Event | Something that triggers a Lambda function |
| API Gateway | Sends HTTP requests to Lambda |
| IAM Role | Secure permissions for Lambda |
| CloudWatch | Monitoring and scheduled events |

---

# Interview Questions

### What is serverless computing?

A cloud model where the cloud provider manages the infrastructure, allowing developers to focus only on writing code.

### What is AWS Lambda?

AWS Lambda is a serverless compute service that runs code in response to events without requiring server management.

### How does Lambda scale?

Lambda automatically creates additional function instances as demand increases.

### How are you charged for Lambda?

You are charged based on the number of requests and the execution duration of your function.

### When should you use Lambda instead of EC2?

Use Lambda for short-lived, event-driven workloads such as APIs, automation, file processing and scheduled tasks.


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


# AWS Notes - Part 8: Route 53 & DNS

> Covers:
>
> - DNS Basics
> - Amazon Route 53
> - Hosted Zones
> - Public vs Private Hosted Zones
> - DNS Record Types
> - TTL (Time To Live)
> - CNAME vs Alias Records
> - Routing Policies
> - Health Checks
> - Domain Registrars vs DNS Providers

---

# What is DNS?

**DNS (Domain Name System)** translates human-readable domain names into IP addresses.

Instead of remembering:

```
18.168.24.15
```

You can simply type:

```
example.com
```

DNS then finds the correct IP address for you.

Think of DNS as the **phone book of the internet**.

---

# How DNS Works

```text
User enters:

www.example.com

        │
        ▼
DNS Resolver

        │
        ▼
DNS Server

        │
        ▼
Returns IP Address

        │
        ▼
Browser connects to server
```

---

# What is Amazon Route 53?

Amazon Route 53 is AWS's managed DNS service.

It is used to:

- Register domain names
- Manage DNS records
- Route traffic
- Perform health checks
- Improve application availability

---

# Why is it Called Route 53?

The name comes from **Port 53**, which is the standard port used by DNS.

---

# Hosted Zones

A Hosted Zone stores the DNS records for a domain.

Example:

```
example.com
```

Inside the Hosted Zone you create records such as:

- A Record
- AAAA Record
- CNAME
- MX
- TXT

---

# Public Hosted Zone

A Public Hosted Zone is used for internet-facing websites.

Example:

```
example.com

↓

Public Website
```

Anyone on the internet can resolve the domain.

---

# Private Hosted Zone

A Private Hosted Zone only works inside a VPC.

Example:

```
database.internal

↓

Private VPC
```

Not accessible from the public internet.

Useful for:

- Internal APIs
- Databases
- Private applications

---

# Common DNS Record Types

| Record | Purpose |
|---------|----------|
| A | Maps a domain to an IPv4 address |
| AAAA | Maps a domain to an IPv6 address |
| CNAME | Maps one domain to another |
| Alias | AWS version of CNAME |
| MX | Mail servers |
| TXT | Verification & security records |
| NS | Name Servers |
| SOA | Zone information |

---

# A Record

Maps a hostname directly to an IPv4 address.

Example:

```
example.com

↓

18.168.20.50
```

---

# AAAA Record

Maps a hostname to an IPv6 address.

Example:

```
example.com

↓

2001:db8::100
```

---

# CNAME Record

Creates an alias from one hostname to another.

Example:

```
blog.example.com

↓

website.example.com
```

Important:

- Only works for subdomains.
- Cannot be used for the root domain.

---

# Alias Record

Alias Records are AWS-specific.

They behave like CNAME records but can point directly to AWS resources.

Example:

```
example.com

↓

Application Load Balancer

or

CloudFront

or

S3 Static Website
```

Advantages:

- Free DNS queries for AWS resources
- Can be used on the root domain
- Automatically updates if AWS changes IP addresses

---

# CNAME vs Alias

| CNAME | Alias |
|---------|--------|
| Standard DNS record | AWS-specific |
| Cannot use root domain | Supports root domain |
| Points to another hostname | Points to AWS resources |
| Extra DNS lookup | Optimised by AWS |

---

# TTL (Time To Live)

TTL tells DNS resolvers how long to cache a DNS record.

Example:

```
TTL = 300 seconds
```

The record is cached for **5 minutes**.

---

# TTL Example

High TTL:

```
86400 seconds (24 hours)
```

Advantages:

- Faster DNS lookups
- Fewer DNS requests

Disadvantages:

- Changes take longer to update.

---

Low TTL:

```
60 seconds
```

Advantages:

- DNS changes update quickly.

Disadvantages:

- More DNS lookups.

---

# Route 53 Routing Policies

Routing Policies determine how Route 53 responds to DNS queries.

---

## Simple Routing

Returns a single record.

Example:

```
example.com

↓

Server A
```

Used for:

- Single web server
- Simple websites

---

## Weighted Routing

Splits traffic based on percentages.

Example:

```
80%

↓

Server A

20%

↓

Server B
```

Useful for:

- Gradual deployments
- A/B testing
- Canary releases

---

## Latency Routing

Routes users to the AWS Region with the lowest network latency.

Example:

UK user:

↓

London Region

US user:

↓

Virginia Region

Improves user experience.

---

## Geolocation Routing

Routes traffic based on the user's geographic location.

Example:

UK Users

↓

London Website

US Users

↓

Virginia Website

Useful for:

- Local content
- Legal requirements
- Regional websites

---

## Geoproximity Routing

Routes users based on physical distance from AWS Regions.

Can shift traffic using **bias values**.

Useful for:

- Traffic balancing
- Expanding into new regions

---

## IP-Based Routing

Routes traffic based on the client's IP address.

Useful for:

- Corporate networks
- Specific customer groups
- Regional restrictions

---

## Multi-Value Routing

Returns multiple healthy IP addresses.

Unlike a Load Balancer:

- DNS provides multiple IPs.
- Client chooses one.

Improves availability.

---

# Route 53 Health Checks

Health Checks monitor whether an application is available.

Example:

```
Website

↓

HTTP Request

↓

200 OK

↓

Healthy
```

If unhealthy:

```
500 Error

↓

Traffic redirected
```

Health Checks can be combined with Routing Policies.

---

# Domain Registrar vs DNS Provider

These are two different services.

---

## Domain Registrar

Registers your domain name.

Examples:

- GoDaddy
- Namecheap
- Cloudflare Registrar
- Amazon Route 53

---

## DNS Provider

Manages your DNS records.

Examples:

- Amazon Route 53
- Cloudflare DNS
- GoDaddy DNS

A domain can be registered with one company and use DNS from another.

---

# Example

```
Domain Registered At:

GoDaddy

↓

DNS Managed By:

Amazon Route 53
```

This is a very common setup.

---

# Example Architecture

```text
User

↓

example.com

↓

Route 53

↓

Application Load Balancer

↓

EC2 Instances
```

---

# Best Practices

- Use Alias Records for AWS resources.
- Keep production DNS records organised.
- Use Health Checks for critical applications.
- Use Weighted Routing for gradual deployments.
- Use Latency Routing for global applications.
- Use Private Hosted Zones for internal services.
- Choose sensible TTL values based on how often records change.

---

# Key Takeaways

- DNS translates domain names into IP addresses.
- Route 53 is AWS's managed DNS service.
- Hosted Zones store DNS records.
- Public Hosted Zones are internet accessible.
- Private Hosted Zones only work inside a VPC.
- Alias Records are preferred for AWS resources.
- Routing Policies determine where traffic is sent.
- Health Checks improve application availability.
- Domain registration and DNS hosting are separate services.

---

# Quick Revision

| Term | Meaning |
|------|---------|
| DNS | Domain Name System |
| Route 53 | AWS DNS Service |
| Hosted Zone | Stores DNS Records |
| A Record | Maps to IPv4 |
| AAAA Record | Maps to IPv6 |
| CNAME | Maps one hostname to another |
| Alias | AWS-specific DNS record |
| TTL | DNS Cache Time |
| Health Check | Monitors application availability |
| Registrar | Owns the domain |
| DNS Provider | Manages DNS records |

---

# Interview Questions

### What is DNS?

A system that translates domain names into IP addresses so devices can locate servers on a network.

### What is Amazon Route 53?

AWS's managed DNS service used for domain registration, DNS management, routing and health checks.

### What is the difference between a CNAME and an Alias Record?

A CNAME points one hostname to another and cannot be used on the root domain. An Alias Record is AWS-specific, supports the root domain and can point directly to AWS resources.

### What is TTL?

TTL (Time To Live) defines how long DNS resolvers cache a record before checking for updates.

### Can a domain be registered with GoDaddy but use Route 53 for DNS?

Yes. Domain registration and DNS hosting are separate services, so they can be provided by different companies.

### What are Route 53 Routing Policies used for?

They control how Route 53 responds to DNS queries, allowing traffic to be routed based on factors such as latency, geography, health or weighted percentages.


