output "load_balancer_public_ip" {
  description = "Public IP of HAProxy load balancer — use this to hit the API"
  value       = aws_instance.loadbalancer.public_ip
}

output "api1_public_ip" {
  description = "Public IP of API instance 1"
  value       = aws_instance.api1.public_ip
}

output "api2_public_ip" {
  description = "Public IP of API instance 2"
  value       = aws_instance.api2.public_ip
}

output "postgres_private_ip" {
  description = "Private IP of PostgreSQL server"
  value       = aws_instance.postgres.private_ip
}

output "rabbitmq_private_ip" {
  description = "Private IP of RabbitMQ server"
  value       = aws_instance.rabbitmq.private_ip
}

output "rabbitmq_management_url" {
  description = "RabbitMQ management UI URL"
  value       = "http://${aws_instance.rabbitmq.public_ip}:15672"
}

output "worker_public_ip" {
  description = "Public IP of worker server"
  value       = aws_instance.worker.public_ip
}

output "producer_public_ip" {
  description = "Public IP of producer server"
  value       = aws_instance.producer.public_ip
}

output "api_endpoint" {
  description = "Base URL for the API through the load balancer"
  value       = "http://${aws_instance.loadbalancer.public_ip}/tareas"
}
