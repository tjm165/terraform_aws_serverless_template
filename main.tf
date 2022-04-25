provider "aws" {
  region = "us-east-2"
}

locals {
  name = "ServerlessCoffeeShope" # remember to set your lambda to call this name
}

module "global_api_gateway" {
  source = "./modules/api_gateway"
  name   = local.name
}
module "example_lambda_to_dynamo" {
  source         = "./modules/api_lambda_dynamo"
  route_key      = "tommy"
  method_type    = "GET"
  source_dir     = "src/lambda"
  name           = local.name
  api_id         = module.global_api_gateway.api_id
  api_source_arn = module.global_api_gateway.execution_arn
}