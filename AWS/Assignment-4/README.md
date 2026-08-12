# AWS Assignment 4 – Serverless API with Lambda, IAM and API Gateway

## Objective

The objective of this assignment was to build a production-style serverless REST API using AWS managed services.

The API accepts student submissions through a POST request, stores the data in DynamoDB, and allows all stored submissions to be retrieved through a GET request.

This assignment introduced serverless computing, IAM least privilege, REST APIs, API Gateway, Lambda, DynamoDB, CloudWatch logging, API Keys and Usage Plans.



# AWS Services Used

## Amazon DynamoDB

Purpose:
Store all student submissions.

Configuration:

- Table Name:
  students

- Capacity Mode:
  On-demand

- Partition Key:
  id (String)

Each item stored contains:

{
    id,
    timestamp,
    payload
}

Why DynamoDB?

- Fully managed NoSQL database
- No servers to maintain
- Automatically scales
- Extremely fast
- Pay only for what is used

---

## AWS Lambda

Two Lambda functions were created.

### 1. student-submission

Purpose:

Receives a POST request and stores data inside DynamoDB.

Responsibilities:

- Read request body
- Validate JSON
- Generate UUID
- Generate timestamp
- Store record in DynamoDB
- Return HTTP 201 response
- Write logs to CloudWatch

---

### 2. get-students

Purpose:

Returns all stored student submissions.

Responsibilities:

- Scan DynamoDB table
- Return JSON response
- Handle pagination
- Write logs to CloudWatch

---

Why Lambda?

- Serverless
- No EC2 instances
- No operating system
- Automatic scaling
- Pay only when executed

---

# IAM

Each Lambda received its own execution role.

This follows the Principle of Least Privilege.

student-submission Role

Permissions:

- AWSLambdaBasicExecutionRole
- DynamoDB PutItem

Only allowed to insert records.

Cannot:

- Scan
- Delete
- Update

---

get-students Role

Permissions:

- AWSLambdaBasicExecutionRole
- DynamoDB Scan

Only allowed to read records.

Cannot:

- Insert
- Delete
- Update

---

Why Least Privilege?

Improves security.

Even if one Lambda became compromised, it could only perform the actions it was specifically permitted to perform.

---

# Environment Variables

Both Lambda functions use:

TABLE_NAME = students

Instead of hardcoding the table name.

Benefits:

- Easier to reuse code
- Easier to move between environments
- Cleaner configuration

---

# API Gateway

Created:

StudentSubmissionAPI

Endpoint Type:

Regional

Deployment Stage:

prod

Resources:

/submit
/students

Methods:

POST /submit

Invokes:

student-submission Lambda

GET /students

Invokes:

get-students Lambda

Proxy Integration:

Enabled

Benefits:

- No request mapping required
- Full HTTP request passed directly into Lambda
- Simpler development

---

# REST API Design

POST /submit

Purpose:

Create a new student submission.

Returns:

HTTP 201 Created

---

GET /students

Purpose:

Retrieve all stored submissions.

Returns:

HTTP 200 OK

---

Why separate resources?

REST APIs organise endpoints around resources.

Instead of:

POST /

GET /

we used:

POST /submit

GET /students

which is easier to understand and extend.

---

# CloudWatch Logs

Both Lambda functions automatically write logs.

Used for:

- Debugging
- Error messages
- Execution duration
- Memory usage
- Request IDs

Without CloudWatch it would be difficult to troubleshoot Lambda functions.

---

# API Keys

Created:

StudentAPIClientKey

Clients must provide:

x-api-key

Without a valid key:

HTTP 403 Forbidden

With a valid key:

Request proceeds to Lambda.

---

# Usage Plan

Created:

StudentAPIUsagePlan

Associated with:

StudentSubmissionAPI

Stage:

prod

Configured:

Rate Limit:
10 requests per second

Burst:
20 requests

Purpose:

Protect API from abuse and limit request volume.

---

# Request Flow

POST Request

Client

↓

API Gateway

↓

API Key Validation

↓

Usage Plan Check

↓

student-submission Lambda

↓

IAM Permission Check

↓

DynamoDB PutItem

↓

CloudWatch Logs

↓

HTTP 201 Response

---

GET Request

Client

↓

API Gateway

↓

API Key Validation

↓

Usage Plan Check

↓

get-students Lambda

↓

IAM Permission Check

↓

DynamoDB Scan

↓

CloudWatch Logs

↓

HTTP 200 Response

---

# Testing

Lambda Testing

Both Lambda functions tested directly inside AWS.

Confirmed:

- Code executes
- IAM permissions correct
- DynamoDB connectivity
- Environment variables
- CloudWatch logs

---

API Testing

Used curl.

POST

curl -X POST

Returned:

HTTP 201 Created

Data successfully inserted.

---

GET

curl

Returned:

HTTP 200 OK

Returned all student records.

---

API Key Testing

Without API Key:

HTTP 403 Forbidden

With API Key:

HTTP 200

and

HTTP 201

This confirmed API Gateway correctly enforced authentication through API Keys.

---

# Skills Learned

- Serverless Computing
- AWS Lambda
- REST APIs
- API Gateway
- Proxy Integration
- DynamoDB
- NoSQL Databases
- UUID Generation
- Environment Variables
- IAM Roles
- Least Privilege
- CloudWatch Logs
- API Keys
- Usage Plans
- HTTP Methods
- JSON
- curl Testing
- Production-style AWS Architecture

---

# Key Takeaways

This assignment demonstrated how multiple AWS managed services work together to create a secure, scalable serverless application.

Instead of managing EC2 servers, operating systems and web servers, AWS automatically handled infrastructure while Lambda executed application code on demand.

Security was improved through IAM least privilege, API Keys and Usage Plans, ensuring only authorised clients could access the API.

This architecture represents a common serverless backend used for web applications, mobile applications, webhooks and microservices.