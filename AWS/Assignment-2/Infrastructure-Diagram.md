                           Internet
                                │
                     http://humdaan.co.uk
                                │
                      HTTP (80) Redirect
                                │
                                ▼
                         HTTPS (443)
                                │
                 ACM SSL Certificate (AWS)
                                │
                   Application Load Balancer
                                │
                         Target Group
                                │
                 ┌──────────────┴──────────────┐
                 │                             │
          Auto Scaling Group (Desired = 2)
                 │                             │
          EC2 Instance                  EC2 Instance
                 │                             │
          NGINX Web Server             NGINX Web Server