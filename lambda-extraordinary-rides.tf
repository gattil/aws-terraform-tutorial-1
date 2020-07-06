# # --------------------------------------------------------------------------------
# # Lambda for Extraordinary Rides Service
# # --------------------------------------------------------------------------------

# data "archive_file" "zip-extraordinary-rides-service" {
#   type        = "zip"
#   source_file = "${path.module}/lambdas/generic-unicorn-service/app.py"
#   output_path = "${path.module}/lambdas/extraordinary-rides-service.zip"
# }

# resource "aws_lambda_function" "extraordinary-rides-service" {
#   filename      = data.archive_file.zip-extraordinary-rides-service.output_path
#   function_name = "${var.username}-extraordinary-rides-service"
#   role          = aws_iam_role.extraordinary-rides-service.arn
#   handler       = "app.handler"
#   timeout       = 3

#   # The filebase64sha256() function is available in Terraform 0.11.12 and later
#   # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
#   # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
#   source_code_hash = data.archive_file.zip-extraordinary-rides-service.output_base64sha256

#   runtime = "python3.7"

#   environment {
#     variables = {
#       SERVICE_NAME     = "EXTRAORDINARY-RIDES-SERVICE"
#     }
#   }
#   tags = var.tags
# }

# resource "aws_lambda_event_source_mapping" "extraordinary-rides-service" {
#   event_source_arn = aws_sqs_queue.extraordinary-rides-service.arn
#   function_name    = aws_lambda_function.extraordinary-rides-service.arn
# }

# resource "aws_iam_role" "extraordinary-rides-service" {
#   name = "${var.username}-extraordinary-rides-service-role"

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

# data "aws_iam_policy_document" "extraordinary-rides-service" {

#   statement {
#     sid       = "AllowSQS"
#     effect    = "Allow"
#     resources = [
#         aws_sqs_queue.extraordinary-rides-service.arn
#       ]
#     actions   = [
#                 "sqs:ChangeMessageVisibility",
#                 "sqs:ChangeMessageVisibilityBatch",
#                 "sqs:DeleteMessage",
#                 "sqs:DeleteMessageBatch",
#                 "sqs:GetQueueAttributes",
#                 "sqs:ReceiveMessage"]
#   }

# }

# resource "aws_iam_policy" "extraordinary-rides-service" {
#   policy = data.aws_iam_policy_document.extraordinary-rides-service.json
# }

# # This policy ensures that the Lambda is visible in the VPC
# resource "aws_iam_role_policy_attachment" "extraordinary-rides-service-standard-lambda-policy" {
#   role       = aws_iam_role.extraordinary-rides-service.name
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
# }
# resource "aws_iam_role_policy_attachment" "extraordinary-rides-service-access-aws-services" {
#   role       = aws_iam_role.extraordinary-rides-service.name
#   policy_arn = aws_iam_policy.extraordinary-rides-service.arn
# }

