
data "archive_file" "lambda-zip" {
  type        = "zip"
  source_dir  = "lambda"
  output_path = "lambda.zip"
}

resource "aws_iam_role" "lambda-iam" {
  name = "lambda-iam"
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
  filename         = "lambda.zip"
  function_name    = "lambda-function"
  role             = aws_iam_role.lambda-iam.arn
  handler          = "lambda.lambda_handler"
  source_code_hash = data.archive_file.lambda-zip.output_base64sha256
  runtime          = "python3.8"
  tags = {
    Name        = "serverless_template"
    Environment = "production"
  }
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

resource "aws_apigatewayv2_integration" "lambda-integration" {
  api_id               = aws_apigatewayv2_api.lambda-api.id
  integration_type     = "AWS_PROXY"
  integration_method   = "POST"
  integration_uri      = aws_lambda_function.lambda.invoke_arn
}

resource "aws_apigatewayv2_route" "lambda_route" {
  api_id    = aws_apigatewayv2_api.lambda-api.id
  route_key = "GET /order"
  target    = "integrations/${aws_apigatewayv2_integration.lambda-integration.id}"

}

resource "aws_lambda_permission" "api-gw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda.arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.lambda-api.execution_arn}/*/*/*"
}


##### Dynamo
resource "aws_dynamodb_table" "basic-dynamodb-table" {
  name           = "ServerlessCoffeeOrders"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "Id"
  range_key      = "Time"

  attribute {
    name = "Id"
    type = "S"
  }

  attribute {
    name = "Time"
    type = "N"
  }

  # attribute {
  #   name = "UserId"
  #   type = "S"
  # }

  # attribute {
  #   name = "Description"
  #   type = "S"
  # }

  #   attribute {
  #   name = "Quantity"
  #   type = "N"
  # }


# Only define attributes for indexes https://stackoverflow.com/questions/50006885/terraform-dynamodb-all-attributes-must-be-indexed


# 
  local_secondary_index { # for global just change name to global_secondary_index. 
    name               = "TimeIndex"
    # hash_key           = "Time" # for global uncomment this
    range_key          = "Time"
    projection_type    = "INCLUDE"
    non_key_attributes = ["Id"]
  }

  server_side_encryption {
    enabled = true
  }

  tags = {
    Name        = "serverless_template"
    Environment = "production"
  }
}

### Give Lambda permsionion
# https://us-east-1.console.aws.amazon.com/iam/home#/policies/arn:aws:iam::299774672086:policy/NotesApp-AccessToTagsTable$jsonEditor
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function

resource "aws_iam_policy" "lambda_to_dynamo" {
  name = "example_lambda_to_dynamo"
  description = "Iam policy for example to dynamo"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "",
            "Effect": "Allow",
            "Action": "dynamodb:*",
            "Resource": [
                "arn:aws:dynamodb:us-east-2:299774672086:table/SunriseNotes-Tags",
                "${aws_dynamodb_table.basic-dynamodb-table.arn}"
            ]
        }
    ]
} 
EOF
}

resource "aws_iam_role_policy_attachment" "attach_lambda_to_dynamo" {
  role       = aws_iam_role.lambda-iam.name
  policy_arn = aws_iam_policy.lambda_to_dynamo.arn
}