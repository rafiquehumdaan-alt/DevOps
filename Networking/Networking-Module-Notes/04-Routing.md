# Networking Notes - Part 4: Routing

> Covers:
>
> - What is Routing?
> - Routers
> - Routing Tables
> - Default Gateway
> - Static Routing
> - Dynamic Routing
> - Common Routing Protocols
> - Packet Forwarding

---

# What is Routing?

**Routing** is the process of sending network traffic from one network to another.

When a device wants to communicate with another device on a different network, the data must pass through a router.

The router decides the best path for the data to take.

---

# Why is Routing Important?

Without routing:

- Home networks could not access the internet.
- Offices could not communicate with cloud services.
- Websites would not be reachable.

Routing allows different networks to communicate.

---

# Example

```text
Laptop

↓

Home Router

↓

Internet

↓

Google Server
```

The router forwards the data towards its destination.

---

# What is a Router?

A **router** is a Layer 3 (Network Layer) device that connects multiple networks together.

Unlike a switch, which forwards traffic inside the same LAN using MAC addresses, a router forwards traffic between different networks using IP addresses.

---

# Switch vs Router

| Switch | Router |
|---------|---------|
| Connects devices | Connects networks |
| Uses MAC addresses | Uses IP addresses |
| Layer 2 | Layer 3 |

---

# Routing Table

Every router maintains a **routing table**.

A routing table contains information about:

- Destination networks
- Next hop
- Interface
- Route source

The router checks this table before forwarding every packet.

---

# Example Routing Table

| Destination | Gateway | Interface |
|-------------|----------|-----------|
| 192.168.1.0/24 | Local | eth0 |
| 10.0.0.0/24 | 192.168.1.1 | eth1 |
| Default Route | ISP | eth0 |

The router chooses the most specific matching route.

---

# Default Gateway

A **default gateway** is the router that devices send traffic to when the destination is outside the local network.

Example:

```text
Laptop

↓

Default Gateway

↓

Internet
```

Most home networks use the home router as the default gateway.

---

# Packet Forwarding

When a packet arrives:

1. The router reads the destination IP address.
2. It searches the routing table.
3. It selects the best route.
4. It forwards the packet to the next hop.

---

# Example Packet Journey

```text
Laptop

↓

Home Router

↓

ISP Router

↓

Internet Backbone

↓

Destination Server
```

Each router makes its own forwarding decision.

---

# Static Routing

A **static route** is manually configured by a network administrator.

Example:

```text
10.0.0.0/24

↓

Gateway:

192.168.1.1
```

Advantages:

- Simple
- Predictable
- Low overhead

Disadvantages:

- Doesn't adapt automatically
- Difficult to manage in large networks

---

# Dynamic Routing

Dynamic routing allows routers to exchange routing information automatically.

Advantages:

- Automatic updates
- Adapts to failures
- Scales well

Disadvantages:

- More complex
- Uses additional CPU and bandwidth

Dynamic routing is commonly used in enterprise and ISP environments.

---

# Static vs Dynamic Routing

| Static Routing | Dynamic Routing |
|----------------|-----------------|
| Manual configuration | Automatic updates |
| Simple | More complex |
| Best for small networks | Best for large networks |
| No automatic failover | Can adapt to network changes |

---

# Common Routing Protocols

Routing protocols allow routers to exchange routing information.

The most common are:

- RIP
- OSPF
- BGP

---

# RIP (Routing Information Protocol)

Characteristics:

- Simple
- Easy to configure
- Uses hop count
- Maximum of 15 hops

Best suited to small networks.

---

# OSPF (Open Shortest Path First)

Characteristics:

- Faster than RIP
- Scales well
- Calculates the shortest path
- Widely used in enterprise networks

OSPF is one of the most common internal routing protocols.

---

# BGP (Border Gateway Protocol)

BGP is the routing protocol used on the internet.

Characteristics:

- Connects different organisations (Autonomous Systems)
- Highly scalable
- Policy-based routing
- Used by ISPs and cloud providers

Without BGP, the internet would not function.

---

# Routing Protocol Comparison

| Protocol | Typical Use |
|----------|-------------|
| RIP | Small networks |
| OSPF | Enterprise networks |
| BGP | Internet / ISPs |

---

# Longest Prefix Match

When multiple routes exist, routers choose the **most specific** route.

Example:

Available routes:

```text
10.0.0.0/8

10.1.0.0/16

10.1.2.0/24
```

Destination:

```text
10.1.2.15
```

The router selects:

```text
10.1.2.0/24
```

because it is the most specific match.

---

# Routing Example

```text
Laptop

↓

Router

↓

Routing Table

↓

Next Hop

↓

Destination
```

Each router repeats this process until the packet reaches its final destination.

---

# Common Mistakes

### Thinking Routers Know Every Device

Routers know about **networks**, not individual devices.

They forward packets based on destination **IP networks**, not MAC addresses.

---

### Confusing Switches and Routers

Remember:

- Switch → Local network (Layer 2)
- Router → Different networks (Layer 3)

---

### Assuming Static Routes Update Automatically

Static routes never change unless an administrator modifies them.

---

# Best Practices

- Understand the purpose of the default gateway.
- Learn how routing tables are used.
- Use static routing for small, simple networks.
- Use dynamic routing for large or changing networks.
- Know the basic differences between RIP, OSPF and BGP.

---

# Key Takeaways

- Routing moves packets between different networks.
- Routers use IP addresses and routing tables.
- The default gateway is used for destinations outside the local network.
- Static routes are manually configured.
- Dynamic routing automatically exchanges route information.
- RIP, OSPF and BGP are common routing protocols.
- Routers choose the most specific matching route when multiple routes exist.

---

# Quick Revision

| Concept | Purpose |
|---------|---------|
| Router | Connects networks |
| Routing Table | Determines packet path |
| Default Gateway | Exit point from local network |
| Static Route | Manual route |
| Dynamic Route | Automatically learned route |
| RIP | Small networks |
| OSPF | Enterprise routing |
| BGP | Internet routing |

---

# Interview Questions

### What is routing?

Routing is the process of forwarding packets between different networks using IP addresses and routing tables.

### What is the purpose of a routing table?

A routing table tells a router where to send packets by listing destination networks and the best next hop.

### What is a default gateway?

A default gateway is the router a device uses to send traffic destined for networks outside its local subnet.

### What is the difference between static and dynamic routing?

Static routing is manually configured and does not change automatically, while dynamic routing uses routing protocols to learn and update routes automatically.

### What are RIP, OSPF and BGP?

They are routing protocols used to exchange routing information:
- **RIP** is simple and suited to small networks.
- **OSPF** is commonly used in enterprise networks.
- **BGP** is the protocol that powers routing across the internet.