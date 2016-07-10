resource "aws_vpc" "main" {
    cidr_block = "10.0.0.0/16"
    tags {
        Name = "main"
        Project = "msa"
    }
}

resource "aws_internet_gateway" "gw" {
    vpc_id = "${aws_vpc.main.id}"

    tags {
        Name = "main"
        Project = "msa"
    }
}
resource "aws_eip" "nat" {
  vpc      = true
}
resource "aws_nat_gateway" "gw" {
  allocation_id = "${aws_eip.nat.id}"
  subnet_id = "${aws_subnet.main_public_d.id}"
  depends_on = ["aws_internet_gateway.gw"]
}

resource "aws_route_table" "r-vpc-main" {
    vpc_id = "${aws_vpc.main.id}"
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = "${aws_internet_gateway.gw.id}"
    }

    tags {
        Project = "msa"
        Name = "main"
    }
    depends_on = ["aws_vpc.main", "aws_internet_gateway.gw"]  
}

resource "aws_route_table" "r_private" {
    vpc_id = "${aws_vpc.main.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_nat_gateway.gw.id}"
    }

    tags {
        Project = "msa"
    }
    depends_on = ["aws_vpc.main", "aws_nat_gateway.gw"]  
}

resource "aws_main_route_table_association" "a" {
    vpc_id = "${aws_vpc.main.id}"
    route_table_id = "${aws_route_table.r-vpc-main.id}"
    depends_on = ["aws_vpc.main", "aws_route_table.r-vpc-main"]  
}

resource "aws_route_table_association" "private_d" {
    subnet_id = "${aws_subnet.main_private_srv_d.id}"
    route_table_id = "${aws_route_table.r_private.id}"
}

resource "aws_route_table_association" "private_b" {
    subnet_id = "${aws_subnet.main_private_srv_b.id}"
    route_table_id = "${aws_route_table.r_private.id}"
}

resource "aws_route_table_association" "private_c" {
    subnet_id = "${aws_subnet.main_private_srv_c.id}"
    route_table_id = "${aws_route_table.r_private.id}"
}
resource "aws_subnet" "main_public_d" {
    vpc_id = "${aws_vpc.main.id}"
    cidr_block = "10.0.1.0/24"
    availability_zone = "us-east-1d"
    tags {
        Project = "msa"
        Name = "main_public_a"
    }
}


resource "aws_subnet" "main_public_b" {
    vpc_id = "${aws_vpc.main.id}"
    cidr_block = "10.0.2.0/24"
    availability_zone = "us-east-1b"
    tags {
        Project = "msa"
        Name = "main_public_b"
    }
}

resource "aws_subnet" "main_public_c" {
    vpc_id = "${aws_vpc.main.id}"
    cidr_block = "10.0.3.0/24"
    availability_zone = "us-east-1c"
    tags {
        Project = "msa"
        Name = "main_public_c"
    }
}



resource "aws_subnet" "main_private_srv_d" {
    vpc_id = "${aws_vpc.main.id}"
    cidr_block = "10.0.4.0/24"
    availability_zone = "us-east-1d"
    tags {
        Project = "msa"
        Name = "service_d"
        Layer =  "service"
    }
}


resource "aws_subnet" "main_private_srv_b" {
    vpc_id = "${aws_vpc.main.id}"
    cidr_block = "10.0.5.0/24"
    availability_zone = "us-east-1b"
    tags {
        Project = "msa"
        Name = "service_b"
        Layer =  "service"
    }
}

resource "aws_subnet" "main_private_srv_c" {
    vpc_id = "${aws_vpc.main.id}"
    cidr_block = "10.0.6.0/24"
    availability_zone = "us-east-1c"
    tags {
        Project = "msa"
        Name = "service_c"
        Layer =  "service"
    }
}

resource "aws_instance" "bastion" {
    ami = "ami-b2e3c6d8"
    instance_type = "t1.micro"
    security_groups = ["${aws_security_group.sg_bastion.id}"]
    subnet_id = "${aws_subnet.main_public_d.id}"
    associate_public_ip_address = "true"
    iam_instance_profile = "empty"
    key_name = "msa"
    tags {
        Project = "msa"
        Name = "bastion"
    }
    depends_on = ["aws_security_group.sg_bastion"]  
}

resource "aws_security_group" "sg_bastion" {
  name = "bastion"
  description = "bastion"
  vpc_id = "${aws_vpc.main.id}"
  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }
  tags {
        Project = "msa"
      Name = "bastion"
  }

}

resource "aws_instance" "service" {
    ami = "ami-b2e3c6d8"
    instance_type = "t1.micro"
    security_groups = ["${aws_security_group.sg_service.id}"]
    subnet_id = "${aws_subnet.main_private_srv_d.id}"
    associate_public_ip_address = "false"
    iam_instance_profile = "empty"
    key_name = "msa"
    tags {
        Project = "msa"
        Name = "service"
    }
    depends_on = ["aws_security_group.sg_service"]  
}

resource "aws_security_group" "sg_service" {
  name = "service"
  description = "service"
  vpc_id = "${aws_vpc.main.id}"
  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      security_groups = ["${aws_security_group.sg_bastion.id}"]
  }
  tags {
      Name = "service"
        Project = "msa"
  }

}
