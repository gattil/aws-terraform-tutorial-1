# # --------------------------------------------------------------------------------
# # Lambda for Extraordinary Rides Service
# # --------------------------------------------------------------------------------

# data "archive_file" "zip-customer-accounting-service" {
#   type        = "zip"
#   source_file = "${path.module}/lambdas/generic-unicorn-service/app.py"
#   output_path = "${path.module}/lambdas/customer-accounting-service.zip"
# }

# resource "aws_lambda_function" "customer-accounting-service" {
#   filename      = data.archive_file.zip-customer-accounting-service.output_path
#   function_name = "${var.username}-customer-accounting-service"
#   role          = aws_iam_role.customer-accounting-service.arn
#   handler       = "app.lambda_handler"
#   timeout       = 3

#   # The filebase64sha256() function is available in Terraform 0.11.12 and later
#   # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
#   # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
#   source_code_hash = data.archive_file.zip-customer-accounting-service.output_base64sha256

#   runtime = "python3.7"

#   environment {
#     variables = {
#       SERVICE_NAME     = "customer-accounting-service"
#     }
#   }
#   tags = var.tags
# }

# resource "aws_lambda_event_source_mapping" "customer-accounting-service" {
#   event_source_arn = aws_sqs_queue.customer-accounting-service.arn
#   function_name    = aws_lambda_function.customer-accounting-service.arn
#   batch_size       = 1
# }

# resource "aws_iam_role" "customer-accounting-service" {
#   name = "${var.username}-customer-accounting-service-role"

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

# data "aws_iam_policy_document" "customer-accounting-service" {

#   statement {
#     sid       = "AllowSQS"
#     effect    = "Allow"
#     resources = [
#         aws_sqs_queue.customer-accounting-service.arn
#       ]
#     actions   = [
#                 "sqs:ChangeMessageVisibility",
#                 "sqs:ChangeMessageVisibilityBatch",
#                 "sqs:DeleteMessage",
#                 "sqs:DeleteMessageBatch",
#                 "sqs:GetQueueAttributes",
#                 "sqs:ReceiveMessage"]
#   }

#   statement {
#     sid       = "AllowKMS"
#     effect    = "Allow"
#     resources = [
#       "*"]
#     actions   = [
#       "kms:Decrypt"]
#   }


# }

# resource "aws_iam_policy" "customer-accounting-service" {
#   policy = data.aws_iam_policy_document.customer-accounting-service.json
# }

# # This policy ensures that the Lambda is visible in the VPC
# resource "aws_iam_role_policy_attachment" "customer-accounting-service-standard-lambda-policy" {
#   role       = aws_iam_role.customer-accounting-service.name
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
# }
# resource "aws_iam_role_policy_attachment" "customer-accounting-service-access-aws-services" {
#   role       = aws_iam_role.customer-accounting-service.name
#   policy_arn = aws_iam_policy.customer-accounting-service.arn
# }

