# AWS S3 bucket for website static hosting
resource "aws_s3_bucket" "this" {
  count  = var.r53_failover_enabled ? 1 : 0
  bucket = var.fqdn

  tags = {
    Terraform = "true"
    Name      = "${var.env}-${var.name}"
  }
}

resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this[0].id
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
}


resource "aws_s3_bucket_acl" "this" {
  bucket = aws_s3_bucket.this[0].id
  acl    = "public-read"
}

resource "aws_s3_bucket_website_configuration" "this" {
  count  = var.r53_failover_enabled ? 1 : 0
  bucket = aws_s3_bucket.this[0].id

  index_document {
    suffix = "index.html"
  }
  error_document {
    key = "index.html"
  }
}

resource "aws_route53_record" "this" {
  count   = var.r53_failover_enabled ? 1 : 0
  zone_id = data.aws_route53_zone.this.zone_id
  name    = var.fqdn
  type    = "A"

  alias {
    name                   = aws_s3_bucket_website_configuration.this[0].website_domain
    zone_id                = aws_s3_bucket.this[0].hosted_zone_id
    evaluate_target_health = false
  }

  failover_routing_policy {
    type = "SECONDARY"
  }
  set_identifier = "${var.fqdn}-SECONDARY"
}
