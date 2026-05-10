# Despliegue en AWS con Terraform

## Arquitectura

```
Internet
   │
   ▼
[EC2 Load Balancer - HAProxy :80]
   │        │
   ▼        ▼
[EC2 API1] [EC2 API2]   ← FastAPI :8000
   │        │
   └───┬────┘
       │
   ┌───┴────────────┐
   ▼                ▼
[EC2 PostgreSQL]  [EC2 RabbitMQ]
      ▲                 │
      │                 ▼
   [EC2 Worker] ←──────┘
   [EC2 Producer] ──────► LB
```

---
Crear un Key Pair en AWS (para SSH a las EC2)

```bash
aws ec2 create-key-pair \
  --key-name mi-keypair \
  --query 'KeyMaterial' \
  --output text > mi-keypair.pem

chmod 400 mi-keypair.pem
```

---

## 5. Desplegar con Terraform

```bash
cd infra/

terraform init

terraform plan 

terraform apply 
```

Al terminar verás los outputs:

```
api_endpoint             = "http://X.X.X.X/tareas"
load_balancer_public_ip  = "X.X.X.X"
rabbitmq_management_url  = "http://X.X.X.X:15672"
...
```

---

## 6. Verificar el despliegue

```bash
# Probar el endpoint a través del load balancer
curl http://<load_balancer_public_ip>/tareas

# Ver a qué instancia llega cada request (round-robin)
curl http://<load_balancer_public_ip>/debug
curl http://<load_balancer_public_ip>/debug

# RabbitMQ Management UI
open http://<rabbitmq_public_ip>:15672  # usuario: admin / admin
```

---

## 7. SSH a las instancias (debugging)

```bash
# Load balancer
ssh -i ~/.ssh/vockey.pem ec2-user@98.81.180.177


# Ver logs del contenedor
sudo docker logs tareas_api -f
sudo docker logs tareas_worker -f
sudo docker logs tareas_producer -f
sudo docker logs load_balancer -f
```

---

## 8. Destruir la infraestructura


terraform destroy \


---

# abrir swagger
http://<ip_api_endpoint>/docs