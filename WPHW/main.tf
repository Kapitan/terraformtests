# data "aws_ami" "centos" {
#   most_recent = true

#   filter {
#     name   = "name"
#     values = ["CentOS Linux 7 x86_64 HVM EBS *"]
#   }

#   filter {
#     name   = "virtualization-type"
#     values = ["hvm"]
#   }
#   owners = ["679593333241"]
# }
resource "aws_instance" "wordpress" {
  ami                     = "ami-04cf43aca3e6f3de3"
  vpc_security_group_ids  = ["${aws_security_group.ssh_http.id}"]
  key_name                = "${var.aws_key}"  
  instance_type           = "${var.itype}"
  tags = {
    Name = "wordpress_res"
  }
  root_block_device {
    delete_on_termination = true
  }
}

# output "instance_ip_addr" {
#   value = "ssh -i ./.ssh/wordpresskey.pem centos@${aws_instance.wordpress.public_ip}"
# }

resource "null_resource" "example_provisioner" {

    connection {
      type        = "ssh"
      host        = "${aws_instance.wordpress.public_ip}"
      user        = "${var.suser}"
      private_key = "${file("/home/user/.ssh/wordpresskey.pem")}"
      port        = "${var.sport}"
      agent       = true
    }
}