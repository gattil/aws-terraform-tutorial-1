# --------------------------------------------------------------
# Variables
# --------------------------------------------------------------
variable "region" {
  type    = string
  default = "eu-central-1"
}
variable "role_arn" {
  type = string
}
variable "username" {
  type = string
}
variable "ddb_table_name" {
  type = string
}
variable "ddb_table_arn"{
  type = string
}
variable "sns_topic_arn" {
  type = string
}
variable "tags"{
  default = map(string)
}