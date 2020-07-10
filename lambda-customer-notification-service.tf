# # --------------------------------------------------------------------------------
# # Lambda for Extraordinary Rides Service
# # --------------------------------------------------------------------------------

# data "archive_file" "zip-customer-notification-service" {
#   type        = "zip"
#   source_file = "${path.module}/lambdas/generic-unicorn-service/app.py"
#   output_path = "${path.module}/lambdas/customer-notification-service.zip"
# }

# resource "aws_lambda_function" "customer-notification-service" {
#   filename      = data.archive_file.zip-customer-notification-service.output_path
#   function_name = "${var.username}-customer-notification-service"
#   role          = aws_iam_role.customer-notification-service.arn
#   handler       = "app.lambda_handler"
#   timeout       = 3

#   # The filebase64sha256() function is available in Terraform 0.11.12 and later
#   # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
#   # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
#   source_code_hash = data.archive_file.zip-customer-notification-service.output_base64sha256

#   runtime = "python3.7"

#   environment {
#     variables = {
#       SERVICE_NAME     = "customer-notification-service"
#     }
#   }
#   tags = var.tags
# }

# resource "aws_lambda_event_source_mapping" "customer-notification-service" {
#   event_source_arn = aws_sqs_queue.customer-notification-service.arn
#   function_name    = aws_lambda_function.customer-notification-service.arn
#   batch_size       = 1
# }

# resource "aws_iam_role" "customer-notification-service" {
#   name = "${var.username}-customer-notification-service-role"

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

# data "aws_iam_policy_document" "customer-notification-service" {

#   statement {
#     sid       = "AllowSQS"
#     effect    = "Allow"
#     resources = [
#         aws_sqs_queue.customer-notification-service.arn
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

# resource "aws_iam_policy" "customer-notification-service" {
#   policy = data.aws_iam_policy_document.customer-notification-service.json
# }

# # This policy ensures that the Lambda is visible in the VPC
# resource "aws_iam_role_policy_attachment" "customer-notification-service-standard-lambda-policy" {
#   role       = aws_iam_role.customer-notification-service.name
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
# }
# resource "aws_iam_role_policy_attachment" "customer-notification-service-access-aws-services" {
#   role       = aws_iam_role.customer-notification-service.name
#   policy_arn = aws_iam_policy.customer-notification-service.arn
# }

