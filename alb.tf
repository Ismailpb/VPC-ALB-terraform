
#========================================================
# Get all subnet of  vpc
#========================================================

#data "aws_subnet_ids" "default" {
#vpc_id = aws_vpc.vpc.id 
#}

#========================================================
# Creating  Security Group for application loadbalancer
#========================================================
#========================================================
# Creating  application loadbalancer
#========================================================

  resource "aws_lb"  "mylb" {
  name               = "MY-LB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [ aws_security_group.alb-sec.id ]
  subnets            = [ aws_subnet.public1.id, aws_subnet.public2.id ] 

  enable_deletion_protection = false
  depends_on = [ aws_lb_target_group.t1-tg ]

tags = {
     Name = "MY-LB"
}
}
output "ALB-Endpoint" {
  value = aws_lb.mylb.dns_name
} 

#========================================================
# Creating http listener of application loadbalancer
#========================================================

resource "aws_lb_listener" "listner" {
    
  load_balancer_arn = aws_lb.mylb.id

  port              = 80
  protocol          = "HTTP"
  
  # default action of the target group.
  default_action {
    type = "forward"
     target_group_arn = aws_lb_target_group.t1-tg.arn
  }
   depends_on = [ aws_lb.mylb ]

   }
    

