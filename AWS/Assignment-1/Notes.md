# AWS VPC & Networking Assignment

## Overview

This project demonstrates how to build a custom AWS Virtual Private Cloud (VPC) from scratch using core networking components. The objective was to create a secure network architecture with both public and private subnets, configure internet connectivity, deploy EC2 instances, and implement secure communication between them.

This assignment provides hands-on experience with AWS networking concepts that form the foundation of many production cloud environments.

---

## Objectives

- Create a custom VPC
- Configure public and private subnets
- Attach an Internet Gateway (IGW)
- Deploy a NAT Gateway with an Elastic IP
- Configure public and private route tables
- Launch EC2 instances into each subnet
- Secure access using Security Groups
- Verify connectivity between public and private instances
- Test outbound internet access from the private subnet

---

## Architecture

```
                                  Internet
                                      │
                                      │
                         ┌────────────────────────┐
                         │ Internet Gateway (IGW) │
                         └─────────────┬──────────┘
                                       │
                        DevOps-VPC (10.0.0.0/16)
                                       │
             ┌─────────────────────────┴─────────────────────────┐
             │                                                   │
             │                                                   │
 ┌─────────────────────────┐                      ┌─────────────────────────┐
 │ Public Subnet           │                      │ Private Subnet          │
 │ 10.0.1.0/24             │                      │ 10.0.2.0/24             │
 │ Route → IGW             │                      │ Route → NAT Gateway     │
 └─────────────┬───────────┘                      └─────────────┬───────────┘
               │                                                │
      ┌────────▼────────┐                              ┌────────▼────────┐
      │ Public EC2      │                              │ Private EC2     │
      │ Public IP       │────────────SSH──────────────►│ No Public IP    │
      │ Bastion Host    │                              │ Internal Server │
      └────────┬────────┘                              └─────────────────┘
               │
      ┌────────▼────────┐
      │ NAT Gateway     │
      │ Elastic IP      │
      └────────┬────────┘
               │
               ▼
            Internet
```

---

## AWS Services Used

- Amazon VPC
- Public Subnet
- Private Subnet
- Internet Gateway
- NAT Gateway
- Elastic IP
- Route Tables
- Security Groups
- Amazon EC2

---

## What Was Configured

### Networking

- Created a custom VPC using the CIDR block `10.0.0.0/16`
- Created:
  - Public Subnet (`10.0.1.0/24`)
  - Private Subnet (`10.0.2.0/24`)
- Attached an Internet Gateway to the VPC
- Allocated an Elastic IP
- Created a NAT Gateway within the Public Subnet

### Routing

Configured separate route tables:

**Public Route Table**

- Local VPC route
- Default route (`0.0.0.0/0`) → Internet Gateway

**Private Route Table**

- Local VPC route
- Default route (`0.0.0.0/0`) → NAT Gateway

### EC2 Instances

**Public EC2**

- Deployed into the Public Subnet
- Assigned a Public IPv4 address
- Accessible via SSH
- Used as a Bastion Host

**Private EC2**

- Deployed into the Private Subnet
- No Public IP assigned
- Accessible only from the Public EC2

### Security Groups

**Public EC2**

Allowed inbound:

- SSH (My IP)
- HTTP (My IP)

**Private EC2**

Allowed inbound:

- SSH only from the Public EC2 Security Group

---

## Testing Performed

The following tests were successfully completed:

- Verified Public EC2 internet connectivity
- SSH from local machine → Public EC2
- SSH from Public EC2 → Private EC2
- Successfully executed:

```bash
sudo apt update
```

on the Private EC2, confirming outbound internet access through the NAT Gateway.

---

## Key Learning Outcomes

This assignment provided practical experience with:

- AWS Virtual Private Clouds (VPCs)
- CIDR addressing
- Public vs Private Subnets
- Internet Gateways
- NAT Gateways
- Route Tables
- Elastic IP addresses
- Security Groups
- Bastion Hosts
- Secure network segmentation
- SSH between EC2 instances
- Private subnet internet access

---

## Conclusion

This project demonstrated how to build a secure AWS networking environment using industry-standard architecture. By separating resources into public and private subnets, implementing controlled routing, and using a Bastion Host for administration, the infrastructure follows common cloud security best practices while maintaining secure outbound internet access for private resources through a NAT Gateway.