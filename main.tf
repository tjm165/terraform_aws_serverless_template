provider "aws" {
  region = "us-east-2"
}



resource "aws_apigatewayv2_api" "lambda-api" {
  name          = "ServerlessCoffeeOrders"
  protocol_type = "HTTP"
  tags = {
    Name        = "serverless_template"
    Environment = "production"
  }
}

resource "aws_apigatewayv2_stage" "lambda-stage" {
  api_id      = aws_apigatewayv2_api.lambda-api.id
  name        = "$default"
  auto_deploy = true
  tags = {
    Name        = "serverless_template"
    Environment = "production"
  }
}

module "example1" {
  source = "./modules/api_lambda_dynamo"
  api_id = aws_apigatewayv2_api.lambda-api.id
  api_source_arn = aws_apigatewayv2_api.lambda-api.execution_arn
}