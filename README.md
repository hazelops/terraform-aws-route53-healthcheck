# terraform-aws-route53-healthcheck
Terraform AWS Route53 Healthcheck Module

The module creates: 
* SNS Topic
* SNS Subscription (e.g. PagerDuty)
* Route53 Healthcheck
* Cloudwatch Metric Alarm
* (optional) Secondary Route53 record for failover routing policy to public S3 website with "Maintenance page"

### Example:
We will monitore s3-static-website.s3-website-us-east-1.amazonaws.com with PagetDuty notification with 
failover routing policy to S3 public website bucket with "Maintenance page" 
```
module "route53-health-check" {
    source  = "hazelops/route53-healthcheck/aws""
    version = "~> 1.0"

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