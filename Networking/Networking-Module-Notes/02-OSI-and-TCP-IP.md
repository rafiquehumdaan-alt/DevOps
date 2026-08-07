# Networking Notes - Part 2: OSI Model & TCP/IP

> Covers:
>
> - What is the OSI Model?
> - Why the OSI Model Matters
> - The 7 OSI Layers
> - TCP/IP Model
> - Encapsulation & Decapsulation
> - Sender & Receiver Perspective
> - Ports & Protocols Recap

---

# What is the OSI Model?

The **OSI (Open Systems Interconnection) Model** is a conceptual framework used to describe how data travels across a network.

It breaks network communication into **7 layers**, with each layer performing a specific function.

The OSI model is primarily used for:

- Understanding networking
- Troubleshooting network issues
- Explaining how protocols work

---

# Why is the OSI Model Important?

The OSI model helps engineers:

- Understand how data flows
- Identify where problems occur
- Learn networking systematically
- Troubleshoot more effectively

For example:

- DNS issue → Application Layer
- Cable unplugged → Physical Layer

---

# The 7 OSI Layers

```text
7. Application
6. Presentation
5. Session
4. Transport
3. Network
2. Data Link
1. Physical
```

A common way to remember them:

> **Please Do Not Throw Sausage Pizza Away**

---

# Layer 7 – Application

The Application Layer is where users interact with network services.

Common protocols:

- HTTP
- HTTPS
- FTP
- DNS
- SSH
- SMTP

Example:

```text
Opening a website in a browser
```

---

# Layer 6 – Presentation

The Presentation Layer handles:

- Data formatting
- Encryption
- Compression

Examples:

- SSL/TLS encryption
- JPEG images
- UTF-8 text encoding

It ensures data is in a usable format.

---

# Layer 5 – Session

The Session Layer manages communication sessions between devices.

Responsibilities include:

- Establishing sessions
- Maintaining sessions
- Ending sessions

Example:

Keeping a video call connected.

---

# Layer 4 – Transport

The Transport Layer ensures data is delivered correctly.

Protocols:

- TCP
- UDP

Responsibilities:

- Reliability
- Flow control
- Error checking
- Segmentation

---

# TCP vs UDP

### TCP

- Reliable
- Ordered delivery
- Error checking
- Connection-oriented

Examples:

- HTTPS
- SSH
- FTP

---

### UDP

- Faster
- Connectionless
- Lower overhead
- No guaranteed delivery

Examples:

- DNS
- Online gaming
- Video streaming
- VoIP

---

# Layer 3 – Network

The Network Layer handles routing between networks.

Uses:

- IP addresses
- Routers

Responsibilities:

- Packet forwarding
- Path selection

---

# Layer 2 – Data Link

The Data Link Layer delivers data within the local network.

Uses:

- MAC addresses
- Switches

Responsibilities:

- Frame delivery
- Error detection
- Local communication

---

# Layer 1 – Physical

The Physical Layer is responsible for transmitting raw bits.

Examples:

- Ethernet cables
- Fibre optics
- Wireless radio signals

It represents the actual hardware connection.

---

# Data Flow Through the OSI Model

```text
Application

↓

Presentation

↓

Session

↓

Transport

↓

Network

↓

Data Link

↓

Physical
```

The receiver processes the layers in reverse order.

---

# Encapsulation

As data moves **down** the OSI stack, each layer adds its own header.

```text
Application Data

↓

TCP Header

↓

IP Header

↓

Ethernet Header

↓

Bits
```

This process is called **Encapsulation**.

---

# Decapsulation

When the receiver gets the data, each layer removes its corresponding header.

```text
Bits

↓

Ethernet

↓

IP

↓

TCP

↓

Application Data
```

This process is called **Decapsulation**.

---

# Sender vs Receiver

### Sender

```text
Application

↓

Transport

↓

Network

↓

Data Link

↓

Physical
```

---

### Receiver

```text
Physical

↓

Data Link

↓

Network

↓

Transport

↓

Application
```

---

# TCP/IP Model

The **TCP/IP Model** is the practical networking model used on the internet.

It has **4 layers**.

```text
Application

↓

Transport

↓

Internet

↓

Network Access
```

---

# OSI vs TCP/IP

| OSI | TCP/IP |
|------|---------|
| 7 layers | 4 layers |
| Theoretical model | Practical model |
| Used for learning | Used on real networks |
| More detailed | Simpler |

---

# Common Protocols by Layer

| Layer | Examples |
|--------|----------|
| Application | HTTP, HTTPS, DNS, FTP, SSH |
| Transport | TCP, UDP |
| Network | IP, ICMP |
| Data Link | Ethernet |
| Physical | Fibre, Copper, Wi-Fi |

---

# Ports Recap

Ports identify services running on a device.

Common ports:

| Port | Service |
|------:|---------|
| 22 | SSH |
| 53 | DNS |
| 80 | HTTP |
| 443 | HTTPS |
| 3389 | RDP |

Ports operate at the **Transport Layer**.

---

# Example: Visiting a Website

```text
Browser

↓

HTTPS

↓

TCP

↓

IP

↓

Ethernet

↓

Internet

↓

Web Server
```

The data is encapsulated as it leaves your device and decapsulated when it reaches the server.

---

# Common Mistakes

### Thinking the OSI Model Exists Physically

The OSI model is a **conceptual framework**.

The layers do not exist as separate physical components.

---

### Confusing Layer 2 and Layer 3

- Layer 2 uses **MAC addresses** and switches.
- Layer 3 uses **IP addresses** and routers.

---

### Memorising Without Understanding

Instead of memorising the layers, understand **what each one is responsible for**.

---

# Best Practices

- Learn the responsibilities of each layer.
- Memorise common protocols and the layer they belong to.
- Use the OSI model when troubleshooting.
- Understand the relationship between the OSI and TCP/IP models.
- Remember that data is encapsulated when sent and decapsulated when received.

---

# Key Takeaways

- The OSI model explains how network communication works.
- It consists of seven layers, each with a specific responsibility.
- TCP and UDP operate at the Transport Layer.
- Routers work at the Network Layer, while switches work at the Data Link Layer.
- Data is encapsulated by the sender and decapsulated by the receiver.
- The TCP/IP model is the practical networking model used on the internet.

---

# Quick Revision

| Layer | Main Responsibility |
|--------|---------------------|
| 7. Application | User services |
| 6. Presentation | Encryption & formatting |
| 5. Session | Manage communication sessions |
| 4. Transport | TCP / UDP |
| 3. Network | IP & routing |
| 2. Data Link | MAC & switching |
| 1. Physical | Hardware & signals |

---

# Interview Questions

### What is the purpose of the OSI model?

The OSI model provides a structured framework for understanding, designing and troubleshooting network communication.

### Which OSI layer uses IP addresses?

Layer 3 – the Network Layer.

### Which OSI layer uses MAC addresses?

Layer 2 – the Data Link Layer.

### What is the difference between the OSI model and the TCP/IP model?

The OSI model has seven conceptual layers used for learning and troubleshooting, while the TCP/IP model has four practical layers used by real-world networks.

### What is encapsulation?

Encapsulation is the process of adding protocol headers to data as it moves down the network stack before being transmitted across the network.