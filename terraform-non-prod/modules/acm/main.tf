resource "aws_acm_certificate" "certificate" {
  domain_name       = var.domain_name # Change this to your domain name
  validation_method = "DNS"

  tags = {
    Name        = "${var.global_prefix}-${var.env_name}-acm"
    Terraform    = "true"
    Environment = var.env_name
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_zone" "zone" {
  name = var.domain_zone # Change this to your domain zone name
}

locals {
  domain_validation_options_map = tomap({
    for option in aws_acm_certificate.certificate.domain_validation_options : option.domain_name => {
      resource_record_name  = option.resource_record_name
      resource_record_type  = option.resource_record_type
      resource_record_value = option.resource_record_value
      zone_id               = aws_route53_zone.zone.zone_id
    }
  })
}

resource "aws_route53_record" "validation" {
  for_each = local.domain_validation_options_map

  zone_id = each.value.zone_id
  name    = each.value.resource_record_name
  type    = each.value.resource_record_type
  records = [each.value.resource_record_value]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "certificate_validation" {
  certificate_arn = aws_acm_certificate.certificate.arn

  validation_record_fqdns = values(aws_route53_record.validation)[*].fqdn
}
