module "api_lambda_attachment" {
  source = "../common/api_lambda_attachment"
  lambda_name = "${var.name}-${var.method_type}-${var.route_key}"
  api_id=var.api_id
  api_source_arn = var.api_source_arn
  route_key = var.route_key
  method_type = var.method_type
  source_dir=var.source_dir
}

##### Dynamo
resource "aws_dynamodb_table" "basic-dynamodb-table" {
  name           = "${var.name}"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "Id"
  # range_key      = "Time"

  attribute {
    name = "Id"
    type = "S"
  }

  # attribute {
  #   name = "Time"
  #   type = "N"
  # }

  # local_secondary_index { # for global just change name to global_secondary_index. 
  #   name               = "TimeIndex"
  #   # hash_key           = "Time" # for global uncomment this
  #   range_key          = "Time"
  #   projection_type    = "INCLUDE"
  #   non_key_attributes = ["Id"]
  # }

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
  name = "example_lambda_to_dynamo_${var.name}"
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
                "${aws_dynamodb_table.basic-dynamodb-table.arn}"
            ]
        }
    ]
} 
EOF
}

resource "aws_iam_role_policy_attachment" "attach_lambda_to_dynamo" {
  role       = module.api_lambda_attachment.iam_role_name
  policy_arn = aws_iam_policy.lambda_to_dynamo.arn
}