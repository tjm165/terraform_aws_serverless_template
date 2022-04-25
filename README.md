# Get Started

1. Fork this repo
1. In `.env` update the environment variables
1. `terraform init && terraform apply -auto-approve`

# Current

1. Hit api/order --> gateway --> lambda --> dynamodb

# MVP

1. How to clone this as your own?
1. GET -> Lambda -> S3 welcome html
1. POST -> Lambda Graphql -> Mutate/Query DynamoDB

# Future

1. POST -> Lambda Graphql -> Mutate/Query Aurora
1. POST -> Lambda -> SQS
1. POST -> Lambda -> Firehose

# Install terraform

# Terraform Serverless Template

https://www.youtube.com/watch?v=cCaTsD8pRrY

Download the zip, unzip it, move to `sudo cp terraform /usr/local/bin `

# Videos

1. Install https://www.youtube.com/watch?v=cCaTsD8pRrY

Download the zip, unzip it, move to `sudo cp terraform /usr/local/bin`

2. Lambda & API Gateway https://www.youtube.com/watch?v=wlVcso4Ut5o

# Useful Terraform Commands

`terraform fmt`
`terraform init`
`terraform graph` -> `https://dreampuf.github.io/GraphvizOnline/`

# Cool Idea

`terraform watch`
Generalize into modules
