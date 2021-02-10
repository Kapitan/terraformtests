resource "aws_alb" "lb" {  
  name                  = "${var.alb_name}"  
  load_balancer_type    = "application"
  subnets               = ["${aws_subnet.public_net.id}"]
  security_groups       = ["${aws_security_group.ssh_http.id}"]
  internal              = false


  tags {    
    Name    = "${var.alb_name}"    
  }   
#   access_logs {    
#     bucket = "${var.s3_bucket}"    
#     prefix = "ELB-logs"  
#   }
}