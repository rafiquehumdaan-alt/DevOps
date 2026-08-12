# Azure NGINX Web Server Deployment

## Project Overview

This project demonstrates the deployment of an Ubuntu Linux virtual machine in Microsoft Azure, the installation and configuration of the NGINX web server, and the configuration of Cloudflare DNS to make the website publicly accessible using a custom domain.

This project was completed to gain hands-on experience with cloud infrastructure, Linux administration, networking, DNS, and web server deployment.

---

# Objectives

- Deploy an Ubuntu Server virtual machine in Microsoft Azure.
- Securely connect to the VM using SSH.
- Install and configure NGINX.
- Verify that the web server is accessible over HTTP.
- Configure Cloudflare DNS to point a custom domain to the Azure VM.
- Verify that the website is accessible via the domain name.

---

# Environment

## Cloud Provider

- Microsoft Azure

## Operating System

- Ubuntu Server 24.04 LTS

## Virtual Machine

- Name: ubuntu-nginx
- Size: Standard_B2ats_v2
- Authentication: SSH Public Key
- Username: azureuser

## Web Server

- NGINX

## Domain Provider

- Cloudflare

---

# Technologies Used

- Microsoft Azure
- Ubuntu Linux
- NGINX
- SSH
- Cloudflare DNS
- Bash
- Git
- GitHub

---

# Deployment Process

## 1. Created the Azure Virtual Machine

An Ubuntu Server 24.04 LTS virtual machine was deployed in Azure using SSH public key authentication.

The VM was assigned a public IPv4 address to allow remote administration and web traffic.

---

## 2. Connected using SSH

The VM was accessed securely from WSL using:

```bash
ssh -i ~/.ssh/ubuntu-nginx_key.pem azureuser@20.11.57.251
```

Connection was verified using:

```bash
whoami
hostname
pwd
```

---

## 3. Updated the Package Repository

Before installing software, the package index was refreshed.

```bash
sudo apt update
```

This downloads the latest package information from the Ubuntu repositories.

---

## 4. Installed NGINX

NGINX was installed using the Ubuntu package manager.

```bash
sudo apt install nginx -y
```

---

## 5. Verified the NGINX Service

The status of the web server was checked using:

```bash
sudo systemctl status nginx
```

The service was confirmed to be:

- Active
- Running
- Enabled at boot

---

## 6. Verified Port 80

NGINX was confirmed to be listening for HTTP requests.

```bash
sudo ss -tulpn | grep :80
```

---

## 7. Tested the Web Server Locally

The default web page was tested from inside the VM.

```bash
curl http://localhost
```

This confirmed that NGINX was correctly serving web content.

---

## 8. Created a Custom Web Page

A custom HTML page was created inside:

```text
/var/www/html/index.html
```

The page replaced the default NGINX welcome page.

---

## 9. Verified Public Access

The website was successfully accessed using the Azure public IP.

```text
http://20.11.57.251
```

This confirmed that:

- Azure networking was configured correctly.
- The Network Security Group allowed HTTP traffic.
- NGINX was serving the website externally.

---

## 10. Configured Cloudflare DNS

An A record was created pointing the root domain to the Azure VM.

| Type | Name | Value |
|------|------|-------|
| A | @ | 20.11.57.251 |

A CNAME record was also created for the www subdomain.

| Type | Name | Target |
|------|------|--------|
| CNAME | www | humdaan.co.uk |

---

## 11. Verified Domain Access

The website was successfully accessed using:

```text
http://humdaan.co.uk
```

DNS resolution was also verified using:

```bash
curl -I http://humdaan.co.uk
```

---

# Skills Demonstrated

- Azure Virtual Machines
- Linux Administration
- SSH
- Package Management (APT)
- NGINX Installation
- systemd Service Management
- Network Security Groups
- HTTP Networking
- DNS
- Cloudflare
- Basic HTML
- Bash Commands
- Troubleshooting

---

# Commands Used

```bash
sudo apt update

sudo apt install nginx -y

sudo systemctl status nginx

sudo ss -tulpn | grep :80

curl http://localhost

curl -I http://20.11.57.251

curl -I http://humdaan.co.uk

ls -l /var/www/html
```

---

# Lessons Learned

- How Azure Virtual Machines are deployed.
- How SSH provides secure remote administration.
- How Ubuntu package management works.
- How NGINX serves static web content.
- How Linux services are managed using systemd.
- How Azure Network Security Groups control inbound traffic.
- How DNS translates domain names into IP addresses.
- How Cloudflare can be used to manage DNS for a public website.
- How to troubleshoot connectivity issues between the browser, DNS, and web server.

---

# Screenshots

Screenshots demonstrating the deployment process, Azure configuration, Cloudflare DNS records, terminal commands, and the final website can be found in the **screenshots** folder within this project.
