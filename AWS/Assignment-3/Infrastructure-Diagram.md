                              +----------------+
                              |     User       |
                              | Web Browser    |
                              +--------+-------+
                                       |
                                 HTTPS Request
                                       |
                                       ▼
                    +--------------------------------+
                    |       Amazon CloudFront        |
                    |--------------------------------|
                    | • Global Edge Locations        |
                    | • HTTPS                        |
                    | • Content Caching              |
                    +---------------+----------------+
                                    |
                             HTTP to Origin
                                    |
                                    ▼
                 +----------------------------------------+
                 |      Amazon S3 Static Website          |
                 |----------------------------------------|
                 | Bucket: humdaan-devops-static-site     |
                 |                                        |
                 | • index.html                           |
                 | • error.html                           |
                 | • Static Website Hosting               |
                 +----------------+-----------------------+
                                  ^
                                  |
                         Upload Website Files
                                  |
                     +-----------------------------+
                     |      AWS Management Console |
                     +-----------------------------+

        Custom Domain (Optional)

      humdaan.co.uk
             │
             ▼
      Cloudflare DNS
             │
             ▼
      Amazon Route 53
             │
             ▼
      CloudFront Distribution