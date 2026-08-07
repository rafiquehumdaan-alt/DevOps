# AWS Notes - Part 3: Storage

> Covers:
>
> - Amazon EBS (Elastic Block Store)
> - Amazon Machine Images (AMI)
> - Amazon EFS (Elastic File System)

---

# AWS Storage Overview

AWS offers multiple storage services designed for different use cases.

| Service | Type | Typical Use |
|----------|------|-------------|
| EBS | Block Storage | EC2 boot drives and application storage |
| EFS | Network File Storage | Shared storage across multiple EC2 instances |
| S3 | Object Storage | Files, backups, static websites (covered later) |

---

# Amazon EBS (Elastic Block Store)

Amazon EBS is **persistent block storage** designed for EC2 instances.

Think of it like a **virtual hard drive (SSD/HDD)** attached to a virtual machine.

---

# Key Features

- Persistent storage
- High performance
- Data survives instance reboots
- Can be resized
- Supports encryption
- Can be backed up using snapshots

---

# Persistent Storage

One of EBS's biggest advantages is persistence.

If an EC2 instance stops and starts, the EBS volume remains intact.

Example:

```text
EC2 Instance
      │
      ▼
   EBS Volume
```

Stopping the EC2 instance does **not** delete the EBS volume.

However, if the instance is terminated, the root EBS volume may also be deleted unless configured otherwise.

---

# EBS Volume Types

AWS offers different EBS volume types depending on performance requirements.

| Volume Type | Best For |
|-------------|----------|
| gp3 | General-purpose SSD (recommended) |
| gp2 | Older general-purpose SSD |
| io1 / io2 | High-performance databases |
| st1 | Frequently accessed HDD workloads |
| sc1 | Low-cost archival HDD storage |

For most workloads, **gp3** is the recommended choice.

---

# Availability Zones

An EBS volume exists within **one Availability Zone**.

Example:

```text
eu-west-2a

EC2
 │
 ▼
EBS
```

You cannot directly attach an EBS volume to an EC2 instance in another Availability Zone.

---

# EBS Snapshots

Snapshots are backups of EBS volumes.

Snapshots are stored in Amazon S3 (managed by AWS).

Benefits:

- Backup data
- Disaster recovery
- Restore deleted volumes
- Create new volumes
- Copy data between regions

---

# Snapshot Workflow

```text
EBS Volume

↓

Snapshot

↓

Stored by AWS

↓

Restore New Volume
```

Snapshots are incremental, meaning only changed blocks are saved after the first snapshot.

This reduces storage costs.

---

# EBS Encryption

EBS supports encryption using AWS Key Management Service (KMS).

Encryption protects:

- Stored data
- Snapshots
- Data moving between EC2 and EBS

Encryption is recommended for production workloads.

---

# Resizing EBS Volumes

EBS volumes can be resized without replacing them.

You can increase:

- Storage capacity
- Performance
- IOPS (depending on volume type)

After resizing, the operating system may also need the filesystem expanded.

---

# Amazon Machine Image (AMI)

An AMI (Amazon Machine Image) is a template used to launch EC2 instances.

It contains:

- Operating System
- Installed software
- Configuration
- Startup settings

---

# Types of AMIs

### AWS Managed

Provided by AWS.

Examples:

- Amazon Linux
- Ubuntu
- Windows Server

---

### Marketplace AMIs

Created by third-party vendors.

Often include:

- Security software
- Databases
- Monitoring tools
- Commercial applications

Some Marketplace AMIs incur additional charges.

---

### Custom AMIs

Created by you.

Useful when you've already configured:

- Software
- Users
- Security settings
- Updates

Instead of configuring every new server manually, launch new instances from the custom AMI.

---

# Why Use Custom AMIs?

Without a custom AMI:

```text
Launch Server

↓

Install Software

↓

Configure Server

↓

Repeat
```

With a custom AMI:

```text
Launch Custom AMI

↓

Server Ready
```

This improves consistency and saves time.

---

# Amazon EFS (Elastic File System)

Amazon EFS is a fully managed **network file system**.

Unlike EBS, multiple EC2 instances can access the same EFS file system simultaneously.

---

# Key Features

- Shared storage
- Highly available
- Automatically scales
- Managed by AWS
- Supports Linux workloads

---

# EFS Architecture

```text
          EFS
        /  |  \
      EC2 EC2 EC2
```

Every EC2 instance sees the same files.

---

# EBS vs EFS

| Feature | EBS | EFS |
|----------|-----|-----|
| Storage Type | Block Storage | Network File Storage |
| Multiple EC2 Instances | No | Yes |
| Availability Zone | Single AZ | Multiple AZs |
| Performance | Very High | High |
| Typical Use | Single server | Shared storage |

---

# When to Use EBS

Use EBS when:

- Hosting a database
- Running a web server
- Booting an EC2 instance
- High-performance storage is required

---

# When to Use EFS

Use EFS when:

- Multiple EC2 instances need the same files
- Shared application storage
- Shared web content
- Container storage
- Home directories

---

# Example Architecture

```text
            Internet
                │
                ▼
        Load Balancer
             │
     ┌───────┴────────┐
     ▼                ▼
   EC2              EC2
      \            /
       \          /
        ▼        ▼
            Amazon EFS
```

Both EC2 instances access the same files.

---

# Best Practices

- Use **gp3** volumes for most workloads.
- Take regular EBS snapshots.
- Enable encryption for production.
- Create custom AMIs after configuring servers.
- Use EFS when multiple EC2 instances need shared storage.
- Avoid storing shared application files on individual EBS volumes.

---

# Key Takeaways

- **EBS** is persistent block storage attached to EC2.
- EBS volumes exist in a single Availability Zone.
- Snapshots back up EBS volumes.
- AMIs are templates used to launch EC2 instances.
- Custom AMIs speed up deployments.
- **EFS** is shared file storage accessible by multiple EC2 instances.
- EFS automatically scales as storage requirements grow.

---

# Quick Revision

| Term | Meaning |
|------|---------|
| EBS | Persistent Block Storage |
| Snapshot | Backup of an EBS Volume |
| AMI | EC2 Launch Template |
| Custom AMI | Your own configured server image |
| EFS | Shared Network File System |
| gp3 | Recommended General-Purpose SSD |

---

# Interview Questions

### What is Amazon EBS?

Persistent block storage used primarily by EC2 instances.

### What is the difference between EBS and EFS?

EBS is attached to a single EC2 instance, while EFS can be shared across multiple EC2 instances simultaneously.

### What is an AMI?

A template containing an operating system and configuration used to launch EC2 instances.

### Why use EBS Snapshots?

To back up volumes, recover data, migrate between regions, and create new volumes.

### When would you choose EFS over EBS?

When multiple EC2 instances need to access the same files at the same time.