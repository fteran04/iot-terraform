#!/bin/bash
# Amazon Linux 2023 - PostgreSQL via Docker

sudo dnf update -y
sudo dnf install -y docker

sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker ec2-user

sudo docker run -d \
  --name postgres_db \
  --restart unless-stopped \
  -e POSTGRES_USER=${db_user} \
  -e POSTGRES_PASSWORD=${db_password} \
  -e POSTGRES_DB=${db_name} \
  -p 5432:5432 \
  postgres:16
