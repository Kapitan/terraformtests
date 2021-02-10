 resource "aws_vpc" "wp_vpc" {
   cidr_block       = "${var.vpcnet}"
   instance_tenancy = "default"

   tags = {
     Name       = "wp_vpc"
     Location   = "dnepr"
     Ovner      = "Kapitan"
   }
 }

resource "aws_subnet" "public_net" {
  vpc_id        = "${aws_vpc.wp_vpc.id}"
  cidr_block    = "${var.networkpub}"
  map_public_ip_on_launch = "true"

  tags = {
    Name = "pub_lan"
    Used = "web content ASG"
  }
}

resource "aws_subnet" "privat_net" {
  vpc_id                    = "${aws_vpc.wp_vpc.id}"
  cidr_block                = "${var.networkpriv}"
  map_public_ip_on_launch   = "false"

  tags = {
    Name = "for something"
  }
}

resource "aws_internet_gateway" "mygw" {
  vpc_id = "${aws_vpc.wp_vpc.id}"
  
  tags = {
      Name = "my GW"
  }
}

resource "aws_route_table" "routingwp" {
  vpc_id = "${aws_vpc.wp_vpc.id}"
  route {
      cidr_block = "${var.vpcnet}"
      gateway_id = "${aws_internet_gateway.mygw.id}"
  } 
  tags = {
      Name = "my f router on aws"
  }
}

resource "aws_route_table_association" "assoc" {
    subnet_id       = "${aws_subnet.privat_net.id}"
    route_table_id  = "${aws_route_table.routingwp.id}"
}

resource "aws_route" "internet_access" {
  route_table_id         = "${aws_vpc.wp_vpc.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.mygw.id}"
}

resource "aws_eip" "pubip" {
    vpc         = true
    depends_on = ["${aws_internet_gateway.mygw}"]
}
