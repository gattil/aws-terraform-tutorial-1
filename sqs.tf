resource "aws_sqs_queue" "customer-accounting-service" {
#   name                       = "${var.username}-customer-accounting-service"
#   delay_seconds              = 0
#   max_message_size           = 262144
#   message_retention_seconds  = 86400
#   visibility_timeout_seconds = 30
#   receive_wait_time_seconds  = 0

#   kms_master_key_id                 = "alias/aws/sqs"
#   kms_data_key_reuse_period_seconds = 300

#   tags = var.tags
# }

# resource "aws_sns_topic_subscription" "customer-accounting-service" {
#   topic_arn = aws_sns_topic.ride-completion-topic.arn
#   protocol  = "sqs"
#   endpoint  = aws_sqs_queue.customer-accounting-service.arn
# }

# resource "aws_sqs_queue" "customer-notification-service" {
#   name                       = "${var.username}-customer-notification-service"
#   delay_seconds              = 0
#   max_message_size           = 262144
#   message_retention_seconds  = 86400
#   visibility_timeout_seconds = 30
#   receive_wait_time_seconds  = 0

#   kms_master_key_id                 = "alias/aws/sqs"
#   kms_data_key_reuse_period_seconds = 300

#   tags = var.tags
# }

# resource "aws_sns_topic_subscription" "customer-notification-service" {
#   topic_arn = aws_sns_topic.ride-completion-topic.arn
#   protocol  = "sqs"
#   endpoint  = aws_sqs_queue.customer-notification-service.arn
# }

# resource "aws_sqs_queue" "extraordinary-rides-service" {
#   name                       = "${var.username}-extraordinary-rides-service"
#   delay_seconds              = 0
#   max_message_size           = 262144
#   message_retention_seconds  = 86400
#   visibility_timeout_seconds = 30
#   receive_wait_time_seconds  = 0

#   kms_master_key_id                 = "alias/aws/sqs"
#   kms_data_key_reuse_period_seconds = 300

#   tags = var.tags
# }

# resource "aws_sns_topic_subscription" "extraordinary-rides-service" {
#   topic_arn = aws_sns_topic.ride-completion-topic.arn
#   protocol  = "sqs"
#   endpoint  = aws_sqs_queue.extraordinary-rides-service.arn

#   filter_policy = <<EOF
#   {
#     "fare": [
#       {
#         "numeric": [
#           ">=",
#           50
#         ]
#       }
#     ],
#     "distance": [
#       {
#         "numeric": [
#           ">=",
#           20
#         ]
#       }
#     ]
#   }
#   EOF
# }