# Terraform AWS Serverless API Template

Template to write and deploy serverless APIs on AWS

## Getting Started

1. Fork this repo
1. `cp .envsample .env`
1. In `.env` update the environment variables
1. `terraform init && terraform apply -auto-approve`
1. `terraform output api-endpoint`

## Roadmap

### Current Goals

- [x] DEFAULT --> Lambda
- [x] GET --> Lambda
- [x] GET --> Lambda --> DynamoDB
- [x] GET -> Lambda -> S3
- [ ] Specify Terraform Version
- [ ] POST -> Lambda Graphql -> Mutate/Query DynamoDB
- [ ] POST -> Lambda Graphql -> Mutate/Query Aurora
- [ ] Quick start YouTube Video
- [ ] Explore a data stack
- [ ] tag
- [ ] shared state

### Future Goals

1. Improved naming strategy for multiple instances
1. POST -> Lambda -> SQS
1. POST -> Lambda -> Firehose
1. Elastic Map Reduce 

## Useful Terraform Commands

- `terraform output api-endpoint`
- `terraform fmt -recursive`
- `terraform init`
- `terraform graph | pbcopy` -> [Edotor](https://edotor.net/) fdp format is best

## Cool Idea

`terraform watch`
Generalize into modules
