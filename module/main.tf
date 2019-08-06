#############################################
# Project: CNHI 
# Calling Required Modules
#############################################

resource "aws_sns_topic" "sns_notification" {
  name = "iTrams-CNHI-PROD-SNS01"
}