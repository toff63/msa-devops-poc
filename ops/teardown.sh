#!/usr/bin/bash

cd infrastructure/jenkins
terraform destroy -force  -var "jenkins_ami=ami" -var "vpc_id=id" -var "sg_bastion_id=id" -var "subnet_id=id"
cd ..
terraform destroy -force
cd ..
