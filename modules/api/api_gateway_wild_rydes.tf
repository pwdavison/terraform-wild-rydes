resource "aws_api_gateway_rest_api" "wild-rydes-api-gateway" {
  name = "WildRydes"

  endpoint_configuration {
    types = ["EDGE"]
  }
}

resource "aws_api_gateway_authorizer" "wild-rydes-api-gateway-authorizer" {
  name          = "WildRydes"
  type          = "COGNITO_USER_POOLS"
  provider_arns = ["${var.cognito_user_pool_arn}"]
  rest_api_id   = "${aws_api_gateway_rest_api.wild-rydes-api-gateway.id}"
}

resource "aws_api_gateway_resource" "wild-rydes-api-gateway-resource" {
  rest_api_id = "${aws_api_gateway_rest_api.wild-rydes-api-gateway.id}"
  parent_id   = "${aws_api_gateway_rest_api.wild-rydes-api-gateway.root_resource_id}"
  path_part   = "ride"
}

resource "aws_api_gateway_method" "wild-rydes-api-gateway-method" {
  rest_api_id   = "${aws_api_gateway_rest_api.wild-rydes-api-gateway.id}"
  resource_id   = "${aws_api_gateway_resource.wild-rydes-api-gateway-resource.id}"
  http_method   = "POST"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = "${aws_api_gateway_authorizer.wild-rydes-api-gateway-authorizer.id}"
}

resource "aws_api_gateway_method" "wild-rydes-api-gateway-options-method" {
  rest_api_id   = "${aws_api_gateway_rest_api.wild-rydes-api-gateway.id}"
  resource_id   = "${aws_api_gateway_resource.wild-rydes-api-gateway-resource.id}"
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "wild-rydes-api-gateway-options-integration" {
  rest_api_id = "${aws_api_gateway_rest_api.wild-rydes-api-gateway.id}"
  resource_id = "${aws_api_gateway_resource.wild-rydes-api-gateway-resource.id}"
  http_method = "${aws_api_gateway_method.wild-rydes-api-gateway-options-method.http_method}"
  type        = "MOCK"

  request_templates = {
    "application/json" = <<PARAMS
{ "statusCode": 200 }
PARAMS
  }
}

resource "aws_api_gateway_integration_response" "wild-rydes-api-gateway-options-integration-response" {
  rest_api_id = "${aws_api_gateway_rest_api.wild-rydes-api-gateway.id}"
  resource_id = "${aws_api_gateway_resource.wild-rydes-api-gateway-resource.id}"
  http_method = "${aws_api_gateway_method.wild-rydes-api-gateway-options-method.http_method}"
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'POST,OPTIONS,GET,PUT,PATCH,DELETE'"
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }

  depends_on = [
    "aws_api_gateway_integration.wild-rydes-api-gateway-options-integration",
  ]
}

resource "aws_api_gateway_method_response" "wild-rydes-api-gateway-options-response" {
  rest_api_id = "${aws_api_gateway_rest_api.wild-rydes-api-gateway.id}"
  resource_id = "${aws_api_gateway_resource.wild-rydes-api-gateway-resource.id}"
  http_method = "${aws_api_gateway_method.wild-rydes-api-gateway-options-method.http_method}"
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin" = true
  }

  depends_on = [
    "aws_api_gateway_method.wild-rydes-api-gateway-options-method",
  ]
}

resource "aws_api_gateway_integration" "wild-rydes-api-gateway-integration" {
  rest_api_id = "${aws_api_gateway_rest_api.wild-rydes-api-gateway.id}"
  resource_id = "${aws_api_gateway_resource.wild-rydes-api-gateway-resource.id}"
  http_method = "${aws_api_gateway_method.wild-rydes-api-gateway-method.http_method}"
  integration_http_method = "POST"
  type = "AWS_PROXY"
  uri = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${var.lambda_arn}/invocations"
}

resource "aws_api_gateway_deployment" "wild-rydes-api-gateway-deployment" {
  depends_on = ["aws_api_gateway_integration.wild-rydes-api-gateway-integration"]
  rest_api_id = "${aws_api_gateway_rest_api.wild-rydes-api-gateway.id}"
  stage_name = "prod"
}
