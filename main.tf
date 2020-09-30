resource "aws_sns_topic" "this" {
  name         = "${var.env}-${var.name}-r53-healthcheck"
  display_name = "${var.env}-${var.name}"
}

resource "aws_sns_topic_subscription" "this" {
  endpoint               = var.subscription_endpoint
  endpoint_auto_confirms = var.endpoint_auto_confirms
  protocol               = var.subscription_endpoint_protocol
  topic_arn              = aws_sns_topic.this.arn
}

resource "aws_route53_health_check" "this" {
  fqdn              = var.fqdn
  port              = var.port
  type              = var.type
  resource_path     = var.resource_path
  failure_threshold = var.failure_threshold
  request_interval  = var.request_interval

  tags = {
    Terraform = "true"
    Name      = "${var.env}-${var.name}"
  }
}

resource "aws_cloudwatch_metric_alarm" "this" {
  alarm_name          = "${var.name}-r53-healthcheck-failed"
  namespace           = var.cw_alarm_namespace
  metric_name         = var.cw_alarm_metric_name
  comparison_operator = var.cw_alarm_comparison_operator
  evaluation_periods  = var.cw_alarm_evaluation_periods
  period              = var.cw_alarm_period
  statistic           = var.cw_alarm_statistic
  threshold           = var.cw_alarm_threshold
  unit                = var.cw_alarm_unit

  dimensions = {
    HealthCheckId = aws_route53_health_check.this.id
  }

  alarm_description         = "This metric monitors ${var.name} service endpoint ( ${var.type}://${var.fqdn}:${var.port}${var.resource_path} ) whether it is UP or Down"
  ok_actions                = [aws_sns_topic.this.arn]
  alarm_actions             = [aws_sns_topic.this.arn]
  insufficient_data_actions = [aws_sns_topic.this.arn]
  treat_missing_data        = "breaching"
}

/*
This approach can be used for email SNS subscription: 
resource "aws_cloudformation_stack" "tf_sns_topic" {
   name = "EmailSNSTopicStack"
   template_body = data.template_file.aws_cf_sns_stack.rendered
   tags = {
     name = "EmailSNSTopicStack"
   }

  # [INFO] Can be updated and implemented for removing email subscription during tf destroy - it's continue 
  # existing after default tf destroy because it was created by the CF stack
  
  #provisioner "local-exec" {
  #  when    = destroy
  #  command = "aws sns unsubscribe --subscription-arn arn:aws:sns:us-east-1:${aws_account_id}:R53-Health:31f450f7-4cf3-4de2-9202-ddc21d022262"
  #}
 }

data.template_file.aws_cf_sns_stack.rendered = {
 "AWSTemplateFormatVersion": "2010-09-09",
  "Resources": {
    "SNSTopicEmail": {
      "Type": "AWS::SNS::Topic",
      "Properties": {
        "TopicName": "${sns_topic_name}",
        "DisplayName": "${sns_display_name}",
        "Subscription": [
          ${sns_subscription_list}
        ]
      }
    }
  },

  "Outputs" : {
    "ARN" : {
      "Description" : "Email SNS Topic ARN",
      "Value" : { "Ref" : "SNSTopicEmail" }
    }
  }
}
 */
