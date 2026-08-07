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