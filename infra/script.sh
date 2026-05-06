#!/bin/bash

yum update -y

# Docker
yum install docker -y

systemctl start docker
systemctl enable docker

# Docker Compose
curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-linux-x86_64" \
-o /usr/local/bin/docker-compose

chmod +x /usr/local/bin/docker-compose

# Clonar proyecto
yum install git -y

cd /home/ec2-user

git clone TU_REPOSITORIO_GITHUB project

cd project

docker compose up -d --build