resource "aws_launch_configuration" "support" {
  
  name_prefix       = "support-"
  image_id          = "ami-052cef05d01020f1d"
  instance_type     = "t2.micro"
  key_name          = "linux"
  security_groups       =  [ var.sec ]
  user_data         = file("setup.sh")
  lifecycle {
    create_before_destroy = true
  }

}
####################################  


resource "aws_autoscaling_group" "supportfirst-asg" {

  launch_configuration    =  aws_launch_configuration.support.id
  availability_zones      =  ["ap-south-1a" , "ap-south-1b"]
  health_check_type       = "EC2"
  min_size                = var.asg_count
  max_size                = var.asg_count
  desired_capacity        = var.asg_count
  load_balancers          = [ "support" ]
  tag {
    key = "Name"
    propagate_at_launch = true
    value = "support"
  }
   
  lifecycle {
    create_before_destroy = true
  }

}
