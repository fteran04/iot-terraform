# Despliegue en AWS con Terraform


## Desplegar con Terraform

cd infra/

terraform init

terraform plan 

terraform apply 


## Verificar el despliegue

# Probar el endpoint a través del load balancer
curl http://<load_balancer_public_ip>/tareas

# Ver a qué instancia llega cada request (round-robin)
curl http://<load_balancer_public_ip>/debug
curl http://<load_balancer_public_ip>/debug

# RabbitMQ Management UI
open http://<rabbitmq_public_ip>:15672  # usuario: admin / admin



## SSH a las instancias (debugging)


# Load balancer
ssh -i ~/.ssh/vockey.pem ec2-user@98.81.180.177


# Ver logs del contenedor
sudo docker logs tareas_api -f
sudo docker logs tareas_worker -f
sudo docker logs tareas_producer -f
sudo docker logs load_balancer -f


## Destruir la infraestructura
terraform destroy 


# abrir swagger
http://<ip_api_endpoint>/docs