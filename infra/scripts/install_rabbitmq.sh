#!/bin/bash
# Amazon Linux 2023 - RabbitMQ via Docker

sudo dnf update -y
sudo dnf install -y docker

sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker ec2-user

sudo docker run -d \
  --name rabbitmq_server \
  --restart unless-stopped \
  -e RABBITMQ_DEFAULT_USER=${rabbitmq_user} \
  -e RABBITMQ_DEFAULT_PASS=${rabbitmq_password} \
  -p 5672:5672 \
  -p 15672:15672 \
  rabbitmq:3-management
