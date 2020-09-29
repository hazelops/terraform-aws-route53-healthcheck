data "aws_region" "current" {}

data "aws_route53_zone" "this" {
  name         = "${var.domain_name}."
  private_zone = false
}
