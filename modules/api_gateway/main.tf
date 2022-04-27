resource "aws_apigatewayv2_api" "lambda-api" {
  name          = var.name
  protocol_type = "HTTP"
  tags = {
    Name        = "serverless_template"
    Environment = "production"
  }
}

output "lambda_api" {
  value = aws_apigatewayv2_api.lambda-api
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

output "api_id" {
  value = aws_apigatewayv2_api.lambda-api.id
}

output "execution_arn" {
  value = aws_apigatewayv2_api.lambda-api.execution_arn
}