resource "aws_route53_zone" "general" {
  name = "almostsecure.org"
}

resource "aws_route53_record" "alias_route53_record" {
  zone_id = aws_route53_zone.general.zone_id
  name    = "almostsecure.org"
  type    = "A"

  alias {
    name                   = aws_lb.webtier_alb.dns_name
    zone_id                = aws_lb.webtier_alb.zone_id
    evaluate_target_health = true
  }
}