variable "api_id" {
  type        = string
  description = "The id of an aws_apigatewayv2_api"
}

variable "api_source_arn" {
  type        = string
  description = "The execution_arn of an aws_apigatewayv2_api"
}

variable "source_dir" {
  type        = string
  description = "path to lambda code"
}