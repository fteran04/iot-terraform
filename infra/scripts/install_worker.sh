#!/bin/bash
# Amazon Linux 2023 - Worker via Docker

sudo dnf update -y
sudo dnf install -y docker

sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker ec2-user

sudo docker run -d \
  --name tareas_worker \
  --restart unless-stopped \
  -e DATABASE_URL="postgresql+psycopg2://${db_user}:${db_password}@${db_host}:5432/${db_name}" \
  -e RABBITMQ_HOST=${rabbitmq_host} \
  -e RABBITMQ_USER=${rabbitmq_user} \
  -e RABBITMQ_PASSWORD=${rabbitmq_password} \
  ${dockerhub_username}/tareas-worker:latest
