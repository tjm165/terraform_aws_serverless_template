provider "aws" {
  region = "us-east-2"
}

module "example1" {
  source = "./modules/api_lambda_dynamo"
}