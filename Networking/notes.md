# Networking Module - README Notes

## Overview

Networking is the process of allowing devices to communicate with one another over a network. It enables users, servers, applications, and cloud resources to exchange data reliably and securely.

Understanding networking is fundamental for Cloud, DevOps, Cyber Security, and IT Infrastructure roles.

---

# OSI Model

The OSI (Open Systems Interconnection) model divides networking into seven layers.

| Layer | Name | Purpose |
|--------|------|---------|
| 7 | Application | Provides network services to applications (HTTP, DNS, SMTP) |
| 6 | Presentation | Encryption, compression, formatting |
| 5 | Session | Establishes and manages sessions |
| 4 | Transport | Reliable communication using TCP or UDP |
| 3 | Network | Routing using IP addresses |
| 2 | Data Link | MAC addresses and switching |
| 1 | Physical | Cables, fibre, wireless signals |

A useful way to troubleshoot networking problems is to work through the OSI model layer by layer.

---

# TCP/IP Model

The TCP/IP model is the practical networking model used on modern networks.

| Layer | Examples |
|--------|-----------|
| Application | HTTP, HTTPS, DNS, SSH |
| Transport | TCP, UDP |
| Internet | IP, ICMP |
| Network Access | Ethernet, Wi-Fi |

---

# IP Addressing

An IP address uniquely identifies a device on a network.

Example:

```
192.168.1.10
```

There are two versions:

- IPv4 (32-bit)
- IPv6 (128-bit)

---

# Public vs Private IP Addresses

## Private IP

Used inside local networks.

Examples:

```
10.0.0.0/8

172.16.0.0 - 172.31.255.255

192.168.0.0/16
```

Private IP addresses cannot be accessed directly from the Internet.

---

## Public IP

Assigned by an ISP or cloud provider.

Example:

```
20.11.57.251
```

Public IPs allow devices to be reached over the Internet.

---

# Subnets

Subnets divide networks into smaller sections.

Example:

```
192.168.1.0/24
```

Benefits:

- Better organisation
- Improved security
- Reduced broadcast traffic
- Easier management

---

# VLANs

A VLAN (Virtual Local Area Network) separates devices logically on the same physical switch.

Benefits:

- Improves security
- Reduces broadcast traffic
- Separates departments
- Simplifies management

OSI Layer:

- Layer 2

---

# Routers

Routers connect different networks together.

Responsibilities:

- Route packets
- Connect LANs to WANs
- Perform NAT
- Default gateway

OSI Layer:

- Layer 3

---

# Switches

Switches connect devices inside the same LAN.

Responsibilities:

- Forward Ethernet frames
- Learn MAC addresses
- Support VLANs

OSI Layer:

- Layer 2

---

# NAT (Network Address Translation)

NAT translates private IP addresses into public IP addresses.

Benefits:

- Conserves public IP addresses
- Allows Internet access
- Hides internal network structure

Types:

## Static NAT

One private IP permanently maps to one public IP.

## Dynamic NAT

Private addresses are mapped from a pool of public addresses.

## PAT (Port Address Translation)

Many private devices share one public IP using different port numbers.

PAT is the most common type of NAT used today.

---

# DNS (Domain Name System)

DNS translates domain names into IP addresses.

Example:

```
humdaan.co.uk

↓

20.11.57.251
```

Without DNS, users would need to remember IP addresses.

---

# Common DNS Records

## A Record

Maps a hostname to an IPv4 address.

```
example.com

↓

93.184.216.34
```

---

## AAAA Record

Maps a hostname to an IPv6 address.

---

## CNAME

Creates an alias for another hostname.

Example:

```
www.example.com

↓

example.com
```

---

## MX Record

Specifies the mail server responsible for email delivery.

---

## TXT Record

Stores text information.

Common uses:

- SPF
- DKIM
- Domain verification

---

# HTTP vs HTTPS

HTTP

- Port 80
- Unencrypted

HTTPS

- Port 443
- Encrypted using TLS

HTTPS protects data travelling across the Internet.

---

# Common Ports

| Service | Port |
|----------|------|
| FTP | 21 |
| SSH | 22 |
| Telnet | 23 |
| SMTP | 25 |
| DNS | 53 |
| HTTP | 80 |
| POP3 | 110 |
| IMAP | 143 |
| HTTPS | 443 |
| RDP | 3389 |

---

# Firewalls

Firewalls control network traffic.

Rules can:

- Allow
- Deny

Traffic can be filtered by:

- Source IP
- Destination IP
- Protocol
- Port

Examples:

- Windows Firewall
- Azure NSG
- AWS Security Groups
- Sophos Firewall

---

# Network Security Groups (Azure)

An NSG filters traffic entering or leaving Azure resources.

Typical rules:

- Allow SSH (22)
- Allow HTTP (80)
- Allow HTTPS (443)

Very similar to AWS Security Groups.

---

# AWS Security Groups

Security Groups are virtual firewalls attached to AWS resources such as EC2 instances.

They control inbound and outbound traffic.

---

# SSH

SSH (Secure Shell) allows secure remote administration.

Example:

```bash
ssh user@server-ip
```

Using SSH keys is more secure than passwords.

---

# NGINX

NGINX is a web server.

Responsibilities:

- Serve websites
- Reverse proxy
- Load balancing
- SSL termination

Common commands:

```bash
sudo systemctl status nginx

sudo systemctl restart nginx

sudo systemctl stop nginx

sudo systemctl start nginx
```

---

# Useful Linux Networking Commands

View IP addresses

```bash
ip addr
```

Show listening ports

```bash
ss -tulpn
```

DNS lookup

```bash
dig example.com

nslookup example.com
```

Test connectivity

```bash
ping google.com
```

Download a webpage

```bash
curl http://example.com
```

View routing table

```bash
ip route
```

Display network interfaces

```bash
ip link
```

---

# Cloud Networking Concepts

Virtual Network (Azure)

Equivalent to an AWS VPC.

Provides network isolation for cloud resources.

---

Subnet

Divides a virtual network into smaller logical sections.

---

Public IP

Allows Internet access to a cloud resource.

---

Private IP

Used for communication inside the virtual network.

---

Network Security Group

Controls inbound and outbound traffic.

Acts as a virtual firewall.

---

# Troubleshooting Approach

When diagnosing networking issues, work from the bottom upwards.

1. Is the machine powered on?
2. Is the network connected?
3. Does it have an IP address?
4. Can it reach the gateway?
5. Is DNS working?
6. Is the service running?
7. Is the firewall blocking traffic?
8. Is the application responding?

Following a structured approach helps identify problems quickly.

---

# Key Skills Learned

- OSI Model
- TCP/IP Model
- IP Addressing
- Public vs Private IPs
- Subnetting
- VLANs
- Routing
- Switching
- NAT
- DNS
- HTTP & HTTPS
- Common Ports
- Firewalls
- Azure Networking
- AWS Security Groups
- SSH
- NGINX
- Linux Networking Commands
- Cloud Networking Fundamentals
- Network Troubleshooting