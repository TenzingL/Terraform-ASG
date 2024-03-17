#!/bin/bash
yum upgrade -y
wget -O /etc/yum.repos.d/jenkins.repo \
    https://pkg.jenkins.io/redhat-stable/jenkins.repo #Add Jenkins Repository
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
dnf install java-17-amazon-corretto -y #Install Java
yum install jenkins -y
systemctl enable jenkins
systemctl start jenkins
systemctl status jenkins

#Connect to http://<your_server_public_DNS>:8080 from your browser.