resource "aws_vpc" "main" {
    cidr_block = "10.0.0.0/16"
    tags {
        Name = "main"
        Project = "msa"
    }
}

output "main_vpc_id" {
    value = "${aws_vpc.main.id}"
}

output "nat_gw_id" {
    value = "${aws_internet_gateway.gw.id}"
}


resource "aws_internet_gateway" "gw" {
    vpc_id = "${aws_vpc.main.id}"

    tags {
        Name = "main"
        Project = "msa"
    }
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

