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

module "example_lambda_default" {
  source         = "./modules/api_default_lambda"
  source_dir     = "src/api_lambda"
  api_id         = module.global_api_gateway.api_id
  api_source_arn = module.global_api_gateway.execution_arn
}

module "example_lambda" {
  source         = "./modules/common/api_lambda"
  route_key      = "tommy_lambda"
  method_type    = "GET"
  source_dir     = "src/api_lambda"
  api_id         = module.global_api_gateway.api_id
  api_source_arn = module.global_api_gateway.execution_arn
}
module "example_lambda_to_dynamo" {
  dynamo_name    = "ServerlessCoffeeShope"
  source         = "./modules/api_lambda_dynamo"
  route_key      = "tommy"
  method_type    = "GET"
  source_dir     = "src/api_lambda_dynamo"
  api_id         = module.global_api_gateway.api_id
  api_source_arn = module.global_api_gateway.execution_arn
}

module "example_lambda_to_s3" {
  source         = "./modules/api_lambda_s3"
  s3_name        = "serverlesscoffeeshops3"
  source_dir     = "src/api_lambda_s3"
  route_key      = "tommy_s3"
  method_type    = "GET"
  api_id         = module.global_api_gateway.api_id
  api_source_arn = module.global_api_gateway.execution_arn
}

# Demonstrate using local-exec
resource "null_resource" "upload_s3_files" {
  triggers = {
    dir_sha1 = sha1(join("", [for f in fileset("src/api_lambda_s3/upload_s3_files", "*"): md5(file(f))   ]))
  }
  provisioner "local-exec" {
   command = "aws s3 cp src/api_lambda_s3/upload_s3_files s3://${module.example_lambda_to_s3.aws_s3_bucket.id}/ --recursive"
  }
}