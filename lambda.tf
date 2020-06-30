# --------------------------------------------------------------------------------
# Lambda for Unicorn Management Service
# --------------------------------------------------------------------------------

data "archive_file" "zip-call-api-with-response" {
  type        = "zip"
  source_file = "${path.module}/lambdas/unicorn-management-service/app.js"
  output_path = "${path.module}/lambdas/unicorn-management-service.zip"
}

resource "aws_lambda_function" "test_lambda" {
  filename      = data.archive_file.zip-call-api-with-response.output_path
  function_name = "${var.username}-unicorn-magaement-service"
  role          = aws_iam_role.unicorn-mng-service.arn
  handler       = "app.handler"
  timeout       = 3

  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  source_code_hash = data.archive_file.zip-call-api-with-response.output_base64sha256

  runtime = "nodejs10.x"

  environment {
    variables = {
      ddb_table     = var.ddb_table_name
      sns_topic_arn = var.sns_topic_arn
      username      = var.username
    }
  }
}

resource "aws_iam_role" "unicorn-mng-service" {
  name = "${var.username}-unicorn-mng-service-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}
data "aws_iam_policy_document" "unicorn-mng-service" {

  statement {
    sid       = "AllowSNSTopic"
    effect    = "Allow"
    resources = [
      var.sns_topic_arn]
    actions   = [
      "sns:*"]
  }
  statement {
    sid       = "AllowDynamoDB"
    effect    = "Allow"
    resources = [
      var.ddb_table_arn]
    actions   = [
      "dynamodb:PutItem"]
  }

}

resource "aws_iam_policy" "unicorn-mng-service" {
  policy = data.aws_iam_policy_document.unicorn-mng-service.json
}

# This policy ensures that the Lambda is visible in the VPC
resource "aws_iam_role_policy_attachment" "unicorn-mng-service-standard-lambda-policy" {
  role       = aws_iam_role.unicorn-mng-service.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
resource "aws_iam_role_policy_attachment" "unicorn-mng-service-access-aws-services" {
  role       = aws_iam_role.unicorn-mng-service.name
  policy_arn = aws_iam_policy.unicorn-mng-service.arn
}