# resource "aws_sqs_queue_policy" "customer-accounting-service" {
#   queue_url = aws_sqs_queue.customer-accounting-service.id

#   policy = <<POLICY
# {
#   "Version": "2012-10-17",
#   "Id": "sqspolicy",
#   "Statement": [
#     {
#       "Sid": "First",
#       "Effect": "Allow",
#       "Principal": "*",
#       "Action": "sqs:SendMessage",
#       "Resource": "${aws_sqs_queue.customer-accounting-service.arn}",
#       "Condition": {
#         "ArnEquals": {
#           "aws:SourceArn": "${aws_sns_topic.ride-completion-topic.arn}"
#         }
#       }
#     }
#   ]
# }
# POLICY
# }

# resource "aws_sqs_queue_policy" "customer-notification-service" {
#   queue_url = aws_sqs_queue.customer-notification-service.id

#   policy = <<POLICY
# {
#   "Version": "2012-10-17",
#   "Id": "sqspolicy",
#   "Statement": [
#     {
#       "Sid": "First",
#       "Effect": "Allow",
#       "Principal": "*",
#       "Action": "sqs:SendMessage",
#       "Resource": "${aws_sqs_queue.customer-notification-service.arn}",
#       "Condition": {
#         "ArnEquals": {
#           "aws:SourceArn": "${aws_sns_topic.ride-completion-topic.arn}"
#         }
#       }
#     }
#   ]
# }
# POLICY
# }

# resource "aws_sqs_queue_policy" "extraordinary-rides-service" {
#   queue_url = aws_sqs_queue.extraordinary-rides-service.id

#   policy = <<POLICY
# {
#   "Version": "2012-10-17",
#   "Id": "sqspolicy",
#   "Statement": [
#     {
#       "Sid": "First",
#       "Effect": "Allow",
#       "Principal": "*",
#       "Action": "sqs:SendMessage",
#       "Resource": "${aws_sqs_queue.extraordinary-rides-service.arn}",
#       "Condition": {
#         "ArnEquals": {
#           "aws:SourceArn": "${aws_sns_topic.ride-completion-topic.arn}"
#         }
#       }
#     }
#   ]
# }
# POLICY
# }
