locals {
  lambda_name     = "lambda-${var.method_type}-${var.route_key}"
  dynamo_name     = var.dynamo_name
  iam_policy_name = "policy-api-lambda-${var.route_key}"
}

output "aws_dynamodb_table" {
  value = aws_dynamodb_table.basic-dynamodb-table
}

output "api_lambda" {
  value = module.api_lambda
}

module "api_lambda" {
  source         = "../common/base_api_lambda"
  api_id         = var.api_id
  api_source_arn = var.api_source_arn
  route_key      = var.route_key
  method_type    = var.method_type
  source_dir     = var.source_dir
}

##### Dynamo
resource "aws_dynamodb_table" "basic-dynamodb-table" {
  name         = local.dynamo_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "Id"
  attribute {
    name = "Id"
    type = "S"
  }

  server_side_encryption {
    enabled = true
  }

  tags = {
    Name        = "serverless_template"
    Environment = "production"
  }
}

resource "aws_iam_policy" "lambda_to_dynamo" {
  name        = local.iam_policy_name
  description = "Iam policy for example to dynamo"
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "",
            "Effect": "Allow",
            "Action": "dynamodb:*",
            "Resource": [
                "${aws_dynamodb_table.basic-dynamodb-table.arn}"
            ]
        }
    ]
} 
EOF
}
resource "aws_iam_role_policy_attachment" "attach_lambda_to_dynamo" {
  role       = module.api_lambda.iam_role.name
  policy_arn = aws_iam_policy.lambda_to_dynamo.arn
}