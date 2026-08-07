# Networking Notes - Part 3: DNS (Domain Name System)

> Covers:
>
> - What is DNS?
> - Why DNS is Needed
> - Domain Names
> - Nameservers
> - Zone Files
> - DNS Records
> - DNS Resolution Process
> - Recursive & Authoritative DNS
> - `nslookup`
> - `dig`
> - `/etc/hosts`

---

# What is DNS?

**DNS (Domain Name System)** is the internet's "phone book."

Humans remember names like:

```text
google.com
```

Computers communicate using IP addresses:

```text
142.250.179.14
```

DNS translates domain names into IP addresses.

---

# Why Do We Need DNS?

Without DNS, every website would need to be accessed using its IP address.

Example:

Instead of:

```text
google.com
```

You would have to remember:

```text
142.250.179.14
```

DNS makes the internet easy to use.

---

# Domain Names

A **domain name** is the human-readable name of a website.

Example:

```text
www.example.com
```

It consists of:

```text
www

↓

example

↓

.com
```

- `www` → Subdomain
- `example` → Domain name
- `.com` → Top-Level Domain (TLD)

---

# DNS Components

DNS is made up of several components:

- Domain Names
- Nameservers
- Zone Files
- DNS Records

Each has a specific role.

---

# Nameservers

A **nameserver** stores DNS records for a domain.

When someone requests:

```text
example.com
```

the nameserver responds with the appropriate DNS records.

Examples:

```text
ns1.example.com

ns2.example.com
```

Large providers such as Cloudflare, AWS Route 53 and GoDaddy all operate nameservers.

---

# Zone Files

A **zone file** contains all DNS records for a domain.

Example records:

- A
- AAAA
- CNAME
- MX
- TXT

When a nameserver receives a query, it looks in the zone file to find the correct answer.

---

# Common DNS Record Types

| Record | Purpose |
|---------|---------|
| A | Maps a domain to an IPv4 address |
| AAAA | Maps a domain to an IPv6 address |
| CNAME | Alias to another domain |
| MX | Mail server |
| TXT | Verification and security records |
| NS | Nameserver information |

---

# A Record

Maps a domain name to an IPv4 address.

Example:

```text
example.com

↓

203.0.113.10
```

This is one of the most common DNS records.

---

# AAAA Record

Same as an A record, but for IPv6.

Example:

```text
example.com

↓

2001:db8::10
```

---

# CNAME Record

Creates an alias.

Example:

```text
www.example.com

↓

example.com
```

The client then resolves `example.com` to its IP address.

---

# MX Record

Specifies which mail server receives email for a domain.

Example:

```text
example.com

↓

mail.example.com
```

Email providers such as Microsoft 365 and Google Workspace rely on MX records.

---

# TXT Record

Stores text information.

Common uses:

- Domain verification
- SPF
- DKIM
- DMARC

TXT records are widely used for email security.

---

# NS Record

Specifies which nameservers are authoritative for the domain.

Example:

```text
example.com

↓

ns1.provider.com

ns2.provider.com
```

---

# How DNS Works

When you visit:

```text
google.com
```

the following steps occur:

```text
Browser

↓

Local DNS Cache

↓

Recursive Resolver

↓

Root DNS Server

↓

TLD Server (.com)

↓

Authoritative Nameserver

↓

IP Address Returned

↓

Browser Connects
```

---

# Recursive Resolver

The recursive resolver performs the DNS lookup on your behalf.

It asks other DNS servers until it finds the answer.

Common examples:

- Google DNS (8.8.8.8)
- Cloudflare DNS (1.1.1.1)
- ISP DNS servers

---

# Authoritative Nameserver

The authoritative nameserver stores the official DNS records for a domain.

It provides the final answer to DNS queries.

---

# DNS Caching

To improve performance, DNS results are cached.

Examples:

- Browser cache
- Operating system cache
- Recursive resolver cache

Caching reduces lookup times and internet traffic.

---

# Using `nslookup`

`nslookup` queries DNS servers.

Example:

```bash
nslookup google.com
```

Example output:

```text
Name: google.com

Address: 142.250.x.x
```

Useful for verifying DNS resolution.

---

# Using `dig`

`dig` (Domain Information Groper) provides detailed DNS information.

Example:

```bash
dig google.com
```

Useful information includes:

- Answer section
- Authority section
- Query time
- DNS server used
- TTL

`dig` is commonly preferred by network engineers because it provides more detail than `nslookup`.

---

# Query Specific Record Types

Example:

```bash
dig google.com MX
```

Retrieve only MX records.

Similarly:

```bash
dig example.com TXT
```

---

# `/etc/hosts`

Linux checks the `/etc/hosts` file **before** querying DNS.

Example:

```text
127.0.0.1 localhost

192.168.1.100 test.local
```

If an entry exists here, DNS is bypassed.

---

# Why Use `/etc/hosts`?

Useful for:

- Local development
- Testing websites
- Troubleshooting DNS
- Temporary hostname overrides

Changes affect only the local machine.

---

# Example DNS Lookup

```text
Browser

↓

/etc/hosts

↓

DNS Cache

↓

Recursive Resolver

↓

Authoritative Nameserver

↓

IP Address

↓

Website
```

---

# Common Mistakes

### Confusing DNS with Web Hosting

DNS only tells your computer **where** a website is located.

It does **not** host the website itself.

---

### Assuming DNS Changes Are Instant

DNS records are cached.

Changes may take time to propagate depending on the record's TTL (Time To Live).

---

### Editing the Wrong Hosts File

On Linux, the hosts file is:

```text
/etc/hosts
```

Administrator privileges are required to edit it.

---

# Best Practices

- Learn the purpose of the common DNS record types.
- Use `dig` for detailed troubleshooting.
- Use `nslookup` for quick lookups.
- Remember that `/etc/hosts` overrides DNS on the local machine.
- Understand the difference between recursive and authoritative DNS servers.

---

# Key Takeaways

- DNS converts domain names into IP addresses.
- Nameservers store DNS records for a domain.
- Zone files contain DNS configuration.
- A records map domains to IPv4 addresses.
- CNAME records create aliases.
- MX records route email.
- `nslookup` and `dig` are common DNS troubleshooting tools.
- `/etc/hosts` is checked before DNS lookups.

---

# Quick Revision

| Record | Purpose |
|---------|---------|
| A | IPv4 address |
| AAAA | IPv6 address |
| CNAME | Alias |
| MX | Mail server |
| TXT | Verification / security |
| NS | Nameservers |

---

# Useful Commands

| Command | Purpose |
|----------|----------|
| `nslookup google.com` | Basic DNS lookup |
| `dig google.com` | Detailed DNS lookup |
| `dig example.com MX` | Query MX records |
| `dig example.com TXT` | Query TXT records |
| `cat /etc/hosts` | View local hosts file |

---

# Interview Questions

### What is DNS?

DNS (Domain Name System) translates human-readable domain names into IP addresses so computers can communicate over networks.

### What is the difference between an A record and a CNAME record?

An A record maps a domain directly to an IPv4 address, while a CNAME record creates an alias that points one domain name to another.

### What is the purpose of an MX record?

An MX (Mail Exchange) record specifies which mail server is responsible for receiving email for a domain.

### What is the difference between `nslookup` and `dig`?

Both perform DNS lookups, but `dig` provides more detailed information and is generally preferred for troubleshooting.

### What is the purpose of the `/etc/hosts` file?

The `/etc/hosts` file provides local hostname-to-IP mappings and is checked before DNS, allowing local overrides for testing and troubleshooting.