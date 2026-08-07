# Networking Notes - Part 6: Network Troubleshooting

> Covers:
>
> - Troubleshooting Methodology
> - Common Network Problems
> - `ping`
> - `traceroute`
> - `nslookup`
> - `dig`
> - Other Useful Networking Commands
> - Real-World Troubleshooting Scenarios
> - Interview Tips

---

# Why Network Troubleshooting Matters

Network problems are common in IT, Cloud and DevOps roles.

A structured troubleshooting process helps you:

- Find problems faster
- Avoid unnecessary changes
- Reduce downtime
- Identify the root cause

Good troubleshooting is about **evidence**, not guessing.

---

# Troubleshooting Methodology

A simple process:

```text
Identify Problem

↓

Gather Information

↓

Test Connectivity

↓

Identify Root Cause

↓

Apply Fix

↓

Verify Solution
```

Avoid changing multiple things at once.

---

# Common Network Problems

Examples include:

- No internet connection
- Website not loading
- Slow network performance
- DNS resolution failure
- Incorrect IP configuration
- Firewall blocking traffic
- Routing issues
- Server unavailable

---

# Step 1 – Check Physical Connectivity

Before investigating software:

- Is the network cable connected?
- Is Wi-Fi enabled?
- Is the switch powered on?
- Are interface lights active?

Never overlook simple causes.

---

# Step 2 – Verify IP Configuration

On Linux:

```bash
ip addr
```

Displays:

- IP address
- Subnet mask
- Network interfaces

Verify that the device has a valid IP address.

---

# Step 3 – Test Connectivity with `ping`

`ping` checks whether a device can be reached over the network.

Example:

```bash
ping google.com
```

Successful output:

```text
64 bytes from ...

time=18 ms
```

Stop with:

```text
Ctrl + C
```

---

# What Does `ping` Test?

It checks:

- Network connectivity
- Basic latency
- Packet loss

`ping` uses the **ICMP** protocol.

---

# Example Troubleshooting with `ping`

Test:

```bash
ping 8.8.8.8
```

Works?

✅ Internet connectivity exists.

---

Then test:

```bash
ping google.com
```

Fails?

Likely a **DNS problem** rather than a network connectivity issue.

---

# Step 4 – Use `traceroute`

`traceroute` shows the path packets take to reach a destination.

Example:

```bash
traceroute google.com
```

Output:

```text
Laptop

↓

Router

↓

ISP

↓

Internet

↓

Google
```

Each "hop" represents a router.

---

# Why Use `traceroute`?

Useful for identifying:

- Routing issues
- High latency
- Packet loss
- Where traffic stops

---

# Step 5 – Check DNS

Use:

```bash
nslookup google.com
```

or

```bash
dig google.com
```

If DNS cannot resolve the domain name, websites may not load even if the network connection is working.

---

# `nslookup`

Quick DNS lookup.

Example:

```bash
nslookup openai.com
```

Shows:

- IP address
- DNS server used

---

# `dig`

Provides more detailed DNS information.

Example:

```bash
dig openai.com
```

Useful details include:

- Query time
- Record type
- Authority section
- TTL

---

# Step 6 – Check Routing

Display the routing table:

```bash
ip route
```

Example output:

```text
default via 192.168.1.1
```

Ensure the default gateway is correct.

---

# Step 7 – Check Open Ports

Use:

```bash
ss -tuln
```

or

```bash
netstat -tuln
```

Displays listening services and ports.

Useful when troubleshooting servers.

---

# Testing HTTP Services

Use:

```bash
curl https://example.com
```

Checks whether a web service is responding.

Useful for testing APIs and websites.

---

# Download Testing

```bash
wget https://example.com/file.txt
```

Confirms:

- DNS resolution
- HTTP connectivity
- Download functionality

---

# Common Troubleshooting Workflow

```text
Website Doesn't Load

↓

ping 8.8.8.8

↓

ping google.com

↓

nslookup

↓

traceroute

↓

curl
```

Each step narrows down the problem.

---

# Common Problems & Causes

| Problem | Possible Cause |
|----------|----------------|
| No internet | Cable, Wi-Fi, router |
| Can ping IP but not hostname | DNS issue |
| Cannot SSH | Firewall, SSH service, wrong IP |
| Website unavailable | Web server or firewall |
| Slow connection | Congestion or routing issue |
| High latency | Network path problem |

---

# Real-World Example

Scenario:

Users cannot access:

```text
www.example.com
```

Troubleshooting:

```text
ping 8.8.8.8

↓

Works

↓

nslookup example.com

↓

Fails

↓

DNS Misconfiguration
```

The issue is not internet connectivity—it is DNS.

---

# Another Example

Cannot SSH into a server.

Check:

- Correct IP?
- SSH service running?
- Port 22 open?
- Firewall rules?
- Security Groups (AWS)?
- Network ACLs?

---

# Common Mistakes

### Skipping Basic Checks

Always verify:

- Cable
- Wi-Fi
- IP address
- Gateway

before investigating more complex issues.

---

### Assuming DNS is Always the Problem

If:

```bash
ping 8.8.8.8
```

fails,

the issue is likely connectivity—not DNS.

---

### Making Multiple Changes

Only change one thing at a time.

This makes it much easier to identify the root cause.

---

# Best Practices

- Follow a structured troubleshooting process.
- Gather evidence before making changes.
- Test one layer at a time.
- Use the correct tool for the problem.
- Verify the fix after applying it.

---

# Key Takeaways

- Start with the simplest possible checks.
- `ping` tests connectivity.
- `traceroute` shows the network path.
- `nslookup` and `dig` troubleshoot DNS.
- `curl` tests web services.
- Routing tables determine packet forwarding.
- Effective troubleshooting relies on evidence, not guesswork.

---

# Quick Revision

| Command | Purpose |
|----------|----------|
| `ping` | Test connectivity |
| `traceroute` | View network path |
| `nslookup` | Basic DNS lookup |
| `dig` | Detailed DNS lookup |
| `ip addr` | View IP configuration |
| `ip route` | View routing table |
| `ss -tuln` | Show listening ports |
| `curl` | Test HTTP service |
| `wget` | Download a file |

---

# Troubleshooting Checklist

```text
✔ Check cables/Wi-Fi

✔ Verify IP address

✔ Check default gateway

✔ Ping gateway

✔ Ping external IP

✔ Test DNS

✔ Check routing

✔ Test application

✔ Verify firewall

✔ Check logs
```

---

# Interview Questions

### What is the purpose of the `ping` command?

`ping` tests basic network connectivity, measures latency and detects packet loss using the ICMP protocol.

### What is the difference between `ping` and `traceroute`?

`ping` checks whether a destination is reachable, while `traceroute` shows each router (hop) the traffic passes through to reach that destination.

### When would you use `nslookup` or `dig`?

When troubleshooting DNS issues, verifying domain name resolution or checking specific DNS records.

### A user can ping `8.8.8.8` but cannot access `google.com`. What is the likely problem?

The network connection is working, but DNS resolution is failing.

### What is the first thing you should do when troubleshooting a network issue?

Start with the simplest checks—verify the physical connection, confirm IP configuration and gather evidence before making changes.