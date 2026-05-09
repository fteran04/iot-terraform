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

## 1. Cambios requeridos en el código Python

Antes de buildear las imágenes, el código necesita leer variables de entorno
en lugar de tener los hosts hardcodeados.

### `publisher.py` — leer RABBITMQ_HOST del entorno

```python
import pika, json, os

def publicar_tarea(tarea_id: int):
    credentials = pika.PlainCredentials(
        os.getenv("RABBITMQ_USER", "admin"),
        os.getenv("RABBITMQ_PASSWORD", "admin")
    )
    connection = pika.BlockingConnection(
        pika.ConnectionParameters(
            host=os.getenv("RABBITMQ_HOST", "rabbitmq"),  # ← cambio
            credentials=credentials
        )
    )
    channel = connection.channel()
    channel.queue_declare(queue='tareas')
    channel.basic_publish(exchange='', routing_key='tareas', body=json.dumps({"id": tarea_id}))
    connection.close()
```

### `worker.py` — leer RABBITMQ_HOST del entorno

```python
connection = pika.BlockingConnection(
    pika.ConnectionParameters(
        host=os.getenv("RABBITMQ_HOST", "rabbitmq"),  # ← cambio
        credentials=pika.PlainCredentials(
            os.getenv("RABBITMQ_USER", "admin"),
            os.getenv("RABBITMQ_PASSWORD", "admin")
        )
    )
)
```

### `producer.py` — leer BASE_URL del entorno

```python
BASE_URL = os.getenv("BASE_URL", "http://lb")  # ← cambio
```

---

## 2. Buildear y subir imágenes a Docker Hub

Reemplaza `TU_USUARIO` con tu usuario de Docker Hub.

```bash
# Desde la raíz del proyecto
export DOCKER_USER=TU_USUARIO

# API
docker build -t $DOCKER_USER/tareas-api:latest -f api/Dockerfile .
docker push $DOCKER_USER/tareas-api:latest

# Worker
docker build -t $DOCKER_USER/tareas-worker:latest -f worker/Dockerfile .
docker push $DOCKER_USER/tareas-worker:latest

# Producer
docker build -t $DOCKER_USER/tareas-producer:latest -f producer/Dockerfile .
docker push $DOCKER_USER/tareas-producer:latest
```

---

## 3. Configurar credenciales AWS

```bash
aws configure
# AWS Access Key ID: TU_ACCESS_KEY
# AWS Secret Access Key: TU_SECRET_KEY
# Default region: us-east-1
```

---

## 4. Crear un Key Pair en AWS (para SSH a las EC2)

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

terraform plan \
  -var="key_name=mi-keypair" \
  -var="dockerhub_username=TU_USUARIO"

terraform apply \
  -var="key_name=mi-keypair" \
  -var="dockerhub_username=TU_USUARIO"
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
ssh -i mi-keypair.pem ubuntu@<lb_public_ip>

# Ver logs del contenedor
sudo docker logs tareas_api -f
sudo docker logs tareas_worker -f
sudo docker logs tareas_producer -f
sudo docker logs load_balancer -f
```

---

## 8. Destruir la infraestructura

```bash
terraform destroy \
  -var="key_name=mi-keypair" \
  -var="dockerhub_username=TU_USUARIO"
```

---

## Notas importantes

- **AMI**: El `ami_id` por defecto es Ubuntu 24.04 en `us-east-1`. Si usas otra región,
  cámbialo en `variables.tf` o pásalo con `-var="ami_id=ami-XXXX"`.
- **user_data**: Los scripts de instalación se ejecutan al arrancar la EC2.
  Si una instancia falla, revisá `/var/log/cloud-init-output.log` dentro de la EC2.
- **Orden de startup**: Terraform crea todo en paralelo pero los scripts de cada EC2
  tienen loops de espera (`until curl...`) para que los servicios dependientes estén listos.
- **Costos**: 7 instancias `t3.micro` entran dentro del free tier si tu cuenta es nueva.
  Siempre corré `terraform destroy` cuando termines.
