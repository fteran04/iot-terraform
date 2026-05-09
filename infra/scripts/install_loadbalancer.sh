#!/bin/bash
# Amazon Linux 2023 - HAProxy via Docker

sudo dnf update -y
sudo dnf install -y docker

sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker ec2-user

# Escribir configuración de HAProxy
mkdir -p /home/ec2-user/haproxy

cat > /home/ec2-user/haproxy/haproxy.cfg <<EOF
defaults
    mode http
    timeout connect 5000ms
    timeout client 50000ms
    timeout server 50000ms

frontend http-in
    bind *:80
    default_backend api_servers

backend api_servers
    balance roundrobin
    server api1 ${api1_private_ip}:8000 check
    server api2 ${api2_private_ip}:8000 check
EOF

sudo docker run -d \
  --name load_balancer \
  --restart unless-stopped \
  -p 80:80 \
  -v /home/ec2-user/haproxy/haproxy.cfg:/usr/local/etc/haproxy/haproxy.cfg:ro \
  haproxy:latest
