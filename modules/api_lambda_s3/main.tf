locals {
  lambda_name     = "lambda-${var.method_type}-${var.route_key}"
  s3_name         = var.s3_name
  iam_policy_name = "policy-api-lambda-${var.route_key}"
}

output "aws_s3_bucket" {
  value = aws_s3_bucket.basic-s3-bucket
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

##### S3
resource "aws_s3_bucket" "basic-s3-bucket" {
  bucket = local.s3_name
  force_destroy = true
}

resource "aws_s3_bucket_acl" "basic-s3-bucket-acl" {
  bucket = aws_s3_bucket.basic-s3-bucket.id
  acl    = "private"
}

resource "aws_iam_policy" "lambda_to_s3" {
  name        = local.iam_policy_name
  description = "Iam policy for example to dynamo"
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "",
            "Effect": "Allow",
            "Action": "s3:*",
            "Resource": [
                "${aws_s3_bucket.basic-s3-bucket.arn}"
            ]
        }
    ]
} 
EOF
}
resource "aws_iam_role_policy_attachment" "attach_lambda_to_s3" {
  role       = module.api_lambda.iam_role.name
  policy_arn = aws_iam_policy.lambda_to_s3.arn
}