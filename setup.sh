#!/bin/bash


echo "ClientAliveInterval 60" >> /etc/ssh/sshd_config
echo "LANG=en_US.utf-8" >> /etc/environment
echo "LC_ALL=en_US.utf-8" >> /etc/environment
service sshd restart

echo "password123" | passwd root --stdin
sed  -i 's/#PermitRootLogin yes/PermitRootLogin yes/' /etc/ssh/sshd_config
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
service sshd restart

yum install httpd php -y
systemctl enable httpd
systemctl restart httpd


yum install http php git -y
systemctl start httpd
systemctl enable httpd
git clone https://github.com/Ismailpb/support.git
cp -r support/*  /var/www/html/
chown -R apache:apache /var/www/html/*
