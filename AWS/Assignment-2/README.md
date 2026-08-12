# AWS Assignment 2 - Application Load Balancer

## Overview

This assignment focused on building a highly available web application architecture using an Application Load Balancer (ALB). Instead of hosting a website on a single EC2 instance, I deployed multiple web servers behind an ALB, allowing incoming traffic to be distributed automatically between healthy instances. I also secured the environment using Security Groups, configured HTTPS using AWS Certificate Manager (ACM), and implemented an Auto Scaling Group to demonstrate self-healing infrastructure.

This assignment introduced several AWS services that are commonly used together in production environments and significantly expanded on the networking concepts learned in Assignment 1.

---

# Objectives

The goals of this assignment were to:

- Deploy two EC2 instances in the same VPC.
- Install and configure NGINX automatically using EC2 User Data.
- Configure an Application Load Balancer.
- Create a Target Group and register both EC2 instances.
- Configure ALB health checks.
- Secure the infrastructure using Security Groups.
- Verify that traffic is distributed between both web servers.
- Configure HTTPS using AWS Certificate Manager.
- Implement an Auto Scaling Group using a Launch Template.
- Demonstrate automatic recovery when an EC2 instance fails.

---



# AWS Services Used

- Amazon EC2
- Application Load Balancer (ALB)
- Target Groups
- Security Groups
- AWS Certificate Manager (ACM)
- Launch Templates
- Auto Scaling Groups (ASG)
- Route 53 Hosted Zone

---

# Step 1 - Creating Security Groups

The first step was creating two separate Security Groups.

## Application Load Balancer Security Group

The ALB Security Group was configured to allow incoming traffic from anywhere on:

- HTTP (Port 80)
- HTTPS (Port 443)

This allows users on the internet to access the load balancer.

## EC2 Security Group

The EC2 Security Group was configured differently.

Instead of allowing HTTP traffic from the internet, it only allows HTTP traffic from the ALB Security Group.

This means users cannot access the EC2 instances directly. Every request must first pass through the Application Load Balancer, which is a common security practice used in production environments.

---

# Step 2 - Launching EC2 Instances

Two EC2 instances running Amazon Linux 2023 were launched.

Both instances were deployed inside the same VPC but across different Availability Zones to improve availability.

Rather than configuring the servers manually, EC2 User Data was used so that each instance automatically:

- Updated the operating system.
- Installed NGINX.
- Created a custom HTML page.
- Enabled NGINX.
- Started the web server.

Each server displayed different content ("Server 1" and "Server 2") so that I could verify traffic was being distributed correctly by the load balancer.

---

# Step 3 - Creating the Target Group

A Target Group was created to manage the backend EC2 instances.

Configuration:

- Target Type: Instances
- Protocol: HTTP
- Port: 80
- Health Check Path: /

Both EC2 instances were registered with the Target Group.

The Target Group performs continuous health checks on every registered server.

If a server fails the health checks, it is automatically removed from the load balancer until it becomes healthy again.

---

# Step 4 - Creating the Application Load Balancer

An Internet-facing Application Load Balancer was created.

The ALB was deployed across two Availability Zones using public subnets.

Configuration included:

- HTTP Listener (Port 80)
- Forwarding traffic to the Target Group

Once the ALB became active, the Target Group began performing health checks against both EC2 instances.

Both instances eventually changed from:

- Initial

to:

- Healthy

indicating that the web servers were responding successfully.

---

# Step 5 - Testing the Load Balancer

The DNS name of the ALB was opened in a web browser.

Refreshing the page showed responses from both:

- Server 1
- Server 2

This demonstrated that the Application Load Balancer was successfully distributing incoming traffic between multiple backend servers.

---

# Step 6 - Configuring HTTPS

To secure the application, an SSL certificate was requested using AWS Certificate Manager (ACM).

A certificate was requested for:

- humdaan.co.uk
- *.humdaan.co.uk

The certificate was validated using DNS validation through Cloudflare.

Once validated, ACM issued the certificate.

A new HTTPS listener was then added to the Application Load Balancer using the ACM certificate.

The existing HTTP listener was modified to permanently redirect all traffic to HTTPS using an HTTP 301 redirect.

This ensures users automatically access the application securely.

---

# Step 7 - Route 53

A public Route 53 Hosted Zone was created for the domain.

Although the domain currently continues using Cloudflare as its DNS provider, creating the Hosted Zone demonstrated how Route 53 is configured and how it can be integrated with an Application Load Balancer using ALIAS records.

---

# Step 8 - Launch Template

Before creating the Auto Scaling Group, a Launch Template was created.

The Launch Template contained all of the information required to launch future EC2 instances, including:

- Amazon Linux 2023 AMI
- Instance Type
- Key Pair
- Security Group
- User Data
- Storage Configuration

Unlike the original EC2 instances, the User Data script displayed the hostname of the server instead of "Server 1" or "Server 2". This allows every new Auto Scaling instance to identify itself automatically.

---

# Step 9 - Auto Scaling Group

An Auto Scaling Group was created using the Launch Template.

Configuration:

- Minimum Capacity: 2
- Desired Capacity: 2
- Maximum Capacity: 4

The Auto Scaling Group was attached directly to the existing Target Group.

ELB Health Checks were enabled so that Auto Scaling could monitor application health rather than simply checking whether the EC2 instance was powered on.

When the Auto Scaling Group was created, AWS launched two additional EC2 instances because the manually created instances were not owned by the Auto Scaling Group.

All four instances eventually became healthy within the Target Group.

---

# Step 10 - Demonstrating Self-Healing Infrastructure

To demonstrate Auto Scaling, one of the Auto Scaling Group's EC2 instances was manually terminated.

AWS automatically detected that the desired capacity had fallen below two instances.

Without any manual intervention, AWS:

- Launched a replacement EC2 instance.
- Executed the User Data script.
- Installed NGINX.
- Registered the new instance with the Target Group.
- Waited until the health checks passed.
- Began routing production traffic to the replacement instance.

This demonstrated one of the key benefits of Auto Scaling: automatic recovery from infrastructure failures.

---

# Challenges Encountered

During this assignment several important concepts required deeper understanding.

The relationship between the Application Load Balancer and Target Groups was initially confusing, but it became clear that the ALB never communicates directly with EC2 instances. Instead, it forwards traffic to a Target Group, which manages the registered backend servers.

Configuring Security Groups also reinforced the principle of layered security by ensuring that only the Application Load Balancer could communicate with the EC2 instances.

HTTPS configuration introduced SSL certificates, DNS validation and HTTP redirection, while Auto Scaling introduced the concepts of Launch Templates, desired capacity, and self-healing infrastructure.

---

# Skills Learned

Through this assignment I gained practical experience with:

- Application Load Balancers
- Target Groups
- Health Checks
- Security Group design
- EC2 User Data automation
- HTTPS configuration
- AWS Certificate Manager
- DNS validation
- Launch Templates
- Auto Scaling Groups
- High Availability
- Self-Healing Infrastructure
- Production-style AWS architecture

---

# Key Takeaways

This assignment demonstrated how multiple AWS services work together to provide a secure, scalable and highly available application.

Rather than exposing individual EC2 instances directly to the internet, traffic is routed through an Application Load Balancer, which distributes requests across healthy servers while continuously monitoring their availability.

The addition of HTTPS improves security by encrypting all client traffic, while Auto Scaling ensures that failed instances are automatically replaced without manual intervention.

This assignment provided a much deeper understanding of production cloud architecture and highlighted the importance of automation, redundancy, load balancing and resilience within modern DevOps environments.