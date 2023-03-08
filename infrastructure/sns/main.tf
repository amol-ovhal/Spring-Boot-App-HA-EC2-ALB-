provider "aws" {
  region = var.region
}

resource "aws_sns_topic" "sns_topic" {
  name = "Default_CloudWatch_Alarms_Topic"
  tags = var.tags
}

resource "aws_sns_topic_subscription" "email" {
  count     = length(var.endpoint)
  topic_arn = aws_sns_topic.sns_topic.arn
  protocol  = "email"
  endpoint  = var.endpoint[count.index]
}