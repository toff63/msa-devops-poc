#!/usr/bin/bash

PACKER_VPC_ID=$(terraform output -state infrastructure/terraform.tfstate | grep packer_vpc_id | awk -F ' = ' '{print $2}')
VPC_ID=$(terraform output -state infrastructure/terraform.tfstate | grep main_vpc_id | awk -F ' = ' '{print $2}')
SG_ID=$(terraform output -state infrastructure/terraform.tfstate | grep packer_sg_id | awk -F ' = ' '{print $2}')
PACKER_SUBNET_ID=$(terraform output -state infrastructure/terraform.tfstate | grep packer_subnet_id | awk -F ' = ' '{print $2}')
PUBLIC_SUBNET_ID_C=$(terraform output -state infrastructure/terraform.tfstate | grep public_subnet_id_c | awk -F ' = ' '{print $2}')
SG_BASTION_ID=$(terraform output -state infrastructure/terraform.tfstate | grep sg_bastion_id | awk -F ' = ' '{print $2}')


packer build -var vpc_id=$PACKER_VPC_ID -var sg_id=$SG_ID -var subnet_id=$PACKER_SUBNET_ID images/jenkins.json > jenkins-ami.log
JENKINS_AMI=$(tail -n 1 jenkins-ami.log | awk -F ': ' '{print $2}')

cd infrastructure/jenkins
terraform plan -var "jenkins_ami=$JENKINS_AMI" -var "vpc_id=$VPC_ID" -var "sg_bastion_id=$SG_BASTION_ID" -var "subnet_id=$PUBLIC_SUBNET_ID_C"
terraform apply -var "jenkins_ami=$JENKINS_AMI" -var "vpc_id=$VPC_ID" -var "sg_bastion_id=$SG_BASTION_ID" -var "subnet_id=$PUBLIC_SUBNET_ID_C"
cd ..

