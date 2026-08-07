# AWS Assignment 3 – Static Website Hosting with Amazon S3, CloudFront & Route 53

## Objective

The objective of this assignment was to deploy a static website using Amazon S3, improve its performance and security using Amazon CloudFront, and prepare it for a custom domain using Amazon Route 53. This project introduced the concepts of object storage, content delivery networks (CDNs), DNS, and global content caching.

---


## AWS Services Used

- Amazon S3
- Amazon CloudFront
- Amazon Route 53
- Cloudflare DNS
- HTML/CSS

---

## Steps Completed

### 1. Created an S3 Bucket

Created a new S3 bucket called:

```
humdaan-devops-static-site
```

This bucket stores all of the website files and acts as the origin for CloudFront.

---

### 2. Uploaded Website Files

Uploaded the following files to the bucket:

- index.html
- error.html

These files make up the complete static website.

---

### 3. Enabled Static Website Hosting

Enabled Static Website Hosting on the bucket.

Configured:

- Index document: `index.html`
- Error document: `error.html`

AWS generated a website endpoint similar to:

```
http://humdaan-devops-static-site.s3-website-eu-west-2.amazonaws.com
```

This endpoint allows the website to be accessed directly from S3.

---

### 4. Configured Bucket Permissions

Updated the bucket policy to allow public read access so visitors could access the website files without AWS credentials.

---

### 5. Verified the Website

Opened the S3 Website Endpoint in a browser and confirmed that the website loaded successfully.

---

### 6. Created a CloudFront Distribution

Created a CloudFront distribution using the S3 Website Endpoint as the origin.

Configuration included:

- Origin: S3 Website Endpoint
- Viewer Protocol Policy: Redirect HTTP to HTTPS
- Allowed Methods: GET, HEAD
- Cache Policy: CachingOptimized
- Default CloudFront settings

CloudFront generated a distribution domain similar to:

```
https://d2l10wt1n868hm.cloudfront.net
```

After deployment, the website was successfully accessible over HTTPS.

---

### 7. Tested CloudFront Caching

After modifying `index.html` and uploading the updated file to S3:

- The S3 Website Endpoint displayed the changes immediately.
- CloudFront initially displayed the old cached version.
- After the cache refreshed, CloudFront automatically served the updated content.

This demonstrated how CloudFront caches website content to improve performance while periodically retrieving updated files from the origin.

---

### 8. Created a Route 53 Hosted Zone

Created a Public Hosted Zone for:

```
humdaan.co.uk
```

Although the domain is registered with Cloudflare, creating the hosted zone demonstrates how Route 53 would manage DNS records within AWS.

---

### 9. Added DNS Records

Created an Alias A record pointing the root domain to the CloudFront distribution.

This allows the custom domain to route traffic through CloudFront before reaching the S3 website.

---

## Key Concepts Learned

### Amazon S3

Amazon S3 is AWS's object storage service. It stores website files such as HTML, CSS, images and JavaScript. When Static Website Hosting is enabled, the bucket behaves like a simple web server.

---

### Static Website Hosting

Allows an S3 bucket to serve web pages directly using an index document and an error document.

---

### CloudFront

CloudFront is AWS's Content Delivery Network (CDN).

Instead of every visitor downloading files directly from the S3 bucket, CloudFront stores copies of the website at edge locations around the world, reducing latency and improving performance.

Benefits include:

- Faster website loading
- HTTPS support
- Global edge locations
- Reduced load on S3
- Improved scalability
- Better availability

---

### Origin

The origin is the location CloudFront retrieves files from.

In this assignment, the origin was the Amazon S3 Static Website Endpoint.

---

### Cache

CloudFront temporarily stores copies of website files.

When users request a page:

1. CloudFront checks whether it already has a cached copy.
2. If cached, it serves that version immediately.
3. If not, it retrieves the latest version from S3 and stores it for future requests.

---

### Edge Locations

CloudFront operates hundreds of edge locations worldwide.

Visitors connect to the nearest edge location instead of directly to the AWS Region hosting the bucket.

---

### Route 53

Amazon Route 53 is AWS's managed DNS service.

It translates domain names into AWS resources such as CloudFront distributions, load balancers and EC2 instances.

---

### Alias Records

An Alias record is an AWS-specific DNS record that points directly to AWS resources without needing an IP address.

---

### HTTPS

CloudFront provides HTTPS encryption for the default `cloudfront.net` domain, ensuring secure communication between users and the CDN.

---

## Outcome

Successfully deployed a static website using Amazon S3 and distributed it globally through Amazon CloudFront. Verified the website using both the S3 Website Endpoint and the CloudFront Distribution URL, demonstrated CloudFront caching behaviour by updating website content, and configured Amazon Route 53 to route a custom domain to the CloudFront distribution. This assignment provided practical experience with static website hosting, object storage, DNS, CDNs, HTTPS, and modern cloud architecture.