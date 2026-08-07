```text
                         CLIENT
               (curl / Postman / Browser)
                        |
          POST /submit          GET /students
                 |                   |
                 +---------+---------+
                           |
                 API Gateway (REST API)
               StudentSubmissionAPI
               /submit      /students
                   |             |
                   |             |
        +----------+             +-----------+
        |                                    |
        v                                    v
 Lambda: student-submission         Lambda: get-students
        |                                    |
   DynamoDB PutItem                    DynamoDB Scan
        |                                    |
        +---------------+--------------------+
                        |
                        v
               DynamoDB Table: students
         -------------------------------
         Partition Key: id
         Attributes:
         - timestamp
         - payload

                ▲
                │
         CloudWatch Logs
                ▲
                │
      Both Lambda Functions

IAM (Least Privilege)

student-submission-role
├── AWSLambdaBasicExecutionRole
└── DynamoDB PutItem only

get-students-role
├── AWSLambdaBasicExecutionRole
└── DynamoDB Scan only

API Security

API Key
     │
     ▼
Usage Plan
     │
     ▼
Protected API Endpoints
```