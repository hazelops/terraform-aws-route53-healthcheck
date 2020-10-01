# AWS S3 bucket for website static hosting
resource "aws_s3_bucket" "this" {
  count  = var.r53_failover_enabled ? 1 : 0
  bucket = var.fqdn
  acl    = "public-read"

  tags = {
    Terraform = "true"
    Name      = "${var.env}-${var.name}"
  }

  policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Sid": "PublicReadForS3BucketObjects",
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::${var.fqdn}/*"
    }
  ]
}
EOF

  website {
    index_document = "index.html"
  }
}

resource "aws_s3_bucket_object" "this" {
  count  = var.r53_failover_enabled ? 1 : 0
  key    = "index.html"
  bucket = aws_s3_bucket.this[0].id
  source = "${path.module}/index.html"
  content_type = "text/html"
}

resource "aws_route53_record" "this" {
  count   = var.r53_failover_enabled ? 1 : 0
  zone_id = data.aws_route53_zone.this.zone_id
  name    = var.fqdn
  type    = "A"

  alias {
    name                   = aws_s3_bucket.this[0].website_domain
    zone_id                = aws_s3_bucket.this[0].hosted_zone_id
    evaluate_target_health = false
  }

  failover_routing_policy {
    type = "SECONDARY"
  }
  set_identifier = "${var.fqdn}-SECONDARY"
}