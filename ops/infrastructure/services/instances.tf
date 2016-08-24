variable "vpc_id" {}
variable "sg_bastion_id" {}

resource "aws_instance" "service" {
    ami = "ami-b2e3c6d8"
    instance_type = "t1.micro"
    vpc_security_group_ids = ["${aws_security_group.sg_service.id}"]
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
      security_groups = ["${var.sg_bastion_id}"]
  }
  tags {
      Name = "service"
        Project = "msa"
  }

}
