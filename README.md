# interfaz
http://localhost:8000/docs

# Construir 
docker compose up -d --build

# Entrar
docker exec -it api_db_worker_project-producer-1 bash

# CURL
curl http://localhost:8000/tareas           # GET (descarga datos)

curl -X POST http://localhost:8000/tareas \
  -H "Content-Type: application/json" \
  -d '{"estado": "pendiente"}'   # POST (envía datos)


# Mirar logs
docker compose logs -f api

# Debud del load balancer
curl http://localhost:8000/debug



# AWS Cloud

# Subir imagenes a docker hub
# API
docker build -t federicoteran04/tareas-api:latest -f api/Dockerfile .
docker push federicoteran04/tareas-api:latest

# Worker
docker build -t federicoteran04/tareas-worker:latest -f worker/Dockerfile .
docker push federicoteran04/tareas-worker:latest

# Producer
docker build -t federicoteran04/tareas-producer:latest -f producer/Dockerfile .
docker push federicoteran04/tareas-producer:latest


# PEM
descargar la pairkey
