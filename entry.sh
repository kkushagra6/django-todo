#!/bin/bash

sudo yum update -y
sudo yum install docker
sudo usermod -aG docker ec2user
systemctl start docker

