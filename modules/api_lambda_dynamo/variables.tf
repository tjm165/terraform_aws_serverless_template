variable "api_id" {
    type = string
    description = "The id of an aws_apigatewayv2_api"
}

variable "api_source_arn" {
      type = string
    description = "The execution_arn of an aws_apigatewayv2_api"
}

variable "route_key" {
    type = string
    description = "The route for this api request. No backslash / needed"
}

variable "method_type" {
    type = string
    description = "POST or GET"
}

variable "name" {
    type = string
    description = "Name for this application"
}