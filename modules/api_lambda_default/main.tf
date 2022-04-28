locals {
  zip_path      = "./dist/${var.source_dir}/lambda.zip"
  lambda_name   = "lambda-default"
  iam_role_name = "role-api-lambda-default"
}

output "iam_role" {
  value = aws_iam_role.lambda-iam
}

data "archive_file" "lambda-zip" {
  type        = "zip"
  source_dir  = var.source_dir
  output_path = local.zip_path
}

resource "aws_iam_role" "lambda-iam" {
  name = local.iam_role_name
  tags = {
    Name        = "serverless_template"
    Environment = "production"
  }
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
                "Service": "lambda.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

resource "aws_lambda_function" "lambda" {
  filename         = local.zip_path
  function_name    = local.lambda_name
  role             = aws_iam_role.lambda-iam.arn
  handler          = "lambda.lambda_handler"
  source_code_hash = data.archive_file.lambda-zip.output_base64sha256
  runtime          = "python3.8"
  tags = {
    Name        = "serverless_template"
    Environment = "production"
  }
}

resource "aws_apigatewayv2_integration" "lambda-integration" {
  api_id               = var.api_id
  integration_type     = "AWS_PROXY"
  integration_method   = "POST"
  integration_uri      = aws_lambda_function.lambda.invoke_arn
  passthrough_behavior = "WHEN_NO_MATCH"
}
resource "aws_apigatewayv2_route" "lambda_route" {
  api_id    = var.api_id
  route_key = "GET /{proxy+}"
  target    = "integrations/${aws_apigatewayv2_integration.lambda-integration.id}"
}

resource "aws_lambda_permission" "api-gw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda.arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${var.api_source_arn}/*/*/*"
}