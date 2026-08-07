# AWS Notes - Part 6: Serverless

> Covers:
>
> - Serverless Computing
> - AWS Lambda
> - Benefits of Lambda
> - Supported Programming Languages
> - Event-Driven Architecture
> - Real-World Example

---

# What is Serverless?

Serverless is a cloud computing model where you write and deploy code **without managing servers**.

You don't need to:

- Launch EC2 instances
- Install operating systems
- Patch servers
- Scale infrastructure

AWS automatically manages all of this.

> **Note:** "Serverless" doesn't mean there are no servers. It means **AWS manages the servers instead of you.**

---

# Traditional vs Serverless

## Traditional

```text
Application

↓

EC2 Instance

↓

Operating System

↓

AWS Infrastructure
```

You manage the EC2 instance and operating system.

---

## Serverless

```text
Application Code

↓

AWS Lambda

↓

AWS Infrastructure
```

AWS manages everything except your code.

---

# What is AWS Lambda?

AWS Lambda is AWS's serverless compute service.

It allows you to run code **only when it's needed**.

Lambda functions are triggered by events instead of running continuously.

---

# How Lambda Works

```text
Event

↓

Lambda Function

↓

Code Executes

↓

Returns Result
```

After the function finishes, AWS stops it automatically.

---

# Event-Driven Computing

Lambda is **event-driven**, meaning code only runs when something triggers it.

Common triggers include:

- API Gateway request
- File uploaded to S3
- CloudWatch Event
- DynamoDB change
- SNS notification
- SQS message

---

# Example

A user uploads an image.

```text
Upload Image

↓

Amazon S3

↓

Lambda Triggered

↓

Resize Image

↓

Save Thumbnail
```

No server is running all day waiting for uploads.

---

# Why Use AWS Lambda?

Benefits include:

- No server management
- Automatic scaling
- Pay only when code runs
- High availability
- Fast deployment
- Easy integration with AWS services

---

# Automatic Scaling

Suppose:

- 1 person visits your website.
- Later, 10,000 people visit at the same time.

Lambda automatically creates enough instances of your function to handle the load.

No manual scaling is required.

---

# Pay Per Use

Unlike EC2:

```text
EC2

Running

↓

Pay for entire runtime
```

Lambda:

```text
Function Runs

↓

Pay only for execution time
```

If the function doesn't run, you pay nothing for compute.

---

# Lambda Execution Time

Lambda functions are designed for **short-lived tasks**.

Examples:

- Process uploaded files
- Send emails
- Validate data
- Handle API requests

They are **not** designed for long-running applications.

---

# Common Lambda Use Cases

- REST APIs
- Image processing
- File conversion
- Scheduled tasks
- Automation
- Data processing
- Chatbots
- Backend services

---

# Supported Programming Languages

AWS Lambda supports several languages, including:

- Python
- JavaScript (Node.js)
- Java
- C#
- Go
- Ruby
- PowerShell

You can also use custom runtimes if required.

---

# Lambda and API Gateway

One of the most common architectures is:

```text
User

↓

API Gateway

↓

Lambda

↓

Database
```

API Gateway receives the request.

Lambda processes it.

The response is sent back to the user.

---

# Lambda and S3

Another common architecture:

```text
File Upload

↓

Amazon S3

↓

Lambda

↓

Process File

↓

Store Result
```

Example:

- Resize uploaded images
- Convert PDFs
- Scan files for malware

---

# Lambda and CloudWatch

CloudWatch can trigger Lambda on a schedule.

Example:

```text
Every Day

↓

CloudWatch Event

↓

Lambda

↓

Generate Report
```

Useful for automation tasks.

---

# Lambda Permissions

Lambda functions often need access to AWS services.

Instead of storing credentials, assign an **IAM Role**.

Example permissions:

- Read from S3
- Write to DynamoDB
- Send CloudWatch Logs
- Access Secrets Manager

This follows AWS security best practices.

---

# Advantages of Lambda

- No infrastructure management
- Automatic scaling
- Highly available
- Cost-effective
- Fast deployment
- Integrates with many AWS services

---

# Limitations of Lambda

- Not suitable for long-running applications
- Limited execution time
- Cold starts may introduce slight delays
- Less control over the underlying environment

---

# EC2 vs Lambda

| EC2 | Lambda |
|------|---------|
| Manage servers | AWS manages servers |
| Runs continuously | Runs only when triggered |
| Pay while running | Pay only when executed |
| Manual scaling | Automatic scaling |
| Full OS access | No OS access |

---

# Real-World Example

A company allows users to upload profile pictures.

Architecture:

```text
User

↓

Amazon S3

↓

AWS Lambda

↓

Resize Image

↓

Save Thumbnail

↓

User Downloads Thumbnail
```

No servers need to be running permanently.

---

# Best Practices

- Keep Lambda functions small and focused.
- Give each function a single responsibility.
- Use IAM Roles instead of credentials.
- Store configuration in environment variables.
- Monitor functions using CloudWatch.
- Keep deployment packages small.
- Use API Gateway for serverless APIs.

---

# Key Takeaways

- Serverless means AWS manages the infrastructure.
- AWS Lambda runs code in response to events.
- You only pay when your code executes.
- Lambda automatically scales with demand.
- Lambda integrates with many AWS services.
- IAM Roles provide secure access to AWS resources.
- Lambda is ideal for short-lived, event-driven workloads.

---

# Quick Revision

| Term | Meaning |
|------|---------|
| Serverless | AWS manages the servers |
| Lambda | Serverless compute service |
| Event | Something that triggers a Lambda function |
| API Gateway | Sends HTTP requests to Lambda |
| IAM Role | Secure permissions for Lambda |
| CloudWatch | Monitoring and scheduled events |

---

# Interview Questions

### What is serverless computing?

A cloud model where the cloud provider manages the infrastructure, allowing developers to focus only on writing code.

### What is AWS Lambda?

AWS Lambda is a serverless compute service that runs code in response to events without requiring server management.

### How does Lambda scale?

Lambda automatically creates additional function instances as demand increases.

### How are you charged for Lambda?

You are charged based on the number of requests and the execution duration of your function.

### When should you use Lambda instead of EC2?

Use Lambda for short-lived, event-driven workloads such as APIs, automation, file processing and scheduled tasks.