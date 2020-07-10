# # --------------------------------------------------------------------------------
# # Lambda for Unicorn Management Service
# # --------------------------------------------------------------------------------

# data "archive_file" "zip-call-api-with-response" {
#   type        = "zip"
#   source_file = "${path.module}/lambdas/unicorn-management-service/app.js"
#   output_path = "${path.module}/lambdas/unicorn-management-service.zip"
# }

# resource "aws_lambda_function" "unicorn-management-service" {
#   filename      = data.archive_file.zip-call-api-with-response.output_path
#   function_name = "${var.username}-unicorn-management-service"
#   role          = aws_iam_role.unicorn-mng-service.arn
#   handler       = "app.handler"
#   timeout       = 3

#   # The filebase64sha256() function is available in Terraform 0.11.12 and later
#   # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
#   # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
#   source_code_hash = data.archive_file.zip-call-api-with-response.output_base64sha256

#   runtime = "nodejs10.x"

#   environment {
#     variables = {
#       ddb_table     = aws_dynamodb_table.ride-requests.name
#       sns_topic_arn = aws_sns_topic.ride-completion-topic.arn
#       username      = var.username
#     }
#   }
#   tags = var.tags
# }

# resource "aws_iam_role" "unicorn-mng-service" {
#   name = "${var.username}-unicorn-mng-service-role"

#   assume_role_policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Action": "sts:AssumeRole",
#       "Principal": {
#         "Service": "lambda.amazonaws.com"
#       },
#       "Effect": "Allow",
#       "Sid": ""
#     }
#   ]
# }
# EOF
#   force_detach_policies = true
#   tags = var.tags
# }
# data "aws_iam_policy_document" "unicorn-mng-service" {

#   statement {
#     sid       = "AllowSNSTopic"
#     effect    = "Allow"
#     resources = [
#       aws_sns_topic.ride-completion-topic.arn]
#     actions   = [
#       "sns:*"]
#   }
#   statement {
#     sid       = "AllowDynamoDB"
#     effect    = "Allow"
#     resources = [
#       aws_dynamodb_table.ride-requests.arn]
#     actions   = [
#       "dynamodb:PutItem"]
#   }

#   statement {
#     sid       = "AllowKMS"
#     effect    = "Allow"
#     resources = [
#       "*"]
#     actions   = [
#       "kms:Decrypt",
#       "kms:GenerateDataKey"]
#   }

# }

# resource "aws_iam_policy" "unicorn-mng-service" {
#   policy = data.aws_iam_policy_document.unicorn-mng-service.json
# }

# # This policy ensures that the Lambda is visible in the VPC
# resource "aws_iam_role_policy_attachment" "unicorn-mng-service-standard-lambda-policy" {
#   role       = aws_iam_role.unicorn-mng-service.name
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
# }
# resource "aws_iam_role_policy_attachment" "unicorn-mng-service-access-aws-services" {
#   role       = aws_iam_role.unicorn-mng-service.name
#   policy_arn = aws_iam_policy.unicorn-mng-service.arn
# }
