# AWS S3 bucket for website static hosting
resource "aws_s3_bucket" "this" {
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
  key    = "index.html"
  bucket = aws_s3_bucket.this.id
  source = "${path.module}/index.html"
}
