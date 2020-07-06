# # -----------------------------------------------------------------------------------
# # API GTW
# # -----------------------------------------------------------------------------------

# resource "aws_api_gateway_rest_api" "unicorn-management-api" {
#   name        = "${var.username}-unicorn-management-api"
#   description = "Unicorn Management API of ${var.username}"
# }

# # -----------------------------------------------------------------------------------
# # POST /ride
# # -----------------------------------------------------------------------------------
# resource "aws_api_gateway_resource" "proxy" {
#   rest_api_id = aws_api_gateway_rest_api.unicorn-management-api.id
#   parent_id   = aws_api_gateway_rest_api.unicorn-management-api.root_resource_id
#   path_part   = "ride"
# }

# resource "aws_api_gateway_method" "proxy" {
#   rest_api_id   = aws_api_gateway_rest_api.unicorn-management-api.id
#   resource_id   = aws_api_gateway_resource.proxy.id
#   http_method   = "POST"
#   authorization = "NONE"
# }

# resource "aws_api_gateway_integration" "lambda" {
#   rest_api_id = aws_api_gateway_rest_api.unicorn-management-api.id
#   resource_id = aws_api_gateway_method.proxy.resource_id
#   http_method = aws_api_gateway_method.proxy.http_method

#   integration_http_method = "POST"
#   type                    = "AWS_PROXY"
#   uri                     = aws_lambda_function.unicorn-management-service.invoke_arn
# }

# resource "aws_lambda_permission" "apigw" {
#   statement_id  = "AllowAPIGatewayInvoke"
#   action        = "lambda:InvokeFunction"
#   function_name = aws_lambda_function.unicorn-management-service.function_name
#   principal     = "apigateway.amazonaws.com"

#   # The "/*/*" portion grants access from any method on any resource
#   # within the API Gateway REST API.
#   source_arn = "${aws_api_gateway_rest_api.unicorn-management-api.execution_arn}/*/*"
# }


# # -----------------------------------------------------------------------------------
# # Deployment
# # -----------------------------------------------------------------------------------
# resource "aws_api_gateway_deployment" "unicorn-management-api" {
#   depends_on = [
#     aws_api_gateway_integration.lambda
#   ]

#   rest_api_id = aws_api_gateway_rest_api.unicorn-management-api.id
#   stage_name  = "default"
# }



