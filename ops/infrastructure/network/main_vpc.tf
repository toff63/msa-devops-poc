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

output "main_vpc_id"    { value = "${aws_vpc.main.id}"}
output "internet_gw_id" { value = "${aws_internet_gateway.gw.id}"}
