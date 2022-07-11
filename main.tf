provider "aws" {
  region = "us-east-2"
}
locals {
  name = "ServerlessCoffeeShope" # remember to set your lambda to call this name
}

variable "github_access_token" {
    type=string
    sensitive = true
  description = "GitHub personal access token https://github.com/settings/tokens - Must have write:repo_hook and read:repo_hook"
}
module "react_app" {
  source = "./modules/amplify_react_app"
  github_access_token = var.github_access_token
}

# output "api-endpoint" {
#   value = module.global_api_gateway.lambda_api.api_endpoint
# }

# ### Create API Gateway
# module "global_api_gateway" {
#   source = "./modules/api_gateway"
#   name   = local.name
# }


# ### Create a lambda as the default endpoint
# module "api_lambda_default" {
#   source         = "./modules/api_lambda_default"
#   source_dir     = "src/api_lambda_default"
#   api_id         = module.global_api_gateway.api_id
#   api_source_arn = module.global_api_gateway.execution_arn
# }

# ### Create a simple lambda at a particular API path
# module "api_lambda" {
#   source         = "./modules/api_lambda"
#   route_key      = "api_lambda"
#   method_type    = "GET"
#   source_dir     = "src/api_lambda"
#   api_id         = module.global_api_gateway.api_id
#   api_source_arn = module.global_api_gateway.execution_arn
# }
# ### Create a lambda --> dynamodb at a particular API path
# module "api_lambda_dynamo" {
#   dynamo_name    = "ServerlessCoffeeShope"
#   source         = "./modules/api_lambda_dynamo"
#   route_key      = "api_lambda_dynamo"
#   method_type    = "GET"
#   source_dir     = "src/api_lambda_dynamo"
#   api_id         = module.global_api_gateway.api_id
#   api_source_arn = module.global_api_gateway.execution_arn
# }

# ### Create a lambda --> s3 at a particular API path
# module "api_lambda_s3" {
#   source         = "./modules/api_lambda_s3"
#   s3_name        = "serverlesscoffeeshops3"
#   source_dir     = "src/api_lambda_s3"
#   route_key      = "api_lambda_s3"
#   method_type    = "GET"
#   api_id         = module.global_api_gateway.api_id
#   api_source_arn = module.global_api_gateway.execution_arn
# }

# ### Demonstrate using local-exec
# locals {
#   upload_s3_path = "src/upload_s3_files"
# }
# # First, zip the files. This is used to get a hash of the directory
# data "archive_file" "s3_files" {
#   type        = "zip"
#   source_dir  = local.upload_s3_path
#   output_path = "dist/uploaded_s3_files.zip"
# }
# # Next, use local-exec to upload the files
# resource "null_resource" "upload_s3_files" {
#   # Use the directory hash to determine if any changes have been made
#   triggers = {
#     src_hash = "${data.archive_file.s3_files.output_sha}"
#   }
#   provisioner "local-exec" {
#     command = "aws s3 sync ${local.upload_s3_path} s3://${module.api_lambda_s3.aws_s3_bucket.id}/ --delete"
#   }
# }

# ### Create a lambda --> aurora at a particular API path
# module "api_lambda_aurora" {
#   source         = "./modules/api_lambda_aurora"
#   route_key      = "api_lambda_aurora"
#   method_type    = "GET"
#   source_dir     = "src/api_lambda_aurora"
#   api_id         = module.global_api_gateway.api_id
#   api_source_arn = module.global_api_gateway.execution_arn
# }