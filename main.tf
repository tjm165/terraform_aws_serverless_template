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

module "example_lambda" {
  source         = "./modules/common/api_lambda_attachment"
  route_key      = "tommy_lambda"
  method_type    = "GET"
  source_dir     = "src/standalone_lambda"
  lambda_name    = "${local.name}-standalone-lambda"
  api_id         = module.global_api_gateway.api_id
  api_source_arn = module.global_api_gateway.execution_arn
}
module "example_lambda_to_dynamo" {
  source         = "./modules/api_lambda_dynamo"
  route_key      = "tommy"
  method_type    = "GET"
  source_dir     = "src/lambda"
  name           = local.name // might want to make this extend example_lambda should name the lambda based on method type
  api_id         = module.global_api_gateway.api_id
  api_source_arn = module.global_api_gateway.execution_arn
}