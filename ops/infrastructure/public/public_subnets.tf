variable "vpc_id" {}
variable "internet_gw_id" {}

output "sg_bastion_id" {
    value = "${aws_security_group.sg_bastion.id}"
}

resource "aws_subnet" "main_public_d" {
    vpc_id = "${var.vpc_id}"
    cidr_block = "10.0.1.0/24"
    availability_zone = "us-east-1d"
    tags {
        Project = "msa"
        Name = "main_public_a"
    }
}


resource "aws_subnet" "main_public_b" {
    vpc_id = "${var.vpc_id}"
    cidr_block = "10.0.2.0/24"
    availability_zone = "us-east-1b"
    tags {
        Project = "msa"
        Name = "main_public_b"
    }
}

resource "aws_subnet" "main_public_c" {
    vpc_id = "${var.vpc_id}"
    cidr_block = "10.0.3.0/24"
    availability_zone = "us-east-1c"
    tags {
        Project = "msa"
        Name = "main_public_c"
    }
}

resource "aws_security_group" "sg_bastion" {
  name = "bastion"
  description = "bastion"
  vpc_id = "${var.vpc_id}"
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

resource "aws_route_table" "r-vpc-main" {
    vpc_id = "${var.vpc_id}"
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = "${var.internet_gw_id}"
    }

    tags {
        Project = "msa"
        Name = "main"
    }
}

resource "aws_route_table_association" "public_d" {
    subnet_id = "${aws_subnet.main_public_d.id}"
    route_table_id = "${aws_route_table.r-vpc-main.id}"
}
resource "aws_route_table_association" "public_c" {
    subnet_id = "${aws_subnet.main_public_c.id}"
    route_table_id = "${aws_route_table.r-vpc-main.id}"
}
resource "aws_route_table_association" "public_b" {
    subnet_id = "${aws_subnet.main_public_b.id}"
    route_table_id = "${aws_route_table.r-vpc-main.id}"
}

resource "aws_eip" "nat" {
  vpc      = true
}

resource "aws_nat_gateway" "gw" {
  allocation_id = "${aws_eip.nat.id}"
  subnet_id = "${aws_subnet.main_public_d.id}"
}

output "nat_gw_id"      { value = "${aws_nat_gateway.gw.id}"}
