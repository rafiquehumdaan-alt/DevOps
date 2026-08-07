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