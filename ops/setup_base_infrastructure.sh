#!/usr/bin/bash


cd infrastructure
terraform get
terraform plan
terraform apply

cd ..


