#!/bin/bash
sudo yum update -y
sudo yum install docker -y 
sudo usermod -aG docker ec2user
sudo chmod 666 /var/run/docker.sock
sudo systemctl start docker.service
