# data "aws_caller_identity" "current" {}

# resource "aws_kms_key" "unicorn" {
#   description = "${var.username}-unicorn-serverless"
#   policy = data.aws_iam_policy_document.sns_sqs_key_policy.json
#   tags        = var.tags
# }

# resource "aws_kms_alias" "unicorn" {
#   name          = "alias/${var.username}-unicorn-serverless-key"
#   target_key_id = aws_kms_key.unicorn.key_id
# }


# data "aws_iam_policy_document" "sns_sqs_key_policy" {
#   policy_id = "${var.username}-unicorn-serverless-sqs-sns-key-policy"

#   statement {
#     sid = "Enable IAM User Permissions"
#     actions = ["kms:*"]
#     principals {
#       type = "AWS"
#       identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
#     }
#     resources = ["*"]
#   }

#   statement {
#     sid = "SNS decrypt permission"
#     actions = ["kms:GenerateDataKey*", "kms:Decrypt"]
#     principals  {
#       type = "Service"
#       identifiers = ["sns.amazonaws.com"]
#     }
#     resources = ["*"]
#   }

#   statement {
#     sid = "Lambda encrypt-decrypt permission"
#     actions = ["kms:GenerateDataKey*", "kms:Decrypt", "kms:Encrypt"]
#     principals  {
#       type = "Service"
#       identifiers = ["lambda.amazonaws.com"]
#     }
#     resources = ["*"]
#   }

#   statement {
#     sid = "DynamoDB encrypt-decrypt permission"
#     actions = ["kms:GenerateDataKey*", "kms:Decrypt", "kms:Encrypt"]
#     principals  {
#       type = "Service"
#       identifiers = ["dynamodb.amazonaws.com"]
#     }
#     resources = ["*"]
#   }
# }