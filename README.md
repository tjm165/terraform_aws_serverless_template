# Terraform AWS Serverless API Template

Template to write and deploy serverless APIs on AWS

## Getting Started

1. Fork this repo
1. `cp .envsample .env`
1. In `.env` update the environment variables
1. `terraform init && terraform apply -auto-approve`

## Roadmap

### MVP Checklist

- [x] GET --> Lambda --> DynamoDB
- [ ] GET -> Lambda -> S3 welcome html
- [ ] Specify Terraform Version
- [ ] POST -> Lambda Graphql -> Mutate/Query DynamoDB
- [ ] POST -> Lambda Graphql -> Mutate/Query Aurora
- [ ] Quick start YouTube Video

### Future Work

1. POST -> Lambda -> SQS
1. POST -> Lambda -> Firehose

## Useful Terraform Commands

`terraform fmt`
`terraform init`
`terraform graph` -> `https://dreampuf.github.io/GraphvizOnline/`

## Cool Idea

`terraform watch`
Generalize into modules
