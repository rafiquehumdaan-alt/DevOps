# AWS Notes - Part 9: CloudFront (Content Delivery Network)

> Covers:
>
> - What is a CDN?
> - Amazon CloudFront
> - CloudFront Origins
> - Edge Locations
> - Caching
> - S3 Origins
> - EC2 & ALB Origins
> - Benefits of CloudFront
> - Cache Invalidation

---

# What is a CDN?

A **Content Delivery Network (CDN)** is a network of servers distributed around the world that stores copies (cached versions) of your content closer to users.

Instead of every user accessing your origin server directly, users are served content from the nearest CDN location.

Benefits:

- Faster loading times
- Lower latency
- Reduced load on your servers
- Better user experience

---

# What is Amazon CloudFront?

Amazon CloudFront is AWS's global CDN service.

It distributes content using **Edge Locations** around the world.

CloudFront can cache:

- Images
- Videos
- HTML
- CSS
- JavaScript
- APIs
- Downloads

---

# How CloudFront Works

```text
User

↓

Nearest Edge Location

↓

Cached Content?

│

├── Yes → Return Content

└── No

↓

Origin Server

↓

Cache Content

↓

Return to User
```

The first request may be slower, but future requests are much faster because the content is cached.

---

# What is an Origin?

An **Origin** is the original location where CloudFront retrieves content.

Supported origins include:

- Amazon S3
- Application Load Balancer (ALB)
- EC2 Instance
- Custom Web Server
- API Gateway

CloudFront caches content from the origin and serves it through Edge Locations.

---

# Edge Locations

Edge Locations are CloudFront servers located around the world.

Example:

```text
Origin (London)

↓

CloudFront Edge Locations

├── London
├── Paris
├── New York
├── Tokyo
├── Sydney
```

Users connect to the closest Edge Location instead of the origin.

---

# Why Use Edge Locations?

Without CloudFront:

```text
User (Australia)

↓

London Server
```

Long-distance connection = slower response.

With CloudFront:

```text
User (Australia)

↓

Sydney Edge Location

↓

Cached Content
```

Much faster response.

---

# CloudFront Caching

CloudFront stores frequently requested files in Edge Locations.

Example:

```text
First Request

↓

Origin Server

↓

Edge Location

↓

User
```

Later requests:

```text
Edge Location

↓

User
```

The origin server doesn't need to be contacted again until the cache expires.

---

# Cache Expiration

Cached content remains at Edge Locations for a configurable amount of time.

After the cache expires:

- CloudFront requests the latest version from the origin.
- The cache is updated automatically.

---

# Cache Invalidation

Sometimes you update a file but don't want to wait for the cache to expire.

You can perform a **Cache Invalidation**, which removes cached copies from Edge Locations.

Example:

```text
Website Updated

↓

CloudFront Invalidation

↓

New Version Available Immediately
```

---

# CloudFront with Amazon S3

A common architecture for static websites.

```text
Users

↓

CloudFront

↓

Amazon S3

↓

Website Files
```

Benefits:

- Faster website loading
- Global performance
- Reduced S3 requests
- HTTPS support

This is the architecture used in your **AWS Static Website Assignment**.

---

# CloudFront with EC2

CloudFront can also cache content from an EC2 instance.

```text
Users

↓

CloudFront

↓

EC2 Web Server
```

Useful for:

- Dynamic websites
- Web applications
- Downloads

---

# CloudFront with Application Load Balancer

For production environments:

```text
Users

↓

CloudFront

↓

Application Load Balancer

↓

EC2 Instances
```

Benefits:

- Global performance
- Load balancing
- High availability
- Improved scalability

---

# CloudFront + ALB + Auto Scaling

A common AWS architecture:

```text
Users

↓

CloudFront

↓

Application Load Balancer

↓

Auto Scaling Group

↓

EC2 Instances
```

CloudFront caches static content while the ALB distributes dynamic requests across EC2 instances.

---

# HTTPS with CloudFront

CloudFront supports HTTPS using **AWS Certificate Manager (ACM)** certificates.

Benefits:

- Encrypted communication
- Improved security
- Better SEO
- Increased user trust

---

# CloudFront Benefits

- Faster content delivery
- Global Edge Locations
- Lower latency
- Reduced load on origin servers
- Automatic scaling
- HTTPS support
- DDoS protection (via AWS Shield Standard)
- Integrates with AWS services

---

# When Should You Use CloudFront?

Use CloudFront when:

- Hosting static websites
- Delivering images or videos
- Serving downloadable files
- Building global web applications
- Improving website performance
- Reducing load on EC2 or S3

---

# CloudFront vs S3

| Amazon S3 | CloudFront |
|------------|------------|
| Stores files | Delivers cached files |
| Single Region | Global Edge Locations |
| No caching | Intelligent caching |
| Higher latency | Lower latency |

CloudFront does **not** replace S3—it works alongside it.

---

# CloudFront vs Load Balancer

| CloudFront | Application Load Balancer |
|-------------|--------------------------|
| Global CDN | Regional Load Balancer |
| Caches content | Does not cache |
| Improves speed | Distributes traffic |
| Uses Edge Locations | Uses Target Groups |

Many production systems use **both** together.

---

# Example Production Architecture

```text
Users

↓

CloudFront

↓

Application Load Balancer

↓

Auto Scaling Group

↓

EC2 Instances

↓

Database
```

This provides:

- Fast global content delivery
- High availability
- Automatic scaling
- Fault tolerance

---

# Best Practices

- Place CloudFront in front of S3 for static websites.
- Use CloudFront with ALBs for production web applications.
- Enable HTTPS using ACM certificates.
- Use cache invalidation after important updates.
- Cache static content aggressively to improve performance.
- Keep dynamic content uncached where appropriate.

---

# Key Takeaways

- CloudFront is AWS's global Content Delivery Network (CDN).
- Edge Locations cache content closer to users.
- Origins provide the original content.
- CloudFront reduces latency and improves website performance.
- CloudFront works with S3, EC2, ALBs and API Gateway.
- Cache invalidation forces updated content to be served immediately.
- CloudFront is commonly used with Application Load Balancers and Auto Scaling Groups in production environments.

---

# Quick Revision

| Term | Meaning |
|------|---------|
| CDN | Content Delivery Network |
| CloudFront | AWS CDN Service |
| Origin | Original content source |
| Edge Location | Global cache server |
| Cache | Temporary stored copy of content |
| Cache Invalidation | Removes cached content before expiry |
| S3 Origin | CloudFront serves files from S3 |
| ALB Origin | CloudFront serves traffic through a Load Balancer |

---

# Interview Questions

### What is Amazon CloudFront?

CloudFront is AWS's Content Delivery Network (CDN) that caches content at Edge Locations to improve performance and reduce latency.

### What is an Origin in CloudFront?

An Origin is the original source of the content, such as an S3 bucket, EC2 instance, Application Load Balancer or API Gateway.

### What are Edge Locations?

Edge Locations are CloudFront servers distributed worldwide that cache and deliver content closer to users.

### Why would you use CloudFront with S3?

To improve performance, reduce latency, decrease requests to S3 and deliver static content globally.

### What is Cache Invalidation?

Cache Invalidation removes cached files from Edge Locations so users receive the latest version immediately instead of waiting for the cache to expire.

### Can CloudFront work with an Application Load Balancer?

Yes. CloudFront commonly sits in front of an Application Load Balancer to improve global performance while the ALB distributes traffic to backend servers.