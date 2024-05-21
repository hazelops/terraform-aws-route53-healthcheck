# terraform-aws-route53-healthcheck
Terraform AWS Route53 Healthcheck Module

Managed by @igorkotof

The module creates: 
* SNS Topic
* SNS Subscription (e.g. PagerDuty)
* Route53 Healthcheck
* Cloudwatch Metric Alarm
* (optional) Secondary Route53 record for failover routing policy to public S3 website with "Maintenance page"
* (optional) S3 public website with "Maintenance page" (bucket name = var.fqdn)

### Example:
We will monitor s3-static-website.s3-website-us-east-1.amazonaws.com with PagerDuty notification with 
failover routing policy to S3 public website bucket with "Maintenance page" 
```
module "route53-health-check" {
    source  = "hazelops/route53-healthcheck/aws""
  
    env                   = "production"
    name                  = "my-monitoring"
    port                  = "80"
    type                  = "HTTP"
    fqdn                  = "s3-static-website.s3-website-us-east-1.amazonaws.com"
    subscription_endpoint = "https://events.pagerduty.com/integration/<Integration_Key>/enqueue"
    
    r53_failover_enabled  = true
    domain_name           = "example.com"

}
```
Note: This module just creates a secondary Route53 record for failover routing policy. Creating a primary record is out of scope of this module.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_metric_alarm.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_route53_health_check.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_health_check) | resource |
| [aws_route53_record.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_s3_bucket.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_acl.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_acl) | resource |
| [aws_s3_bucket_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_website_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_website_configuration) | resource |
| [aws_sns_topic.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic) | resource |
| [aws_sns_topic_subscription.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription) | resource |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_route53_zone.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cw_alarm_comparison_operator"></a> [cw\_alarm\_comparison\_operator](#input\_cw\_alarm\_comparison\_operator) | Comparison Operator of Cloudwatch metric alarm | `string` | `"LessThanThreshold"` | no |
| <a name="input_cw_alarm_evaluation_periods"></a> [cw\_alarm\_evaluation\_periods](#input\_cw\_alarm\_evaluation\_periods) | Evaluation periods of Cloudwatch metric alarm | `string` | `"1"` | no |
| <a name="input_cw_alarm_metric_name"></a> [cw\_alarm\_metric\_name](#input\_cw\_alarm\_metric\_name) | Metric name of Cloudwatch metric alarm | `string` | `"HealthCheckStatus"` | no |
| <a name="input_cw_alarm_namespace"></a> [cw\_alarm\_namespace](#input\_cw\_alarm\_namespace) | Namespace of Cloudwatch metric alarm | `string` | `"AWS/Route53"` | no |
| <a name="input_cw_alarm_period"></a> [cw\_alarm\_period](#input\_cw\_alarm\_period) | Period of Cloudwatch metric alarm | `string` | `"60"` | no |
| <a name="input_cw_alarm_statistic"></a> [cw\_alarm\_statistic](#input\_cw\_alarm\_statistic) | Statistic of Cloudwatch metric alarm | `string` | `"Minimum"` | no |
| <a name="input_cw_alarm_threshold"></a> [cw\_alarm\_threshold](#input\_cw\_alarm\_threshold) | Threshold of Cloudwatch metric alarm | `string` | `"1"` | no |
| <a name="input_cw_alarm_unit"></a> [cw\_alarm\_unit](#input\_cw\_alarm\_unit) | Unit of Cloudwatch metric alarm | `string` | `"None"` | no |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | n/a | `any` | n/a | yes |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Gives ability to enable or disable a module | `bool` | `true` | no |
| <a name="input_endpoint_auto_confirms"></a> [endpoint\_auto\_confirms](#input\_endpoint\_auto\_confirms) | Endpoint endpoint for SNS topic subscription, PagerDuty (https://events.pagerduty.com/integration/<Integration Key>/enqueue) | `bool` | `true` | no |
| <a name="input_env"></a> [env](#input\_env) | n/a | `any` | n/a | yes |
| <a name="input_failure_threshold"></a> [failure\_threshold](#input\_failure\_threshold) | The number of consecutive health checks that an endpoint must pass or fail. | `string` | `"3"` | no |
| <a name="input_fqdn"></a> [fqdn](#input\_fqdn) | The FQDN of the endpoint to be monitored | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | The name of the monitoring and name of the subscription service endpoint | `string` | n/a | yes |
| <a name="input_port"></a> [port](#input\_port) | The port of the endpoint to be monitored | `string` | `"443"` | no |
| <a name="input_r53_failover_enabled"></a> [r53\_failover\_enabled](#input\_r53\_failover\_enabled) | Enabling creating secondary Failover R53 Record | `bool` | `false` | no |
| <a name="input_request_interval"></a> [request\_interval](#input\_request\_interval) | The number of seconds between the time that Amazon Route 53 gets a response from your endpoint and the time that it sends the next health-check request. | `string` | `"30"` | no |
| <a name="input_resource_path"></a> [resource\_path](#input\_resource\_path) | The path that you want Amazon Route 53 to request when performing health checks. | `string` | `"/"` | no |
| <a name="input_subscription_endpoint"></a> [subscription\_endpoint](#input\_subscription\_endpoint) | Endpoint endpoint for SNS topic subscription, PagerDuty, Slack etc. | `string` | n/a | yes |
| <a name="input_subscription_endpoint_protocol"></a> [subscription\_endpoint\_protocol](#input\_subscription\_endpoint\_protocol) | Endpoint protocol for SNS topic subscription | `string` | `"https"` | no |
| <a name="input_type"></a> [type](#input\_type) | The protocol to use when performing health checks. Valid values are HTTP, HTTPS, HTTP\_STR\_MATCH, HTTPS\_STR\_MATCH, TCP, CALCULATED and CLOUDWATCH\_METRIC | `string` | `"HTTPS"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
