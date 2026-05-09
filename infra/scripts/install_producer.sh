#!/bin/bash
# Amazon Linux 2023 - Producer via Docker

sudo dnf update -y
sudo dnf install -y docker

sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker ec2-user

sudo docker run -d \
  --name tareas_producer \
  --restart unless-stopped \
  -e BASE_URL="http://${lb_host}" \
  ${dockerhub_username}/tareas-producer:latest
