#############################################
# Project: CNHI 
# Calling Required Modules
#############################################
variable "aws_access_key" {}
variable "aws_secret_key" {}
provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "us-west-2"
}
resource "aws_sns_topic" "sns_notification" {
  name = "iTrams-CNHI-PROD-SNS01"
}