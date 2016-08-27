#!/bin/bash -x

cd /tmp
echo $PWD
ls
ansible-galaxy install williamyeh.oracle-java -p ./roles/
echo -e '[local]\nlocalhost ansible_connection=local' > hosts
ansible-playbook -i hosts jenkins.yml

cd ..
