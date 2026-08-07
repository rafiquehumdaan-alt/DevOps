                              CLIENT
                     (curl / Postman / Browser)
                                   │
                 POST /submit      │      GET /students
───────────────────────────────────┼──────────────────────────────────
                                   │
                                   ▼
                        Amazon API Gateway
                 REST API (StudentSubmissionAPI)
                                   │
             ┌─────────────────────┴─────────────────────┐
             │                                           │
             ▼                                           ▼
      POST /submit                               GET /students
             │                                           │
             ▼                                           ▼
    Lambda: student-submission                 Lambda: get-students
             │                                           │
             │ PutItem                                  │ Scan
             ▼                                           ▼
                  Amazon DynamoDB (students table)
        ┌───────────────────────────────────────────────┐
        │ id (Partition Key)                            │
        │ timestamp                                     │
        │ payload                                       │
        └───────────────────────────────────────────────┘

             ▲
             │
      CloudWatch Logs
             ▲
             │
      Both Lambda Functions

             ▲
             │
      IAM Roles (Least Privilege)

student-submission-role
    ├── AWSLambdaBasicExecutionRole
    └── DynamoDB PutItem only

get-students-role
    ├── AWSLambdaBasicExecutionRole
    └── DynamoDB Scan only

             ▲
             │
        API Gateway Security

    API Key
        │
        ▼
    Usage Plan
        │
        ▼
 StudentSubmissionAPI (prod)

Rate Limit:
10 requests/sec
Burst:
20 requests

Without API Key
        │
        ▼
403 Forbidden

With Valid API Key
        │
        ▼
Lambda executes