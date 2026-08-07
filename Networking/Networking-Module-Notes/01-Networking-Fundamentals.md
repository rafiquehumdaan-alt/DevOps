# Networking Notes - Part 1: Networking Fundamentals

> Covers:
>
> - What is Networking?
> - Types of Networks
> - LAN & WAN
> - Network Devices
> - Switches
> - Routers
> - Firewalls
> - IP Addresses
> - MAC Addresses
> - Ports
> - TCP vs UDP

---

# What is Networking?

A **computer network** is a collection of devices connected together so they can communicate and share resources.

Examples of devices:

- Computers
- Servers
- Phones
- Printers
- Routers
- Switches

Networks allow devices to exchange data.

---

# Why is Networking Important?

Networking allows devices to:

- Share files
- Access the internet
- Communicate with servers
- Send emails
- Access cloud services
- Host websites

Without networking, computers would work in isolation.

---

# Simple Network Example

```text
Laptop

↓

Switch

↓

Router

↓

Internet

↓

Website
```

---

# Types of Networks

There are many types of networks.

The two most common are:

- LAN
- WAN

---

# Local Area Network (LAN)

A **LAN** connects devices within a small geographical area.

Examples:

- Home network
- Office
- School
- University

Characteristics:

- High speed
- Low latency
- Privately managed

Example:

```text
Laptop

↓

Switch

↓

Printer

↓

Server
```

---

# Wide Area Network (WAN)

A **WAN** connects multiple LANs over large distances.

Examples:

- The Internet
- Company offices in different cities
- Cloud providers

Characteristics:

- Covers large geographical areas
- Higher latency than LANs
- Often uses leased internet connections

---

# LAN vs WAN

| LAN | WAN |
|-----|-----|
| Small area | Large area |
| High speed | Lower speed |
| Low latency | Higher latency |
| Privately managed | ISP or provider managed |
| Home & office | Internet & global networks |

---

# Network Devices

Several devices work together to move network traffic.

Common devices include:

- Switches
- Routers
- Firewalls

Each has a different purpose.

---

# What is a Switch?

A **switch** connects devices within the same LAN.

It forwards data to the correct device using **MAC addresses**.

Example:

```text
Laptop

↓

Switch

↓

Printer

↓

Server
```

The switch keeps local traffic inside the network.

---

# What is a Router?

A **router** connects different networks together.

It uses **IP addresses** to determine where packets should be sent.

Example:

```text
Home Network

↓

Router

↓

Internet

↓

Google
```

Without a router, devices cannot communicate with other networks.

---

# Switch vs Router

| Switch | Router |
|---------|---------|
| Connects devices | Connects networks |
| Uses MAC addresses | Uses IP addresses |
| Operates inside a LAN | Connects LANs to other networks |
| Layer 2 (OSI) | Layer 3 (OSI) |

---

# What is a Firewall?

A **firewall** controls network traffic by allowing or blocking connections based on predefined security rules.

It helps protect systems from unauthorised access.

Example:

```text
Internet

↓

Firewall

↓

Company Network
```

---

# What Can Firewalls Do?

Firewalls can:

- Allow traffic
- Block traffic
- Restrict ports
- Filter protocols
- Protect internal networks

Firewalls are a key part of network security.

---

# What is an IP Address?

An **IP address** uniquely identifies a device on a network.

Example (IPv4):

```text
192.168.1.25
```

Every device communicating over an IP network requires an IP address.

---

# Public vs Private IP Addresses

### Private IP

Used inside local networks.

Examples:

```text
192.168.x.x

10.x.x.x

172.16.x.x – 172.31.x.x
```

Private IP addresses are **not routable over the public internet**.

---

### Public IP

Assigned by an Internet Service Provider (ISP).

Example:

```text
81.2.69.160
```

Public IP addresses are reachable over the internet.

---

# What is a MAC Address?

A **MAC (Media Access Control) address** is the physical hardware address of a network interface.

Example:

```text
00:1A:2B:3C:4D:5E
```

Unlike IP addresses, MAC addresses are typically assigned by the device manufacturer and remain constant.

---

# IP Address vs MAC Address

