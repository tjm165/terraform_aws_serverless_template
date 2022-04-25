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
  # name    = "${local.name}-standalone-lambda"
  source         = "./modules/common/api_lambda"
  route_key      = "tommy_lambda"
  method_type    = "GET"
  source_dir     = "src/api_lambda"
  api_id         = module.global_api_gateway.api_id
  api_source_arn = module.global_api_gateway.execution_arn
}
module "example_lambda_to_dynamo" {
  // name           = local.name // should name the lambda based on method type
  dynamo_name    = "ServerlessCoffeeShope"
  source         = "./modules/api_lambda_dynamo"
  route_key      = "tommy"
  method_type    = "GET"
  source_dir     = "src/api_lambda_dynamo"
  api_id         = module.global_api_gateway.api_id
  api_source_arn = module.global_api_gateway.execution_arn
}