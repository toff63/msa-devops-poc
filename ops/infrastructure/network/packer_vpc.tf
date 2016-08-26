resource "aws_vpc" "packer" {
    cidr_block = "10.1.0.0/16"
    tags {
        Name = "packer"
        Project = "msa"
    }
}
resource "aws_subnet" "packer_subnet" {
    vpc_id = "${aws_vpc.packer.id}"
    cidr_block = "10.1.1.0/24"
    availability_zone = "us-east-1d"
    tags {
        Project = "msa",
        Name = "packer"
    }
}

resource "aws_internet_gateway" "packer-gw" {
    vpc_id = "${aws_vpc.packer.id}"

    tags {
        Name = "main"
        Project = "msa"
    }
}


resource "aws_route_table" "r-vpc-packer" {
    vpc_id = "${aws_vpc.packer.id}"
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = "${aws_internet_gateway.packer-gw.id}"
    }

    tags {
        Project = "msa"
        Name = "main"
    }
}

resource "aws_route_table_association" "packer" {
    subnet_id = "${aws_subnet.packer_subnet.id}"
    route_table_id = "${aws_route_table.r-vpc-packer.id}"
}

resource "aws_security_group" "sg_packer" {
  name = "packer"
  description = "sg used to bake amis"
  vpc_id = "${aws_vpc.packer.id}"
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
        Project = "msa",
        Name = "packer"
  }

}



output "packer_vpc_id" { value = "${aws_vpc.packer.id}"}
output "packer_subnet_id" { value = "${aws_subnet.packer_subnet.id}"}
output "packer_sg_id" { value = "${aws_security_group.sg_packer.id}"}
