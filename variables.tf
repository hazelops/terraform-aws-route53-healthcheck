variable "env" {}
variable "domain_name" {}

variable "name" {
  type = string
  description = "The name of the monitoring and name of the subscription service endpoint"
}

variable "subscription_endpoint" {
  type = string
  description = "Endpoint endpoint for SNS topic subscription, PagerDuty, Slack etc."
}

variable "endpoint_auto_confirms" {
  type        = bool
  default     = true
  description = "Endpoint endpoint for SNS topic subscription, PagerDuty (https://events.pagerduty.com/integration/<Integration Key>/enqueue)"
}

variable "fqdn" {
  type = string
  description = "The FQDN of the endpoint to be monitored"
}

variable "subscription_endpoint_protocol" {
  type = string
  default     = "https"
  description = "Endpoint protocol for SNS topic subscription"
}

variable "port" {
  type = string
  default     = "443"
  description = "The port of the endpoint to be monitored"
}

variable "type" {
  type = string
  default     = "HTTPS"
  description = "The protocol to use when performing health checks. Valid values are HTTP, HTTPS, HTTP_STR_MATCH, HTTPS_STR_MATCH, TCP, CALCULATED and CLOUDWATCH_METRIC"
}

variable "resource_path" {
  type = string
  default     = "/"
  description = "The path that you want Amazon Route 53 to request when performing health checks."
}

variable "failure_threshold" {
  type = string
  default     = "3"
  description = "The number of consecutive health checks that an endpoint must pass or fail."
}

variable "request_interval" {
  type = string
  default     = "30"
  description = "The number of seconds between the time that Amazon Route 53 gets a response from your endpoint and the time that it sends the next health-check request."
}

variable "cw_alarm_namespace" {
  type = string
  default     = "AWS/Route53"
  description = "Namespace of Cloudwatch metric alarm"
}

variable "cw_alarm_comparison_operator" {
  type = string
  default     = "LessThanThreshold"
  description = "Comparison Operator of Cloudwatch metric alarm"
}

variable "cw_alarm_metric_name" {
  type = string
  default     = "HealthCheckStatus"
  description = "Metric name of Cloudwatch metric alarm"
}

variable "cw_alarm_evaluation_periods" {
  type = string
  default     = "1"
  description = "Evaluation periods of Cloudwatch metric alarm"
}

variable "cw_alarm_period" {
  type = string
  default     = "60"
  description = "Period of Cloudwatch metric alarm"
}

variable "cw_alarm_statistic" {
  type = string
  default     = "Minimum"
  description = "Statistic of Cloudwatch metric alarm"
}

variable "cw_alarm_threshold" {
  type = string
  default     = "1"
  description = "Threshold of Cloudwatch metric alarm"
}

variable "cw_alarm_unit" {
  type = string
  default     = "None"
  description = "Unit of Cloudwatch metric alarm"
}

variable "r53_failover_enabled" {
  type        = bool
  default     = false
  description = "Enabling creating secondary Failover R53 Record"
}

variable "enabled" {
  type        = bool
  default     = true
  description = "Gives ability to enable or disable a module"
}

