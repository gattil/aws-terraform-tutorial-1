resource "aws_sqs_queue" "customer-accounting-service" {
  name                       = "${var.username}-customer-accounting-service"
  delay_seconds              = 0
  max_message_size           = 262144
  message_retention_seconds  = 86400
  visibility_timeout_seconds = 30
  receive_wait_time_seconds  = 0

  kms_master_key_id                 = "alias/aws/sqs"
  kms_data_key_reuse_period_seconds = 300

  tags = var.tags
}

resource "aws_sqs_queue" "customer-notification-service" {
  name                       = "${var.username}-customer-notification-service"
  delay_seconds              = 0
  max_message_size           = 262144
  message_retention_seconds  = 86400
  visibility_timeout_seconds = 30
  receive_wait_time_seconds  = 0

  kms_master_key_id                 = "alias/aws/sqs"
  kms_data_key_reuse_period_seconds = 300

  tags = var.tags
}

resource "aws_sqs_queue" "extraordinary-rides-service" {
  name                       = "${var.username}-extraordinary-rides-service"
  delay_seconds              = 0
  max_message_size           = 262144
  message_retention_seconds  = 86400
  visibility_timeout_seconds = 30
  receive_wait_time_seconds  = 0

  kms_master_key_id                 = "alias/aws/sqs"
  kms_data_key_reuse_period_seconds = 300

  tags = var.tags
}
