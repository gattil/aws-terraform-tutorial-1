#resource "aws_dynamodb_table" "ride-requests" {
#  name           = "${var.username}-ride-requests"
#  read_capacity  = 3
#  write_capacity = 3
#
#  hash_key = "RideId"
#
#  attribute {
#    name = "RideId"
#    type = "S"
#  }
#
#  server_side_encryption {
#    enabled = true
#    kms_key_arn = aws_kms_key.unicorn.arn
#  }
#
#  tags = var.tags
#}
