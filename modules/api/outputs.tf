output "wild-rydes-deployment-invoke-url" {
  value = "${aws_api_gateway_deployment.wild-rydes-api-gateway-deployment.invoke_url}"
}

output "wild-rydes-api-gateway-arn" {
  value = "${aws_api_gateway_rest_api.wild-rydes-api-gateway.execution_arn}"
}

output "api_invoke_Url" {
  value = "${aws_api_gateway_deployment.wild-rydes-api-gateway-deployment.invoke_url}"
}
