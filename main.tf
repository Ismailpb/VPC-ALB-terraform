
resource "aws_security_group" "alb-sec" {
    
  name        = "alb-sec"
  description = "allows 80 for inbound and all for outbound"
  vpc_id      =aws_vpc.vpc.id
ingress     = [ 
      
  {
    description      = ""
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = [ "0.0.0.0/0" ]
    ipv6_cidr_blocks = [ "::/0" ]
    prefix_list_ids  = []
    security_groups  = []
    self             = false 
  },
      
  {
    description      = ""
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = [ "0.0.0.0/0" ]
    ipv6_cidr_blocks = [ "::/0" ]
    prefix_list_ids  = []
    security_groups  = []
    self             = false 
  }


  ]
      
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }


  tags = {
    Name = "alb-sec"
  }
}



#=======================================================================================





resource "aws_launch_configuration" "support" {
  
  name_prefix       = "support-"
  image_id          = "ami-052cef05d01020f1d"
  instance_type     = "t2.micro"
  key_name          = "linux"
  security_groups       =  [ aws_security_group.alb-sec.id ]
  user_data         = file("setup.sh")
  lifecycle {
    create_before_destroy = true
  }

}
####################################  


resource "aws_autoscaling_group" "asg-1" {

  launch_configuration    =  aws_launch_configuration.support.id
  vpc_zone_identifier       = [aws_subnet.public1.id, aws_subnet.public2.id ]
  target_group_arns       = [ aws_lb_target_group.t1-tg.arn ]
  health_check_type       = "EC2"
  min_size                = var.asg_count
  max_size                = var.asg_count
  desired_capacity        = var.asg_count
  #load_balancers          = [ "support" ]
  tag {
    key = "Name"
    propagate_at_launch = true
    value = "asg-1"
  }
   
  lifecycle {
    create_before_destroy = true
  }

}
