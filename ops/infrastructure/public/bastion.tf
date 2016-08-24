resource "aws_instance" "bastion" {
    ami = "ami-b2e3c6d8"
    instance_type = "t1.micro"
    vpc_security_group_ids = ["${aws_security_group.sg_bastion.id}"]
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


