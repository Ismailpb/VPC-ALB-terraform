
#========================================================
# Get all subnet of  vpc
#========================================================

#data "aws_subnet_ids" "default" {
# vpc_id = "vpc-0d7969b7cf528ca81" 
#}

#========================================================
# Creating  application loadbalancer
#========================================================

  resource "aws_lb"  "tech-support" {
  name               = "tech-support-lb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [ var.sec ]
  subnets            = [ "subnet-0ece07548b6436471", "subnet-076d866f7827bcc9d"]

  enable_deletion_protection = true

  tags = {
    Environment = "production"
  }
}


output "ALB-Endpoint" {
  value = aws_lb.tech-support.dns_name
} 

#========================================================
# Creating http listener of application loadbalancer
#========================================================

resource "aws_lb_listener" "listner" {
    
  load_balancer_arn = aws_lb.tech-support.id

  port              = 80
  protocol          = "HTTP"
  
  # default action of the target group.
  default_action {
    type = "forward"
     target_group_arn = aws_lb_target_group.t1.arn
  }
   }
    

