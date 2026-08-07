# Networking Notes - Part 5: Subnetting, CIDR & NAT

> Covers:
>
> - What is Subnetting?
> - IPv4 Address Structure
> - Binary Basics
> - CIDR Notation
> - Subnet Masks
> - Network & Broadcast Addresses
> - Usable Hosts
> - Calculating Subnets
> - NAT (Network Address Translation)
> - Public vs Private IP Addresses

---

# What is Subnetting?

**Subnetting** is the process of dividing a large network into smaller, more manageable networks called **subnets**.

Benefits include:

- Improved performance
- Better security
- Easier management
- Reduced broadcast traffic

---

# Why Use Subnetting?

Instead of one large network:

```text
192.168.1.0/24
```

You could divide it into:

```text
192.168.1.0/26

192.168.1.64/26

192.168.1.128/26

192.168.1.192/26
```

Each subnet functions as its own smaller network.

---

# IPv4 Address Structure

An IPv4 address contains **32 bits**, divided into four octets.

Example:

```text
192.168.1.10
```

Each octet ranges from:

```text
0 - 255
```

---

# Binary Basics

Computers use binary (1s and 0s).

Example:

```text
192

↓

11000000
```

Each IPv4 address is stored as 32 binary bits.

---

# Binary Values

| Bit | Value |
|----:|------:|
| 1 | 128 |
| 2 | 64 |
| 3 | 32 |
| 4 | 16 |
| 5 | 8 |
| 6 | 4 |
| 7 | 2 |
| 8 | 1 |

Example:

```text
11000000

↓

128 + 64

↓

192
```

---

# What is CIDR?

**CIDR (Classless Inter-Domain Routing)** indicates how many bits belong to the network portion of an IP address.

Example:

```text
192.168.1.0/24
```

The `/24` means:

- 24 bits = Network
- 8 bits = Hosts

---

# Common CIDR Values

| CIDR | Subnet Mask | Usable Hosts |
|------|-------------|-------------:|
| /24 | 255.255.255.0 | 254 |
| /25 | 255.255.255.128 | 126 |
| /26 | 255.255.255.192 | 62 |
| /27 | 255.255.255.224 | 30 |
| /28 | 255.255.255.240 | 14 |
| /29 | 255.255.255.248 | 6 |
| /30 | 255.255.255.252 | 2 |

These are common subnet sizes in real-world networks.

---

# Subnet Mask

A subnet mask separates:

- Network portion
- Host portion

Example:

```text
255.255.255.0
```

Equivalent CIDR:

```text
/24
```

---

# Network Address

The **network address** identifies the subnet itself.

Example:

```text
192.168.1.0/24
```

Network address:

```text
192.168.1.0
```

This address **cannot** be assigned to a device.

---

# Broadcast Address

The **broadcast address** is used to send traffic to every device on the subnet.

Example:

```text
192.168.1.255
```

This address also **cannot** be assigned to a host.

---

# Usable Hosts

For:

```text
192.168.1.0/24
```

Range:

```text
192.168.1.1

↓

192.168.1.254
```

Total:

```text
254 usable hosts
```

---

# Example Subnet

Network:

```text
10.0.0.0/24
```

| Item | Value |
|------|-------|
| Network Address | 10.0.0.0 |
| First Host | 10.0.0.1 |
| Last Host | 10.0.0.254 |
| Broadcast | 10.0.0.255 |

---

# Calculating Subnets

Example:

```text
192.168.1.0/26
```

Block size:

```text
64
```

Subnets become:

```text
192.168.1.0

192.168.1.64

192.168.1.128

192.168.1.192
```

Each subnet contains:

- 64 total addresses
- 62 usable hosts

---

# Private IP Addresses

Private IP ranges:

```text
10.0.0.0/8

172.16.0.0/12

192.168.0.0/16
```

These addresses:

- Are used inside private networks
- Cannot be routed directly over the internet

---

# Public IP Addresses

Public IP addresses:

- Are globally unique
- Are assigned by Internet Service Providers (ISPs)
- Can communicate over the internet

Example:

```text
81.2.69.160
```

---

# What is NAT?

**Network Address Translation (NAT)** converts private IP addresses into public IP addresses.

This allows many private devices to share a single public IP.

---

# Why NAT is Needed

Without NAT:

Every device would require its own public IP.

With NAT:

```text
Laptop

Phone

Tablet

↓

Router (NAT)

↓

One Public IP

↓

Internet
```

This conserves public IPv4 addresses.

---

# How NAT Works

Example:

Private device:

```text
192.168.1.15
```

Router performs NAT:

```text
↓

81.2.69.160
```

The internet only sees the public IP address.

---

# Benefits of NAT

- Conserves IPv4 addresses
- Hides internal devices
- Adds a layer of security
- Simplifies private network design

---

# Example Home Network

```text
Laptop
192.168.1.10

↓

Home Router (NAT)

↓

Public IP

↓

Internet
```

Every device shares the same public IP address.

---

# Common Mistakes

### Confusing CIDR and Subnet Mask

These represent the same concept.

Example:

```text
/24

=

255.255.255.0
```

---

### Using Network or Broadcast Addresses

Never assign:

- Network address
- Broadcast address

to devices.

---

### Thinking NAT is a Firewall

NAT translates addresses.

A firewall filters traffic.

Although NAT provides some protection by hiding private IP addresses, it is **not** a replacement for a firewall.

---

# Best Practices

- Learn the common CIDR values by memory.
- Understand the relationship between CIDR and subnet masks.
- Always identify the network, broadcast and usable host range.
- Memorise the private IP ranges.
- Understand why NAT is required for IPv4.

---

# Key Takeaways

- Subnetting divides large networks into smaller networks.
- CIDR defines the size of the network portion of an IP address.
- Network and broadcast addresses cannot be assigned to hosts.
- Private IP addresses are not routable on the internet.
- NAT allows multiple private devices to share one public IP address.
- Subnetting improves scalability, performance and security.

---

# Quick Revision

| CIDR | Subnet Mask | Hosts |
|------|-------------|------:|
| /24 | 255.255.255.0 | 254 |
| /25 | 255.255.255.128 | 126 |
| /26 | 255.255.255.192 | 62 |
| /27 | 255.255.255.224 | 30 |

---

# Private IP Ranges

| Range | CIDR |
|--------|------|
| 10.0.0.0 - 10.255.255.255 | /8 |
| 172.16.0.0 - 172.31.255.255 | /12 |
| 192.168.0.0 - 192.168.255.255 | /16 |

---

# Interview Questions

### What is subnetting?

Subnetting is the process of dividing a larger network into smaller subnetworks to improve efficiency, security and management.

### What does `/24` mean?

It means the first 24 bits represent the network portion of the IP address, leaving 8 bits for host addresses.

### What is the difference between a private and a public IP address?

Private IP addresses are used within local networks and are not routable on the public internet, whereas public IP addresses are globally unique and accessible over the internet.

### What is NAT?

Network Address Translation (NAT) converts private IP addresses into public IP addresses, allowing multiple devices to share a single public IP.

### Why can't the network and broadcast addresses be assigned to hosts?

The network address identifies the subnet itself, while the broadcast address is reserved for sending traffic to all devices on the subnet.