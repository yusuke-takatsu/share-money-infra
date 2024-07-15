resource "aws_acm_certificate" "share-money" {
  domain_name       = local.domain
  validation_method = "DNS"
  tags = {
    Name = "${local.domain}"
  }
}

resource "aws_route53_record" "certificate_validation" {
  for_each = {
    for i in aws_acm_certificate.share-money.domain_validation_options : i.domain_name => {
      name   = i.resource_record_name
      record = i.resource_record_value
      type   = i.resource_record_type
    }
  }

  name    = each.value.name
  records = [each.value.record]
  ttl     = 60
  type    = each.value.type
  zone_id = data.aws_route53_zone.this.id
}

resource "aws_acm_certificate_validation" "share-money" {
  certificate_arn         = aws_acm_certificate.share-money.arn
  validation_record_fqdns = [for record in aws_route53_record.certificate_validation : record.fqdn]
}