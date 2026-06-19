# ==================== ROUTE 53 HOSTED ZONE ====================

resource "aws_route53_zone" "primary" {
  name = var.domain_name
}

# ==================== HEALTH CHECKS ====================

resource "aws_route53_health_check" "primary" {
  fqdn              = var.primary_alb_endpoint
  port              = 443
  type              = "HTTPS"
  resource_path     = "/healthz"
  failure_threshold = "3"
  request_interval  = "30"

  tags = {
    Name = "primary-eks-health-check"
  }
}

# ==================== FAILOVER ROUTING RECORDS ====================

resource "aws_route53_record" "primary" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "app.${var.domain_name}"
  type    = "CNAME"
  ttl     = "60"
  
  failover_routing_policy {
    type = "PRIMARY"
  }

  set_identifier  = "primary"
  health_check_id = aws_route53_health_check.primary.id
  records         = [var.primary_alb_endpoint]
}

resource "aws_route53_record" "secondary" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "app.${var.domain_name}"
  type    = "CNAME"
  ttl     = "60"
  
  failover_routing_policy {
    type = "SECONDARY"
  }

  set_identifier = "secondary"
  records        = [var.dr_alb_endpoint]
}
