#!/bin/bash

dnf update -y
dnf install -y docker awscli

systemctl enable docker
systemctl start docker

aws ecr get-login-password --region us-east-1 | \
docker login \
--username AWS \
--password-stdin 120685574103.dkr.ecr.us-east-1.amazonaws.com

docker pull 120685574103.dkr.ecr.us-east-1.amazonaws.com/adebayo-docker-app:1.1

docker run -d \
  --name adebayo-app \
  --restart unless-stopped \
  -p 80:3000 \
  120685574103.dkr.ecr.us-east-1.amazonaws.com/adebayo-docker-app:1.1
