# Networking Commands

This document contains commonly used Linux networking commands for monitoring, troubleshooting, and managing network connectivity.

---

# IP Addressing

Display IP addresses assigned to the system.

```bash
ip addr
```

Display only IPv4 addresses.

```bash
ip -4 addr
```

---

# Routing

Display the routing table.

```bash
ip route
```

Display the default gateway.

```bash
ip route | grep default
```

---

# Network Interfaces

List all network interfaces.

```bash
ip link
```

Display interface statistics.

```bash
ip -s link
```

---

# Test Connectivity

Ping another device.

```bash
ping <hostname-or-ip>
```

Example:

```bash
ping google.com
```

---

# DNS

Query DNS using dig.

```bash
dig example.com
```

Query DNS using nslookup.

```bash
nslookup example.com
```

Lookup a hostname.

```bash
host example.com
```

---

# HTTP Requests

Retrieve a webpage.

```bash
curl http://example.com
```

View HTTP response headers.

```bash
curl -I http://example.com
```

Download a file.

```bash
curl -O https://example.com/file.zip
```

---

# Open Ports

Display listening ports.

```bash
sudo ss -tulpn
```

Filter for a specific port.

```bash
sudo ss -tulpn | grep :80
```

Older alternative.

```bash
netstat -tulpn
```

---

# Active Connections

Display established network connections.

```bash
ss -tun
```

---

# Trace Network Path

Trace the route packets take.

```bash
traceroute example.com
```

---

# Name Resolution

Display hostname.

```bash
hostname
```

Display detailed hostname information.

```bash
hostnamectl
```

---

# Firewall

View UFW status.

```bash
sudo ufw status
```

Enable UFW.

```bash
sudo ufw enable
```

Disable UFW.

```bash
sudo ufw disable
```

Allow a port.

```bash
sudo ufw allow 80/tcp
```

---

# Services

Check service status.

```bash
sudo systemctl status <service>
```

Start a service.

```bash
sudo systemctl start <service>
```

Stop a service.

```bash
sudo systemctl stop <service>
```

Restart a service.

```bash
sudo systemctl restart <service>
```

Enable a service at boot.

```bash
sudo systemctl enable <service>
```

---

# Processes

View running processes.

```bash
ps aux
```

Search for a process.

```bash
ps aux | grep <process>
```

---

# Package Management

Refresh package repositories.

```bash
sudo apt update
```

Upgrade installed packages.

```bash
sudo apt upgrade
```

Install a package.

```bash
sudo apt install <package>
```

Remove a package.

```bash
sudo apt remove <package>
```

---

# SSH

Connect to a remote server.

```bash
ssh username@server-ip
```

Connect using an SSH private key.

```bash
ssh -i private_key.pem username@server-ip
```

Copy files to a remote server.

```bash
scp file.txt username@server-ip:/path
```

Copy files from a remote server.

```bash
scp username@server-ip:/path/file.txt .
```

---

# File and Directory Management

List files.

```bash
ls
```

Detailed file listing.

```bash
ls -lh
```

Display current directory.

```bash
pwd
```

Create a directory.

```bash
mkdir directory
```

Copy files.

```bash
cp source destination
```

Move files.

```bash
mv source destination
```

Delete files.

```bash
rm file
```

---

# Network Troubleshooting Checklist

Useful commands when diagnosing network issues:

```bash
hostnamectl
ip addr
ip route
ping <host>
dig <domain>
curl -I http://<host>
ss -tulpn
sudo ufw status
systemctl status <service>
```

---

# Summary

These commands provide a solid foundation for:

- Viewing IP configuration
- Testing connectivity
- Troubleshooting DNS
- Monitoring network connections
- Checking open ports
- Managing firewalls
- Managing services
- Administering Linux systems
- Remote administration using SSH