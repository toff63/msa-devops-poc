variable "jenkins_ami" {}
variable "vpc_id" {}
variable "sg_bastion_id" {}
variable "subnet_id" {}

resource "aws_security_group" "sg_jenkins" {
  name = "jenkins"
  description = "jenkins"
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
  ingress {
      from_port = 8080
      to_port = 8080
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }
  tags {
        Project = "msa"
        Name = "jenkins"
  }

}


resource "aws_instance" "jenkins" {
    ami = "${var.jenkins_ami}"
    instance_type = "t2.small"
    vpc_security_group_ids = ["${aws_security_group.sg_jenkins.id}"]
    subnet_id = "${var.subnet_id}"
    associate_public_ip_address = "true"
    iam_instance_profile = "empty"
    key_name = "msa"
    tags {
        Project = "msa"
        Name = "jenkins"
    }
}


