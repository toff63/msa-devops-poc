variable "nat_gw_id" {}
variable "vpc_id" {}

resource "aws_route_table" "r_private" {
    vpc_id = "${var.vpc_id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${var.nat_gw_id}"
    }

    tags {
        Project = "msa"
    }
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


resource "aws_subnet" "main_private_srv_d" {
    vpc_id = "${var.vpc_id}"
    cidr_block = "10.0.4.0/24"
    availability_zone = "us-east-1d"
    tags {
        Project = "msa"
        Name = "service_d"
        Layer =  "service"
    }
}


resource "aws_subnet" "main_private_srv_b" {
    vpc_id = "${var.vpc_id}"
    cidr_block = "10.0.5.0/24"
    availability_zone = "us-east-1b"
    tags {
        Project = "msa"
        Name = "service_b"
        Layer =  "service"
    }
}

resource "aws_subnet" "main_private_srv_c" {
    vpc_id = "${var.vpc_id}"
    cidr_block = "10.0.6.0/24"
    availability_zone = "us-east-1c"
    tags {
        Project = "msa"
        Name = "service_c"
        Layer =  "service"
    }
}


