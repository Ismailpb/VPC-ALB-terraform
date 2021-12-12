resource "aws_lb_target_group" "t1-tg" {
  name     = "t1-tg"
  port     = 80
  target_type = "instance"
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id
  load_balancing_algorithm_type = "round_robin"
  deregistration_delay = 60
  stickiness {
    enabled = false
    type    = "lb_cookie"
    cookie_duration = 60
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 30
    path                = "/index.html"
    protocol            = "HTTP"

  }
  lifecycle {
    create_before_destroy = true
  }
}
