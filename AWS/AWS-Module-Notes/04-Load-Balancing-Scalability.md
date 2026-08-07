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