| IP Address | MAC Address |
|------------|-------------|
| Logical address | Physical address |
| Can change | Usually permanent |
| Used between networks | Used within local networks |
| Layer 3 | Layer 2 |

---

# What is a Port?

A **port** identifies a specific service or application running on a device.

Think of an IP address as a building address, and a port as the specific room inside that building.

Example:

```text
192.168.1.10:80
```

- IP → Device
- Port → Service

---

# Common Ports

| Port | Service |
|------:|---------|
| 20/21 | FTP |
| 22 | SSH |
| 23 | Telnet |
| 25 | SMTP |
| 53 | DNS |
| 80 | HTTP |
| 110 | POP3 |
| 143 | IMAP |
| 443 | HTTPS |
| 3389 | RDP |

These are common interview questions.

---

# Protocols

A **protocol** is a set of rules that defines how devices communicate.

Examples:

- HTTP
- HTTPS
- SSH
- FTP
- DNS
- TCP
- UDP

Without protocols, devices would not understand each other.

---

# TCP

**Transmission Control Protocol (TCP)** provides reliable communication.

Features:

- Connection-oriented
- Guarantees delivery
- Checks for errors
- Maintains packet order

Used by:

- HTTPS
- SSH
- FTP
- Email

---

# UDP

**User Datagram Protocol (UDP)** prioritises speed over reliability.

Features:

- Connectionless
- Faster
- No delivery guarantee
- Lower overhead

Used by:

- Video streaming
- Online gaming
- Voice calls
- DNS queries

---

# TCP vs UDP

| TCP | UDP |
|------|------|
| Reliable | Fast |
| Connection-oriented | Connectionless |
| Error checking | Minimal error checking |
| Ordered delivery | No guaranteed order |
| Higher overhead | Lower overhead |

---

# Example Communication

```text
Browser

↓

HTTPS (TCP)

↓

Router

↓

Internet

↓

Web Server
```

---

# Common Mistakes

### Confusing IP and MAC Addresses

- IP addresses identify devices on a network and can change.
- MAC addresses identify the physical network interface and are usually permanent.

---

### Thinking Switches Connect Networks

Switches connect devices **within** a LAN.

Routers connect **different** networks.

---

### Assuming UDP is "Bad"

UDP is not unreliable by mistake—it is designed for applications where speed is more important than guaranteed delivery.

---

# Best Practices

- Learn the difference between switches, routers and firewalls.
- Memorise the most common ports (22, 53, 80, 443).
- Understand when TCP or UDP is appropriate.
- Be comfortable explaining the difference between IP and MAC addresses.
- Think of networks as layers working together rather than isolated components.

---

# Key Takeaways

- Networks allow devices to communicate.
- LANs connect devices locally; WANs connect networks over large distances.
- Switches use MAC addresses to forward local traffic.
- Routers use IP addresses to connect different networks.
- Firewalls filter network traffic based on security rules.
- IP addresses identify devices, while ports identify services.
- TCP provides reliable communication; UDP provides faster communication with less overhead.

---

# Quick Revision

| Device / Concept | Purpose |
|------------------|---------|
| LAN | Local network |
| WAN | Wide area network |
| Switch | Connect devices in a LAN |
| Router | Connect different networks |
| Firewall | Filter network traffic |
| IP Address | Identify a device |
| MAC Address | Identify a network interface |
| Port | Identify a service |
| TCP | Reliable communication |
| UDP | Fast communication |

---

# Interview Questions

### What is the difference between a LAN and a WAN?

A LAN connects devices within a small geographical area, while a WAN connects multiple LANs across larger distances, such as the internet.

### What is the difference between a switch and a router?

A switch connects devices within the same network using MAC addresses, whereas a router connects different networks using IP addresses.

### What is the purpose of a firewall?

A firewall monitors and filters incoming and outgoing network traffic based on security rules to protect systems from unauthorised access.

### What is the difference between an IP address and a MAC address?

An IP address is a logical address used for routing between networks, while a MAC address is a physical hardware address used for communication within a local network.

### When would you use TCP instead of UDP?

TCP is used when reliable, ordered delivery is required, such as for web browsing (HTTPS), file transfers and SSH connections.